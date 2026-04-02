# =============================================================================
# run-validator.ps1 — Issue Validator Agent
# Valida work items New do Azure DevOps (path Torre Manutencao)
# e aplica comentario HTML + tag "abertura-incompleta" nas incompletas.
# =============================================================================

param(
    [string]$Organization = "https://gantc.visualstudio.com",
    [string]$Project      = "Senior Agro Dev",
    [string]$AreaPath     = "Senior Agro Dev\Torre Manutencao",
    [string]$TagAlerta    = "abertura-incompleta",
    [int]$Top             = 0  # 0 = todas, N = limitar para teste
)

# --- Encoding seguro para caracteres especiais no terminal Windows ----------
$integracaoFiltro  = "Integra" + [char]231 + [char]227 + "o"
$informaticaFiltro = "Inform"  + [char]225 + "tica"
$manutencaoLabel   = "Manuten" + [char]231 + [char]227 + "o"
$excluiProcesso    = @("Mobile", "SimpleFarm", "Web", $integracaoFiltro, $informaticaFiltro)
$excluiModulo      = @("Scouting")

# --- PASSO 1: Configurar contexto -------------------------------------------
Write-Host "=== PASSO 1: Configurando contexto Azure DevOps ==="
az devops configure --defaults organization=$Organization project=$Project
Write-Host "Contexto: $Organization / $Project"

# --- PASSO 2: Buscar issues New sem tag abertura-incompleta ------------------
Write-Host ""
Write-Host "=== PASSO 2: Buscando issues elegiveis ==="

$wiql = @"
SELECT [System.Id], [System.Title]
FROM WorkItems
WHERE [System.TeamProject] = '$Project'
  AND [System.WorkItemType] IN ('Fix', 'Hotfix', 'User Story')
  AND [System.AreaPath] = '$AreaPath'
  AND [System.State] = 'New'
  AND [System.AssignedTo] = ''
  AND NOT [System.Tags] CONTAINS '$TagAlerta'
ORDER BY [System.CreatedDate] DESC
"@

$queryResult = az boards query --wiql $wiql --output json | ConvertFrom-Json

# az boards query retorna array direto ou objeto com .workItems dependendo da versao
if ($queryResult -is [array]) {
    $ids = $queryResult | Select-Object -ExpandProperty id
} elseif ($queryResult.workItems) {
    $ids = $queryResult.workItems | Select-Object -ExpandProperty id
} else {
    $ids = @()
}

if ($Top -gt 0 -and $ids.Count -gt $Top) {
    $ids = $ids | Select-Object -First $Top
}

Write-Host "Issues no WIQL: $($ids.Count)"

if ($ids.Count -eq 0) {
    Write-Host "Nenhuma issue elegivel encontrada. Encerrando."
    exit 0
}

# --- Contadores --------------------------------------------------------------
$totalAnalisadas  = 0
$totalCompletas   = 0
$totalIncompletas = 0
$idsIncompletas   = @()
$erros            = @()
$relatorio        = @()

# --- PASSOS 3-5: Loop de validacao, comentario e tag -------------------------
Write-Host ""
Write-Host "=== PASSOS 3-5: Validando issues ==="

foreach ($id in $ids) {
    Write-Host ""
    Write-Host "--- Processando #$id ---"

    try {
        # Buscar detalhes com relacoes (necessario para verificar anexos)
        $wi        = az boards work-item show --id $id --expand relations --output json | ConvertFrom-Json
        $titulo    = $wi.fields."System.Title"
        $descricao = $wi.fields."System.Description"
        $natureza  = $wi.fields."Custom.ZendeskNatureza"
        $modulo    = $wi.fields."Custom.ZendeskModulo"
        $processo  = $wi.fields."Custom.ZendeskProcesso"
        $analista  = $wi.fields."Custom.ZendeskAnalistaSuporte"
        $relacoes  = $wi.relations

        # Filtro pos-query: excluir processos e modulos nao elegiveis
        if ($excluiProcesso -contains $processo) {
            Write-Host "#$id excluido (processo: $processo)"
            continue
        }
        if ($excluiModulo -contains $modulo) {
            Write-Host "#$id excluido (modulo: $modulo)"
            continue
        }

        $totalAnalisadas++

        # Verificar se ja existe comentario do validador (evitar duplicacao)
        $commentsResult = az devops invoke `
            --area wit --resource comments `
            --route-parameters project=$Project workItemId=$id `
            --http-method GET --api-version "7.1-preview" `
            --output json | ConvertFrom-Json

        $jaValidada = $commentsResult.comments | Where-Object { $_.text -like "*issue-validator-agent*" }
        if ($jaValidada) {
            Write-Host "#$id ja validada anteriormente - pulando."
            $totalCompletas++
            continue
        }

        # =================================================================
        # VALIDACAO DOS 6 ITENS
        # =================================================================
        $descLimpa = ($descricao -replace "<[^>]+>", "") -replace "&nbsp;", " "

        # 1. Tipo (erro, incidente, melhoria, duvida)
        $v1 = if ($natureza -and $natureza.Trim() -ne "") { $natureza }
              elseif ($titulo -match "erro|incidente|melhoria|duvida") { $Matches[0] }
              else { $null }

        # 2. Descricao do problema
        $v2 = if ([string]::IsNullOrWhiteSpace($descLimpa) -or $descLimpa.Trim() -match "^Ver.*#\d+$") { $null }
              else { "Presente" }

        # 3. Sistema/modulo afetado
        $v3 = if ($modulo -and $modulo.Trim() -ne "" -and $modulo -notmatch "^(o sistema|o software|o programa)$") { $modulo }
              else { $null }

        # 4. Caminho no menu
        $v4 = if ($descricao -match "(?i)(menu|caminho|tela)") { "Mencionado" }
              else { $null }

        # 5. Evidencia anexada
        $anexos = @($relacoes | Where-Object { $_.rel -eq "AttachedFile" })
        $v5 = if ($anexos.Count -gt 0) { "$($anexos.Count) anexo(s)" }
              elseif ($descricao -like "*<img*") { "Imagem inline" }
              else { $null }

        # 6. Analista do Suporte
        $v6 = if ($analista -and $analista.Trim() -ne "") { $analista }
              else { $null }

        # Valores para relatorio/comentario
        $s1 = if ($v1) { $v1 } else { "ausente" }
        $s2 = if ($v2) { $v2 } else { "ausente" }
        $s3 = if ($v3) { $v3 } else { "ausente" }
        $s4 = if ($v4) { $v4 } else { "ausente" }
        $s5 = if ($v5) { $v5 } else { "ausente" }
        $s6 = if ($v6) { $v6 } else { "ausente" }

        # Lista de itens faltando (HTML)
        $itensFaltando = @()
        if (-not $v1) { $itensFaltando += "<li><strong>1. Tipo</strong> - informe se e erro, incidente, melhoria ou duvida</li>" }
        if (-not $v2) { $itensFaltando += "<li><strong>2. Descricao do problema</strong> - descreva o que aconteceu e o que o usuario tentou fazer</li>" }
        if (-not $v3) { $itensFaltando += "<li><strong>3. Sistema/modulo</strong> - informe o modulo especifico (ex: GATEC_SAF)</li>" }
        if (-not $v4) { $itensFaltando += "<li><strong>4. Caminho no menu</strong> - informe o caminho completo (ex: Logistica - Transporte - Romaneio)</li>" }
        if (-not $v5) { $itensFaltando += "<li><strong>5. Evidencia</strong> - anexe um print da tela com o problema visivel</li>" }
        if (-not $v6) { $itensFaltando += "<li><strong>6. Analista do Suporte</strong> - informe o nome do analista responsavel pelo ticket</li>" }

        $completa = $itensFaltando.Count -eq 0

        # Adicionar ao relatorio
        $tituloCorto = $titulo.Substring(0, [math]::Min(40, $titulo.Length))
        $relatorio += [PSCustomObject]@{
            ID        = $id
            Titulo    = $tituloCorto
            Tipo      = $s1
            Descricao = $s2
            Sistema   = $s3
            Menu      = $s4
            Evidencia = $s5
            Analista  = $s6
            Tag       = if ($completa) { "-" } else { $TagAlerta }
        }

        if ($completa) {
            $totalCompletas++
            Write-Host "#$id COMPLETA"
            continue
        }

        # =================================================================
        # PASSO 4: Postar comentario HTML na issue incompleta
        # =================================================================
        $totalIncompletas++
        $idsIncompletas += $id

        $st1 = if ($v1) { "ok" } else { "AUSENTE" }
        $st2 = if ($v2) { "ok" } else { "AUSENTE" }
        $st3 = if ($v3) { "ok" } else { "AUSENTE" }
        $st4 = if ($v4) { "ok" } else { "AUSENTE" }
        $st5 = if ($v5) { "ok" } else { "AUSENTE" }
        $st6 = if ($v6) { "ok" } else { "AUSENTE" }

        $listaHtml = $itensFaltando -join "`n"

        $htmlComentario = @"
<h2>&#9888;&#65039; Validacao de Qualidade - Issue Incompleta</h2>
<p>Esta issue foi validada automaticamente e <strong>nao atende ao checklist minimo</strong> para ser trabalhada pelo time de $manutencaoLabel.</p>
<h3>Resultado da validacao</h3>
<table>
<thead><tr><th>#</th><th>Item</th><th>Valor encontrado</th><th>Status</th></tr></thead>
<tbody>
<tr><td>1</td><td>Tipo</td><td>$s1</td><td>$st1</td></tr>
<tr><td>2</td><td>Descricao do problema</td><td>$s2</td><td>$st2</td></tr>
<tr><td>3</td><td>Sistema/modulo afetado</td><td>$s3</td><td>$st3</td></tr>
<tr><td>4</td><td>Caminho no menu</td><td>$s4</td><td>$st4</td></tr>
<tr><td>5</td><td>Evidencia anexada</td><td>$s5</td><td>$st5</td></tr>
<tr><td>6</td><td>Analista do Suporte</td><td>$s6</td><td>$st6</td></tr>
</tbody>
</table>
<h3>Itens faltando</h3>
<ul>
$listaHtml
</ul>
<h3>Como corrigir</h3>
<p>Preencha os itens marcados como AUSENTE e adicione as informacoes nos comentarios desta issue.<br/>
Consulte o checklist completo: <em>guias/checklist-abertura-issue.md</em></p>
<p>&#127991;&#65039; Tag adicionada automaticamente: <code>$TagAlerta</code><br/>
&#129302; Comentario gerado automaticamente pelo issue-validator-agent</p>
"@

        # Gravar JSON sem BOM (az CLI falha com BOM)
        $jsonBody = @{ text = $htmlComentario } | ConvertTo-Json -Depth 5
        $tempFile = "$env:TEMP\issue-validator-comment.json"
        [System.IO.File]::WriteAllText($tempFile, $jsonBody, (New-Object System.Text.UTF8Encoding($false)))

        az devops invoke `
            --area wit --resource comments `
            --route-parameters project=$Project workItemId=$id `
            --http-method POST --in-file $tempFile `
            --api-version "7.1-preview" --output none

        Write-Host "#$id comentario postado"

        # =================================================================
        # PASSO 5: Adicionar tag sem perder as existentes
        # =================================================================
        $tagsAtuais = (az boards work-item show --id $id --output json | ConvertFrom-Json).fields.'System.Tags'

        if ($tagsAtuais -and $tagsAtuais -like "*$TagAlerta*") {
            Write-Host "#$id ja tem a tag - pulando."
        }
        elseif ([string]::IsNullOrWhiteSpace($tagsAtuais) -or $tagsAtuais.Trim() -eq "None") {
            az boards work-item update --id $id --fields "System.Tags=$TagAlerta" --output none
            Write-Host "#$id tag aplicada: $TagAlerta"
        }
        else {
            $novasTags = "$($tagsAtuais.Trim()); $TagAlerta"
            az boards work-item update --id $id --fields "System.Tags=$novasTags" --output none
            Write-Host "#$id tag aplicada: $novasTags"
        }

    } catch {
        $erros += [PSCustomObject]@{ ID = $id; Erro = $_.Exception.Message }
        Write-Host "#$id ERRO: $($_.Exception.Message)"
    }
}

# --- PASSO 6: Relatorio final ------------------------------------------------
Write-Host ""
Write-Host "================================================================"
Write-Host "  RELATORIO FINAL"
Write-Host "================================================================"
Write-Host "Total analisadas: $totalAnalisadas | Completas: $totalCompletas | Incompletas: $totalIncompletas"
Write-Host ""
$relatorio | Format-Table -AutoSize

if ($erros.Count -gt 0) {
    Write-Host ""
    Write-Host "=== ERROS ==="
    $erros | Format-Table -AutoSize
}

# --- PASSO 7: Registrar no historico -----------------------------------------
$dataHora = Get-Date -Format "yyyy-MM-dd HH:mm"
$idsLista = if ($idsIncompletas.Count -gt 0) { $idsIncompletas -join ", " } else { "-" }
$linha    = "| $dataHora | $totalAnalisadas | $totalCompletas | $totalIncompletas | $idsLista |"

$repoRoot = git -C $PSScriptRoot rev-parse --show-toplevel 2>$null
if (-not $repoRoot) { $repoRoot = Split-Path $PSScriptRoot }
$histPath = Join-Path $repoRoot "agents\issue-validator-history.md"

if (Test-Path $histPath) {
    Add-Content -Path $histPath -Value $linha -Encoding UTF8
    Write-Host ""
    Write-Host "Historico atualizado em: $histPath"
} else {
    Write-Host "AVISO: Arquivo de historico nao encontrado em $histPath"
}

Write-Host ""
Write-Host "=== Validacao concluida ==="

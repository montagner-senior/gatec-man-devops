# =============================================================================
# run-validator.ps1 - Issue Validator Agent (Data Layer)
# Dois modos:
#   FETCH (padrao): Busca issues e grava JSON para o agente (LLM) analisar.
#   APPLY (-Apply): Le resultados do agente e posta comentarios/tags.
#
# O agente (LLM) e o cerebro: ele analisa cada issue com inteligencia,
# decide o que esta faltando, e gera comentarios contextuais.
# Este script e apenas o data layer (busca + acao).
#
# Uso:
#   & agents\run-validator.ps1                              # Fetch todas
#   & agents\run-validator.ps1 -Top 3                       # Fetch limitado
#   & agents\run-validator.ps1 -Id 128340                   # Fetch por ID
#   & agents\run-validator.ps1 -Id 128340,128257            # Multiplos IDs
#   & agents\run-validator.ps1 -Apply results.json          # Aplicar resultados
#   & agents\run-validator.ps1 -Revalidate                  # Revalidar com tag
#   & agents\run-validator.ps1 -Apply results.json -DryRun  # Preview
# =============================================================================

param(
    [string]$Organization = "https://gantc.visualstudio.com",
    [string]$Project      = "Senior Agro Dev",
    [string]$AreaPath     = "Senior Agro Dev\Torre Manutencao",
    [string]$TagAlerta    = "abertura-incompleta",
    [int]$Top             = 0,
    [int[]]$Id            = @(),
    [string]$Apply        = "",
    [switch]$Revalidate,
    [switch]$DryRun
)

# --- Encoding seguro para filtros pos-query ---
$integracaoFiltro  = "Integra" + [char]231 + [char]227 + "o"
$informaticaFiltro = "Inform"  + [char]225 + "tica"
$excluiProcesso    = @("Mobile", "SimpleFarm", "Web", $integracaoFiltro, $informaticaFiltro)
$excluiModulo      = @("Scouting")

# --- Configurar contexto Azure DevOps ---
Write-Host "Configurando Azure DevOps..."
az devops configure --defaults organization=$Organization project=$Project 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERRO: Falha ao configurar contexto. Verifique autenticacao."
    Write-Host "Execute: az devops login --organization $Organization"
    exit 1
}

# =============================================================================
# MODO APPLY - Posta comentarios/tags a partir dos resultados do agente
# =============================================================================
if ($Apply -ne "") {
    Write-Host "=== MODO APPLY ==="
    if ($DryRun) { Write-Host "[DRY-RUN] Nenhuma alteracao sera feita" }

    if (-not (Test-Path $Apply)) {
        Write-Host "ERRO: Arquivo nao encontrado: $Apply"
        exit 1
    }

    $raw = [System.IO.File]::ReadAllText($Apply, [System.Text.Encoding]::UTF8)
    $resultados = $raw | ConvertFrom-Json
    if ($resultados -isnot [array]) { $resultados = @($resultados) }

    $aplicados = 0
    $erros     = 0
    $idsVistos = @{}

    foreach ($r in $resultados) {
        $rid = $r.id
        Write-Host "--- #$rid ---"

        # Fix idempotencia: evitar duplicata se mesmo ID aparecer mais de uma vez
        if ($idsVistos.ContainsKey($rid)) {
            Write-Host "#$rid duplicado no arquivo - pulando"
            continue
        }
        $idsVistos[$rid] = $true

        if ($DryRun) {
            Write-Host "#$rid [DRY-RUN] Pulado"
            continue
        }

        try {
            # Postar comentario HTML
            $bodyJson = @{ text = $r.comentarioHtml } | ConvertTo-Json -Depth 5
            $tempFile = [System.IO.Path]::Combine($env:TEMP, "issue-validator-comment-$rid.json")
            [System.IO.File]::WriteAllText($tempFile, $bodyJson, (New-Object System.Text.UTF8Encoding($false)))

            az devops invoke `
                --area wit --resource comments `
                --route-parameters project=$Project workItemId=$rid `
                --http-method POST --in-file $tempFile `
                --api-version "7.1-preview" --output none

            if ($LASTEXITCODE -ne 0) {
                Write-Host "#$rid ERRO ao postar comentario"
                $erros++
                continue
            }
            Write-Host "#$rid comentario postado"

            # Determinar acao (padrao: incompleta)
            $acao = if ($r.acao) { $r.acao } else { "incompleta" }

            if ($acao -eq "complementada") {
                # Remover tag abertura-incompleta
                $tagsAtuais = $r.tags
                if ($tagsAtuais -and $tagsAtuais -like "*$TagAlerta*") {
                    $tagsList = ($tagsAtuais -split ";\s*") | Where-Object { $_.Trim() -ne $TagAlerta -and $_.Trim() -ne "" }
                    $novasTags = $tagsList -join "; "
                    az boards work-item update --id $rid --fields "System.Tags=$novasTags" --output none
                    if ($LASTEXITCODE -ne 0) {
                        Write-Host "#$rid ERRO ao remover tag"
                        $erros++
                        continue
                    }
                    Write-Host "#$rid tag removida: $TagAlerta"
                } else {
                    Write-Host "#$rid tag ja ausente"
                }
            }
            elseif ($acao -eq "completa") {
                # Adicionar tag abertura-completa
                $tagCompleta = "abertura-completa"
                $tagsAtuais = $r.tags

                if ($tagsAtuais -and $tagsAtuais -like "*$tagCompleta*") {
                    Write-Host "#$rid tag $tagCompleta ja existe"
                }
                elseif ([string]::IsNullOrWhiteSpace($tagsAtuais) -or $tagsAtuais.Trim() -eq "None") {
                    az boards work-item update --id $rid --fields "System.Tags=$tagCompleta" --output none
                    if ($LASTEXITCODE -ne 0) {
                        Write-Host "#$rid ERRO ao aplicar tag"
                        $erros++
                        continue
                    }
                    Write-Host "#$rid tag: $tagCompleta"
                }
                else {
                    $novasTags = "$($tagsAtuais.Trim()); $tagCompleta"
                    az boards work-item update --id $rid --fields "System.Tags=$novasTags" --output none
                    if ($LASTEXITCODE -ne 0) {
                        Write-Host "#$rid ERRO ao aplicar tag"
                        $erros++
                        continue
                    }
                    Write-Host "#$rid tag: $novasTags"
                }
            }
            else {
                # Adicionar tag preservando existentes
                $tagsAtuais = $r.tags

                if ($tagsAtuais -and $tagsAtuais -like "*$TagAlerta*") {
                    Write-Host "#$rid tag ja existe"
                }
                elseif ([string]::IsNullOrWhiteSpace($tagsAtuais) -or $tagsAtuais.Trim() -eq "None") {
                    az boards work-item update --id $rid --fields "System.Tags=$TagAlerta" --output none
                    if ($LASTEXITCODE -ne 0) {
                        Write-Host "#$rid ERRO ao aplicar tag"
                        $erros++
                        continue
                    }
                    Write-Host "#$rid tag: $TagAlerta"
                }
                else {
                    $novasTags = "$($tagsAtuais.Trim()); $TagAlerta"
                    az boards work-item update --id $rid --fields "System.Tags=$novasTags" --output none
                    if ($LASTEXITCODE -ne 0) {
                        Write-Host "#$rid ERRO ao aplicar tag"
                        $erros++
                        continue
                    }
                    Write-Host "#$rid tag: $novasTags"
                }
            }

            $aplicados++

        } catch {
            Write-Host "#$rid ERRO: $($_.Exception.Message)"
            $erros++
        }
    }

    Write-Host ""
    Write-Host "=== Apply: $aplicados OK | $erros erros ==="
    exit 0
}

# =============================================================================
# MODO FETCH (padrao) - Busca issues e grava JSON para o agente analisar
# =============================================================================
Write-Host "=== MODO FETCH ==="

if ($Id.Count -gt 0) {
    $ids = $Id
    Write-Host "Modo ID: $($ids -join ', ')"
} elseif ($Revalidate) {
    Write-Host "Modo REVALIDACAO: buscando issues com tag $TagAlerta"
    $wiql = @"
SELECT [System.Id], [System.Title]
FROM WorkItems
WHERE [System.TeamProject] = '$Project'
  AND [System.WorkItemType] IN ('Fix', 'Hotfix', 'User Story')
  AND [System.AreaPath] = '$AreaPath'
  AND [System.Tags] CONTAINS '$TagAlerta'
ORDER BY [System.CreatedDate] DESC
"@

    $queryResult = az boards query --wiql $wiql --output json 2>$null | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO: Falha na query WIQL."
        exit 1
    }

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

    Write-Host "Issues com tag encontradas: $($ids.Count)"
} else {
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

    $queryResult = az boards query --wiql $wiql --output json 2>$null | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO: Falha na query WIQL."
        exit 1
    }

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

    Write-Host "Issues encontradas: $($ids.Count)"
}

if (-not $ids -or $ids.Count -eq 0) {
    Write-Host "Nenhuma issue elegivel."
    $outPath = Join-Path $env:TEMP "validator-fetch.json"
    [System.IO.File]::WriteAllText($outPath, "[]", (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "OUTPUT_FILE: $outPath"
    exit 0
}

# Fetch dados de cada issue
$issues = [System.Collections.ArrayList]@()
$totalExcluidas = 0

foreach ($workItemId in $ids) {
    Write-Host "Buscando #$workItemId..."

    try {
        $wi = az boards work-item show --id $workItemId --expand relations --output json | ConvertFrom-Json

        $processo  = $wi.fields."Custom.ZendeskProcesso"
        $moduloVal = $wi.fields."Custom.ZendeskModulo"

        # Filtro pos-query: excluir processos e modulos nao elegiveis
        if ($excluiProcesso -contains $processo) {
            Write-Host "#$workItemId excluido (processo: $processo)"
            $totalExcluidas++
            continue
        }
        if ($excluiModulo -contains $moduloVal) {
            Write-Host "#$workItemId excluido (modulo: $moduloVal)"
            $totalExcluidas++
            continue
        }

        # Verificar idempotencia (ja tem comentario do validador?)
        $commentsRaw = az devops invoke `
            --area wit --resource comments `
            --route-parameters project=$Project workItemId=$workItemId `
            --http-method GET --api-version "7.1-preview" `
            --output json 2>$null | ConvertFrom-Json

        $jaVal = $false
        if ($commentsRaw.comments) {
            $jaVal = [bool]($commentsRaw.comments | Where-Object { $_.text -like "*issue-validator-agent*" })
        }

        # Extrair descricao como texto limpo (sem HTML)
        $descHtml = $wi.fields."System.Description"
        $descText = ""
        if ($descHtml) {
            $descText = ($descHtml -replace "<[^>]+>", " ") -replace "&nbsp;", " "
            $descText = ($descText -replace "\s+", " ").Trim()
        }

        # Contar anexos e verificar imagens inline
        $anexoCount = 0
        if ($wi.relations) {
            $anexoCount = @($wi.relations | Where-Object { $_.rel -eq "AttachedFile" }).Count
        }
        $temImg = ($descHtml -and $descHtml -like "*<img*")

        # Extrair e baixar imagens inline da descricao
        $imagensLocais = @()
        if ($descHtml) {
            $imgMatches = [regex]::Matches($descHtml, '<img[^>]+src="([^"]+)"')
            if ($imgMatches.Count -gt 0) {
                $imgDir = Join-Path $env:TEMP "validator-images"
                if (-not (Test-Path $imgDir)) { New-Item -ItemType Directory -Path $imgDir -Force | Out-Null }
                $imgIndex = 0
                foreach ($match in $imgMatches) {
                    $imgUrl = $match.Groups[1].Value
                    $imgIndex++
                    # Extrair nome do arquivo da URL ou gerar um
                    $urlName = if ($imgUrl -match '[?&]name=([^&]+)') { $Matches[1] } else { "img${imgIndex}.png" }
                    $localName = "${workItemId}_${imgIndex}_${urlName}"
                    $localPath = Join-Path $imgDir $localName
                    try {
                        Invoke-WebRequest -Uri $imgUrl -OutFile $localPath -UseBasicParsing -TimeoutSec 15 2>$null
                        if (Test-Path $localPath) {
                            $imagensLocais += $localPath
                            Write-Host "#$workItemId imagem $imgIndex baixada: $urlName"
                        }
                    } catch {
                        Write-Host "#$workItemId imagem $imgIndex FALHOU: $($_.Exception.Message)"
                    }
                }
            }
        }

        [void]$issues.Add([PSCustomObject][ordered]@{
            id               = [int]$workItemId
            titulo           = $wi.fields."System.Title"
            tipoWorkItem     = $wi.fields."System.WorkItemType"
            createdDate      = $wi.fields."System.CreatedDate"
            descricaoTexto   = $descText
            natureza         = $wi.fields."Custom.ZendeskNatureza"
            modulo           = $moduloVal
            processo         = $processo
            tags             = $wi.fields."System.Tags"
            anexos           = $anexoCount
            temImagensInline = $temImg
            imagensLocais    = $imagensLocais
            jaValidada       = $jaVal
        })
        Write-Host "#$workItemId ok"

    } catch {
        Write-Host "#$workItemId ERRO: $($_.Exception.Message)"
        [void]$issues.Add([PSCustomObject][ordered]@{
            id   = [int]$workItemId
            erro = $_.Exception.Message
        })
    }
}

# Gerar JSON (garantir array mesmo com 1 elemento)
if ($issues.Count -eq 0) {
    $json = "[]"
} elseif ($issues.Count -eq 1) {
    $single = $issues[0] | ConvertTo-Json -Depth 5
    $json = "[$single]"
} else {
    $json = ConvertTo-Json -InputObject $issues.ToArray() -Depth 5
}

$outPath = Join-Path $env:TEMP "validator-fetch.json"
[System.IO.File]::WriteAllText($outPath, $json, (New-Object System.Text.UTF8Encoding($false)))

Write-Host ""
Write-Host "Issues retornadas: $($issues.Count) | Excluidas: $totalExcluidas"
Write-Host "OUTPUT_FILE: $outPath"
Write-Host "=== Fetch concluido ==="

---
title: Como Usar o Issue Validator Agent
parent: Agentes
nav_order: 1
---

# Como Usar o Issue Validator Agent

O `issue-validator-agent` é um **agente inteligente** que valida issues com status **New** no path **Manutenção**. Diferente de um script com regex, o agente (Claude Sonnet) **lê e compreende** a descrição de cada issue para decidir se tem informação suficiente para o time trabalhar. Quando encontra issues incompletas, adiciona um comentário contextual explicando o que falta e aplica a tag `abertura-incompleta`.

### Arquitetura

```
MCP Server Azure DevOps         Agente LLM (cérebro)
┌─────────────────────────┐    ┌───────────────────────────────┐
│  WIQL: busca issues       │────▶│  Lê descrição e avalia cada    │
│  Get Work Item: detalhes  │    │  item com inteligência         │
│  Add Comment: resultado   │◀────│  Gera comentário contextual    │
│  Update WI: tags          │    │  específico para cada issue    │
└─────────────────────────┘    └───────────────────────────────┘
```

O agente acessa o Azure DevOps **diretamente via MCP Server** (sem scripts intermediários). Toda a lógica — buscar, analisar, comentar e taguear — é executada pelo próprio agente usando as tools MCP.

---

## Pré-requisitos

### 1. Node.js 20+

Verifique:
```powershell
node --version   # deve retornar v20.x ou superior
```

Se necessário, instale via <https://nodejs.org/en/download>.

### 2. MCP Server Azure DevOps configurado

O arquivo `%APPDATA%/Code/User/mcp.json` deve conter o servidor `ado`:

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "senior-sistemas", "-d", "core", "work-items"],
      "env": {
        "ado_mcp_project": "ERP - GATEC"
      }
    }
  }
}
```

### 3. Servidor MCP iniciado

No VS Code, o servidor deve estar ativo (ícone na barra ou `Ctrl+Shift+P` → **MCP: Start Server**).

### 4. GitHub Copilot no VS Code

Extensões necessárias (`Ctrl+Shift+X`):
- `GitHub Copilot`
- `GitHub Copilot Chat`

---

## Como rodar o agente

### 1. Abra o Copilot Chat

```
Ctrl + Alt + I
```

### 2. Selecione o agente

No seletor de agentes do chat, escolha **Issue Validator**.

### 3. Digite o comando

```
valida as issues
```

Pronto. O agente executa as 5 fases automaticamente e exibe o relatório.

### Validar issue específica

```
valide a issue #128340
```

### Prévia sem postar comentário/tag (dry-run)

```
roda o validador -DryRun
```

### Limitar quantidade

```
roda o validador -Top 5
```

### Revalidar issues já alertadas

```
revalida as issues
```

Busca issues que já receberam tag `abertura-incompleta` e verifica se o Suporte complementou. Issues agora completas recebem comentário ✅ e a tag é removida.

### Revalidar issue específica

```
revalida a issue #128340
```

---

## O que acontece automaticamente

| Fase | Ação |
|------|------|
| 1 | Carrega critérios de validação (`agents/issue-validator-validation-criteria.md`) |
| 2 | Busca issues via MCP (WIQL filtrando por `ERP - GATEC\Manutencao` e filhos) |
| 3 | **Lê a descrição de cada issue e valida com inteligência** |
| 4 | Posta comentário HTML (com `#zd`) e aplica tag via MCP |
| 5 | Apresenta relatório e atualiza histórico |

---

## Exemplo de relatório gerado

```
## ✅ Validação Concluída — Path: Manutenção | Status: New

| ID     | Título                        | Tipo WI  | Tipo | Desc | Sist | Menu | Evid | Anal | Vers | Resultado            |
|--------|-------------------------------|----------|------|------|------|------|------|------|------|----------------------|
| ⚡#1230 | Processo parado na filial 02  | Bug      | ✅   | ✅   | ✅   | ✅   | ❌   | ✅   | ✅   | Incompleta           |
| #1234  | Erro ao emitir NF             | Bug      | ✅   | ❌   | ✅   | ✅   | ❌   | ✅   | ❌   | Incompleta           |
| #1237  | Relatório zerado em Contabil   | US       | ✅   | ✅   | ✅   | ⚠️   | ✅   | ✅   | ✅   | Completa com ressalva|
| #1235  | Sistema não abre na filial 03 | US       | ✅   | ✅   | ✅   | ✅   | ✅   | ✅   | ✅   | Completa             |
| #1236  | Relatório zerado              | Bug      | -    | -    | -    | -    | -    | -    | -    | Já validada          |

Total analisadas: 5
Completas: 1
Completas com ressalva: 1
Incompletas: 2 (comentário + tag aplicados)
Já validadas: 1
Excluídas: 0

Itens mais faltantes: Descrição (1) · Evidência (2)

Tendência: ⬇️ Taxa caiu de 100% para 40% vs execução anterior

Pendentes de correção (alertadas há >2 dias úteis):
  #1220 — Erro no fechamento (alertada há 3 dias)
  #1218 — Tela travando (alertada há 5 dias)
```

---

## Checklist de validação

O agente considera uma issue **incompleta** quando qualquer item está ausente.
**Exceção:** se apenas o item 4 (caminho no menu) está ausente e os outros 6 estão OK, classifica como **"Completa com ressalva"** (recebe comentário + tag `abertura-completa`).

| # | Item |
|---|------|
| 1 | Tipo — erro, incidente, melhoria ou dúvida |
| 2 | Descrição do problema |
| 3 | Sistema ou módulo afetado |
| 4 | Caminho no menu até a tela (⚠️ ressalva se único ausente) |
| 5 | Print ou evidência anexada |
| 6 | Analista do Suporte responsável |
| 7 | Versão do sistema |

> Referência completa: `guias/checklist-abertura-issue.md`

## Diferença em relação a um script com regex

| Aspecto | Script com regex | Agente inteligente |
|---------|-----------------|--------------------|
| Descrição | Verifica se campo não está vazio | **Lê o texto e avalia se é um relato real** |
| Caminho no menu | Busca palavras "menu", "tela" | **Entende se a descrição indica ONDE no sistema** |
| Comentário | Template fixo para todas | **Personalizado com contexto específico** |
| Falso positivo | "a tela travou" → aprovaria menu | **"a tela travou" sem QUAL tela → recusa** |

---

## Dúvidas frequentes

**O agente vai sobrescrever comentários existentes?**
Não. Se a issue já tiver um comentário do `issue-validator-agent`, ele pula essa etapa.

**A tag vai duplicar se eu rodar duas vezes?**
Não. O agente verifica se a tag `abertura-incompleta` já existe antes de aplicar.

**O agente altera o conteúdo da issue?**
Não. Ele apenas adiciona/remove comentário e tag — nunca edita título, descrição ou outros campos. Na revalidação, remove a tag `abertura-incompleta` de issues complementadas.

**O servidor MCP não inicia, o que fazer?**
1. Verifique se Node.js 20+ está instalado: `node --version`
2. Teste manualmente: `npx -y @azure-devops/mcp --help`
3. Limpe cache se necessário: `npm cache clean --force`
4. Reinicie o VS Code

**Erro de autenticação ao consultar o ADO?**
Na primeira execução, o navegador abre pedindo login Microsoft. Use as credenciais que têm acesso à organização `senior-sistemas`.

---

## Agendamento (automação)

O agente é executado manualmente a qualquer momento. Para automação futura:

| Opção | Como |
|-------|------|
| **GitHub Actions (cron)** | Workflow `.github/workflows/validate-issues.yml` com `schedule: cron` |

> **Recomendação:** Execute a **validação diariamente** (ex: 08:00) e a **revalidação 2x por semana** (ex: terça e quinta) para fechar o ciclo de feedback com o Suporte.
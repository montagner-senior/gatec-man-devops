---
title: Como Usar o Issue Closure Validator Agent
parent: Agentes
nav_order: 4
---

# Como Usar o Issue Closure Validator Agent

O `issue-closure-validator` é um **agente inteligente** que valida a qualidade do fechamento de issues com estado **Closed** no path **Manutenção**. Ele analisa os comentários da Discussion para verificar se o dev documentou adequadamente a conclusão: o que foi feito, a revisão/commit, e a causa raiz.

### Arquitetura

```
MCP Server Azure DevOps          Agente LLM (cérebro)
┌────────────────────────┐    ┌───────────────────────────────┐
│  WIQL: busca issues     │◀──▶│  Lê comentários e avalia cada  │
│  Get: detalhes + comments│    │  item com inteligência         │
│  Update: tags           │    │                                │
│  Comment: posta HTML    │◀───│  Gera comentário contextual    │
└────────────────────────┘    └───────────────────────────────┘
```

O agente usa **exclusivamente o MCP Server Azure DevOps** para todas as operações — sem scripts intermediários.

---

## Pré-requisitos

### 1. Node.js 20+

Necessário para o MCP Server. Verifique:

```powershell
node --version  # deve ser v20+
```

### 2. MCP Server configurado

O arquivo `%APPDATA%/Code/User/mcp.json` deve conter o servidor `ado`:

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "senior-sistemas", "-d", "core", "work-items"],
      "env": { "ado_mcp_project": "ERP - GATEC" }
    }
  }
}
```

### 3. Servidor MCP ativo

No VS Code: **Command Palette > MCP: Start Server** ou clique no ícone MCP na barra de status. O servidor precisa estar rodando antes de invocar o agente.

### 4. Autenticação Azure DevOps

O MCP usa a autenticação do `az login` ou token configurado no ambiente. Verifique se você tem acesso à organização `senior-sistemas`.

### 5. GitHub Copilot no VS Code

Extensões: `GitHub Copilot` + `GitHub Copilot Chat`

---

## Como rodar o agente

### 1. Abra o Copilot Chat

```
Ctrl + Alt + I
```

### 2. Selecione o agente

No seletor de agentes, escolha **Issue Closure Validator**.

### 3. Digite o comando

```
valida as conclusoes
```

Pronto. O agente executa as 5 fases automaticamente e exibe o relatório ao final.

### Validar issue específica

```
valide a conclusao da issue #128340
```

### Prévia sem postar comentário/tag (dry-run)

```
roda o validador de conclusao -DryRun
```

### Alterar janela temporal (padrão: 7 dias)

```
roda o validador de conclusao -Days 14
```

### Limitar quantidade

```
roda o validador de conclusao -Top 5
```

### Revalidar issues já alertadas

```
revalida as conclusoes
```

Busca issues com tag `conclusao-incompleta` e verifica se o dev já complementou. Issues agora completas recebem comentário ✅ e a tag é removida.

---

## O que acontece automaticamente

| Fase | Ação |
|------|------|
| 1 | Carrega os critérios de validação de conclusão |
| 2 | Busca issues `Closed` via WIQL (MCP) e obtém detalhes + comentários |
| 3 | **Lê os comentários de cada issue e valida com inteligência** |
| 4 | Posta comentário interno (sem `#zd`) e aplica tag via MCP |
| 5 | Apresenta relatório e atualiza histórico |

---

## Checklist de validação de conclusão

O agente considera uma issue **incompleta** quando qualquer item obrigatório está ausente.

| # | Item | Obrigatório |
|---|------|-------------|
| 1 | Comentário de fechamento (o que foi feito) | Sempre |
| 2 | Revisão/Commit referenciado (SVN ou Git) | Sempre (N/A se sem alteração de código) |
| 3 | Análise Crítica (campos da aba) | Sempre para Bugs (N/A para User Stories) |
| 4 | Achado registrado (base-conhecimento) | Quando relevante (⚠️ recomendação) |
| 5 | Suporte notificado (`#zd`) | Quando tem ticket Zendesk (N/A se interno) |

> Referência completa: [Critérios de Validação de Conclusão](closure-validator-validation-criteria.md)

---

## Diferença em relação ao validador de abertura

| Aspecto | Validador de Abertura | Validador de Conclusão |
|---------|----------------------|----------------------|
| **Estado alvo** | New (issues recém-abertas) | Closed (issues recém-fechadas) |
| **Fonte principal** | Descrição da issue | Comentários da Discussion |
| **O que verifica** | Informação para o dev começar | Documentação do que foi feito |
| **Comentário** | Com `#zd` (vai pro Zendesk) | Interno (sem `#zd`) |
| **Tags** | `abertura-completa` / `abertura-incompleta` | `conclusao-validada` / `conclusao-incompleta` |

---

## Dúvidas frequentes

**O comentário vai aparecer no Zendesk?**
Não. O validador de conclusão posta comentários **internos** (sem `#zd`), visíveis apenas no Azure DevOps.

**A tag vai duplicar se eu rodar duas vezes?**
Não. O agente verifica se a tag já existe antes de aplicar, e pula issues já validadas (idempotência via `closure-validator-agent` no HTML).

**Issues sem alteração de código (ex: problema de cadastro) precisam de revisão/commit?**
Não. Se o dev menciona no comentário que não houve alteração de código, o agente marca como N/A.

**O item "Achado registrado" pode reprovar a issue?**
Não. É uma **recomendação** (⚠️), não um bloqueio. A issue é classificada como "Completa com ressalva".

**Posso rodar os dois validadores na mesma issue?**
Sim. Eles operam em fases diferentes do ciclo de vida: um valida a abertura, outro a conclusão. Usam tags e comentários diferentes.

**E se o servidor MCP não estiver ativo?**
O agente informa que o servidor não está disponível e orienta como iniciar. Ele não tenta usar alternativas (CLI, scripts).

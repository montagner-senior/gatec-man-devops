---
title: Como Usar o Issue Validator Agent
parent: Guias
nav_order: 3
---

# Como Usar o Issue Validator Agent

O `issue-validator-agent` valida automaticamente todas as issues com status **New** no path **Manutenção**, adiciona um comentário explicando o que está faltando e aplica a tag `abertura-incompleta` nas issues que não atendem ao checklist.

---

## Pré-requisitos

Faça isso **uma única vez** antes de usar o agente pela primeira vez.

### 1. Instalar o Azure CLI

Baixe e instale em:
```
https://aka.ms/installazurecliwindows
```

### 2. Instalar a extensão Azure DevOps no CLI

Abra o terminal e rode:
```bash
az extension add --name azure-devops
```

### 3. Autenticar com o Azure DevOps

```bash
az devops login --organization https://gantc.visualstudio.com
```

> Será solicitado um **Personal Access Token (PAT)**. Para gerar o seu:
> 1. Acesse `https://gantc.visualstudio.com`
> 2. Clique no seu avatar → **Personal Access Tokens**
> 3. Crie um token com permissões: `Work Items — Read & Write`
> 4. Cole o token quando o terminal pedir

### 4. Instalar o GitHub Copilot no VS Code

No VS Code, instale as duas extensões via `Ctrl+Shift+X`:
- `GitHub Copilot`
- `GitHub Copilot Chat`

---

## Como rodar o agente

### 1. Abra o Copilot Chat

```
Ctrl + Alt + I
```

### 2. Anexe o arquivo do agente

Clique no ícone de clipe 📎 e selecione:
```
agents/validador-issues/issue-validator-agent.md
```

Ou arraste o arquivo direto para o campo de texto do chat.

### 3. Digite o comando

```
@workspace valida as issues
```

Pronto. O agente vai executar os 6 passos automaticamente e exibir o relatório ao final.

---

## O que acontece automaticamente

| Passo | Ação |
|-------|------|
| 1 | Configura o contexto da organização e projeto |
| 2 | Busca todas as issues `New` do path `Manutenção` |
| 3 | Valida cada issue contra os 6 itens do checklist |
| 4 | Adiciona comentário Markdown em cada issue incompleta |
| 5 | Aplica a tag `abertura-incompleta` preservando tags existentes |
| 6 | Exibe o relatório final consolidado |

---

## Exemplo de relatório gerado

```
## ✅ Validação Concluída — Path: Manutenção | Status: New

| ID     | Título                        | Itens faltando                  | Tag                   |
|--------|-------------------------------|---------------------------------|-----------------------|
| #1234  | Erro ao emitir NF             | 2. Descrição · 5. Evidência     | abertura-incompleta ✅ |
| #1235  | Sistema não abre na filial 03 | —                               | —                     |

Total analisadas: 2
Completas: 1
Incompletas: 1 (comentário + tag aplicados automaticamente)
```

---

## Checklist de validação

O agente considera uma issue **incompleta** quando qualquer um dos 6 itens abaixo estiver ausente:

| # | Item |
|---|------|
| 1 | Tipo — erro, incidente, melhoria ou dúvida |
| 2 | Descrição do problema |
| 3 | Sistema ou módulo afetado |
| 4 | Caminho no menu até a tela |
| 5 | Print ou evidência anexada |
| 6 | Analista do Suporte responsável |

> Referência completa: `guias/checklist-abertura-issue.md`

---

## Dúvidas frequentes

**O agente vai sobrescrever comentários existentes?**
Não. Se a issue já tiver um comentário do `issue-validator-agent`, ele pula essa etapa.

**A tag vai duplicar se eu rodar duas vezes?**
Não. O agente verifica se a tag `abertura-incompleta` já existe antes de aplicar.

**O agente altera o conteúdo da issue?**
Não. Ele apenas adiciona comentário e tag — nunca edita título, descrição ou outros campos.

**O token PAT expirou, o que fazer?**
Gere um novo PAT em `https://gantc.visualstudio.com` e rode novamente:
```bash
az devops login --organization https://gantc.visualstudio.com
```
---
title: GitHub Copilot Free — Guia
parent: Guias
nav_order: 7
---

# GitHub Copilot Free

## Objetivo

Como usar o **GitHub Copilot Free** nos projetos do time agora versionados em **Git/GitHub Enterprise**.

> 🔄 **Pós-migração:** o time não usa mais SVN. Todo o código vive no **GitHub Enterprise (Senior Sistemas)**, com prefixo `gatec-` nos repositórios. Veja o [Guia GitHub Enterprise](github-enterprise.md).

## Conta

Crie a conta pessoal usando o e-mail corporativo Senior ou uma conta Google dedicada.

> Para acessar os repositórios da Senior, o login é com o **usuário de rede** (provisionamento via DevOps Central) — ver [GitHub Enterprise](github-enterprise.md).

## IDE

Baixar e usar o VS Code: <https://code.visualstudio.com/download>

## Extensões

### Obrigatória

| Extensão | Descrição |
| --- | --- |
| **GitHub Copilot** by GitHub | Sugestões inline e Copilot Chat — escrever, explicar ou consertar código |
| **GitHub Copilot Chat** by GitHub | Chat com agente integrado ao editor |

### Recomendadas para o fluxo Git

| Extensão | Descrição |
| --- | --- |
| **GitHub Pull Requests and Issues** by GitHub | Abrir, revisar e aprovar PRs sem sair do VS Code |
| **GitLens** by GitKraken | Histórico Git, blame, comparação de versões |
| **Git Graph** by mhutchie | Visualização gráfica do histórico de branches |

> 💡 Para quem prefere interface gráfica para Git: o time DevOps recomenda o **GitHub Desktop** (<https://desktop.github.com/>) como cliente.

### Opcionais — Markdown e legado VB6

| Extensão | Descrição |
| --- | --- |
| **Markdown All in One** by Yu Zhang | Listas, sumários, atalhos de digitação para `.md` |
| **markdownlint** by David Anson | Apontamento de problemas de formatação Markdown |
| **VBA** by serkonda7 | Realce de sintaxe para código VB6/VBA |
| **vscode-pdf** by tomoki1207 | Visualização de arquivos PDF |

> ❌ **Não instalar mais:** extensões de SVN/TortoiseSVN — não são mais usadas pelo time.

---

## Como usar o GitHub Copilot Free

1. No VS Code, **File → Open Folder** e selecione a pasta do repositório (clonado via SSH do GitHub Enterprise)
2. Abra o **Copilot Chat** (`Ctrl+Alt+I`)
3. Garanta que está no modo **Agent** (dropdown inferior do chat)
4. Para a primeira análise de um projeto VB6 legado, rode:

```text
Analise este projeto VB6 e gere um data dictionary.

Include:
- forms (.frm)
- controls in each form
- SQL queries
- database tables and columns
- routines responsible for load and save operations
```

A partir daí, siga normalmente com os prompts que precisar.

> Pode ser que o agente solicite permissão para executar passos — selecione **Enable** para o Agent seguir.

---

## Agentes Copilot do time

O repositório `gatec-man-devops` inclui agentes personalizados que automatizam tarefas do time. Para usá-los, abra o Copilot Chat (`Ctrl+Alt+I`) e selecione o agente, ou digite `@nome-do-agente`.

| Agente | O que faz | Comando rápido |
|--------|-----------|----------------|
| **Issue Validator** | Valida issues abertas no path Manutenção contra o [checklist de abertura](checklist-abertura-issue.md). Posta comentário `#zd` e tag `abertura-incompleta` nas incompletas. | `valida as issues` |
| **Issue Closure Validator** | Valida a qualidade do fechamento das issues contra o [checklist de fechamento](checklist-fechamento-issue.md). | `valida as conclusoes` |
| **Security Validator** | Valida PRs em busca de dados sensíveis expostos no diff. | `valida o PR` |

> 📌 Para detalhes completos, veja [Como Usar o Issue Validator](../agents/issue-validator-how-to.md).

---

## Copilot como revisor de PR

No GitHub Enterprise, é possível **adicionar o GitHub Copilot como revisor** em um Pull Request para análise automática do código.

- Requer **licença de Copilot ativa**
- Consome **créditos da licença** de quem solicita
- Adicionar via página do PR → seção *Reviewers* → selecionar Copilot

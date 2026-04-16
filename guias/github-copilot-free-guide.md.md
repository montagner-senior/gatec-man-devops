---
title: GitHub Copilot Free — Guia
parent: Guias
nav_order: 3
---

# Guithub Copilot Free

## Objetivo

Este guia explica como usar o Github Copilot Free nos projetos VB6

## Conta

A criação da conta pessoal pode ser feita utilizando o e-mail corporativo da Senior ou uma nova conta do Google dedicada a esse fim.

## IDE

Baixar e utilizar o VSCode. <https://code.visualstudio.com/download>

## Extensões

### Obrigatória

| Extensão | Descrição |
| --- | --- |
| Github Copilot Chat by GitHub | Chat com agente para escrever, explicar ou consertar o código. |

### Opcionais

| Extensão | Descrição |
| --- | --- |
| Markdown All in One by Yu Zhang | Para facilitar a digitação e exportação de textos .md (cria listas e sumários sozinho) |
| Markdownlint by David Anson | Um "corretor", mas em vez de ortografia, ele avisa se a formatação do .md está bagunçada |
| SVN by Chris Johnston | Para salvar e ver o histórico de versões dos seus arquivos |
| TortoiseSVN by antasytyx | Cria atalhos de clique-direito para usar o programa Tortoise direto no editor |
| VBA by serkonda7 | Para colorir as palavras dos códigos antigos de VBA e VB6 |
| vscode-pdf by tomoki1207 | Para visualizar arquivos PDF |


## Como usar Github Copilot Free

No VSCode, acessar File > Open Folder e selecionar a pasta do fonte em questão.

Se for a primeira vez abrindo o fonte:

1. Abrir Github Copilot Chat
2. Garantir que está no modo Agent (Dropbox inferior no container do chat)
3. Rodar o Prompt abaixo:

```plain-text
Analise este projeto VB6 e gere um data dictionary.
 
Include:
 
- forms (.frm)
- controls in each form
- SQL queries
- database tables and columns
- routines responsible for load and save operations
```

Depois disso, seguir normalmente com os prompts que desejarem.

> Pode ser que ele solicite permissão para executar certos passos, necessário selecionar Enable para o Agente seguir com o processo.

---

## Agentes Copilot do time

O repositório `gatec-man-devops` inclui agentes personalizados que automatizam tarefas do time.
Para usá-los, abra o Copilot Chat (`Ctrl+Alt+I`) e selecione o agente desejado no seletor, ou digite `@nome-do-agente`.

| Agente | O que faz | Comando rápido |
|--------|-----------|----------------|
| **Issue Validator** | Valida issues abertas no path Manutenção contra o [checklist de 6 itens](checklist-abertura-issue.md). Posta comentário `#zd` e tag `abertura-incompleta` nas issues incompletas. | `valida as issues` |

> 📌 Para detalhes completos, veja [Como Usar o Issue Validator Agent](../agents/issue-validator-how-to.md).

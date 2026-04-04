---
title: Checklist de Abertura de Issue
parent: Guias
nav_order: 2
---

# Modelo Checklist para Suporte Abrir Issue

> 📌 Este checklist é verificado automaticamente pelo agente **Issue Validator**. Issues que não atenderem estes 6 itens recebem comentário `#ZD` e tag `abertura-incompleta`. Veja [como funciona](../agents/issue-validator-how-to.md).

| # | Item | Campo verificado | Critério de presença |
|---|---|---|---|
| 1 | **Tipo** | `Custom.ZendeskNatureza` ou título | Preenchido (erro, incidente, melhoria, dúvida) |
| 2 | **Descrição do problema** | `System.Description` | Não vazio e não apenas "Ver Zendesk #XXXX" e precisa ter um descrição que explique minimamente o problema |
| 3 | **Sistema/módulo afetado** | `Custom.ZendeskModulo` | Preenchido com granularidade — "o sistema" não conta |
| 4 | **Caminho no menu** | `System.Description` | O agente avalia semanticamente se indica ONDE no sistema (ex: "Menu → Tela") |
| 5 | **Evidência anexada** | `relations[rel=AttachedFile]` ou `<img>` | Anexo formal ou imagem inline |
| 6 | **Analista do Suporte** | `System.Description` | O agente lê a descrição procurando nome do analista (assinatura, email, ou menção explícita) |


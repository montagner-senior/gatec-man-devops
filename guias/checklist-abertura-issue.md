---
title: Checklist de Abertura de Issue
parent: Guias
nav_order: 2
---

# Modelo Checklist para Suporte Abrir Issue

| # | Item | Campo verificado | Critério de presença |
|---|---|---|---|
| 1 | **Tipo** | `Custom.ZendeskNatureza` ou título | Preenchido (erro, incidente, melhoria, dúvida) |
| 2 | **Descrição do problema** | `System.Description` | Não vazio e não apenas "Ver Zendesk #XXXX" e precisa ter um descrição que explique minimamente o problema |
| 3 | **Sistema/módulo afetado** | `Custom.ZendeskModulo` | Preenchido com granularidade — "o sistema" não conta |
| 4 | **Caminho no menu** | `System.Description` (regex) | Mencionado (ex: "Menu → Tela") |
| 5 | **Evidência anexada** | `relations[rel=AttachedFile]` ou `<img>` | Anexo formal ou imagem inline |
| 6 | **Analista do Suporte** | `Custom.Description` | Campo preenchido |

#	Item	Critério de presença
•	Descrição do problema	Descrição que explique minimamente o problema
•	Caminho no menu	Mencionado (ex: "Menu → Tela")
•	Evidência anexada	Anexo formal ou imagem inline
•	Analista do Suporte	Campo preenchido

> 💡 **Print rápido:** `Print Screen` → abrir o Paint → `Ctrl+V` → salvar → anexar aqui.

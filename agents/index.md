---
title: Agentes
nav_order: 8
has_children: true
---

# Agentes

Agentes GitHub Copilot configurados para auxiliar o time de Manutenção de Sistemas Legados.

---

## Agentes disponíveis

| Agente | Descrição | Comando rápido |
|--------|-----------|----------------|
| **Issue Validator** | Valida issues abertas no path Manutenção contra o [checklist de 6 itens](../guias/checklist-abertura-issue.md). Adiciona comentário `#zendesk` e tag `abertura-incompleta` nas issues incompletas. | `valida as issues` |

---

## Documentação do Issue Validator

| Documento | Conteúdo |
|-----------|----------|
| [Como Usar](issue-validator-how-to.md) | Pré-requisitos, passo a passo e dúvidas frequentes |
| [Critérios de Validação](issue-validator-validation-criteria.md) | Os 6 itens obrigatórios e campos da API |
| [Histórico de Execuções](issue-validator-history.md) | Log de todas as execuções do agente |

> 📌 A definição técnica do agente fica em `.github/agents/issue-validator.agent.md` — o Copilot Chat o detecta automaticamente.

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
| **Issue Validator** | Valida issues abertas no path Manutenção contra o [checklist de 7 itens](../guias/checklist-abertura-issue.md). Adiciona comentário `#zd` e tag `abertura-incompleta` nas issues incompletas. | `valida as issues` |
| **Issue Closure Validator** | Valida a qualidade do fechamento de issues contra o [checklist de conclusão](../guias/checklist-fechamento-issue.md). Adiciona comentário interno e tag `conclusao-incompleta` nas issues com documentação insuficiente. | `valida as conclusoes` |
| **Security Validator** | Analisa arquivos alterados em busca de dados sensíveis expostos (secrets, credenciais, chaves privadas, dados pessoais). Reporta achados com severidade e recomendação de correção. | `valida o PR` |

---

## Documentação do Issue Validator

| Documento | Conteúdo |
|-----------|----------|
| [Como Usar](issue-validator-how-to.md) | Pré-requisitos, passo a passo e dúvidas frequentes |
| [Critérios de Validação](issue-validator-validation-criteria.md) | Os 7 itens obrigatórios e campos da API |
| [Histórico de Execuções](issue-validator-history.md) | Log de todas as execuções do agente |

> 📌 A definição técnica do agente fica em `.github/agents/issue-validator.agent.md` — o Copilot Chat o detecta automaticamente.

---

## Documentação do Issue Closure Validator

| Documento | Conteúdo |
|-----------|----------|
| [Como Usar](closure-validator-how-to.md) | Pré-requisitos, passo a passo e dúvidas frequentes |
| [Critérios de Validação](closure-validator-validation-criteria.md) | Os 5 itens de conclusão com exemplos |
| [Histórico de Execuções](closure-validator-history.md) | Log de todas as execuções do agente |

> 📌 A definição técnica do agente fica em `.github/agents/issue-closure-validator.agent.md` — o Copilot Chat o detecta automaticamente.

---

## Documentação do Security Validator

| Documento | Conteúdo |
|-----------|----------|
| [Critérios de Validação](security-validator-validation-criteria.md) | As 9 categorias de dados sensíveis com exemplos e severidade |

> 📌 A definição técnica do agente fica em `.github/agents/security-validator.agent.md` — o Copilot Chat o detecta automaticamente.

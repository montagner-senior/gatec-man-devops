---
title: Início
nav_order: 1
permalink: /
---

# Base de Conhecimento — Time de Manutenção
{: .no_toc }

Processos, guias e referências do **Time de Manutenção** — projeto **ERPGA Tech** (Azure DevOps) e **GitHub Enterprise (Senior Sistemas)** após a migração.
{: .fs-6 .fw-300 }

---

| Ponto de atenção | Detalhe |
|---|---|
| **Origem dos Work Items** | Criados **automaticamente** via integração **Zendesk → Azure DevOps** — o dev nunca cria o work item inicial de um cliente |
| **Tipos do time** | **User Story** (dúvida/incidente) e **Bug** (correção) — Fix e Hotfix não existem mais, tudo é Bug |
| **Código-fonte** | **GitHub Enterprise** (organização Senior Sistemas, prefixo `gatec-`) — SVN não é mais usado |
| **Retrabalho** | Sempre **reabrir o work item existente** — nunca abrir novo |
| **Timesheet** | Apontar diretamente no **User Story** ou **Bug** trabalhado |
| **Due Date** | Não alterar o Due Date das Issues ao alterar status no Zendesk |

---

## Sumário
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Primeiros Passos

- [Azure Boards (ADO) — Guia](guias/azure-devops-iniciantes.md)
- [GitHub Enterprise — Guia](guias/github-enterprise.md)
- [Checklist de Abertura de Issue](guias/checklist-abertura-issue.md)
- [Checklist de Fechamento de Issue](guias/checklist-fechamento-issue.md)

---

## Work Items

- [Tipos de Work Item do time — User Story, Bug, Hotfix](guias/work-items.md)
- [Fluxo de estados](guias/work-items.md#fluxo-de-estados)
- [Regras de Timesheet e Retrabalho](guias/work-items.md#timesheet-apontador)

---

## Processos Operacionais

- [User Story — passo a passo](processos/user-story.md)
- [Fix — passo a passo](processos/fix.md)
- [Hotfix — passo a passo](processos/hotfix.md)

---

## Zendesk → Azure DevOps

- [Como funciona a integração](guias/zendesk-devops.md)
- [Ajustes definidos na integração](guias/zendesk-devops.md#ajustes-definidos-na-integração-zendesk)

---

## Agentes Copilot

- [Issue Validator — valida issues incompletas no path Manutenção](agents/issue-validator-how-to.md)
- [Critérios de validação (abertura)](agents/issue-validator-validation-criteria.md)
- [Issue Closure Validator — valida fechamento](agents/closure-validator-how-to.md)
- [Security Validator — valida PRs no GitHub](agents/security-validator-validation-criteria.md)
- [Histórico de execuções](agents/issue-validator-history.md)

---

## Referências

- [Documentação Oficial Azure DevOps](https://learn.microsoft.com/pt-br/azure/devops/)
- [GitHub Copilot — Guia de Uso](guias/github-copilot-free-guide.md.md)

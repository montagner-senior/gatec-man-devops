---
title: Início
nav_order: 1
permalink: /
---

# Base de Conhecimento — Time de Manutenção
{: .no_toc }

Processos, guias e referências do **Time de Manutenção**.
{: .fs-6 .fw-300 }

---

| Ponto de atenção | Detalhe |
|---|---|
| **Origem dos Work Items** | Criados **automaticamente** via integração **Zendesk → Azure DevOps** — o dev nunca cria o work item inicial de um cliente |
| **Retrabalho** | Sempre **reabrir a Issue existente** — nunca abrir nova |
| **Timesheet** | Apontar diretamente no **User Story** |
| **SLA** | Não retirar o SLA das Issues ao alterar status no Zendesk |

---

## Sumário
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Primeiros Passos

- [Azure DevOps para Iniciantes](guias/azure-devops-iniciantes.md)
- [Controle de Versão — SVN](guias/controle-versao-svn.md)
- [Checklist de Abertura de Chamado](guias/checklist-abertura-chamado.md)

---

## Work Items

- [Tipos de Work Item do time — User Story, Fix, Hotfix, Task](guias/work-items.md)
- [Fluxo de estados](guias/work-items.md#fluxo-de-estados)
- [Regras de Timesheet e Retrabalho](guias/work-items.md#timesheet-apontador)

---

## Processos Operacionais

- [User Story — passo a passo](processos/user-story.md)
- [Fix — passo a passo](processos/fix.md)
- [Hotfix — passo a passo](processos/hotfix.md)
- [Transbordo de Suporte — como atender um ticket do Zendesk](processos/transbordo-suporte.md)
- [Investigação de Sistemas](processos/investigacao-legado.md)

---

## Zendesk → Azure DevOps

- [Como funciona a integração](guias/zendesk-devops.md)
- [Ajustes definidos na integração](guias/zendesk-devops.md#ajustes-definidos-na-integração-zendesk)
- [SLA de atendimento](gestao/sla.md)

---

## Gestão do Time

- [SLA — Acordo de Nível de Serviço](gestao/sla.md)
- [Métricas e KPIs](gestao/metricas-kpis.md)
- [Cerimônias](gestao/cerimonias.md)
- [Gestão de Capacidade](gestao/capacidade.md)

---

## Pipelines (CI/CD)

- [Pipeline de Build (CI)](pipelines/ci-build.md)
- [Pipeline de Deploy (CD)](pipelines/cd-deploy.md)
- [Rollback de Deploy](pipelines/rollback.md)

---

## Base de Conhecimento

- [Mapa dos Sistemas](base-conhecimento/mapa-sistemas.md)
- [FAQ do Suporte](base-conhecimento/faq-suporte.md)
- [Template de Achado de Investigação](base-conhecimento/achados/TEMPLATE-achado.md)

---

## Segurança e Acessos

- [Acessos e Permissões](seguranca/acessos-permissoes.md)

---

## Referências

- [Documentação Oficial Azure DevOps](https://learn.microsoft.com/pt-br/azure/devops/)
- [GitHub Copilot — Guia de Uso](guias/github-copilot-free-guide.md.md)

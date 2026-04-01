---
title: Início
nav_order: 1
permalink: /
---

# Gerência e Processos
{: .no_toc }

Base de conhecimento do **Time de Manutenção de Sistemas Legados**.
{: .fs-6 .fw-300 }

---

> **Contexto:** Este workspace é destinado ao time de Manutenção de Sistemas Legados.
> O time atua exclusivamente em manutenção corretiva e atendimento a demandas transbordadas do Suporte.
> **Não existe documentação formal dos softwares legados** — o conhecimento é construído e registrado aqui progressivamente, a partir da investigação do código-fonte.

| Fato crítico | Detalhe |
|---|---|
| **Linguagem dos sistemas** | Visual Basic 6 (VB6) — 100% dos softwares legados |
| **Controle de versão** | Tortoise SVN — o legado **não** usa Git |
| **Origem dos Work Items** | Criados **automaticamente** via integração **Zendesk → Azure DevOps** — o dev nunca cria o work item inicial |
| **Documentação** | Inexistente — todo conhecimento é construído aqui |

---

## Sumário
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Para o Dev — Primeiros Passos

- [O que é o Azure DevOps e por que usamos](guias/azure-devops-iniciantes.md)
- [Como acessar o Azure DevOps](guias/azure-devops-iniciantes.md#como-acessar)
- [Navegando pela interface do Azure DevOps](guias/azure-devops-iniciantes.md#navegando)
- [Onboarding e Offboarding de Membros](gestao/onboarding.md)

---

## Work Items — O que o Time Usa e Como Usar

- [Os três tipos de Work Item do nosso time](guias/work-items.md)
  - [User Story — demanda de melhoria ou novo comportamento](guias/work-items.md#user-story)
  - [Fix — correção de defeito identificado internamente](processos/fix.md)
  - [Hotfix — correção urgente em produção](processos/hotfix.md)
- [Fluxo de Estados dos Work Items](guias/work-items.md#fluxo-de-estados)
- [Como receber e triar um Work Item vindo do Zendesk](guias/zendesk-devops.md)
- [Como atualizar e registrar progresso em um Work Item](guias/work-items.md#registrar-progresso)
- [Como vincular Work Items entre si](guias/work-items.md#vincular)
- [Uso de Tags, Área e Iteração](guias/work-items.md#tags)
- [Queries e Dashboards](guias/work-items.md#queries)

---

## Transbordo de Tickets do Suporte

- [O que é transbordo e quando ocorre](guias/zendesk-devops.md#transbordo)
- [Como o Zendesk cria o Work Item automaticamente](guias/zendesk-devops.md#integracao)
- [Como receber e triar o Work Item na fila do board](guias/zendesk-devops.md#triagem)
- [Processo de investigação do código-fonte VB6](processos/investigacao-legado.md)
- [Como registrar os achados e responder ao Suporte](processos/investigacao-legado.md#registrar)
- [Quando o ticket vira um Fix ou Hotfix](processos/investigacao-legado.md#escalation)
- [SLA de atendimento ao Suporte](gestao/sla.md)

---

## Gestão do Time

- [Papéis e Responsabilidades](gestao/papeis.md)
- [Organização dos Times / Squads](gestao/squads.md)
- [Cerimônias e Rituais Ágeis](gestao/cerimonias.md)
- [Métricas e KPIs de Gerência](gestao/metricas.md)
- [Gestão de Capacidade e Férias](gestao/capacidade.md)
- [Processo de Escalation](gestao/escalation.md)
- [Planejamento de Sprint e Iterações](gestao/sprint.md)
- [Gestão de Backlog e Priorização](gestao/backlog.md)

---

## Controle de Versão — Tortoise SVN

- [O que é o Tortoise SVN e como funciona](guias/svn-basico.md)
- [Como fazer checkout de um repositório SVN](guias/svn-basico.md#checkout)
- [Como atualizar e commitar no SVN](guias/svn-basico.md#update-commit)
- [Estrutura de pastas do SVN (trunk, branches, tags)](guias/svn-basico.md#estrutura)
- [Como resolver conflitos no SVN](guias/svn-basico.md#conflitos)
- [Como rastrear histórico e autoria no SVN](guias/svn-basico.md#historico)

---

## Pipelines (CI/CD)

- [Visão Geral das Pipelines do Time](pipelines/visao-geral.md)
- [Pipeline de Build (CI)](pipelines/build.md)
- [Pipeline de Release / Deploy (CD)](pipelines/release.md)
- [Ambientes: Dev / Homologação / Produção](pipelines/ambientes.md)
- [Aprovações e Gates de Deploy](pipelines/aprovacoes.md)
- [Procedimento em Caso de Falha de Pipeline](pipelines/falha.md)
- [Rollback de Deploy](pipelines/rollback.md)

---

## Processos Operacionais

- [Procedimento de Hotfix — passo a passo completo](processos/hotfix.md)
- [Gestão de Mudanças (Change Management)](processos/change-management.md)
- [Comunicação e Registro de Indisponibilidade](processos/indisponibilidade.md)
- [Gestão de Dívida Técnica](processos/divida-tecnica.md)

---

## Base de Conhecimento dos Sistemas Legados

- [Por que não há documentação e o que fazer](base-conhecimento/sem-documentacao.md)
- [Como documentar um achado de investigação](base-conhecimento/como-documentar.md)
- [Mapa dos sistemas legados (construção contínua)](base-conhecimento/mapa-sistemas.md)
- [Guia de leitura e navegação no código-fonte VB6](base-conhecimento/leitura-vb6.md)
- [FAQ técnico do Suporte](base-conhecimento/faq.md)

---

## Segurança e Acessos

- [Política de Acesso ao Azure DevOps](seguranca/politica-acesso.md)
- [Gestão de Grupos e Permissões](seguranca/grupos-permissoes.md)
- [Segredos, Variáveis e Service Connections](seguranca/secrets.md)
- [Auditoria e Rastreabilidade](seguranca/auditoria.md)

---

## Artifacts e Testes

- [Gestão de Feeds e Pacotes](artifacts/feeds.md)
- [Versionamento de Pacotes](artifacts/versionamento.md)
- [Estratégia de Testes](artifacts/testes.md)
- [Critérios de Aceite e Definition of Done](artifacts/definition-of-done.md)

---

## Referências

- [Documentação Oficial Azure DevOps](https://learn.microsoft.com/pt-br/azure/devops/)
- [Glossário](referencias/glossario.md)
- [Histórico de Decisões (ADR)](referencias/adr.md)

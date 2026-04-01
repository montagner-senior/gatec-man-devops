# .devops — Gerência e Processos | Time de Manutenção Legado Azure DevOps

> **Contexto:** Este workspace é destinado ao time de Manutenção de Sistemas Legados.
> O time atua exclusivamente em manutenção corretiva e atendimento a demandas transbordadas do Suporte.
> **Não existe documentação formal dos softwares legados** — o conhecimento é construído e registrado aqui progressivamente, a partir da investigação do código-fonte.
>
> | Fato crítico | Detalhe |
> |---|---|
> | **Linguagem dos sistemas** | Visual Basic 6 (VB6) — 100% dos softwares legados |
> | **Controle de versão** | Tortoise SVN — o legado **não** usa Git |
> | **Origem dos Work Items** | Criados **automaticamente** via integração **Zendesk → Azure DevOps** — o dev nunca cria o work item inicial |
> | **Documentação** | Inexistente — todo conhecimento é construído aqui |

---

## Sumário

### Para o Dev — Primeiros Passos

1. [O que é o Azure DevOps e por que usamos](#1-o-que-é-o-azure-devops-e-por-que-usamos)
2. [Como acessar o Azure DevOps](#2-como-acessar-o-azure-devops)
3. [Navegando pela interface do Azure DevOps](#3-navegando-pela-interface-do-azure-devops)
4. [Onboarding e Offboarding de Membros](#4-onboarding-e-offboarding-de-membros)

---

### Work Items — O que o Time Usa e Como Usar

5. [Os três tipos de Work Item do nosso time](#5-os-três-tipos-de-work-item-do-nosso-time)
   - 5.1 [User Story — demanda de melhoria ou novo comportamento](#51-user-story)
   - 5.2 [Fix — correção de defeito identificado internamente](#52-fix)
   - 5.3 [Hotfix — correção urgente em produção](#53-hotfix)
6. [Fluxo de Estados dos Work Items](#6-fluxo-de-estados-dos-work-items)
7. [Como receber e triar um Work Item vindo do Zendesk](#7-como-receber-e-triar-um-work-item-vindo-do-zendesk)
8. [Como atualizar e registrar progresso em um Work Item](#8-como-atualizar-e-registrar-progresso-em-um-work-item)
9. [Como vincular Work Items entre si (links e relações)](#9-como-vincular-work-items-entre-si)
10. [Uso de Tags, Área e Iteração](#10-uso-de-tags-área-e-iteração)
11. [Queries e Dashboards — como consultar seu trabalho](#11-queries-e-dashboards)

---

### Transbordo de Tickets do Suporte

12. [O que é transbordo e quando ocorre](#12-o-que-é-transbordo-e-quando-ocorre)
13. [Como o Zendesk cria o Work Item automaticamente no Azure DevOps](#13-como-o-zendesk-cria-o-work-item-automaticamente)
14. [Como receber e triar o Work Item na fila do board](#14-como-receber-e-triar-o-work-item-na-fila-do-board)
15. [Processo de investigação do código-fonte VB6 (sem documentação)](#15-processo-de-investigação-do-código-fonte-vb6)
16. [Como registrar os achados e responder ao Suporte](#16-como-registrar-os-achados-e-responder-ao-suporte)
17. [Quando o ticket vira um Fix ou Hotfix](#17-quando-o-ticket-vira-um-fix-ou-hotfix)
18. [SLA de atendimento ao Suporte](#18-sla-de-atendimento-ao-suporte)

---

### Gestão do Time

19. [Papéis e Responsabilidades](#19-papéis-e-responsabilidades)
20. [Organização dos Times / Squads](#20-organização-dos-times--squads)
21. [Cerimônias e Rituais Ágeis](#21-cerimônias-e-rituais-ágeis)
22. [Métricas e KPIs de Gerência](#22-métricas-e-kpis-de-gerência)
23. [Gestão de Capacidade e Férias](#23-gestão-de-capacidade-e-férias)
24. [Processo de Escalation](#24-processo-de-escalation)
25. [Planejamento de Sprint e Iterações](#25-planejamento-de-sprint-e-iterações)
26. [Gestão de Backlog e Priorização](#26-gestão-de-backlog-e-priorização)

---

### Controle de Versão — Tortoise SVN

27. [O que é o Tortoise SVN e como funciona](#27-o-que-é-o-tortoise-svn-e-como-funciona)
28. [Como fazer checkout de um repositório SVN](#28-como-fazer-checkout-de-um-repositório-svn)
29. [Como atualizar (SVN Update) e commitar (SVN Commit)](#29-como-atualizar-e-commitar-no-svn)
30. [Estrutura de pastas do SVN (trunk, branches, tags)](#30-estrutura-de-pastas-do-svn)
31. [Como resolver conflitos no SVN](#31-como-resolver-conflitos-no-svn)
32. [Como rastrear histórico e autoria de alterações no SVN](#32-como-rastrear-histórico-e-autoria-no-svn)

---

### Pipelines (CI/CD)

33. [Visão Geral das Pipelines do Time](#33-visão-geral-das-pipelines-do-time)
34. [Pipeline de Build (CI)](#34-pipeline-de-build-ci)
35. [Pipeline de Release / Deploy (CD)](#35-pipeline-de-release--deploy-cd)
36. [Ambientes: Dev / Homologação / Produção](#36-ambientes-dev--homologação--produção)
37. [Aprovações e Gates de Deploy](#37-aprovações-e-gates-de-deploy)
38. [Procedimento em Caso de Falha de Pipeline](#38-procedimento-em-caso-de-falha-de-pipeline)
39. [Rollback de Deploy](#39-rollback-de-deploy)

---

### Processos Operacionais

40. [Procedimento de Hotfix — passo a passo completo](#40-procedimento-de-hotfix)
41. [Gestão de Mudanças (Change Management)](#41-gestão-de-mudanças)
42. [Comunicação e Registro de Indisponibilidade](#42-comunicação-e-registro-de-indisponibilidade)
43. [Gestão de Dívida Técnica](#43-gestão-de-dívida-técnica)

---

### Base de Conhecimento dos Sistemas Legados

44. [Por que não há documentação e o que fazer sobre isso](#44-por-que-não-há-documentação-e-o-que-fazer-sobre-isso)
45. [Como documentar um achado de investigação](#45-como-documentar-um-achado-de-investigação)
46. [Mapa dos sistemas legados (construção contínua)](#46-mapa-dos-sistemas-legados)
47. [Guia de leitura e navegação no código-fonte VB6 legado](#47-guia-de-leitura-e-navegação-no-código-fonte-vb6-legado)
48. [Perguntas frequentes recebidas do Suporte (FAQ técnico)](#48-faq-técnico-do-suporte)

---

### Segurança e Acessos

49. [Política de Acesso ao Azure DevOps](#49-política-de-acesso-ao-azure-devops)
50. [Gestão de Grupos e Permissões](#50-gestão-de-grupos-e-permissões)
51. [Segredos, Variáveis e Service Connections](#51-segredos-variáveis-e-service-connections)
52. [Auditoria e Rastreabilidade](#52-auditoria-e-rastreabilidade)

---

### Artifacts e Testes

53. [Gestão de Feeds e Pacotes](#53-gestão-de-feeds-e-pacotes)
54. [Versionamento de Pacotes](#54-versionamento-de-pacotes)
55. [Estratégia de Testes](#55-estratégia-de-testes)
56. [Critérios de Aceite e Definition of Done](#56-critérios-de-aceite-e-definition-of-done)

---

### Referências

57. [Documentação Oficial Azure DevOps](#57-documentação-oficial-azure-devops)
58. [Glossário](#58-glossário)
59. [Histórico de Decisões (ADR — Architecture Decision Records)](#59-histórico-de-decisões-adr)

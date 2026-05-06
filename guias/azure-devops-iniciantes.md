---
title: Azure Boards (ADO) — Guia
parent: Guias
nav_order: 1
---

# Azure Boards (ADO) — Guia do time

> Projeto: **ERPGA Tech** (organização nova após migração do Azure DevOps).
> Treinamento conduzido por **Gisele Cimony**.

Este guia cobre o uso do **Azure Boards** no novo ambiente: hierarquia, tipos de work item, campos obrigatórios, integrações e o que mudou após a migração.

> Para o fluxo de trabalho diário (apontar, comentar, mudar estado, retrabalho, integração com Zendesk) consulte também:
>
> - [Work Items do time](work-items.md)
> - [Zendesk → Azure DevOps](zendesk-devops.md)
> - [Checklist de Abertura](checklist-abertura-issue.md) e [Checklist de Fechamento](checklist-fechamento-issue.md)

---

## Sumário

1. [Acesso ao projeto](#1-acesso-ao-projeto)
2. [Hierarquia de Work Items](#2-hierarquia-de-work-items)
3. [Campos obrigatórios](#3-campos-obrigatórios)
4. [Tipos de Work Item](#4-tipos-de-work-item)
5. [Campos do Bug](#5-campos-do-bug)
6. [Lei do Bem, LGPD, Impedimento](#6-lei-do-bem-lgpd-impedimento)
7. [Apontamento de Horas](#7-apontamento-de-horas)
8. [Delivery Plans](#8-delivery-plans)
9. [Notas de Versão e DOC](#9-notas-de-versão-e-doc)
10. [Natureza do Bug e Hotfix](#10-natureza-do-bug-e-hotfix)
11. [Severidade × Priority](#11-severidade--priority)
12. [Queries e Dashboards](#12-queries-e-dashboards)
13. [Tags Estratégicas](#13-tags-estratégicas)
14. [Customização do Board](#14-customização-do-board)
15. [Migração — o que mudou](#15-migração--o-que-mudou)
16. [Boas práticas](#16-boas-práticas)

---

## 1. Acesso ao projeto

- Link do Azure DevOps disponibilizado pelo time responsável
- Projeto: **ERPGA Tech**
- Boards já vêm configurados após a migração

> O ambiente antigo (`gantc.visualstudio.com`) ficará disponível somente para consulta por tempo a definir, com acesso restrito a Luis Lopes, Yves Polo e DevOps Central.

---

## 2. Hierarquia de Work Items

```
Épico
 └── Feature  /  Discovery (relacionado como filho do Épico)
      └── User Story  /  Bug  /  Apoio  /  Deploy  /  Spike  /  Horas Administrativas
```

| Nível | Tipo | Finalidade |
|---|---|---|
| 1 | Épico | Grande iniciativa / tema de negócio |
| 2 | Feature | Funcionalidade entregável |
| 2 | Discovery | Pesquisa upstream (pré-feature) |
| 3 | User Story | Entrega de valor ao usuário |
| 3 | Bug | Defeito / manutenção |
| 3 | Apoio | Atividades internas sem entrega direta |
| 3 | Deploy | Registro de implantação |
| 3 | Spike | Pesquisa técnica em desenvolvimento |
| 3 | Horas Administrativas | Apontamento não-operacional |

---

## 3. Campos obrigatórios

| Campo | Obrigatório em | Observação |
|---|---|---|
| **Lei do Bem** | Épicos e Features | Use "Não Contempla" ou "Não Informada" quando não aplicável |
| **Tipo de Demanda** | Todos | Replicado automaticamente para os filhos |
| **Datas (Planning)** | Todos | Necessário para o Delivery Plans |
| **Cota** | Todos | Indica se o item possui cota alocada |
| **Impedido** | Todos | Flag de bloqueio |
| **Motivo do Impedimento** | Todos (quando impedido) | Visível para todo o projeto — escrever de forma clara |

> 💡 **Tipo de Demanda** preenchido no item pai é replicado automaticamente nos filhos.

---

## 4. Tipos de Work Item

### 4.1 Épico

Grande iniciativa de negócio. Contém a aba de **LGPD**. Lei do Bem obrigatória.

### 4.2 Discovery

Pesquisa **antes** da Feature (upstream). Vinculado como filho do Épico. Quando finalizado dá origem a uma Feature.

> Fluxo: `Discovery (upstream) → Feature → User Stories`

### 4.3 Feature

Funcionalidade entregável. Filha do Épico. Pode receber uma Spike para refinamento técnico antes do planejamento. Lei do Bem obrigatória.

### 4.4 User Story

Entrega de valor ao usuário final. Item central do Kanban. Preencher datas para o Delivery Plans.

### 4.5 Apoio

Atividades **sem entrega direta de valor**: configuração de ambiente, instalação de ferramentas, suporte interno (chamado no Teams), apoio operacional.

### 4.6 Deploy

Registro de implantação/deploy de versões. Usado pelos times que adotam esse processo.

### 4.7 Horas Administrativas

Apontamento de horas em atividades **não fim** do dev: treinamentos, reuniões da empresa, comunicados.

Sugestão de uso:

1. Crie **uma Hora Administrativa por mês**
2. Aponte pelo aplicativo do time
3. Encerre ao final do mês
4. O BI consolida pela **data do apontamento**, independente do item usado

### 4.8 Spike

Pesquisa técnica **durante o desenvolvimento**. Usos típicos:

- Refinamento técnico antes da Feature entrar no planejamento
- Validar esforço de uma Feature
- Quebrar Feature em histórias
- Insumo técnico para Discovery em andamento

> ⚠️ **Discovery × Spike:** Discovery é upstream (pré-dev). Spike é durante o ciclo de dev.

### 4.9 Bug / Manutenção

Defeitos e manutenções. **Raia (swimlane) dedicada** no Board.

> No ambiente antigo o time usava os tipos **Issue, Fix e Hotfix** — todos foram migrados para **Bug**, e o tipo (incluindo Hotfix) é identificado pelo campo **Natureza** (ver [seção 10](#10-natureza-do-bug-e-hotfix) e o guia [Work Items do time](work-items.md)).

Lei do Bem em Bug: **Não Contempla** (bugs não geram lei do bem).

---

## 5. Campos do Bug

### Aba principal

| Campo | Descrição |
|---|---|
| **Bug Type** | Classificação do tipo |
| **Severidade** | Impacto no sistema (uso interno do time) |
| **Criticidade** | Urgência de resolução |
| **Descrição** | Detalhe do problema |

### Aba Análise Crítica

Processo da Senior para melhoria contínua. Permite registrar:

- Comportamento original do produto
- Defeito gerado por uma implementação
- Manutenção que causou efeito cascata

> A Análise Crítica gera insumos para evolução de processos. Mesmo se não obrigatória, o uso é incentivado.

### Aba Zendesk

Campos preenchidos automaticamente pela integração com o Zendesk — ver [Zendesk → Azure DevOps](zendesk-devops.md).

### Aba Notas de Versão

Registro das notas de versão relacionadas ao bug corrigido (uso pela equipe DOC).

---

## 6. Lei do Bem, LGPD, Impedimento

### Lei do Bem

| Valor | Quando usar |
|---|---|
| *(valor específico)* | Quando há lei do bem associada |
| **Não Contempla** | Não está relacionada (ex: bugs, manutenções) |
| **Não Informada** | Ainda não se sabe qual lei do bem associar |

> 🔍 Use **"Não Informada"** para facilitar filtros/QLRs de itens a classificar.

### LGPD

Aba dentro do Épico. Política de segurança da informação da Senior, normalmente usada apenas no módulo ERP. Seguir orientações da PO de LGPD.

### Impedimento

Presente em **todos** os work items.

| Campo | Descrição |
|---|---|
| **Impedido** | Flag de bloqueio |
| **Motivo do Impedimento** | Texto descritivo (visível a todos) |

> ⚠️ O motivo aparece para todo o projeto. Escreva de forma clara, objetiva e profissional. É possível adicionar mais de um motivo.

---

## 7. Apontamento de Horas

Feito pelo **aplicativo já utilizado pelo time** (evoluído para uso na Senior).

| Tipo | Para apontar |
|---|---|
| User Story / Bug | Desenvolvimento / manutenção |
| Apoio | Suporte interno, configurações |
| Spike | Pesquisa técnica com horas do time |
| Horas Administrativas | Treinamentos, reuniões, comunicados |

Fluxo recomendado:

```
1. Crie uma Hora Administrativa por mês
2. Aponte pelo aplicativo (vinculado ao work item)
3. Encerre ao final do mês
4. O BI consolida pela data do apontamento
```

---

## 8. Delivery Plans

Visualização de planejamento ao longo do tempo. Requer o **preenchimento das datas** de Planning em cada work item. Permite ver entregas de múltiplos times em uma linha do tempo.

> 📅 Sempre preencha datas de início e fim para garantir visibilidade.

---

## 9. Notas de Versão e DOC

### Notas de Versão

Campo nos work items (especialmente Bugs), usado pela equipe **DOC**. Coordene com DOC sobre o padrão de preenchimento.

### Work Item DOC

| Vínculo | Tipo |
|---|---|
| Apoio | **Related** a User Story / Feature |
| Bug | **Related** a User Story |
| Spike | **Child** ou **Related** a Feature / User Story |
| **DOC** | **Child** obrigatório de User Story |

> 📌 **Sem o DOC vinculado, a User Story não avança no Board.** Mesma regra para Bugs (precisam de documentação associada).

---

## 10. Natureza do Bug e Hotfix

| Origem | Comportamento |
|---|---|
| Bugs vindos do Zendesk | **Natureza definida automaticamente** pela integração — não editável |
| Bugs criados manualmente | É possível selecionar/criar nova classificação (`Hotfix`, `Bug Fix`, etc.) |

> Para o time ERPGA Tech, **Hotfix** deixou de ser um tipo de work item — é um **Bug com Natureza = Hotfix**. Ver [Work Items do time](work-items.md).

---

## 11. Severidade × Priority

| Campo | Origem | Edita? |
|---|---|---|
| **Priority** | Integração Zendesk | ❌ Não — não alterar |
| **Severidade** | Interno do time | ✅ Sim — ajustar conforme avaliação |

---

## 12. Queries e Dashboards

| Perfil | Pode |
|---|---|
| **Liderança** | Criar queries compartilhadas, editar, gerenciar pastas, conceder permissões |
| **Devs** | Criar/editar queries dentro das pastas autorizadas |

Queries compartilhadas ficam organizadas em **pastas por time** (ex: pasta da equipe). Lideranças definem permissões. Dentro da pasta autorizada todos os membros podem gerenciar queries.

---

## 13. Tags Estratégicas

Tags coloridas identificam visualmente entregas de alto valor.

Aplicar quando o item é:

- **Contrato de Resultado** — entrega que compõe o resultado formal do time/unidade
- **Projeto Estratégico** — iniciativa do planejamento estratégico

Aplicação principalmente pelo **time de Produto** ao priorizar o backlog. Elimina planilhas paralelas — dashboards e queries são gerados direto do board.

---

## 14. Customização do Board

- **Lideranças** podem customizar colunas do Board do seu time
- A customização precisa **respeitar os status existentes** no processo
- Para novos status: alinhar com a equipe responsável pelo ADO

---

## 15. Migração — o que mudou

### Cronograma

| Evento | Quando |
|---|---|
| Início da migração | Sexta, após 17h |
| Suporte pós-migração | Segunda-feira seguinte |
| Adição dos usuários ao projeto | Quinta/sexta da semana de corte |

### Tipos migrados

Tipos antigos foram convertidos automaticamente:

| Tipo antigo | Tipo novo |
|---|---|
| Issue, Fix, Hotfix | **Bug** |
| Documentation | **Documentação** |
| Administrative Task | **HADM** |
| Deployment Task | **Deploy** |

### Estados após a migração

| Situação no antigo | Estado no novo |
|---|---|
| Em backlog | **New** |
| Em andamento (qualquer etapa) | **Active** |

> ⚠️ Itens que estavam em Review/Teste/etc. chegam como **Active** — é necessário **reposicionar manualmente** no Board.

### Critérios de corte

- ChangedDate como referência: **1 ano** para Épicos, **4 meses** para os demais
- Itens em **Closed/Removed/Canceled** **não** foram migrados
- Tipos **Test Suite, Test Plan, Product** **não** foram migrados

### Campo `ReflectedWorkItemId`

Contém o link para o work item antigo. Pode ser usado para filtrar pelo ID antigo (filtro **Contains** com o ID no final do link).

### Tags da migração — podem ser ignoradas/removidas

`simple-farm-mg`, `torreA-simplefarm`, `sf-commodities`, `sf-commodities-trading`, `sf-commodities-commerce`, `torreB-simplefarm`, `simplefarm-agricola`, `first-migration-batch`, `migrated-full`, `migration-attachment-error`, `attachment-uploaded`.

### Histórico

O migrador preserva o histórico, mas pode mostrar entradas estranhas (ex: item criado no ano passado constando como criado no projeto novo). Isso é **esperado**.

---

## 16. Boas práticas

✅ **Faça sempre:**

- Preencha **todos os campos obrigatórios** antes de mover o item
- Use "Não Contempla"/"Não Informada" em Lei do Bem quando não aplicável
- Crie **uma Hora Administrativa por mês**
- Escreva motivo de impedimento de forma clara (visível a todos)
- Vincule o work item ao **pai correto**

❌ **Evite:**

- Deixar campos obrigatórios em branco
- Criar work item sem pai na hierarquia
- Confundir **Discovery** (upstream) com **Spike** (em desenvolvimento)
- Descrever impedimentos de forma vaga

### Resumo rápido — qual usar?

| Situação | Work Item |
|---|---|
| Grande iniciativa de negócio | Épico |
| Funcionalidade para o usuário | Feature |
| Pesquisa antes da Feature (upstream) | Discovery |
| Entrega de valor ao usuário final | User Story |
| Defeito ou manutenção | Bug |
| Suporte interno, configuração | Apoio |
| Registro de deploy | Deploy |
| Análise técnica durante o dev | Spike |
| Treinamento, reunião, comunicado | Horas Administrativas |

---

*Guia baseado no treinamento Azure Boards — ERPGA Tech (facilitadora: Gisele Cimony).*

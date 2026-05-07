---
title: Work Items do time
parent: Guias
nav_order: 4
---

# Work Items — User Story e Bug

## Objetivo

Explicar os tipos de work item utilizados pelo time de Manutenção no novo ambiente **ERPGA Tech**, como identificar cada um e quais são as regras do time.

> 📚 Para o catálogo completo de tipos do Azure Boards (Épico, Feature, Discovery, Apoio, Spike, Deploy, Horas Administrativas), consulte o [Guia do Azure Boards](azure-devops-iniciantes.md).

---

## O que mudou com a migração

No ambiente antigo o time usava três tipos próprios — **Issue**, **Fix** e **Hotfix**. Na migração para o ERPGA Tech todos foram convertidos:

| Tipo antigo | Tipo novo | Como diferenciar |
|---|---|---|
| Issue (dúvida/incidente) | **User Story** | Atendimento de dúvida ou incidente — sem alteração de código |
| Fix | **Bug** | Correção de erro identificado |
| Hotfix | **Bug** | Correção de erro identificado (urgência tratada via Priority/Severidade) |

---

## Os tipos usados pelo time

| Tipo | Urgência | Origem | Natureza |
|---|---|---|---|
| **User Story** | Normal | Solicitação de melhoria, dúvida ou incidente (Zendesk ou gerência) | Atendimento de Dúvida e Incidentes |
| **Bug** | Normal ou Imediata | Erro identificado (Zendesk ou interno) | Alteração de código — correção de erros |

> ⚠️ **Tickets do Zendesk chegam automaticamente** como Bug ou User Story via integração — o dev **nunca cria** o work item inicial de um ticket de cliente.

> 💡 A urgência de um Bug é controlada pelos campos **Priority** (vindo do Zendesk, não editável) e **Severidade** (interno do time, ajustável). Bugs com processo crítico parado em produção devem ter Severidade elevada.

---

## Apoio, Spike e Horas Administrativas

Use os tipos abaixo quando aplicável (detalhes no [Guia Azure Boards](azure-devops-iniciantes.md)):

| Tipo | Quando usar |
|---|---|
| **Apoio** | Atendimentos derivados de uma issue já aberta (ex: subir base, executar script), suporte interno, configurações de ambiente |
| **Spike** | Pesquisa técnica com consumo de horas (refinamento, validação de esforço) |
| **Horas Administrativas** | Treinamentos, reuniões da empresa, comunicados internos |

> 📌 **Regra do time:** O antigo "Task" foi substituído por **Apoio** para atendimentos derivados de uma issue já existente.

---

## Timesheet (Apontador)

> 📌 **Regra do time:** O apontamento de horas é feito **diretamente no User Story ou Bug** que está sendo trabalhado. Apontamentos administrativos vão para **Horas Administrativas** (sugestão: uma por mês).

---

## Retrabalho

> 📌 **Regra do time:** Quando houver retrabalho em um atendimento, **não abra um novo work item**. **Reabra o existente** e continue nele. Mantém o histórico completo e facilita o rastreamento. Mesma regra vale no Zendesk: reabrir o ticket existente (via Macro) em vez de abrir novo.

---

## Fluxo de estados

| Estado | Descrição |
|---|---|
| **New** | Na fila para atendimento |
| **Active** | Em atendimento |
| **Waiting** | Esperando por algo ou alguém |
| **Closed** | Atendimento finalizado |

> ⚠️ Itens migrados que estavam em estados intermediários (Review, Teste, etc.) chegaram como **Active**. Reposicione manualmente conforme o estado real.

---

## Discussion

Todo work item deve ter pelo menos um comentário técnico antes de ser concluído. Não feche um work item sem registrar o que foi feito.

> 📌 **Tag `#zd`:** Ao incluir um comentário no campo Discussion, utilize **`#zd`** como primeira palavra para que o comentário seja enviado ao ticket no Zendesk como **observação interna**.

> 💡 **Validação automatizada:** O agente **Issue Validator** verifica se as issues abertas possuem os 7 campos do [checklist de abertura](checklist-abertura-issue.md). Issues incompletas recebem comentário e tag automaticamente. Veja [como funciona](../agents/issue-validator-how-to.md).

---

## Exemplos de classificação

### User Story
- "O que o botão *Realizar Fechamento* faz?"
- "Envio de e-mail automático retorna mensagem dizendo que o servidor SMTP está indisponível"

### Bug
- Tela de erro genérico
- `Invalid use of Null`
- `ORA-XXXX`
- Balança retorna peso 0 e impede a operação do cliente
- Tela de Fechamento apresentando erro em produção

---

## Documentação obrigatória (DOC)

> 📌 No novo processo Senior, **User Stories e Bugs precisam de um item DOC vinculado** (filho da User Story / relacionado ao Bug) para avançarem no Board. Coordene com a equipe de DOC sobre o padrão de preenchimento das **Notas de Versão**.

---

## Comunicação Suporte ↔ Manutenção

| Caminho | Como |
|---|---|
| Manutenção → Suporte | Comentário no work item com `#zd` (vai como observação interna no Zendesk). Para conclusão, comunicar também via Teams ao responsável do ticket. |
| Suporte → Manutenção | Via Zendesk → integração cria/atualiza o work item automaticamente |

> ❌ Dev **não responde** diretamente no Zendesk — sempre via comentário no work item.

---

## Tabela comparativa rápida

| Critério | User Story | Bug |
|---|---|---|
| **Urgência** | Normal | Normal ou Imediata (conforme Severidade) |
| **Natureza** | Dúvida / Incidente | Correção de erro |
| **Altera código?** | Em geral, não | Sim |
| **Timesheet** | Aponta aqui | Aponta aqui |

---

## Pendências em definição

| Ponto | Status |
|---|---|
| Fechar versão toda sexta-feira? | ⏳ Aguardando definição |
| Criação de time de QA? | ⏳ Aguardando definição |

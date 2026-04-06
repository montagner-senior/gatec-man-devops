---
title: Work Items
parent: Guias
nav_order: 4
---

# Work Items — User Story, Fix e Hotfix

## Objetivo

Este guia explica os três tipos de work item utilizados pelo time de Manutenção de Sistemas Legados: como identificar cada um, como gerenciá-los no Azure DevOps e quais são as regras de uso.

## Os três tipos de Work Item do time

> 📌 **Regra do time:** O time usa **exclusivamente** estes três tipos.

| Tipo | Urgência | Origem | Natureza |
| --- | --- | --- | --- |
| **User Story** | Normal | Solicitação de melhoria, dúvida ou incidente | Atendimentos de Dúvida e Incidentes |
| **Fix** | Normal | Correção identificada internamente | Alteração de código — correção de erros |
| **Hotfix** | **Alta — imediata** | Correção em processo crítico (Ex.: Fechamento ou Pesagem) | Alteração de código — correção de erros |

> ⚠️ **Atenção:** Tickets do Zendesk chegam no Azure DevOps via Work Item — Criação realizada pelo time de suporte via Integração.

---

## Task — Quando usar

> 📌 **Regra do time:** Tasks **só devem ser criadas** quando houver um **segundo atendimento derivado** de uma Issue já existente — por exemplo, subir base de dados, executar script em produção, ou outra ação complementar ao atendimento principal não executado pelo Responsável Original. Ou, quando for relacionado à alguma tarefa administrativa, como reuniões.

**Não crie Tasks para:**
- O atendimento principal do ticket (use User Story, Fix ou Hotfix)
- Subdivisão de atividades dentro de um mesmo atendimento

---

## Timesheet (Apontador)

> 📌 **Regra do time:** O apontamento de horas (Timesheet) deve ser feito **diretamente no User Story, Fix ou Hotfix**. Apontamento em tasks, somente quando tarefas administrativas.

---

## Retrabalho

> 📌 **Regra do time:** Quando houver retrabalho em um atendimento, **não abra uma nova Issue**. **Reabra a Issue existente** e continue o trabalho nela. Isso mantém o histórico completo e facilita rastreamento.

---

## Fluxo de estados

| Estado | Descrição |
| --- | --- |
| New | Na fila para atendimento
| Active | Em atendimento |
| Waiting | Esperando por algo ou alguém
| Closed | Atendimento finalizado

## Discussion

Todo work item deve ter pelo menos um comentário técnico antes de ser concluído. Não feche um work item sem registrar o que foi feito.

> 📌 **Dica:** Ao incluir um comentário no campo Discussion, utilize a tag **`#zendesk`** como primeira palavra para que o comentário seja enviado ao ticket no Zendesk como **observação interna**.

> 💡 **Validação automatizada:** O agente **Issue Validator** verifica se as issues abertas possuem os 6 campos obrigatórios do [checklist de abertura](checklist-abertura-issue.md). Issues incompletas recebem comentário e tag automaticamente. Veja [como funciona](../agents/issue-validator-how-to.md).

## User Story

Um **User Story** representa uma dúvida ou incidente nos sistemas.

**Exemplos:**

- "O que o botão realizar fechamento faz?"
- "Envio de e-mail automático retorna mensagem falando que o servidor SMTP está indisponível"

## Fix

Um **Fix** é a correção de um erro nos sistemas.

**Exemplos:**

- Tela de Erro genérico explicito
- Invalid use of Null
- ORA-XXXX

## Hotfix

Um **Hotfix** é uma correção **urgente** de um erro que está **parando o processo do cliente** e causando impacto direto no negócio. Tem **prioridade máxima** sobre qualquer outra atividade do time.

> ⚠️ **Atenção:** Ao identificar ou receber um Hotfix, **pare o que estiver fazendo** e siga as orientações recebidas pelo Gestor.

**Exemplos:**

- Balança retorna peso 0
- Fechamento apresentando erro

## Comunicação entre Suporte x Manutenção

Use o canal de comunicação Teams para informar o responsável do Ticket sobre um atendimento concluído. (Esse processo é manual até termos uma automatização ou integração do processo)

## Tabela comparativa rápida

| Critério | User Story | Fix | Hotfix |
|---|---|---|---|
| **Urgência** | Normal | Normal | **Imediata** |
| **Natureza** | Atendimentos de Dúvida e Incidentes | Alteração de código — correção de erros | Alteração de código — correção de erros |
| **Timesheet** | Apontar aqui | — | — |

---

## Pendências em definição

Os seguintes pontos foram levantados em alinhamento e aguardam definição pela Gerência:

| Ponto | Status |
|---|---|
| Fechar versão toda sexta-feira? | ⏳ Aguardando definição |
| Criação de time de QA? | ⏳ Aguardando definição |

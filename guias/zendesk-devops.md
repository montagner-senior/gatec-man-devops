---
title: Zendesk → Azure DevOps
parent: Guias
nav_order: 5
---

# Integração Zendesk → Azure DevOps

## Objetivo

Explicar como funciona a integração automática entre o sistema de suporte ao cliente (Zendesk) e o Azure DevOps — por onde os tickets chegam ao time de Manutenção, como identificar a origem de um work item e o que o dev deve fazer ao recebê-lo.

## Como funciona a integração

O Suporte utiliza o **Zendesk** para registrar e gerenciar os chamados dos clientes. Quando um chamado ultrapassa a capacidade técnica do Suporte (ou seja, exige análise de código-fonte), ele é enviado para o time de Manutenção.

Acontece de forma **totalmente automática**:

```
Cliente reporta problema ao Suporte
       ↓
Suporte abre ou atualiza o chamado no Zendesk
       ↓
Suporte entende que o chamado precisa ir para a equipe técnica
       ↓
Integração cria um Work Item no Azure DevOps
       ↓
Work Item aparece na fila do time de Manutenção (Boards → Backlogs)
       ↓
Dev recebe, investiga e atualiza o Work Item
```

> 📌 **Regra do time:** O dev **nunca cria** o work item inicial de um ticket de cliente. Ele **sempre chega** via Zendesk. Criar manualmente seria duplicar o ticket e quebrar o rastreamento com o Suporte.

## O que fazer ao receber um Work Item do Zendesk

### Passo 1 — Ler e entender o relato

### Passo 2 — Sinalizar que o ticket está em andamento

1. Mude o estado para **Active**

> ⚠️ **Atenção:** Nunca deixe um ticket sem atribuição.

### Passo 3 — Investigar

### Passo 4 — Atualizar o Work Item

A cada achado relevante, adicione um comentário técnico no work item.

**Modelo de comentário técnico:**

```
Investigação — [data]

Sistema: <nome-do-sistema>
Arquivo investigado: NomeTela.frm / NomeModulo.bas

O que foi encontrado:
[descreva o achado aqui]

Próximo passo:
[o que você vai fazer em seguida]
```

### Passo 5 — Comunicar ao Suporte

Ao concluir a investigação (mesmo que sem solução definitiva), adicione um comentário em linguagem acessível para que o Suporte possa repassar ao cliente:

> 📌 **Dica:** Utilize a tag **`#zendesk`** no campo Discussion para que o comentário seja enviado ao ticket no Zendesk como **observação interna**.

**Modelo de resposta ao Suporte:**

```
Resposta para o Suporte — [data]

Analisamos o sistema <nome-do-sistema> e identificamos o seguinte:

[Explicação sem jargão técnico do que foi encontrado]

Ação tomada:
[ ] Problema resolvido — o que foi feito
[ ] Fix aberto (#número) — previsão: [data estimada]
[ ] Hotfix iniciado — em correção agora
[ ] Aguardando mais informações — precisamos saber: [pergunta]
```

### Passo 6 — Encerrar

## Ajustes definidos na integração Zendesk

Os seguintes ajustes foram alinhados entre o time de Manutenção e o Suporte para a integração Zendesk → Azure DevOps:

### 1. User Story deve ter path "Manutenção"

> 📌 **Regra do time:** As User Stories criadas via integração Zendesk devem conter o **path "Manutenção"** configurado no Zendesk. Isso garante que os work items cheguem corretamente ao board do time.

### 2. Não retirar SLA das Issues ao alterar status no Zendesk

> ⚠️ **Atenção:** Ao alterar o status de uma Issue no Zendesk, o **SLA não deve ser retirado**. A contagem de SLA deve permanecer ativa independentemente de mudanças de status no Zendesk. Se isso estiver acontecendo, comunique à Gerência para ajuste na configuração da integração.

### 3. Retrabalho — Reabrir a Issue existente

> 📌 **Regra do time:** Quando houver retrabalho em um atendimento, **não abrir uma nova Issue** no Zendesk. A Issue existente deve ser **reaberta**. Deve ser criada uma **Macro no Zendesk** para facilitar esse processo de reabertura.

---

## Observações e Alertas

> 📌 **Regra do time:** Todo ticket vindo do Zendesk deve ter, ao final, um comentário de "Resposta ao Suporte" no work item — mesmo que a resposta seja "não foi possível reproduzir o problema".

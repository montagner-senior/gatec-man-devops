---
title: Zendesk → Azure DevOps
parent: Guias
nav_order: 5
---

# Integração Zendesk → Azure DevOps

## Objetivo

Explicar como funciona a integração automática entre o **Zendesk** (suporte ao cliente) e o **Azure DevOps ERPGA Tech** — por onde os tickets chegam ao time de Manutenção e o que o dev deve fazer ao recebê-los.

---

## Como funciona

```
Cliente reporta problema ao Suporte
       ↓
Suporte abre/atualiza o chamado no Zendesk (path: Manutenção)
       ↓
Integração cria um Bug ou User Story no Azure DevOps (ERPGA Tech)
       ↓
Work Item aparece na fila do time (Boards → Backlogs)
       ↓
Dev recebe, investiga e atualiza o work item
       ↓
Dev fecha o work item com comentário #zd (vai ao Zendesk)
```

> 📌 **Regra do time:** O dev **nunca cria** o work item inicial de um ticket de cliente — ele **sempre chega** via Zendesk. Criar manualmente duplica o ticket e quebra o rastreamento com o Suporte.

---

## O que a integração preenche automaticamente

Bugs vindos do Zendesk chegam com:

- **Aba Zendesk** preenchida (ticket de origem, módulo, dados do solicitante)
- Campo **Priority** (vindo do Zendesk — **não editar**)
- Campo **Natureza** já definido — para Bug, **não é editável** após a chegada via Zendesk

> ⚠️ **Severidade × Priority:**
>
> - **Priority** vem do Zendesk e **não deve ser alterado**
> - **Severidade** é interno do time e **pode ser ajustado** conforme avaliação técnica

---

## O que fazer ao receber um work item do Zendesk

### Passo 1 — Ler e entender o relato

Confira o checklist de [abertura de issue](checklist-abertura-issue.md). Se faltar informação essencial, peça via comentário `#zd`.

### Passo 2 — Sinalizar que está em andamento

1. Atribua o item a você
2. Mude o estado para **Active**

> ⚠️ Nunca deixe um item sem atribuição.

### Passo 3 — Investigar

### Passo 4 — Atualizar o work item

A cada achado relevante, adicione um comentário técnico no campo Discussion.

**Modelo:**

```
Investigação — [data]

Sistema: <nome-do-sistema>
Repositório: gatec-<nome-do-repo>
Arquivo investigado: NomeTela.frm / NomeModulo.bas

O que foi encontrado:
[descreva o achado]

Próximo passo:
[o que você vai fazer em seguida]
```

### Passo 5 — Comunicar ao Suporte

Ao concluir (mesmo sem solução definitiva), adicione um comentário em linguagem acessível para o Suporte repassar ao cliente.

> 📌 Use `#zd` como **primeira palavra** para que o comentário vá como **observação interna** no Zendesk.

### Passo 6 — Encerrar

Siga o [checklist de fechamento](checklist-fechamento-issue.md) — incluindo o link do **PR no GitHub** (não mais revisão SVN) e a descrição da causa raiz.

---

## Ajustes definidos na integração Zendesk

### 1. Path "Manutenção" no Zendesk

> 📌 As User Stories/Bugs criados via integração Zendesk devem conter o **path "Manutenção"** configurado no Zendesk. Isso garante que cheguem ao board correto do time.

### 2. Due Date não deve ser alterado ao mover status no Zendesk

> ⚠️ Ao alterar o status de uma issue no Zendesk, o campo **Due Date** não pode ser retirado ou alterado. A data precisa permanecer ativa. Se isso ocorrer, comunicar à Gerência para ajuste na configuração da integração.

### 3. Retrabalho — reabrir a issue existente

> 📌 Quando houver retrabalho, **não abrir nova issue** no Zendesk. A existente deve ser **reaberta** (via Macro). Mesma regra no Azure Boards: reabrir o work item existente.

---

## Diferenças em relação ao ambiente antigo

| Antes (Azure DevOps antigo) | Agora (ERPGA Tech) |
|---|---|
| Issue / Fix / Hotfix vinham do Zendesk | **Bug** vem do Zendesk (Fix e Hotfix não existem mais) |
| Revisão SVN no comentário de fechamento | **Link do PR no GitHub** + número da revisão Git |
| Tipos próprios do time | Tipos padronizados Senior + campos customizados |
| Campo "Zendesk SLA" | Campo **Due Date** |

---

## Observações e alertas

> 📌 Todo ticket vindo do Zendesk deve ter, ao final, um comentário de "Resposta ao Suporte" no work item (com `#zd`) — mesmo que a resposta seja "não foi possível reproduzir o problema".

> 💡 **Automação:** O agente **Issue Validator** verifica automaticamente as issues abertas no path Manutenção contra os campos obrigatórios. Issues incompletas recebem comentário `#zd` (visível ao Suporte no Zendesk) listando o que falta. Veja [Como Usar o Issue Validator](../agents/issue-validator-how-to.md).

---
title: Checklist de Fechamento de Issue (Em Validação)
parent: Guias
nav_order: 3
---

# Checklist de Fechamento de Issue

> 📌 Este checklist é verificado automaticamente pelo agente **Issue Closure Validator**. Issues que não atenderem os itens obrigatórios recebem comentário interno e tag `conclusao-incompleta`. Veja [como funciona](../agents/closure-validator-how-to.md).

## Antes de mover para "Concluído"

Adicione um comentário na Discussion com as informações abaixo:

| # | Item | Obrigatório | O que escrever |
|---|------|-------------|----------------|
| 1 | **O que foi feito** | ✅ Sempre | Descreva a ação realizada: o que corrigiu, ajustou ou investigou. Onde no código (arquivo, rotina, tela). |
| 2 | **Revisão SVN** | ✅ Sempre | Número do commit: `r54321` ou `Rev. 54321`. Se não houve alteração de código, mencione explicitamente. |
| 3 | **Causa raiz** | ✅ Sempre | Por que o problema acontecia? Qual era a causa? Ex: "campo alíquota não considerava UF destino". |
| 4 | **Achado registrado** | ⚠️ Quando relevante | Se a investigação revelou algo importante, registre em `base-conhecimento/achados/` e mencione no comentário. |
| 5 | **Suporte notificado** | ✅ Quando tem ticket Zendesk | Adicione um comentário com `#zd` explicando a resolução para o Suporte repassar ao cliente. |

---

## Exemplo de comentário de fechamento

```
Corrigido o cálculo de ICMS na rotina de emissão de NF (frmEmissaoNF.frm).

Causa: o campo alíquota não considerava a UF de destino na tabela ICMS_UF.
O WHERE da SP_CALCULA_ICMS filtrava apenas por UF_ORIGEM.

Revisão: r54321

Achado registrado em base-conhecimento/achados/ (pode afetar outras rotinas que usam SP_CALCULA_ICMS).
```

---

## Comentários que NÃO atendem o checklist

| ❌ Comentário | Problema |
|---------------|----------|
| "feito" | Não diz O QUE foi feito |
| "Corrigido o erro" | Não diz POR QUE o erro acontecia (causa raiz) |
| "Commitado" | Falta o número da revisão SVN |
| "Conforme alinhado" | Não descreve nada |
| (nenhum comentário) | Issue fechada sem documentação |

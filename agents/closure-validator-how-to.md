---
title: Como Usar o Issue Closure Validator Agent
parent: Agentes
nav_order: 4
---

# Como Usar o Issue Closure Validator Agent

O `issue-closure-validator` é um **agente inteligente** que valida a qualidade do fechamento de issues com estado **Closed** no path **Manutenção**. Ele analisa os comentários da Discussion para verificar se o dev documentou adequadamente a conclusão: o que foi feito, a revisão SVN, e a causa raiz.

### Arquitetura

```
Script (data layer)          Agente LLM (cérebro)
┌────────────────────┐    ┌───────────────────────────────┐
│  FETCH: busca issues  │────▶│  Lê comentários e avalia cada  │
│  Closed e grava JSON  │    │  item com inteligência         │
└────────────────────┘    └────────────┬──────────────────┘
┌────────────────────┐    ┌────────────┴──────────────────┐
│  APPLY: posta         │◀────│  Gera comentário contextual    │
│  comentários + tags    │    │  específico para cada issue    │
└────────────────────┘    └───────────────────────────────┘
```

---

## Pré-requisitos

Mesmos do Issue Validator de abertura. Se já configurou, está pronto.

### 1. Azure CLI + extensão Azure DevOps

```bash
az extension add --name azure-devops
az devops login --organization https://gantc.visualstudio.com
```

### 2. GitHub Copilot no VS Code

Extensões: `GitHub Copilot` + `GitHub Copilot Chat`

---

## Como rodar o agente

### 1. Abra o Copilot Chat

```
Ctrl + Alt + I
```

### 2. Selecione o agente

No seletor de agentes, escolha **Issue Closure Validator**.

### 3. Digite o comando

```
valida as conclusoes
```

Pronto. O agente executa as 5 fases automaticamente e exibe o relatório ao final.

### Validar issue específica

```
valide a conclusao da issue #128340
```

### Prévia sem postar comentário/tag (dry-run)

```
roda o validador de conclusao -DryRun
```

### Alterar janela temporal (padrão: 7 dias)

```
roda o validador de conclusao -Days 14
```

### Revalidar issues já alertadas

```
revalida as conclusoes
```

Busca issues com tag `conclusao-incompleta` e verifica se o dev já complementou. Issues agora completas recebem comentário ✅ e a tag é removida.

---

## O que acontece automaticamente

| Fase | Quem | Ação |
|------|------|------|
| 1 | Agente | Carrega os critérios de validação de conclusão |
| 2 | Script | Busca issues `Closed` dos últimos 7 dias e grava JSON |
| 3 | **Agente** | **Lê os comentários de cada issue e valida com inteligência** |
| 4 | Script | Posta comentário interno (sem `#zd`) e aplica tag |
| 5 | Agente | Apresenta relatório e atualiza histórico |

---

## Exemplo de relatório gerado

```
## ✅ Validação de Conclusão — Path: Manutenção | Últimos 7 dias

| ID     | Título                        | Tipo WI  | Fech | Rev  | Causa | Achado | Suporte | Resultado            |
|--------|-------------------------------|----------|------|------|-------|--------|---------|----------------------|
| ⚡#1230 | Processo parado na filial 02  | Hotfix   | ✅   | ✅   | ✅    | ⚠️     | ✅      | Completa com ressalva|
| #1234  | Erro ao emitir NF             | Fix      | ✅   | ❌   | ✅    | -      | ❌      | Incompleta           |
| #1237  | Relatório zerado em Contabil   | US       | ✅   | ✅   | ✅    | -      | -       | Completa             |
| #1235  | Tela travando ao abrir        | Fix      | ❌   | ❌   | ❌    | -      | ✅      | Incompleta           |
| #1236  | Cadastro com erro             | Fix      | -    | -    | -     | -      | -       | Já validada          |

Total analisadas: 5
Completas: 1
Completas com ressalva: 1
Incompletas: 2 (comentário + tag aplicados)
Já validadas: 1

Itens mais faltantes: Revisão SVN (2) · Causa raiz (1) · Suporte notificado (1)

Tendência: primeira execução — baseline estabelecido
```

---

## Checklist de validação de conclusão

O agente considera uma issue **incompleta** quando qualquer item obrigatório está ausente.

| # | Item | Obrigatório |
|---|------|-------------|
| 1 | Comentário de fechamento (o que foi feito) | Sempre |
| 2 | Revisão SVN / commit referenciado | Sempre (N/A se sem alteração de código) |
| 3 | Causa raiz documentada | Sempre |
| 4 | Achado registrado (base-conhecimento) | Quando relevante (⚠️ recomendação) |
| 5 | Suporte notificado (`#zd`) | Quando tem ticket Zendesk (N/A se interno) |

> Referência completa: [Critérios de Validação de Conclusão](closure-validator-validation-criteria.md)

---

## Diferença em relação ao validador de abertura

| Aspecto | Validador de Abertura | Validador de Conclusão |
|---------|----------------------|----------------------|
| **Estado alvo** | New (issues recém-abertas) | Closed (issues recém-fechadas) |
| **Fonte principal** | Descrição da issue | Comentários da Discussion |
| **O que verifica** | Informação para o dev começar | Documentação do que foi feito |
| **Comentário** | Com `#zd` (vai pro Zendesk) | Interno (sem `#zd`) |
| **Tags** | `abertura-completa` / `abertura-incompleta` | `conclusao-validada` / `conclusao-incompleta` |

---

## Dúvidas frequentes

**O comentário vai aparecer no Zendesk?**
Não. O validador de conclusão posta comentários **internos** (sem `#zd`), visíveis apenas no Azure DevOps.

**A tag vai duplicar se eu rodar duas vezes?**
Não. O script verifica se a tag já existe antes de aplicar, e o agente pula issues já validadas (`jaValidada: true`).

**Issues sem alteração de código (ex: problema de cadastro) precisam de revisão SVN?**
Não. Se o dev menciona no comentário que não houve alteração de código, o agente marca a revisão SVN como N/A.

**O item "Achado registrado" pode reprovar a issue?**
Não. É uma **recomendação** (⚠️), não um bloqueio. A issue é classificada como "Completa com ressalva".

**Posso rodar os dois validadores na mesma issue?**
Sim. Eles operam em fases diferentes do ciclo de vida: um valida a abertura, outro a conclusão. Usam tags e comentários diferentes.

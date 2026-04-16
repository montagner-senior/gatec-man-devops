---
title: Como Usar o Issue Validator Agent
parent: Agentes
nav_order: 1
---

# Como Usar o Issue Validator Agent

O `issue-validator-agent` é um **agente inteligente** que valida issues com status **New** no path **Manutenção**. Diferente de um script com regex, o agente (Claude Sonnet) **lê e compreende** a descrição de cada issue para decidir se tem informação suficiente para o time trabalhar. Quando encontra issues incompletas, adiciona um comentário contextual explicando o que falta e aplica a tag `abertura-incompleta`.

### Arquitetura

```
Script (data layer)          Agente LLM (cérebro)
┌────────────────────┐    ┌───────────────────────────────┐
│  FETCH: busca issues  │────▶│  Lê descrição e avalia cada    │
│  e grava JSON         │    │  item com inteligência         │
└────────────────────┘    └────────────┬──────────────────┘
┌────────────────────┐    ┌────────────┴──────────────────┐
│  APPLY: posta         │◀────│  Gera comentário contextual    │
│  comentários + tags    │    │  específico para cada issue    │
└────────────────────┘    └───────────────────────────────┘
```

---

## Pré-requisitos

Faça isso **uma única vez** antes de usar o agente pela primeira vez.

### 1. Instalar o Azure CLI

Baixe e instale em:
```
https://aka.ms/installazurecliwindows
```

### 2. Instalar a extensão Azure DevOps no CLI

Abra o terminal e rode:
```bash
az extension add --name azure-devops
```

### 3. Autenticar com o Azure DevOps

```bash
az devops login --organization https://gantc.visualstudio.com
```

> Será solicitado um **Personal Access Token (PAT)**. Para gerar o seu:
> 1. Acesse `https://gantc.visualstudio.com`
> 2. Clique no seu avatar → **Personal Access Tokens**
> 3. Crie um token com permissões: `Work Items — Read & Write`
> 4. Cole o token quando o terminal pedir

### 4. Instalar o GitHub Copilot no VS Code

No VS Code, instale as duas extensões via `Ctrl+Shift+X`:
- `GitHub Copilot`
- `GitHub Copilot Chat`

---

## Como rodar o agente

### 1. Abra o Copilot Chat

```
Ctrl + Alt + I
```

### 2. Anexe o arquivo do agente

No seletor de agentes do chat, escolha **Issue Validator**.

Ou mencione o agente digitando `@issue-validator` no campo de texto.

### 3. Digite o comando

```
valida as issues
```

Pronto. O agente vai executar as 5 fases automaticamente e exibir o relatório ao final.

### Validar issue específica

```
valide a issue #128340
```

### Prévia sem postar comentário/tag (dry-run)

```
roda o validador -DryRun
```

### Revalidar issues já alertadas

```
revalida as issues
```

Busca issues que já receberam tag `abertura-incompleta` e verifica se o Suporte já complementou as informações. Issues agora completas recebem comentário de ✅ e a tag é removida.

### Revalidar issue específica

```
revalida a issue #128340
```

---

## O que acontece automaticamente

| Fase | Quem | Ação |
|------|------|------|
| 1 | Agente | Carrega os critérios de validação |
| 2 | Script | Busca issues `New` do path `Manutenção` e grava JSON |
| 3 | **Agente** | **Lê a descrição de cada issue e valida com inteligência** |
| 4 | Script | Posta comentário HTML (com `#zd`) e aplica tag |
| 5 | Agente | Apresenta relatório e atualiza histórico |

---

## Exemplo de relatório gerado

```
## ✅ Validação Concluída — Path: Manutenção | Status: New

| ID     | Título                        | Tipo WI  | Tipo | Desc | Sist | Menu | Evid | Anal | Vers | Resultado            |
|--------|-------------------------------|----------|------|------|------|------|------|------|------|----------------------|
| ⚡#1230 | Processo parado na filial 02  | Hotfix   | ✅   | ✅   | ✅   | ✅   | ❌   | ✅   | ✅   | Incompleta           |
| #1234  | Erro ao emitir NF             | Fix      | ✅   | ❌   | ✅   | ✅   | ❌   | ✅   | ❌   | Incompleta           |
| #1237  | Relatório zerado em Contabil   | US       | ✅   | ✅   | ✅   | ⚠️   | ✅   | ✅   | ✅   | Completa com ressalva|
| #1235  | Sistema não abre na filial 03 | US       | ✅   | ✅   | ✅   | ✅   | ✅   | ✅   | ✅   | Completa             |
| #1236  | Relatório zerado              | Fix      | -    | -    | -    | -    | -    | -    | -    | Já validada          |

Total analisadas: 5
Completas: 1
Completas com ressalva: 1
Incompletas: 2 (comentário + tag aplicados)
Já validadas: 1
Excluídas: 0

Itens mais faltantes: Descrição (1) · Evidência (2)

Tendência: ⬇️ Taxa caiu de 100% para 40% vs execução anterior

Pendentes de correção (alertadas há >2 dias úteis):
  #1220 — Erro no fechamento (alertada há 3 dias)
  #1218 — Tela travando (alertada há 5 dias)

Detalhe #1234:
  2. Descrição — texto atual é apenas "Ver Zendesk #3421", sem relato do problema
  5. Evidência — nenhum arquivo ou imagem anexado
```

---

## Checklist de validação

O agente considera uma issue **incompleta** quando qualquer item está ausente.
**Exceção:** se apenas o item 4 (caminho no menu) está ausente e os outros 6 estão OK, classifica como **"Completa com ressalva"** (sem tag, sem comentário).

| # | Item |
|---|------|
| 1 | Tipo — erro, incidente, melhoria ou dúvida |
| 2 | Descrição do problema |
| 3 | Sistema ou módulo afetado |
| 4 | Caminho no menu até a tela (⚠️ ressalva se único ausente) |
| 5 | Print ou evidência anexada |
| 6 | Analista do Suporte responsável |
| 7 | Versão do sistema |

> Referência completa: `guias/checklist-abertura-issue.md`

## Diferença em relação a um script com regex

| Aspecto | Script com regex | Agente inteligente |
|---------|-----------------|--------------------|
| Descrição | Verifica se campo não está vazio | **Lê o texto e avalia se é um relato real** |
| Caminho no menu | Busca palavras "menu", "tela" | **Entende se a descrição indica ONDE no sistema** |
| Comentário | Template fixo para todas | **Personalizado com contexto específico** |
| Falso positivo | "a tela travou" → aprovaria menu | **"a tela travou" sem QUAL tela → recusa** |

---

## Dúvidas frequentes

**O agente vai sobrescrever comentários existentes?**
Não. Se a issue já tiver um comentário do `issue-validator-agent`, ele pula essa etapa.

**A tag vai duplicar se eu rodar duas vezes?**
Não. O agente verifica se a tag `abertura-incompleta` já existe antes de aplicar.

**O agente altera o conteúdo da issue?**
Não. Ele apenas adiciona/remove comentário e tag — nunca edita título, descrição ou outros campos. Na revalidação, remove a tag `abertura-incompleta` de issues complementadas.

**O token PAT expirou, o que fazer?**
Gere um novo PAT em `https://gantc.visualstudio.com` e rode novamente:
```bash
az devops login --organization https://gantc.visualstudio.com
```

---

## Agendamento (automação)

O agente pode ser executado manualmente a qualquer momento. Para automação:

| Opção | Como |
|-------|------|
| **GitHub Actions (cron)** | Crie um workflow `.github/workflows/validate-issues.yml` com `schedule: cron` que execute o agente via CLI |
| **Tarefa agendada Windows** | Use o Agendador de Tarefas do Windows para rodar o script de FETCH + análise em horário fixo |
| **Azure DevOps Pipeline** | Pipeline com trigger cron que execute o script de FETCH + LLM + APPLY |

> **Recomendação:** Execute a **validação diariamente** (ex: 08:00) e a **revalidação 2x por semana** (ex: terça e quinta) para fechar o ciclo de feedback com o Suporte.
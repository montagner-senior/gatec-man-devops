---
title: Azure DevOps para Iniciantes
parent: Guias
nav_order: 1
---

# Guia de Azure DevOps para Iniciantes

## Objetivo

Este guia explica o que é o Azure DevOps, como acessá-lo e como utilizá-lo no dia a dia do time de Manutenção de Sistemas Legados. Foi escrito para quem **nunca usou o Azure DevOps antes**.

## O que é o Azure DevOps?

O **Azure DevOps** é uma plataforma da Microsoft para gestão de desenvolvimento de software. Para o nosso time, ele serve como:

- **Quadro de tarefas**: onde chegam os tickets do Suporte (via Zendesk) e onde registramos o que estamos fazendo
- **Histórico de trabalho**: onde ficam registradas todas as atividades, comentários e decisões de cada ticket
- **Pipeline**: onde o sistema faz o build e o deploy automático dos sistemas VB6

> 💡 **Dica:** Pense no Azure DevOps como o "coração" do processo do time — tudo passa por ele.

---

## Como acessar o Azure DevOps

1. Abra seu navegador e acesse: `https://gantc.visualstudio.com/Senior%20Agro%20Dev`
2. Clique em **"Sign in"** (entrar)
3. Use seu e-mail corporativo `@gatec.onmicrosoft.com` e sua senha
4. Após o login, selecione o projeto: **`gantc > Senior Agro Dev`**

> ⚠️ **Atenção:** Se aparecer uma mensagem de "Acesso negado" ou "Você não tem permissão", contate o responsável para solicitar acesso. Não tente criar uma conta por conta própria.

---

## Conhecendo a tela principal

Depois de acessar o projeto, você verá o menu lateral esquerdo com as seções principais:

| Ícone | Seção | O que é |
|---|---|---|
| 🗂️ | **Boards** | Quadro de tarefas — é aqui que você vai trabalhar |
| 🔧 | **Repos** | Código-fonte — **não usamos esta seção** (nosso código está no SVN) |
| 🚀 | **Pipelines** | Build e deploy automático |
| 🧪 | **Test Plans** | Planos de teste — não usamos |
| 📦 | **Artifacts** | Pacotes — não usamos |

> 📌 **Regra do time:** Nosso trabalho diário acontece exclusivamente em **Boards** e **Pipelines**. Ignore as demais seções por enquanto.

---

## Boards — O quadro de tarefas

### O que é o Board?

O Board (quadro) é uma lista de work items (tarefas/tickets) organizadas por estado. É como um mural de post-its digitais.

Para acessar: clique em **Boards** no menu lateral → **Boards** (ou **Backlogs** para ver a lista completa).

### Tipos de Work Item que o time usa

> 📌 **Regra do time:** O time usa **apenas três tipos** de work item. Qualquer outro tipo que apareça no sistema deve ser ignorado ou reportado à gerência.

| Tipo | Ícone | Quando aparece |
|---|---|---|
| **User Story** | 📋 | Atendimneto de Dúvidas e Incidentes |
| **Fix** | 🔧 | Correção de bug |
| **Hotfix** | 🚨 | Correção de bug — **prioridade máxima** |

### Estados de um Work Item

Cada work item percorre os seguintes estados:

```
New → Active → Wating → Closed
```

---

## Como abrir um Work Item (Se necessário)

1. Clique em **Boards** no menu lateral
2. Clique em **Backlogs** (lista completa de tarefas)
3. Localize o work item pelo número (`#1234`) ou pelo título
4. Clique no título do work item para abri-lo

### O que você verá dentro de um Work Item

| Campo | O que é |
|---|---|
| **Título** | Descrição breve do problema ou da melhoria |
| **Estado** | Em qual etapa o work item está |
| **Atribuído a** | Para quem o work item está designado |
| **Área / Iteração** | A qual sistema e sprint pertence |
| **Descrição** | Detalhes do que foi reportado pelo Suporte |
| **Comentários** | Histórico de atualizações — **onde você vai escrever** |
| **Ticket Zendesk** | Link para o chamado original do cliente |

---

## Como atualizar um Work Item

Atualizar o work item é a principal atividade do dev no Azure DevOps. Faça isso sempre que houver progresso na investigação.

### Passo a passo para adicionar um comentário

1. Abra o work item
2. Role a tela para baixo até a seção **Discussion**
3. Clique no campo de texto e escreva sua atualização
4. Clique em **"Salvar"** (botão azul)

> 💡 **Dica:** Escreva comentários claros, como se estivesse explicando para alguém que não viu o código. O Suporte vai ler esses comentários para responder ao cliente.

### Passo a passo para mudar o estado

1. Abra o work item
2. Localize o campo **"Estado"** no topo (logo abaixo do título)
3. Clique no campo e selecione o novo estado
4. Clique em **"Salvar"**

> ⚠️ **Atenção:** Só mude o estado para **"Closed"** quando o Work Item estiver finalizado e entregue ao time de suporte.

---

## Como filtrar work items no Board

Para encontrar rapidamente os work items designados para você:

1. Clique em **Boards** → **Backlogs**
2. No topo, clique em **"Filtro"** (ícone de funil 🔍)
3. No campo **"Atribuído a"**, selecione seu nome
4. A lista vai exibir apenas seus work items

---

## Boas práticas

| Prática | Por quê é importante |
|---|---|
| Atualize o work item **antes de começar** a investigar | Sinaliza para o time que o ticket está em andamento |
| Adicione comentários a cada achado | Cria histórico e ajuda quem vier depois |
| Mude o estado corretamente | O manager acompanha o board para gerir o time |
| Nunca exclua comentários | O histórico é auditável |
| Registre mesmo quando não encontrar nada | "Não encontrado" também é informação útil |

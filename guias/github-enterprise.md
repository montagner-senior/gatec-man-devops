---
title: GitHub Enterprise
parent: Guias
nav_order: 6
---

# Guia de Uso — GitHub Enterprise (GHE)

> Time DevOps responsável: **DevOps Centralizado — Matriz**
> Pontos focais ERPGAtec: **Luis Lopes** e **Yves Polo**

A partir da migração, **todo o código-fonte** do time (antes em SVN/Azure Repos) está no **GitHub Enterprise da Senior**. Apenas devs têm acesso ao GitHub — analistas e demais perfis seguem usando o Azure Boards.

---

## Sumário

1. [Acesso ao GitHub Enterprise](#1-acesso-ao-github-enterprise)
2. [Estrutura: Enterprise e Organizações](#2-estrutura-enterprise-e-organizações)
3. [Configuração SSH — Obrigatório](#3-configuração-ssh--obrigatório)
4. [Commits Verificados](#4-commits-verificados)
5. [Atualização do remote (quem já usava Git)](#5-atualização-do-remote-quem-já-usava-git)
6. [Nomenclatura de Branches — Conventional Branches](#6-nomenclatura-de-branches--conventional-branches)
7. [Arquivos e Binários — O que não pode entrar](#7-arquivos-e-binários--o-que-não-pode-entrar)
8. [BastionX — Portal do Desenvolvedor](#8-bastionx--portal-do-desenvolvedor)
9. [Criação de Repositórios](#9-criação-de-repositórios)
10. [Times e Permissões](#10-times-e-permissões)
11. [Pull Requests — Fluxo e Regras](#11-pull-requests--fluxo-e-regras)
12. [Branches Protegidas e Deleção Automática](#12-branches-protegidas-e-deleção-automática)
13. [GitHub Actions (Pipelines)](#13-github-actions-pipelines)
14. [Conventional Commits e Versionamento](#14-conventional-commits-e-versionamento)
15. [Copilot no Code Review](#15-copilot-no-code-review)
16. [Suporte e Pontos Focais](#16-suporte-e-pontos-focais)
17. [Checklist — Primeiros passos](#17-checklist--primeiros-passos)

---

## 1. Acesso ao GitHub Enterprise

- URL: <https://github.com/enterprises/SeniorSistemas>
- Login com **usuário de rede** da Senior (sem criar conta nova)
- Provisionamento feito pelo time **DevOps Central**
- Acesso **somente para devs**

---

## 2. Estrutura: Enterprise e Organizações

```
Enterprise: Senior Sistemas
 └── Organização: Senior Sistemas    ← onde o ERPGAtec trabalha
 └── Organização: Globaltech
 └── Organização: Conviva
 └── ... outras unidades
```

Como todas as unidades convivem na mesma organização, todo repositório recebe um **prefixo da unidade** para evitar duplicidade de nomes.

| Time/Unidade | Prefixo |
|---|---|
| ERPGAtec | `gatec-` |
| Conviva    | `conviva-` |
| Globaltech | `globaltech-` |

> Exemplo: o antigo `backend-api-datalake` virou `gatec-backend-api-datalake`.

---

## 3. Configuração SSH — Obrigatório

> ⚠️ **SSH é obrigatório.** HTTPS existe mas **não é utilizado** na Senior. Operações via HTTPS impactam a operação.

### Duas etapas

| Etapa | O que fazer | Quando |
|-------|-------------|--------|
| 1 — Gerar e cadastrar a chave SSH | Criar par de chaves e adicionar ao perfil GitHub | Assim que o usuário for criado |
| 2 — Autorizar a chave SSH na organização | No perfil GitHub, autorizar a chave para a organização **Senior Sistemas** | **Somente depois do rollout** |

### Como autorizar (etapa 2)

1. Abra o **perfil** no GitHub
2. Vá em **Settings → SSH and GPG keys**
3. Localize a chave SSH cadastrada
4. Clique em **Configure SSO** / **Authorize**
5. Selecione **Senior Sistemas** → **Continue** → **Continue**
6. A organização aparece como **Authorized**

### Documentação de apoio

- <https://wiki.senior.com.br/pt-br/DevSecOps/github-enterprise/configurar-ssh>
- <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account>
- Verificar se commits estão assinados: <https://docs.github.com/en/authentication/troubleshooting-commit-signature-verification/checking-your-commit-and-tag-signature-verification-status>

### Clients suportados

Linha de comando, **GitHub Desktop** (recomendado pelo time DevOps), VS Code, SourceTree etc. O importante é fazer o **clone via SSH** — daí em diante todas as operações usam SSH.

---

## 4. Commits Verificados

Com a SSH autorizada na organização, o GitHub garante que cada commit veio do dono real do usuário. Sem SSH seria possível assumir identidade de outra pessoa via `git config`. Esse controle é **requisito de segurança** da Senior.

---

## 5. Atualização do remote (quem já usava Git)

A URL dos repositórios mudou. Em cada clone local, atualizar o remote:

```bash
# pegar a URL nova: GitHub → repositório → botão Code → SSH
git remote set-url origin git@github.com:senior-sistemas/gatec-<nome-do-repo>.git
git remote -v   # confirmar
```

---

## 6. Nomenclatura de Branches — Conventional Branches

**Padrão obrigatório.** Branches fora dos prefixos abaixo **não podem ser criadas**.

| Prefixo | Uso |
|---|---|
| `main` / `master` | Principal de produção |
| `develop` | Desenvolvimento |
| `feature/` | Nova funcionalidade |
| `fix/` | Correção geral |
| `bugfix/` | Correção de bug |
| `hotfix/` | Correção urgente em produção |
| `release/` | Preparação de release |
| `chore/` | Manutenção/configuração |

Formato recomendado:

```
<prefixo>/<id-do-work-item>
```

Exemplo: `fix/123`, `feature/456`.

Branches migradas que estavam fora do padrão são **mantidas como estão**; novas precisam respeitar a regra. Se precisar de prefixo diferente ou bypass para uma migrada, acione o ponto focal.

---

## 7. Arquivos e Binários — O que não pode entrar

> **Nenhum binário deve estar no GitHub.**

| Tipo | Onde deve estar |
|---|---|
| `.dll`, `.exe` | Nexus |
| Vídeos | SharePoint |
| `.zip` | SharePoint |
| `.docx`, `.pdf` | Em definição |
| Outros binários | Consultar ponto focal |

Paths bloqueados independentemente de `.gitignore`:

- `node_modules/`
- `target/`
- `dist/`

> Tentativas de `git push` com binários bloqueados são rejeitadas pelo GitHub. **Não existe bypass para adição.** Para excluir binário pré-existente, solicite bypass ao DevOps.

---

## 8. BastionX — Portal do Desenvolvedor

Ferramenta interna da Senior (alfa/beta) que fornece **permissões granulares** sem expor permissões amplas do GitHub.

Hoje é possível:

- Criar repositório
- Gerenciar membros de times

Login: usuário de rede. Disponível a partir da segunda-feira pós-migração.

---

## 9. Criação de Repositórios

> Repositórios **não são criados diretamente no GitHub** — são criados pelo **BastionX**.

Passos:

1. Acessar BastionX e logar com usuário de rede
2. Selecionar a organização **Senior Sistemas**
3. Selecionar o **time** responsável
4. Informar o **nome** — o prefixo (`gatec-`) é aplicado automaticamente

---

## 10. Times e Permissões

- Modelo é por **times** (no Azure Repos era por usuário). Times agrupam pessoas e definem acesso a repositórios.
- A composição inicial dos times foi definida em planilha pelos pontos focais.
- **Tech Leads** podem adicionar/remover membros via BastionX.

| Situação | O que acontece |
|---|---|
| Pessoa saiu da empresa | AD remove o acesso automaticamente |
| Pessoa mudou de squad | **Manual** — remover do time antigo e adicionar ao novo |

> Novos times: solicitar via chat com o DevOps Central.

---

## 11. Pull Requests — Fluxo e Regras

Toda PR para `main`/`master` exige:

1. **Pipeline (Action) passando**
2. **Aprovação de pelo menos uma pessoa diferente** de quem abriu

> ❌ Sem isso o merge é bloqueado. Regra de **auditoria SOC** da Senior — aplicada também à operação (SRE + segundo SRE).

Fluxo:

1. Dev abre PR e adiciona revisor
2. Revisor recebe e-mail e notificação no GitHub
3. Revisor abre o PR (aba **Files Changed**)
4. Revisor pode comentar, **Request Changes** ou **Approve** (Submit Review)
5. Com aprovação + pipeline verde, merge é liberado

| Branch alvo | Aprovação obrigatória? |
|---|---|
| `main` / `master` | **Sim** |
| Outras branches por padrão | Não |
| Branches protegidas específicas (ex: `sandbox`) | Sim, sob solicitação ao DevOps |

---

## 12. Branches Protegidas e Deleção Automática

Após o merge a **branch de origem é deletada automaticamente**; a branch alvo permanece intacta.

Exemplo: `feature/123 → main` ⇒ `feature/123` é deletada.

Para evitar a deleção (ex: branches que representam ambientes), peça ao DevOps para **proteger** a branch.

---

## 13. GitHub Actions (Pipelines)

- Pipelines = **Actions** (workflows YAML no repositório)
- Equivalentes ao antigo Azure Pipelines
- As **VMs já configuradas** no Azure DevOps continuam sendo usadas
- Deploy padrão: ao chegar na branch `main` (ou por tag, se configurado)
- Cada time pode criar seus próprios workflows; depois o DevOps consolida e padroniza
- Validações customizadas (ex: bloquear `DROP TABLE` em scripts SQL) podem ser feitas como steps de Action — falha bloqueia o PR

---

## 14. Conventional Commits e Versionamento

Ainda **não obrigatório** na migração — mas é a direção. Quando ativado, o tipo do commit determina a versão automaticamente:

| Commit | Bump |
|---|---|
| `fix:` | Patch (1.0.**1**) |
| `feat:` | Minor (1.**1**.0) |
| Breaking change | Major (**2**.0.0) |

---

## 15. Copilot no Code Review

É possível adicionar **GitHub Copilot como revisor** num PR para análise automática.

- Requer **licença de Copilot** ativa
- Consome **créditos da licença** de quem solicita

---

## 16. Suporte e Pontos Focais

| Quando | Para onde levar a dúvida |
|---|---|
| Rollout / migração | Chat do treinamento DevOps (atendimento prioritário) |
| Dia a dia | **Pontos focais ERPGAtec**: Luis Lopes, Yves Polo |
| Problema de acesso/permissão GitHub | Chat com DevOps Central |

### O que solicitar diretamente ao DevOps Central

- Proteção de branches além de `main`/`master`
- Bypass para branches migradas fora do padrão
- Bypass para excluir binários pré-existentes
- Configurações de aprovação para ambientes adicionais (ex: sandbox)

---

## 17. Checklist — Primeiros passos

- [ ] Logar em **github.com** com usuário de rede
- [ ] Abrir o **perfil** e localizar a chave SSH
- [ ] Clicar em **Authorize** e autorizar a organização **Senior Sistemas**
- [ ] Acessar o **BastionX** e validar login
- [ ] Verificar acesso aos repositórios do time
- [ ] Atualizar o remote dos clones locais (`git remote set-url origin ...`)
- [ ] Confirmar que o remote usa SSH (`git remote -v` mostra `git@github.com:...`)
- [ ] Em caso de dúvida: chat do treinamento ou ponto focal

---

*Baseado no treinamento GitHub Enterprise — facilitadores Nathan Alcantara e Matheus Miziara.*

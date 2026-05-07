# Guia de Uso — GitHub Enterprise (GHE)
> Baseado no treinamento realizado pela equipe ERPGAtec  
> Facilitadores: Nathan Alcantara e Matheus Miziara  
> Time responsável: DevOps Centralizado — Matriz

---

## Sumário

1. [Sobre o Time DevOps Central](#1-sobre-o-time-devops-central)
2. [Acesso ao GitHub Enterprise](#2-acesso-ao-github-enterprise)
3. [Estrutura: Enterprise e Organizações](#3-estrutura-enterprise-e-organizações)
4. [O que você encontra em um repositório](#4-o-que-você-encontra-em-um-repositório)
5. [Configuração SSH — Obrigatório](#5-configuração-ssh--obrigatório)
6. [Commits Verificados e Segurança de Identidade](#6-commits-verificados-e-segurança-de-identidade)
7. [Nomenclatura de Branches — Conventional Branches](#7-nomenclatura-de-branches--conventional-branches)
8. [Arquivos e Binários — O que não pode entrar no GitHub](#8-arquivos-e-binários--o-que-não-pode-entrar-no-github)
9. [BastionX — Portal do Desenvolvedor](#9-bastionx--portal-do-desenvolvedor)
10. [Criação de Repositórios](#10-criação-de-repositórios)
11. [Gestão de Times e Permissões](#11-gestão-de-times-e-permissões)
12. [Pull Requests — Fluxo e Regras](#12-pull-requests--fluxo-e-regras)
13. [Branches Protegidas e Deleção Automática](#13-branches-protegidas-e-deleção-automática)
14. [GitHub Actions (Pipelines)](#14-github-actions-pipelines)
15. [Conventional Commits e Versionamento Automático](#15-conventional-commits-e-versionamento-automático)
16. [Copilot no Code Review](#16-copilot-no-code-review)
17. [Permissões — Diferenças em relação ao Azure DevOps](#17-permissões--diferenças-em-relação-ao-azure-devops)
18. [Canais de Suporte e Pontos Focais](#18-canais-de-suporte-e-pontos-focais)
19. [Checklist: Primeiros Passos na Segunda-feira](#19-checklist-primeiros-passos-na-segunda-feira)

---

## 1. Sobre o Time DevOps Central

- O DevOps está sendo **centralizado na Matriz**, embora cada unidade ainda tenha seu próprio time de DevOps
- O time central é responsável pelos novos ambientes e pela migração
- Para o time ERPGAtec, haverá **pontos focais** designados que serão o canal principal de comunicação com o DevOps Central
- Os pontos focais têm acesso direto e facilitado ao time central para resolver questões

> 💬 **Pontos focais confirmados:** Luis Lopes e Yves. Outros pontos focais serão indicados pelos coordenadores.

---

## 2. Acesso ao GitHub Enterprise

- O acesso será feito pelo endereço **github.com**
- Você estará dentro da **Enterprise: Senior Sistemas**
- O login é feito com o **usuário de rede** já utilizado normalmente (sem necessidade de criar nova conta)
- Os usuários serão **provisionados pelo time DevOps** durante a migração

---

## 3. Estrutura: Enterprise e Organizações

A Enterprise **Senior Sistemas** é dividida em **organizações**. Cada unidade/time trabalha dentro de uma organização específica.

```
Enterprise: Senior Sistemas
 └── Organização: Senior Sistemas (onde o time ERPGAtec vai trabalhar)
 └── Organização: Globaltech (já migrada)
 └── Organização: Conviva (já migrada)
 └── ... outras unidades
```

- O time ERPGAtec trabalhará dentro da **organização Senior Sistemas**
- Todas as unidades — ERPGAtec, Matriz, Governança e outras — trabalham dentro de uma **única organização**
- Por isso existe o conceito de **prefixo de repositório** (ex: `geatech-`, `conviva-`, `globaltech-`) para evitar duplicatas de nomes

---

## 4. O que você encontra em um repositório

Dentro de cada repositório no GitHub você terá:

- **Arquivos** — código-fonte e demais arquivos do projeto
- **Branches** — ramificações de desenvolvimento
- **Tags** — marcações de versão
- **Pull Requests** — solicitações de merge entre branches
- **Actions / Workflows** — pipelines de CI/CD (equivalente ao Azure Pipelines)
- **Logs** — histórico de execuções das pipelines

---

## 5. Configuração SSH — Obrigatório

### Por que SSH?

No GitHub Enterprise da Senior, o uso de **SSH é obrigatório** para todas as operações Git. A modalidade HTTPS existe, mas **não será utilizada** — apenas SSH.

A SSH também garante **commits verificados**: quando você clona via SSH e faz operações Git, o GitHub confirma que o commit foi feito pelo usuário real, impedindo que alguém assuma a identidade de outra pessoa.

### Documentação disponível

O time DevOps disponibilizou documentação específica sobre como configurar a SSH, complementada pela documentação oficial do GitHub.

### Clients suportados

Qualquer client Git pode ser usado: linha de comando, **GitHub Desktop** (recomendado pelo time), VS Code, SourceTree, ou outro. O que importa é que o **clone seja feito via SSH** — a partir daí, todas as operações usam SSH automaticamente.

### Duas etapas da configuração

| Etapa | O que fazer | Quando pode ser feito |
|-------|-------------|----------------------|
| **1. Criar e configurar a chave SSH na máquina** | Gerar o par de chaves e adicionar ao perfil do GitHub | Assim que o usuário for criado |
| **2. Autorizar a SSH na organização** | Dentro do perfil GitHub, autorizar a chave SSH para a organização Senior Sistemas | **Somente após o rollout/migração** |

> ⚠️ A etapa 2 **só pode ser feita depois da migração**, pois requer permissão na organização, que só é concedida ao final do processo.

### Como autorizar a SSH na organização (etapa 2)

1. Abra a página de **perfil** no GitHub
2. Acesse as configurações de SSH
3. Localize a chave SSH já configurada
4. Clique em **"Configure SSO"** / **"Authorize"**
5. Selecione a organização **Senior Sistemas**
6. Clique em **Continue** → **Continue**
7. A organização aparecerá como **Autorizada**

> 📌 **Primeira coisa na segunda-feira pós-migração:** abrir o perfil e autorizar a SSH na organização.

---

## 6. Commits Verificados e Segurança de Identidade

Ao usar SSH, o GitHub garante que os commits são **verificados** — ou seja, é possível confirmar que quem fez o commit é realmente o dono daquele usuário.

Sem SSH (por exemplo, usando HTTPS com configurações manuais), seria possível fazer um commit em nome de outra pessoa, configurando o nome e e-mail de outro usuário no git config. Com SSH autorizada na organização, isso não é possível, pois a chave representa o usuário real com permissão naquela organização.

> 🔒 Esse controle é um requisito de segurança da Senior e será utilizado de forma mais rigorosa no GitHub do que era no Azure DevOps.

---

## 7. Nomenclatura de Branches — Conventional Branches

O GitHub Enterprise adota um padrão **obrigatório** de nomenclatura de branches, baseado no Conventional Branches.

### Prefixos permitidos

| Prefixo | Uso |
|---------|-----|
| `main` | Branch principal de produção |
| `master` | Branch principal (alternativo) |
| `develop` | Branch de desenvolvimento |
| `feature/` | Nova funcionalidade |
| `fix/` | Correção geral |
| `bugfix/` | Correção de bug |
| `hotfix/` | Correção urgente em produção |
| `release/` | Preparação de release |
| `chore/` | Tarefas de manutenção/configuração |

### Formato recomendado

```
<prefixo>/<número-do-work-item>
```

Exemplo: `fix/123` ou `feature/456`

### Regras importantes

- Branches **fora desses prefixos não poderão ser criadas** no GitHub
- Branches que vieram da migração e não estão no padrão **são mantidas como estão** — a regra se aplica apenas a branches novas
- Se uma branch migrada estiver causando problemas, solicite bypass ao time DevOps
- Se precisar de um prefixo diferente, acione o ponto focal — o time avalia e busca uma solução dentro do padrão

> 💡 O objetivo não é engessamento, mas padronização. O time DevOps entende a demanda e busca a solução mais adequada.

---

## 8. Arquivos e Binários — O que não pode entrar no GitHub

O GitHub possui **restrições de arquivos** que não existiam no Azure DevOps. Um trabalho de limpeza já foi feito antes da migração, mas podem restar casos a tratar.

### Regra geral

> **Nenhum binário deve estar dentro do GitHub.**

### Exemplos de arquivos não permitidos e onde devem estar

| Tipo de arquivo | Onde deve estar |
|-----------------|-----------------|
| `.dll` | Nexus |
| `.exe` | Nexus |
| `.docx` | Em estudo (a definir) |
| `.pdf` | Em estudo (a definir) |
| Vídeos | SharePoint |
| `.zip` | SharePoint |
| Outros binários | Consulte o ponto focal |

### Paths bloqueados (independente de extensão)

Além de extensões, certos **diretórios inteiros são bloqueados**, independentemente do `.gitignore`:

| Path | Contexto |
|------|----------|
| `node_modules/` | JavaScript / Node.js |
| `target/` | Java |
| `dist/` | Projetos front-end |

> ⚠️ Mesmo que você tenha esquecido de incluir no `.gitignore` e tente fazer `git add` + `git commit`, o próprio GitHub bloqueará o push.

### Regras de bypass

| Ação | Bypass possível? |
|------|-----------------|
| **Excluir** arquivo bloqueado já existente no repositório | Sim — solicite ao time DevOps |
| **Adicionar** arquivo de extensão bloqueada | **Não existe bypass** para adição |

> Essa lista de restrições é **viva** e será ampliada conforme o time DevOps identifica novas necessidades.

---

## 9. BastionX — Portal do Desenvolvedor

O **BastionX** é uma ferramenta interna da Senior (em versão alfa/beta) que funciona como um **portal do desenvolvedor**, criada para resolver a limitação de permissões do GitHub: certas ações precisam de permissões muito amplas que não é seguro conceder diretamente na plataforma.

### Por que o BastionX existe?

Algumas permissões no GitHub são muito abrangentes. Por exemplo: para criar repositório, seria necessário uma permissão que também permite renomear repositórios — algo indesejável. O BastionX fornece permissões **granulares e específicas** para cada ação.

### O que já é possível fazer no BastionX

- **Criar repositório**
- **Gerenciar membros de times**

### Acesso

- Login via **usuário de rede** da Senior
- Disponível a partir da segunda-feira pós-migração

### Evolução futura

O BastionX está em crescimento constante. Funcionalidades que hoje precisam ser solicitadas ao DevOps Central serão gradualmente incorporadas à ferramenta, reduzindo dependência de solicitações manuais.

---

## 10. Criação de Repositórios

**Repositórios não são criados diretamente no GitHub** — são criados pelo **BastionX**.

### Como criar um repositório

1. Acesse o BastionX e faça login com usuário de rede
2. Selecione a **organização** (Senior Sistemas)
3. Selecione o **time** responsável pelo repositório
4. Informe o **nome** do repositório — o prefixo do time é aplicado automaticamente

### Nomenclatura de repositórios

Todos os repositórios levam um **prefixo da unidade** para evitar duplicatas dentro da organização compartilhada:

| Time/Unidade | Prefixo |
|---|---|
| ERPGAtec | `geatech-` |
| Conviva | `conviva-` |
| Globaltech | `globaltech-` |

---

## 11. Gestão de Times e Permissões

### Times no GitHub

Dentro da organização existem **times** que agrupam pessoas e definem quais repositórios cada grupo pode acessar. A composição dos times foi definida previamente em planilha pelo ponto focal da ERPGAtec.

### Quem gerencia os times

**Tech Leads** têm permissão para adicionar e remover membros dos seus times.

### Gestão de saída de pessoas

| Situação | O que acontece |
|----------|----------------|
| Pessoa saiu da empresa | O AD faz a gestão automaticamente — o GitHub remove o acesso |
| Pessoa mudou de time/squad | **Deve ser feito manualmente** — remova do time antigo e adicione ao novo |

> ⚠️ Mantenha os times atualizados quando houver mudança de squad. Quem saiu do time mas permanece na empresa continua com acesso ao repositório se não for removido.

> Futuramente haverá uma política formal de revisão periódica de permissões (prática já adotada na Matriz via GitLab).

---

## 12. Pull Requests — Fluxo e Regras

### Regras obrigatórias para todo Pull Request

Todo PR tem **duas regras obrigatórias** configuradas a nível de enterprise para a branch `main`/`master`:

1. **Pipeline (Action) passando** — o workflow deve executar com sucesso
2. **Aprovação de pelo menos uma pessoa diferente** de quem abriu o PR

> ❌ Se a pipeline falhar ou não houver aprovação de outro membro, o merge **não é possível**.

### Por que essa regra existe?

É uma exigência de **auditoria SOC** da Senior: qualquer mudança que vai para produção deve ter sido solicitada por uma pessoa e aprovada por outra. Isso vale para desenvolvimento (PR) e também para operações (SRE + validação de segundo SRE).

### Como funciona o fluxo de revisão

1. Desenvolvedor abre o PR e adiciona um revisor
2. O revisor recebe **notificação por e-mail** e também vê o alerta no GitHub
3. O revisor acessa o PR via notificação ou pela aba **"Files Changed"**
4. O revisor pode:
   - Deixar um **comentário** geral ou numa linha específica do código
   - Solicitar mudanças com **Request Changes**
   - **Aprovar** o PR (Submit Review → Approve)
5. Com aprovação e pipeline passando, o merge é liberado

### Política de aprovação por branch

| Branch alvo | Aprovação obrigatória? |
|-------------|------------------------|
| `main` / `master` | **Sim** — sempre |
| Feature → feature (ou qualquer branch não-main) | Não obrigatório por padrão |
| Branches específicas protegidas (ex: `sandbox`) | Sim — se solicitado ao time DevOps |

> Configurações de branches protegidas que existiam no Azure DevOps podem ser migradas para o GitHub — envie os detalhes ao time DevOps.

---

## 13. Branches Protegidas e Deleção Automática

### Deleção automática após merge

Por padrão, após o merge de um Pull Request, **a branch de origem é deletada automaticamente**. A branch de destino (target) não é afetada.

**Exemplo:**
- `feature/123` → merge para → `main`
- Resultado: `feature/123` é **deletada**; `main` permanece intacta

### Exceção: branches que não devem ser deletadas

Se uma branch de origem não pode ser deletada (ex: `sandbox` que representa um ambiente), informe ao time DevOps para que ela seja **protegida**.

> Esse comportamento é **padrão e não configurável pelo time** — deve ser tratado via solicitação ao DevOps.

---

## 14. GitHub Actions (Pipelines)

- As pipelines no GitHub se chamam **Actions** e são definidas por **workflows** (arquivos YAML no repositório)
- São equivalentes ao Azure Pipelines que o time já utilizava
- As **VMs já configuradas e usadas no Azure DevOps** continuarão sendo usadas no GitHub também

### Comportamento de deploy

- Por padrão, deploy só é acionado quando o código está na **branch main**
- É possível configurar para disparar também por **tag**

### Liberdade durante a migração

- Cada time é **livre para criar seus próprios workflows e automações** durante a migração
- Futuramente, após todas as migrações, o time DevOps vai revisar, padronizar e consolidar as automações existentes — sem removê-las, apenas unificando o que fizer sentido

### Validações customizadas via Actions

É possível criar steps nas Actions para validações específicas do repositório — por exemplo, bloquear comandos perigosos em scripts SQL (`DROP TABLE`, `DROP DATABASE`). Se a Action falhar, o Pull Request é automaticamente bloqueado.

---

## 15. Conventional Commits e Versionamento Automático

Ainda não há política obrigatória de **conventional commits** na migração, mas é uma prática que o time DevOps planeja trazer para todas as unidades futuramente (já usada na Matriz).

### Como funciona

O formato do commit determina o tipo de versão gerada automaticamente:

| Tipo de commit | Impacto na versão |
|----------------|-------------------|
| `fix:` | Patch (ex: 1.0.0 → 1.0.**1**) |
| `feat:` | Minor (ex: 1.0.0 → 1.**1**.0) |
| Breaking change | Major (ex: 1.0.0 → **2**.0.0) |

> Quando essa ferramenta for implantada, o versionamento e a liberação de releases passam a ser automáticos com base nos commits.

---

## 16. Copilot no Code Review

É possível adicionar o **GitHub Copilot como revisor** em um Pull Request para que ele faça uma análise automática do código.

- Disponível apenas para quem possui **licença de Copilot**
- O uso consome **créditos da licença** da pessoa que solicita a revisão
- Para adicionar: abra o PR e solicite o Copilot como revisor

---

## 17. Permissões — Diferenças em relação ao Azure DevOps

- No GitHub, as permissões são **mais restritivas** do que no Azure DevOps
- Algumas ações que eram feitas diretamente precisarão ser **solicitadas ao time DevOps Central** nesse primeiro momento
- Com o tempo, mais ações serão disponibilizadas via BastionX

### O que solicitar ao time DevOps (por agora)

- Proteção de branches específicas além de `main`/`master`
- Bypass para branches migradas com nome fora do padrão
- Bypass para exclusão de arquivos binários que ficaram para trás na migração
- Configurações de fluxo de aprovação para ambientes adicionais (ex: sandbox)

---

## 18. Canais de Suporte e Pontos Focais

### Durante o rollout e migração

- Use o **chat do treinamento** para tirar dúvidas diretamente com o time DevOps
- Atendimento é **prioritário** para o time ERPGAtec durante a migração

### Após a migração (dia a dia — a partir de 2 a 3 semanas)

- Direcione dúvidas e questões para os **pontos focais** da ERPGAtec
- Os pontos focais respondem o que sabem ou acionam o DevOps Central quando necessário

### Pontos focais confirmados

- **Luis Lopes**
- **Yves**
- Outros — consultar os coordenadores

---

## 19. Checklist: Primeiros Passos na Segunda-feira

- [ ] Acessar **github.com** e logar com usuário de rede
- [ ] Abrir a página de **perfil**
- [ ] Localizar a **chave SSH** já configurada anteriormente
- [ ] Clicar em **Authorize** e autorizar a organização **Senior Sistemas**
- [ ] Acessar o **BastionX** e verificar login com usuário de rede
- [ ] Verificar acesso aos repositórios do time
- [ ] Confirmar que o repositório local clonado usa SSH (`git remote -v` deve mostrar `git@github.com`)
- [ ] Em caso de dúvida, acionar o chat do treinamento ou o ponto focal

---

> 📚 **Documentação complementar:** O time DevOps disponibilizou documentação específica sobre configuração de SSH e uso do GitHub Enterprise. Consulte essa documentação para o passo a passo detalhado.

---

*Guia gerado com base no treinamento de GitHub Enterprise — ERPGAtec*  
*Facilitadores: Nathan Alcantara e Matheus Miziara*

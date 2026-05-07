# Guia de Uso — Azure Boards (ADO)
> Baseado no treinamento realizado pela equipe ERPGAtec  
> Facilitadora: Gisele Cimony

---

## Sumário

1. [Acesso ao Projeto](#1-acesso-ao-projeto)
2. [Hierarquia de Work Items](#2-hierarquia-de-work-items)
3. [Campos Obrigatórios](#3-campos-obrigatórios)
4. [Tipos de Work Items](#4-tipos-de-work-items)
   - 4.1 [Épico](#41-épico)
   - 4.2 [Discovery](#42-discovery)
   - 4.3 [Feature](#43-feature)
   - 4.4 [User Story](#44-user-story)
   - 4.5 [Apoio](#45-apoio)
   - 4.6 [Deploy](#46-deploy)
   - 4.7 [Horas Administrativas](#47-horas-administrativas)
   - 4.8 [Spike](#48-spike)
   - 4.9 [Bug / Manutenção](#49-bug--manutenção)
5. [Campos Específicos do Bug](#5-campos-específicos-do-bug)
6. [Integração com Zendesk](#6-integração-com-zendesk)
7. [Campo: Lei do Bem](#7-campo-lei-do-bem)
8. [Campo: Impedimento](#8-campo-impedimento)
9. [Campo: LGPD](#9-campo-lgpd)
10. [Apontamento de Horas](#10-apontamento-de-horas)
11. [Delivery Plans](#11-delivery-plans)
12. [Notas de Versão](#12-notas-de-versão)
13. [Relacionamentos entre Work Items (DOC e Links)](#13-relacionamentos-entre-work-items-doc-e-links)
14. [Natureza do Bug e Hotfix](#14-natureza-do-bug-e-hotfix)
15. [Integração Zendesk — Severidade e Priority](#15-integração-zendesk--severidade-e-priority)
16. [Queries e Dashboards — Permissões](#16-queries-e-dashboards--permissões)
17. [Tags Estratégicas e Contrato de Resultado](#17-tags-estratégicas-e-contrato-de-resultado)
18. [Customização de Colunas do Board](#18-customização-de-colunas-do-board)
19. [Migração — O que esperar](#19-migração--o-que-esperar)
20. [Boas Práticas Gerais](#20-boas-práticas-gerais)

---

## 1. Acesso ao Projeto

- O link de acesso ao Azure DevOps será disponibilizado pela equipe responsável.
- Os usuários são adicionados ao projeto **ERPGAtec** durante a migração (previsão: quinta ou sexta-feira do período de implantação).
- Após o acesso, você verá o projeto **ERPGAtec** com os Boards já configurados.

> ⚠️ Antes da migração, o acesso ainda não estará disponível para todos os usuários.

---

## 2. Hierarquia de Work Items

A estrutura hierárquica do projeto segue o modelo abaixo:

```
Épico
 └── Feature  /  Discovery (relacionado como filho do Épico)
      └── User Story  /  Bug  /  Apoio  /  Deploy  /  Spike  /  Horas Administrativas
```

| Nível       | Tipo de Work Item                              | Finalidade                                      |
|-------------|------------------------------------------------|-------------------------------------------------|
| Nível 1     | Épico                                          | Grande iniciativa / tema de negócio             |
| Nível 2     | Feature                                        | Funcionalidade entregável                       |
| Nível 2     | Discovery                                      | Pesquisa e análise upstream (pré-feature)       |
| Nível 3     | User Story                                     | Entrega de valor ao usuário final               |
| Nível 3     | Bug                                            | Correção de defeito / manutenção                |
| Nível 3     | Apoio                                          | Atividades internas sem entrega de valor direto |
| Nível 3     | Deploy                                         | Registro de implantações                        |
| Nível 3     | Spike                                          | Pesquisa técnica em tempo de desenvolvimento    |
| Nível 3     | Horas Administrativas                          | Apontamento de horas não-operacionais           |

---

## 3. Campos Obrigatórios

Todos os work items possuem campos obrigatórios que devem ser preenchidos para garantir o funcionamento correto das automações e relatórios da Senior.

| Campo             | Obrigatório em       | Observação                                                                 |
|-------------------|----------------------|----------------------------------------------------------------------------|
| **Lei do Bem**    | Épicos e Features    | Use "Não Contempla" ou "Não Informada" quando não aplicável                |
| **Tipo de Demanda** | Todos              | Campo obrigatório da Senior; será replicado automaticamente para filhos    |
| **Datas (Planning)** | Todos             | Necessário para uso do Delivery Plans                                      |
| **Cota**          | Todos                | Indica se o item possui cota alocada                                       |
| **Impedido**      | Todos                | Indica se o item está bloqueado                                            |
| **Motivo do Impedimento** | Todos (quando impedido) | Descreva o motivo com clareza — aparece para todo o projeto        |

> 💡 **Automação:** O campo **Tipo de Demanda** preenchido no item pai é replicado automaticamente para os work items filhos.

---

## 4. Tipos de Work Items

### 4.1 Épico

Representa uma grande iniciativa de negócio ou tema estratégico.

- Contém a **aba de LGPD** (ver seção 9)
- Campo **Lei do Bem** obrigatório
- Serve como agrupador de Features e Discoveries

---

### 4.2 Discovery

Work item de pesquisa e análise utilizado **antes** da criação da Feature (tempo de upstream).

- Usado durante a fase de descoberta, antes do desenvolvimento
- Fica relacionado como **filho do Épico** na hierarquia
- Quando finalizado, dá origem a uma **Feature**

> 🔁 Fluxo: `Discovery (upstream) → Feature → User Stories`

---

### 4.3 Feature

Representa uma funcionalidade entregável ao cliente.

- Filha do Épico
- Pode receber uma **Spike** antes de entrar no planejamento, para refinamento técnico
- Campo **Lei do Bem** obrigatório

---

### 4.4 User Story

Representa a entrega de valor direta ao usuário final.

- É o principal item de desenvolvimento do Kanban
- Preencher datas de planejamento para uso no Delivery Plans

---

### 4.5 Apoio

Utilizado para atividades internas que **não geram entrega de valor direto** ao usuário final.

**Exemplos de uso:**
- Configuração de ambiente
- Instalação de ferramentas
- Suporte interno (ex: atender chamado no Teams antes de fazer uma avaliação)
- Qualquer atividade de apoio operacional

---

### 4.6 Deploy

Work item específico para times que registram atividades de implantação/deploy de versões.

- Utilizado apenas pelos times que adotam esse processo
- Registra as entregas de implantação no ambiente

---

### 4.7 Horas Administrativas

Utilizado para apontamento de horas em atividades **que não são a atividade-fim** do desenvolvedor.

**Exemplos de uso:**
- Treinamentos
- Reuniões da empresa
- Comunicados internos que exigiram participação

**Como usar:**
1. Crie uma Hora Administrativa por mês (sugerido)
2. Faça os apontamentos pelo aplicativo já utilizado pelo time
3. Encerre a Hora Administrativa ao final do mês
4. Os apontamentos são compilados no BI pela **data do apontamento**, independente de qual item foi usado

> 📌 A sugestão é criar **uma Hora Administrativa por mês** para facilitar o controle, mas não é obrigatório — o BI consolida pela data do apontamento.

---

### 4.8 Spike

Work item de pesquisa e análise técnica utilizado **durante o desenvolvimento** (diferente do Discovery, que é upstream).

**Quando usar Spike:**
- Refinamento técnico antes de uma Feature entrar no planejamento
- Validação do esforço/tempo necessário para construção de uma Feature
- Análise de como quebrar uma Feature em histórias
- Fornecer insumos técnicos para um Discovery em andamento (ex: quando alguém pede validação técnica antes de finalizar o Discovery)

> ⚠️ **Diferença importante:**
> - **Discovery** = pesquisa em tempo de **upstream** (antes do desenvolvimento começar)
> - **Spike** = pesquisa em tempo de **desenvolvimento** (durante o ciclo de dev)

---

### 4.9 Bug / Manutenção

Utilizado para registro e acompanhamento de defeitos e manutenções.

- Possui uma **raia (swimlane) dedicada** no Board
- Campos específicos detalhados na seção 5
- **Lei do Bem**: usar valor "Não Contempla" (bugs não geram lei do bem)

---

## 5. Campos Específicos do Bug

O work item de Bug possui abas e campos adicionais:

### Aba Principal — Informações do Bug

| Campo           | Descrição                                                                 |
|-----------------|---------------------------------------------------------------------------|
| **Bug Type**    | Classifica o tipo de bug (selecione conforme a natureza do defeito)       |
| **Severidade**  | Impacto do bug no sistema                                                 |
| **Criticidade** | Urgência de resolução                                                     |
| **Descrição**   | Detalhe completo do problema encontrado                                   |

### Aba: Análise Crítica

Processo da Senior para melhoria contínua. Permite registrar:

- Se o erro é um **comportamento original do produto** (problema de produto)
- Se o erro veio de uma **implementação** que gerou o defeito
- Se é uma **manutenção** que causou outros problemas (efeito cascata)

> 💡 A Análise Crítica gera insumos para melhoria de processos internos. Mesmo que não seja obrigatória imediatamente, sua utilização é incentivada.

### Aba: Zendesk

Campos preenchidos automaticamente via **integração com o Zendesk** (ver seção 6).

### Aba: Notas de Versão

Campo para registro das notas de versão relacionadas ao bug corrigido (ver seção 12).

---

## 6. Integração com Zendesk

- O Azure Boards possui integração direta com o Zendesk
- Chamados do Zendesk podem ser vinculados a work items de Bug automaticamente
- Os campos customizados da integração são preenchidos na **aba Zendesk** do Bug
- Facilita o rastreamento entre chamados de suporte e itens de desenvolvimento

---

## 7. Campo: Lei do Bem

Campo obrigatório relacionado à política da Senior.

| Valor              | Quando usar                                                              |
|--------------------|--------------------------------------------------------------------------|
| *(valor específico)* | Quando há uma lei do bem associada à entrega                           |
| **Não Contempla**  | Quando a entrega **não** está relacionada a nenhuma lei do bem (ex: bugs, manutenções) |
| **Não Informada**  | Quando ainda não se sabe qual lei do bem será associada (poderá ser alterado depois) |

> 🔍 **Dica para filtros e QLRs:** Use o valor **"Não Informada"** para facilitar a identificação de itens que ainda precisam ser classificados.

---

## 8. Campo: Impedimento

Presente em **todos** os work items (User Story, Bug, Manutenção, etc.).

| Campo                  | Descrição                                                        |
|------------------------|------------------------------------------------------------------|
| **Impedido**           | Flag indicando se o item está bloqueado                          |
| **Motivo do Impedimento** | Descrição do motivo do bloqueio                              |

> ⚠️ **Atenção ao preencher:** O motivo do impedimento fica visível para **todos os usuários do projeto**. Escreva de forma clara, objetiva e profissional.  
> É possível adicionar mais de um motivo de impedimento quando necessário.

---

## 9. Campo: LGPD

- Aparece na **aba LGPD** dentro do Épico
- Relacionado à política de segurança de dados e segurança da informação da Senior
- Normalmente utilizado apenas no módulo ERP
- Siga as orientações da PO responsável pelo processo de LGPD

---

## 10. Apontamento de Horas

O apontamento de horas é feito pelo **aplicativo já utilizado pelo time** (evoluído para uso na Senior).

**Fluxo recomendado:**

```
1. Crie uma Hora Administrativa por mês
2. Faça os apontamentos pelo aplicativo (vinculados ao work item)
3. Ao final do mês, encerre/feche a Hora Administrativa
4. O BI consolida os apontamentos pela data do apontamento
```

**Tipos de work items para apontamento:**

| Tipo                    | Quando usar                                              |
|-------------------------|----------------------------------------------------------|
| User Story / Bug        | Atividade de desenvolvimento / manutenção                |
| Apoio                   | Suporte interno, configurações, atividades operacionais  |
| Spike                   | Pesquisa técnica com consumo de horas do time            |
| Horas Administrativas   | Treinamentos, reuniões, comunicados                      |

---

## 11. Delivery Plans

- Funcionalidade do Azure Boards para visualização de planejamento ao longo do tempo
- Requer o **preenchimento das datas** nos campos de Planning de cada work item
- Permite visualizar entregas de múltiplos times em uma linha do tempo

> 📅 **Preencha sempre as datas de início e fim** nos work items para garantir a visibilidade correta no Delivery Plans.

---

## 12. Notas de Versão

- Campo disponível nos work items (especialmente Bugs)
- Utilizado pela equipe de **Documentação (DOC)**
- Registra as informações que serão incluídas nas notas de versão do produto
- Coordene com o time de DOC sobre o padrão de preenchimento

---

## 13. Relacionamentos entre Work Items (DOC e Links)

Nem todos os work items são filhos diretos (child) de outro. Alguns são **related** (relacionados). Consulte sempre a documentação do projeto para verificar o tipo de vínculo correto.

### Tipos de relacionamento

| Work Item  | Tipo de vínculo            | Vinculado a                     |
|------------|----------------------------|---------------------------------|
| Apoio      | **Related**                | User Story ou Feature           |
| Bug        | **Related**                | User Story                      |
| Spike      | **Child** ou **Related**   | Feature ou User Story           |
| DOC        | **Child**                  | User Story                      |

### Work Item DOC

- O item **DOC** (documentação) é um **filho obrigatório da User Story**
- Faz parte do processo obrigatório da Senior
- Garante que durante toda a jornada do item — da criação até a finalização — ele tenha sido documentado
- **Sem o DOC vinculado, a User Story não avança no Board** (regra de coluna)
- O mesmo vale para Bugs: precisam ter documentação associada

> 📌 User Stories e Bugs possuem **obrigatoriedade de DOC** para que possam ser movidos para frente no fluxo do Board.

---

## 14. Natureza do Bug e Hotfix

O campo **Natureza** classifica a origem/tipo do bug criado.

### Bugs vindos da integração com Zendesk

- Chegam com uma **natureza já definida automaticamente** pela integração
- **Não é possível alterar a natureza** após a chegada via Zendesk

### Bugs criados manualmente (internos ou de outras fontes)

- É possível selecionar ou criar uma nova classificação de natureza
- Exemplos de uso: **Hotfix**, **Bug Fix**, entre outros tipos que façam sentido para o time

> 💡 O processo de naturezas e classificações está em evolução. Novas categorias poderão ser adicionadas conforme o time identificar necessidades.

---

## 15. Integração Zendesk — Severidade e Priority

Existem dois campos distintos relacionados a criticidade nos Bugs:

| Campo          | Origem                  | Quem pode editar          |
|----------------|-------------------------|---------------------------|
| **Priority**   | Vem da integração Zendesk | Não editável pelo time   |
| **Severidade** | Campo interno do time   | Time pode editar livremente |

> ✅ O campo **Severidade** é de uso do time e pode ser ajustado conforme a avaliação interna. O **Priority** é preenchido automaticamente pela integração com o Zendesk e não deve ser alterado.

---

## 16. Queries e Dashboards — Permissões

### Perfis de permissão

| Perfil        | O que pode fazer                                                               |
|---------------|--------------------------------------------------------------------------------|
| **Liderança** | Criar queries compartilhadas, editar, gerenciar pastas, conceder permissões    |
| **Devs**      | Criar e editar queries dentro das pastas autorizadas pelo líder                |

### Como funciona na prática

- As queries compartilhadas ficam organizadas em **pastas por time** (ex: pasta da equipe Conviva)
- **Lideranças** criam as pastas e definem quem pode acessar/editar cada uma
- Dentro da pasta autorizada, **todos os membros do time** podem adicionar e gerenciar queries
- Esse modelo evita que as queries compartilhadas virem uma lista desorganizada

> 📁 Organize as queries em pastas por squad/time. Lideranças gerenciam as permissões de acesso a cada pasta.

---

## 17. Tags Estratégicas e Contrato de Resultado

O Azure Boards centraliza informações que antes exigiam preenchimento de planilhas externas. As **tags coloridas** foram criadas para identificar visualmente entregas de alto valor estratégico.

### Quando usar

Sempre que um item do backlog estiver relacionado a:

- **Contrato de Resultado** — entrega que compõe o resultado formal do time/unidade
- **Projeto Estratégico** — iniciativa que faz parte do planejamento estratégico da Senior

### Quem deve aplicar

Principalmente o **time de produto** ao priorizar e inserir itens no backlog.

### Benefícios

- Elimina a necessidade de planilhas paralelas para controle estratégico
- Permite filtrar por queries diretamente no Azure Boards
- Dashboards são gerados automaticamente a partir das tags
- Visibilidade consolidada por squad, sem depender de respostas manuais

> 🎯 **Exemplo:** "Filtrar tudo que é da ERPGAtec e está marcado como estratégico" — a query puxa automaticamente, sem necessidade de planilha.

---

## 18. Customização de Colunas do Board

- **Lideranças** têm permissão para customizar as colunas do Board do seu time
- A customização deve **respeitar os status existentes** no processo configurado
- Os status foram mantidos simples e objetivos para atender todas as necessidades dos times
- Caso algum status esteja faltando ou não faça sentido, converse com a equipe responsável para avaliar evoluções futuras

> ⚠️ Não crie colunas que conflitem com os status definidos no processo. Qualquer necessidade de novo status deve ser discutida com a equipe de gestão do ADO.

---

## 19. Migração — O que esperar

### Cronograma

| Evento                          | Data/Horário                              |
|---------------------------------|-------------------------------------------|
| Início da migração              | Sexta-feira, após as 17h                  |
| Suporte pós-migração disponível | Segunda-feira seguinte                    |
| Adição dos usuários ao projeto  | Quinta ou sexta-feira da semana de corte  |

> ⛔ **Não mexa nas ferramentas** a partir das 17h da sexta-feira de migração.

### Status dos itens após a migração

| Situação no sistema antigo    | Status no Azure Boards (após migração) |
|-------------------------------|----------------------------------------|
| Em backlog                    | **New**                                |
| Em andamento (qualquer etapa) | **Active**                             |

> ⚠️ Itens que estavam em **Review**, **Teste** ou outro estágio intermediário chegarão como **Active**. Será necessário **reposicionar manualmente** cada item para o status correto.

### O que é migrado automaticamente

- Conteúdo e histórico dos work items
- **Histórico de status** de cada item (para consulta e rastreabilidade)

### O que pode precisar de ajuste manual

- Reposicionamento de itens no Board (ex: mover do Active para Review)

> 💬 A equipe de suporte estará disponível na **segunda-feira** após a migração para auxiliar em dúvidas e ajustes.

---

## 20. Boas Práticas Gerais

### ✅ Faça sempre:

- Preencha **todos os campos obrigatórios** antes de mover o item no Board
- Use **"Não Contempla"** ou **"Não Informada"** nos campos Lei do Bem quando não houver lei aplicável
- Crie **uma Hora Administrativa por mês** para organizar os apontamentos
- Escreva o motivo de impedimento de forma **clara e profissional** (visível para todos)
- Vincule sempre o work item ao **pai correto** na hierarquia

### ❌ Evite:

- Deixar campos obrigatórios em branco
- Criar work items sem pai definido na hierarquia
- Usar Discovery quando deveria usar Spike (e vice-versa)
- Descrever impedimentos de forma vaga ou inadequada

### 📋 Resumo rápido: Qual work item usar?

| Situação                                              | Work Item           |
|-------------------------------------------------------|---------------------|
| Grande iniciativa de negócio                          | Épico               |
| Funcionalidade para o usuário                         | Feature             |
| Pesquisa antes de criar a Feature (upstream)          | Discovery           |
| Entrega de valor ao usuário final                     | User Story          |
| Defeito ou manutenção                                 | Bug                 |
| Suporte interno, configuração de ambiente             | Apoio               |
| Registro de deploy/implantação                        | Deploy              |
| Análise técnica durante o desenvolvimento             | Spike               |
| Treinamento, reunião, comunicado interno              | Horas Administrativas |

---

> 📚 **Documentação complementar:** Os detalhes de cada campo, regras de uso e processos adicionais estão na documentação oficial do projeto ERPGAtec no Azure DevOps.  
> Em caso de dúvidas, entre em contato com a equipe responsável pelo processo.

---

*Guia gerado com base no treinamento de Azure Boards — ERPGAtec*  
*Facilitadora: Gisele Cimony*

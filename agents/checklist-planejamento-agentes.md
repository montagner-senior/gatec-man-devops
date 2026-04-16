---
title: Checklist de Planejamento de Agentes
parent: Agentes
nav_order: 10
---

# Checklist de Planejamento de Agentes

> Template para planejar cada novo agente do time. Preencha antes de iniciar a implementação.
> Baseado nos padrões dos agentes existentes (Issue Validator, Issue Closure Validator).

---

## Agentes planejados

| # | Agente | Complexidade | Status |
|---|--------|-------------|--------|
| 1 | **Auxiliar de Investigação no Fonte** — Identifica onde no código VB6 fazer o ajuste, com nível de confiança. Valida ajuste realizado vs. sugerido. | Alta | 🔲 Pendente |
| 2 | **Localizador de Issues Relacionadas** — Encontra issues similares (resolvidas ou não) com assertividade. | Média | 🔲 Pendente |
| 3 | **Criação de Test Case** — Gera casos de teste a partir da issue e do código alterado. | Média-Alta | 🔲 Pendente |
| 4 | **Criação de Release Notes** — Gera notas de versão a partir das issues fechadas no período. | Baixa-Média | 🔲 Pendente |
| 5 | **Validação da Descrição Técnica** — Valida se o dev documentou tecnicamente o ajuste realizado. | Média | 🔲 Pendente |
| 6 | **Validação de Assertividade** — Valida se a correção realmente resolve o problema descrito na issue. | Alta | 🔲 Pendente |

---

## Checklist por agente (copie e preencha para cada)

### A. Definição e escopo

- [ ] **Nome do agente** — nome curto e claro (será exibido no seletor do Copilot)
- [ ] **Objetivo em uma frase** — o que faz, para quem, e por quê
- [ ] **Gatilho de execução** — sob demanda, automático, ou por evento?
- [ ] **Entrada principal** — o que recebe? (issue ID, código, período, etc.)
- [ ] **Saída esperada** — o que entrega? (relatório, comentário, arquivo, sugestão)
- [ ] **Escopo incluído** — o que está DENTRO
- [ ] **Escopo excluído** — o que está FORA (para não crescer demais)

### B. Fontes de dados

- [ ] **Azure DevOps** — quais campos, estados, queries? Precisa de script PS1?
- [ ] **Código-fonte (SVN/VB6)** — precisa acessar `.frm`, `.bas`, `.cls`? Como?
- [ ] **Base de conhecimento** — usa `base-conhecimento/achados/`?
- [ ] **Zendesk** — precisa consultar tickets? Via API ou via campos da issue?
- [ ] **Histórico de execuções** — consulta execuções anteriores?
- [ ] **Outras fontes** — banco de dados, logs, documentação externa?

### C. Lógica de validação / processamento

- [ ] **Checklist de itens** — quais itens avalia? (listar com critérios válido/inválido)
- [ ] **Itens obrigatórios vs. condicionais** — quais bloqueiam e quais são recomendação?
- [ ] **Nível de confiança** — retorna % de confiança? Como calcula?
- [ ] **Julgamento semântico** — precisa "entender" texto, ou é verificação de campos?
- [ ] **Regras por tipo de work item** — lógica diferente para Fix vs. Hotfix vs. User Story?

### D. Ações e saídas

- [ ] **Comentário no Azure DevOps** — posta comentário? Com `#zd` ou interno?
- [ ] **Tags** — aplica tags? Quais?
- [ ] **Arquivos gerados** — cria arquivos? Onde?
- [ ] **Relatório** — formato do relatório final
- [ ] **Revalidação** — suporta modo revalidação?
- [ ] **DryRun** — suporta modo preview?

### E. Arquitetura técnica

- [ ] **Script PowerShell** — precisa de data layer? (FETCH + APPLY)
- [ ] **Acesso ao código-fonte** — como lê VB6? (caminho local, checkout SVN?)
- [ ] **Dependências** — Azure CLI, SVN CLI, APIs externas?
- [ ] **Performance** — quantas issues por vez? Lotes?
- [ ] **Idempotência** — como evita duplicação?

### F. Métricas e assertividade

- [ ] **O que medir** — taxa de acerto, falsos positivos, falsos negativos?
- [ ] **Feedback loop** — dev confirma/rejeita sugestão? Como rastreia?
- [ ] **Histórico** — log de execuções? Formato?
- [ ] **Tendência** — compara ao longo do tempo?

### G. Arquivos a criar

- [ ] `.github/agents/{nome}.agent.md`
- [ ] `agents/{nome}-validation-criteria.md` (se aplicável)
- [ ] `agents/{nome}-history.md` (se aplicável)
- [ ] `agents/{nome}-how-to.md`
- [ ] `agents/run-{nome}.ps1` (se aplicável)
- [ ] `guias/checklist-{nome}.md` (se aplicável)
- [ ] Atualizar `agents/index.md`

### H. Riscos e dependências

- [ ] **Pré-requisitos** — depende de outro agente?
- [ ] **Acessos** — permissões, PAT, SVN, banco?
- [ ] **Limitações** — o que NÃO vai conseguir fazer?
- [ ] **Falsos positivos/negativos** — onde pode errar?
- [ ] **Dados sensíveis** — lida com dados de cliente?

---

## Notas específicas por agente

### 1. Auxiliar de Investigação no Fonte

**Perguntas-chave:**
- Como o agente acessa o código VB6? (caminho local, workspace aberto, checkout SVN?)
- Como identifica arquivos relevantes? (busca por nome de tela/módulo mencionado na issue?)
- Como calcula nível de confiança? (match exato de tela vs. heurística?)
- Para validar ajuste realizado vs. sugerido: compara diff SVN com sugestão original?
- Precisa entender sintaxe VB6? (parsing de forms, classes, módulos)

### 2. Localizador de Issues Relacionadas

**Perguntas-chave:**
- Critérios de "relacionada": mesmo módulo? Mesma tela? Mesmo erro? Texto similar?
- Como calcula assertividade/score de similaridade?
- Busca só no path Manutenção ou em todo o projeto?
- Distingue visualmente resolvidas vs. não resolvidas?
- Limite de resultados? (top 5, top 10?)

### 3. Criação de Test Case

**Perguntas-chave:**
- Formato do test case: markdown, tabela, template estruturado?
- Cobre cenário feliz + cenário de erro + regressão?
- Precisa do diff SVN ou só da descrição da issue?
- Onde salva? (pasta no workspace, comentário na issue, clipboard?)
- Usa template existente do time?

### 4. Criação de Release Notes

**Perguntas-chave:**
- Período: por sprint, semana, data customizada?
- Formato: markdown, HTML, texto para email?
- Agrupa por módulo, tipo (Fix/Hotfix/US), ou cliente?
- Inclui revisão SVN e causa raiz?
- Onde salva? (arquivo, clipboard, comentário?)

### 5. Validação da Descrição Técnica

**Perguntas-chave:**
- Diferença em relação ao Closure Validator — este é mais profundo na parte técnica?
- Avalia se o dev mencionou: arquivos alterados, rotinas, tabelas, SPs?
- Avalia se a descrição é reproduzível por outro dev?
- É extensão do Closure Validator ou agente separado?

### 6. Validação de Assertividade

**Perguntas-chave:**
- Como mede assertividade? (problema descrito == correção aplicada?)
- Precisa acessar diff SVN para comparar?
- É análise documental ou precisa re-testar?
- Feedback do dev: confirma se agente acertou?
- Validação pós-deploy ou pré-deploy?

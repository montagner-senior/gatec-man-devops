---
title: Critérios de Validação de Conclusão
parent: Agentes
nav_order: 5
---

# Critérios de Validação de Conclusão de Issues — Path: Manutenção

> Este arquivo é a referência oficial do que torna o **fechamento** de uma issue válido para o time.
> O agente `issue-closure-validator` usa este documento como base de validação.

---

## Por que isso importa

Issues são fechadas após deploy em produção, mas frequentemente sem documentação adequada
do que foi feito. Sem os itens abaixo, o time perde rastreabilidade: não sabe qual revisão
SVN corrigiu o problema, qual foi a causa raiz, ou se o Suporte foi notificado.

> **Nota para o agente:** Este documento é sua referência principal de validação.
> Use seu julgamento ao analisar cada item — não use apenas verificação de campo vazio.
> Leia os comentários e avalie se realmente documentam o fechamento de forma útil.

### Fonte principal de informação

Diferente do validador de abertura (que analisa a descrição), o validador de conclusão
analisa primariamente os **comentários da Discussion**. É nos comentários que o dev
documenta o que fez ao longo do atendimento.

O agente analisa **duas fontes**:

1. **`comentarios`** — Comentários da Discussion (fonte principal)
2. **`descricaoTexto`** — Descrição da issue (fonte secundária, pode conter info de conclusão)

> **IMPORTANTE:** O agente deve ler **todos os comentários** da Discussion, incluindo os
> mais recentes. A informação de fechamento geralmente está nos últimos comentários,
> próximos à data de fechamento da issue.

### Análise de comentários (Discussion)

O agente **deve ler cada comentário** procurando informações de conclusão:

- **Comentário de fechamento:** Descrição da ação realizada (corrigido, ajustado, investigado)
- **Revisão/Commit:** Referências a revisões SVN (r12345) ou commits Git (hash, PR, branch)
- **Causa raiz:** Explicação do porquê do problema
- **Achado registrado:** Menção a registro na base de conhecimento
- **Notificação ao Suporte:** Comentários com `#zd` ou menção explícita

O agente deve mencionar no quadro quando encontrou a informação e em qual comentário:
*"ok (via comentário de Luis Montagner em 2026-04-08)"*

---

## Checklist de validação (5 itens)

| # | Item | Obrigatório | Como o agente valida |
|---|------|-------------|----------------------|
| 1 | **Comentário de fechamento** | Sempre | O dev adicionou comentário na Discussion explicando o que foi feito? Precisa descrever a ação realizada. |
| 2 | **Revisão/Commit** | Sempre | Nos comentários, há referência a revisão SVN ou commit Git? |
| 3 | **Análise Crítica** | Sempre (Bugs) / N/A (User Stories) | Os campos da aba Análise Crítica estão preenchidos? (Agente Ofensor, Tipo, Causa Principal, Idade do Erro, Origem do Bug) |
| 4 | **Achado registrado** | Quando relevante | Nos comentários, há menção a achado registrado na base de conhecimento? |
| 5 | **Suporte notificado** | Quando tem ticket Zendesk | Nos comentários, há menção de comunicação ao Suporte via `#zd` ou similar? |

---

## Critérios detalhados

### 1. Comentário de fechamento

**O que é:** Documentação do que foi feito para resolver a issue, adicionada pelo dev
como comentário na Discussion antes ou ao fechar a issue.

**Como o agente valida:** Leia os comentários da Discussion procurando um relato
que explique a ação realizada. Um bom comentário de fechamento responde:
- O que foi alterado/corrigido?
- Onde foi a alteração? (arquivo, tela, rotina)
- O problema foi resolvido? Como?

**Válido:**
- "Corrigido o cálculo de ICMS na rotina de emissão de NF. O campo alíquota não estava considerando a UF de destino."
- "Ajustado o relatório de fechamento mensal para incluir contratos do tipo X na query."
- "Investigado o travamento — causa era lock de tabela na SP_CALCULA_FRETE. Adicionado NOLOCK na query."
- "Alterado o formulário frmCadFornecedor.frm para validar CNPJ com dígito verificador correto."
- "Problema era cadastro incorreto do cliente. Sem alteração de código — orientado o Suporte a corrigir o cadastro."

**Inválido:**
- Nenhum comentário do dev na Discussion
- "feito" / "ok" / "pronto" / "resolvido" — sem dizer O QUE foi feito
- "Conforme alinhado" — sem detalhes
- Apenas comentários automáticos do sistema (mudança de estado)
- Apenas comentários do validador de abertura (issue-validator-agent)

---

### 2. Revisão/Commit

**O que é:** Referência ao commit/revisão (SVN ou Git) que contém as alterações de código.

**Como o agente valida:** Leia todos os comentários procurando referências a revisões SVN
ou commits Git. O formato pode variar. Procure por:
- Padrões SVN: `r12345`, `R12345`, `rev`, `rev.`, `revisão`, `revisao`, `revision`, `checkin`
- Padrões Git: hash de 7+ caracteres hexadecimais, `commit abc1234`, menção a PR, branch, `merge`
- Menções diretas: `commit`, `svn`, `checkin`, `push`
- Números/hashes próximos a palavras-chave (ex: "commitado na 54321", "merge do PR #42")

**Válido (SVN):**
- "Commitado na r54321"
- "Rev. 54321 — corrigido cálculo ICMS"
- "Revisão 54321"
- "svn commit r54321"
- "Alteração commitada - revisão 54321"
- "Checkin realizado (54321)"

**Válido (Git):**
- "Commit abc1234f no branch fix/icms"
- "Merge do PR #42"
- "Push realizado - hash 3f2a1b9"
- "Alteração no commit 7a8b9c0d1e2f3"

**Inválido:**
- Nenhuma referência a revisão/commit nos comentários
- "Código commitado" — sem o número da revisão ou hash
- "Aguardando commit" — ainda não foi feito
- Números soltos sem contexto de revisão (ex: "54321" isolado)

> **Exceção:** Se o comentário de fechamento menciona explicitamente que **não houve
> alteração de código** (ex: "problema era de cadastro, sem alteração de código"),
> o agente classifica como **N/A** em vez de AUSENTE. Não é necessário revisão/commit
> quando não houve código alterado.

---

### 3. Análise Crítica

**O que é:** Campos estruturados da aba "Análise Crítica" do work item (disponível apenas para Bugs).
Documenta a classificação e causa raiz do erro de forma padronizada.

**Campos obrigatórios (todos devem estar preenchidos):**

| Campo (display name) | Campo API | O que esperar |
|---|---|---|
| Offensive Agent | `Custom.SR_OFFENSIVE_AGENT` | Qual time/agente causou o problema (ex: "Manutenção") |
| Critical Analysis Type | `Custom.SR_CRITICAL_ANALYSIS_TYPE` | Tipo de problema (ex: "Lentidão", "Erro de cálculo") |
| Principal Error Cause | `Custom.SR_ERROR_CAUSE` | Categoria da causa (ex: "SQL (Lentidão)", "Lógica") |
| Error Age | `Custom.SR_ERROR_AGE` | Há quanto tempo o erro existe (ex: "Até 1 mês", "Mais de 6 meses") |
| Bug Origin | `Custom.BugOrigin` | Texto livre HTML explicando a origem/causa raiz do bug |

**Campo opcional:**
| Campo | Campo API | Descrição |
|---|---|---|
| Error Comment | `Custom.ErrorComment` | Comentário adicional sobre o erro (pode estar vazio) |

**Válido:**
- Todos os 4 campos dropdown preenchidos E Bug Origin com texto explicativo
- Bug Origin: "Erro originado devido alteração em estrutura de tabela. A velocidade de execução das DDLs depende da infraestrutura do cliente."
- Bug Origin: "Campo alíquota não considerava UF destino na tabela ICMS_UF."

**Inválido:**
- Qualquer dos 4 campos dropdown vazio/null
- Bug Origin vazio ou apenas espaços
- Bug Origin genérico sem contexto: "Erro corrigido" (não explica a causa)

**Para User Stories:** Este item é **N/A** — User Stories não possuem a aba Análise Crítica.

> **Nota:** Os nomes de campos acima (`Custom.SR_*` e `Custom.BugOrigin`) foram
> confirmados na API do projeto ERP - GATEC. Se algum campo retornar vazio
> inesperadamente, use `mcp_ado_wit_get_work_item_type` para revalidar.

---

### 4. Achado registrado

**O que é:** Registro de descoberta técnica na base de conhecimento do time
(`base-conhecimento/achados/`). Documenta investigações complexas para referência futura.

**Como o agente valida:** Leia os comentários procurando menção a registro na base
de conhecimento. Este item é **condicional** — só é relevante quando a issue envolveu
investigação técnica significativa.

**Válido:**
- "Achado registrado em base-conhecimento/achados/"
- "Registrado na base de conhecimento"
- "Documentado no achado ACHADO-2026-04-001"
- Link ou referência a arquivo de achado

**Quando é relevante (agente deve alertar se ausente):**
- Issue envolveu investigação técnica complexa (mais de uma causa testada)
- Descoberta que pode afetar outras telas/módulos
- Bug com causa não óbvia (ex: race condition, encoding, lock de tabela)
- Problema que pode se repetir em contexto similar

**Quando NÃO é relevante (agente marca N/A):**
- Correção simples e direta (typo, campo null, filtro faltando)
- Problema de cadastro/dados (sem alteração de código)
- Ajuste trivial sem descoberta técnica

> **Classificação:** Se ausente em issue com investigação complexa, o agente classifica
> como **⚠️ recomendação** em vez de AUSENTE. Não bloqueia a conclusão, mas alerta.
> No relatório, use ⚠️ no item 4.

---

### 5. Suporte notificado

**O que é:** Comunicação ao time de Suporte sobre a resolução, para que possam
responder ao cliente.

**Como o agente valida:** Verifique primeiro se a issue tem origem no Zendesk
(campo `natureza` preenchido, ou `tags` contendo "zendesk"). Se não tem vínculo
com Zendesk, marque como **N/A**.

Se tem vínculo Zendesk, leia os comentários procurando:
- Comentários que começam com `#zd` (sincronizados com Zendesk)
- Menções explícitas como "informado ao Suporte", "resposta enviada", "Suporte notificado"
- Instruções do tipo "Resposta para o Suporte — Ação: ..."

**Válido:**
- Comentário com `#zd` no início (sincronizado automaticamente)
- "Informado ao Suporte para responder ao cliente"
- "Resposta para o Suporte — Ação: Informar ao cliente que o relatório foi corrigido"
- "Suporte notificado via comentário #zd"

**Inválido (quando issue tem vínculo Zendesk):**
- Nenhuma menção de comunicação ao Suporte
- Issue fechada sem nenhum comentário `#zd`
- "Vou informar o Suporte" — intenção, não ação realizada

**N/A (quando issue NÃO tem vínculo Zendesk):**
- Issues internas (sem campo `natureza` e sem tag "zendesk")
- Fix/Hotfix identificado internamente pelo time

---

## Histórico de revisões

| Data | Alteração | Responsável |
|------|-----------|-------------|
| 2026-04-10 | Criação inicial com 5 critérios | Time de Manutenção |

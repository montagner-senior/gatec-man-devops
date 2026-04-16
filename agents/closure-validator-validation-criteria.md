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
- **Revisão SVN:** Referências a commits ou revisões (r12345, rev 12345)
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
| 2 | **Revisão SVN** | Sempre | Nos comentários, há referência a revisão SVN / commit? |
| 3 | **Causa raiz** | Sempre | Nos comentários, há explicação do que causou o problema ou da razão da alteração? |
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

### 2. Revisão SVN

**O que é:** Referência ao commit/revisão SVN que contém as alterações de código.

**Como o agente valida:** Leia todos os comentários procurando referências a revisões.
O formato pode variar. Procure por:
- Padrões numéricos: `r12345`, `R12345`
- Prefixos: `rev`, `rev.`, `revisão`, `revisao`, `revision`
- Menções diretas: `commit`, `svn`, `checkin`
- Números de revisão próximos a palavras-chave (ex: "commitado na 54321")

**Válido:**
- "Commitado na r54321"
- "Rev. 54321 — corrigido cálculo ICMS"
- "Revisão 54321"
- "svn commit r54321"
- "Alteração commitada - revisão 54321"
- "Checkin realizado (54321)"

**Inválido:**
- Nenhuma referência a revisão nos comentários
- "Código commitado" — sem o número da revisão
- "Aguardando commit" — ainda não foi feito
- Números soltos sem contexto de revisão (ex: "54321" isolado)

> **Exceção:** Se o comentário de fechamento menciona explicitamente que **não houve
> alteração de código** (ex: "problema era de cadastro, sem alteração de código"),
> o agente classifica como **N/A** em vez de AUSENTE. Não é necessário revisão SVN
> quando não houve código alterado.

---

### 3. Causa raiz

**O que é:** Explicação do que causou o problema ou da razão pela qual a alteração
foi necessária. Responde à pergunta "POR QUÊ?".

**Como o agente valida:** Leia os comentários procurando explicação causal.
Pode estar implícita no comentário de fechamento ou em comentários separados
de investigação.

**Válido:**
- "Causa: o campo alíquota não considerava a UF de destino na tabela ICMS_UF."
- "O problema ocorria porque a SP_CALCULA_FRETE fazia lock exclusivo na tabela."
- "Registro do fornecedor estava com CNPJ duplicado na base — cadastro incorreto."
- "A rotina de fechamento mensal não incluía contratos do tipo 3 no filtro WHERE."
- "Erro ao emitir NF porque o campo TipoNF estava NULL para registros migrados."
- "Necessidade de incluir novo campo para atender exigência fiscal — Nota Técnica 2024.001."

**Inválido:**
- Nenhuma explicação do porquê
- "Corrigido o erro" — diz O QUE fez, mas não POR QUÊ o erro acontecia
- "Ajustado conforme solicitação" — sem dizer a razão

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

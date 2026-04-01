# Métricas e KPIs do Time

## Objetivo

Definir os indicadores utilizados para medir a performance e saúde do time de Manutenção de Sistemas Legados. As métricas são referência para a Gerência na tomada de decisões e no acompanhamento da capacidade do time.

---

## Métricas de atendimento (Suporte / Zendesk)

### 1. Taxa de cumprimento de SLA

**O que mede:** Percentual de tickets atendidos dentro do prazo definido no [SLA](./sla.md)

**Fórmula:**
$$\text{Taxa SLA} = \frac{\text{Tickets dentro do prazo}}{\text{Total de tickets}} \times 100$$

**Meta:** ≥ `<X>%` por mês

**Fonte de dados:** Azure DevOps — campo "Data de fechamento" vs "Data de criação"

---

### 2. Tempo médio de primeira resposta (TMPR)

**O que mede:** Tempo médio entre a chegada do work item no Azure DevOps e o primeiro comentário do dev

**Meta:** ≤ `<X horas>` em dias úteis

**Como calcular:** Exportar work items do Azure DevOps e calcular diferença entre `Data de criação` e `Data do primeiro comentário`

---

### 3. Tempo médio de resolução (TMR) por tipo

**O que mede:** Tempo médio para concluir cada tipo de work item

| Tipo | Meta | Referência |
|---|---|---|
| Hotfix | ≤ 4 horas | SLA crítico |
| Fix | ≤ 5 dias úteis | SLA padrão |
| Ticket Zendesk (simples) | ≤ 1 dia útil | SLA padrão |
| Ticket Zendesk (complexo) | ≤ 3 dias úteis | SLA padrão |

---

### 4. Volume de tickets por período

**O que mede:** Quantidade de work items criados por semana/mês, segmentados por tipo e sistema

**Utilidade:** Identificar sistemas com alto volume de tickets (candidatos a refatoração ou maior atenção)

**Acompanhamento:** Mensal — na reunião de `<nome-da-cerimônia>`

---

### 5. Taxa de reabertura

**O que mede:** Percentual de tickets marcados como "Concluído" que foram reabertos por não-resolução

**Fórmula:**
$$\text{Taxa Reabertura} = \frac{\text{Tickets reabertos}}{\text{Tickets concluídos}} \times 100$$

**Meta:** ≤ `<X>%` por mês

**Sinal de alerta:** Taxa alta indica falta de testes antes do deploy ou diagnóstico incompleto

---

## Métricas de desenvolvimento

### 6. Número de Hotfixes por período

**O que mede:** Quantidade de Hotfixes por mês

**Meta:** Tendência de **redução** ao longo do tempo (mais Hotfixes = mais instabilidade)

**Sinal de alerta:** Aumento mês a mês em um mesmo sistema indica necessidade de revisão mais profunda

---

### 7. Velocidade do time (story points ou contagem)

**O que mede:** Quantidade de work items concluídos por sprint

**Como usar:** Referência para planejamento de capacidade nos próximos sprints

**Acompanhamento:** A cada sprint — na reunião de retrospectiva

---

### 8. Cobertura da base de conhecimento

**O que mede:** Percentual de investigações que geraram um arquivo de achado em `base-conhecimento/achados/`

**Meta:** 100% das investigações documentadas

**Como verificar:** Cruzar número de work items concluídos com arquivos criados em `achados/`

---

## Métricas de qualidade do código

### 9. Incidentes causados por deploy

**O que mede:** Número de Hotfixes diretamente causados por um deploy anterior

**Meta:** Zero incidentes por deploy

**Como rastrear:** Verificar no work item do Hotfix se há referência a um deploy como causa

---

### 10. Crescimento da base de conhecimento

**O que mede:** Número de entradas adicionadas à base de conhecimento por mês

| Arquivo | Entradas |
|---|---|
| `base-conhecimento/faq-suporte.md` | Contagem de entradas novas |
| `base-conhecimento/achados/` | Número de arquivos criados |
| `base-conhecimento/mapa-sistemas.md` | Sistemas catalogados / total estimado |

---

## Dashboard recomendado no Azure DevOps

O Azure DevOps permite criar dashboards com os seguintes widgets recomendados:

| Widget | O que exibe |
|---|---|
| **Work Item Chart** | Volume de tickets por tipo e estado |
| **Velocity** | Ritmo de conclusão por sprint |
| **Cumulative Flow** | Distribuição de tickets por estado ao longo do tempo |
| **Lead Time / Cycle Time** | Tempo médio de resolução |
| **Query Tile** | Contagem de Hotfixes abertos (meta: 0) |

> 💡 **Dica:** Consulte o guia do [Azure DevOps para Iniciantes](../guias/azure-devops-iniciantes.md) para aprender a navegar pelo projeto. A Gerência é responsável pela criação e manutenção do dashboard.

---

## Frequência de revisão

| Métrica | Frequência | Responsável |
|---|---|---|
| Cumprimento de SLA | Mensal | Gerência |
| Volume de Hotfixes | Semanal | Gerência |
| Velocidade do time | Por sprint | Gerência + Dev Sênior |
| Cobertura da base de conhecimento | Mensal | Dev Sênior |
| Taxa de reabertura | Mensal | Gerência |

---

## Observações e Alertas

> ⚠️ **Atenção:** Métricas são para apoio à decisão, não para punição individual. Indicadores negativos são oportunidades de melhoria de processo, não de avaliação pessoal.

> 📌 **Regra do time:** As metas numéricas marcadas com `<X>` devem ser preenchidas pela Gerência com base na capacidade atual do time antes de o documento entrar em uso.

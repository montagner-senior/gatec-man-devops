# SLA — Acordo de Nível de Serviço

## Objetivo

Definir os prazos e compromissos do time de Manutenção de Sistemas Legados no atendimento dos tickets recebidos via Zendesk e na entrega de correções e melhorias.

> 📌 **Regra do time:** Os prazos aqui definidos foram estabelecidos pela Gerência. Qualquer renegociação deve ser aprovada pela Gerência e comunicada ao Suporte.

---

## Definições

| Termo | Significado |
|---|---|
| **Tempo de Primeira Resposta** | Prazo para o dev atribuir o ticket a si e registrar o primeiro comentário de andamento |
| **Tempo de Análise** | Prazo para concluir a investigação e comunicar a resposta técnica ao Suporte |
| **Tempo de Resolução** | Prazo para o deploy da correção ou entrega da melhoria em produção |
| **Dias úteis** | Segunda a sexta, exceto feriados nacionais e locais |
| **Horário de atendimento** | `<horário-comercial>` — ex: 08h às 18h |

---

## SLA por tipo de Work Item

### Hotfix — Problema ativo em produção

| Marco | Prazo |
|---|---|
| **Primeira Resposta** | Imediato — comunicar ao Dev Sênior e Gerência no mesmo momento |
| **Início da investigação** | Até **1 hora** após identificação |
| **Resolução e deploy** | Meta: até **4 horas** — máximo: **1 dia útil** |
| **Comunicação ao Suporte** | A cada atualização relevante durante o atendimento |

> ⚠️ **Atenção:** Se a causa não for identificada em até **2 horas**, avaliar rollback do último deploy como alternativa mais rápida.

---

### Fix — Correção interna planejada

| Marco | Prazo |
|---|---|
| **Primeira Resposta** | Não aplicável (Fix é criado internamente) |
| **Triagem pelo Dev Sênior** | Até **2 dias úteis** após criação do work item |
| **Início do desenvolvimento** | Conforme priorização no sprint |
| **Resolução e deploy** | Dentro do sprint de alocação — meta: **5 dias úteis** |

---

### User Story — Melhoria ou novo comportamento

| Marco | Prazo |
|---|---|
| **Primeira Resposta ao Suporte** | Até **2 dias úteis** após recebimento |
| **Análise técnica de viabilidade** | Até **5 dias úteis** |
| **Início do desenvolvimento** | Conforme priorização no backlog |
| **Resolução e deploy** | A ser definido na reunião de planejamento do sprint |

---

### Tickets de Suporte (via Zendesk — sem classificação inicial)

Tickets chegam sem classificação prévia. O prazo conta a partir do momento em que o work item aparece no board do Azure DevOps.

| Marco | Prazo |
|---|---|
| **Atribuição e Primeira Resposta** | Até **4 horas** em dias úteis |
| **Resposta técnica ao Suporte** | Até **1 dia útil** para problemas simples |
| **Resposta técnica ao Suporte** | Até **3 dias úteis** para problemas complexos |
| **Resolução** | Conforme classificação após investigação (Hotfix, Fix ou User Story) |

> ⚠️ **Atenção:** O SLA das Issues **não deve ser retirado** quando o status é alterado no Zendesk. A contagem de SLA permanece ativa independentemente de mudanças de status na ferramenta de origem. Se perceber que o SLA está sendo removido automaticamente, comunique à Gerência para correção na integração.

---

## Fluxo de escalation

Quando o SLA estiver em risco de ser descumprido:

```
Dev identifica que não conseguirá cumprir o prazo
       ↓
Comunicar ao Dev Sênior imediatamente (não esperar o prazo vencer)
       ↓
Dev Sênior avalia e decide: suporte técnico, redistribuição ou realocação de prioridade
       ↓
Gerência é informada se o prazo já foi ou será descumprido
       ↓
Gerência comunica ao Suporte com novo prazo estimado
```

> ⚠️ **Atenção:** Nunca deixe um prazo vencer sem comunicar proativamente. Surpresas prejudicam a relação com o Suporte e com os clientes.

---

## Priorização em caso de volume alto

Quando houver múltiplos tickets simultâneos, a ordem de priorização é:

1. 🔴 **Hotfix** — sempre primeiro, independente de quantidade
2. 🟡 **Tickets Zendesk com SLA próximo do vencimento**
3. 🟡 **Fixes** do sprint atual
4. 🟢 **User Stories** do sprint atual
5. 🟢 **Tickets Zendesk** com prazo confortável

---

## Relatório de SLA

> 📌 **Regra do time:** O cumprimento do SLA é monitorado pela Gerência. Métricas de SLA são revisadas na cerimônia de `<retrospectiva ou reunião de gestão>`.

Consulte as métricas em: [Métricas e KPIs](./metricas-kpis.md)

---

## Observações e Alertas

> 💡 **Dica:** Para verificar os prazos de todos os tickets abertos no Azure DevOps, use o filtro de data de criação no board. Tickets mais antigos têm prioridade dentro da mesma classificação.

> 📌 **Regra do time:** Feriados e ausências planejadas (férias, folgas) devem ser comunicados à Gerência com antecedência para ajuste de capacidade e SLA. Consulte: [Gestão de Capacidade](./capacidade.md).

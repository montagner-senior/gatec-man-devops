# Cerimônias do Time

## Objetivo

Descrever os rituais ágeis adotados pelo time de Manutenção de Sistemas Legados — quando acontecem, qual o propósito de cada um e o que se espera dos participantes.

---

## Visão geral das cerimônias

| Cerimônia | Frequência | Duração | Participantes |
|---|---|---|---|
| Planejamento do Sprint | A cada `<X semanas>` | Até `<X horas>` | Todo o time |
| Daily (Stand-up) | Diária | 15 minutos | Todo o time |
| Revisão do Sprint | A cada `<X semanas>` | Até `<X hora>` | Time + Gerência |
| Retrospectiva | A cada `<X semanas>` | Até `<X hora>` | Todo o time |
| Triagem de Backlog | `<frequência>` | Até `<X hora>` | Gerência + Dev Sênior |

> 📌 **Regra do time:** As cerimônias têm horários fixos definidos pela Gerência. Ausências devem ser comunicadas com antecedência. Hotfixes em andamento têm prioridade — o dev pode sair da cerimônia para atender.

---

## Planejamento do Sprint

### Propósito

Selecionar os work items do backlog que serão desenvolvidos no próximo sprint, considerando a capacidade do time, prioridades e SLAs.

### Quando

- Início de cada sprint
- Horário: `<horário definido pela gerência>`
- Local / Link: `<sala ou videoconferência>`

### Pauta

1. Revisão da velocidade do sprint anterior (quantos work items foram concluídos)
2. Verificação de capacidade para o próximo sprint (férias, ausências — consulte [Gestão de Capacidade](./capacidade.md))
3. Priorização dos work items do backlog pela Gerência
4. Estimativa de esforço pelos devs (se o time usar estimativas)
5. Comprometimento do time com o escopo do sprint

### Resultado esperado

- Sprint planejado no Azure DevOps com work items alocados
- Todos os participantes sabem o que cada um vai fazer

---

## Daily (Stand-up)

### Propósito

Sincronização rápida diária para compartilhar progresso, identificar bloqueios e manter o time alinhado.

### Quando

- Todos os dias úteis
- Horário fixo: `<horário definido pela gerência>`
- Duração máxima: **15 minutos**

### O que cada dev deve responder

Cada participante responde **brevemente** três perguntas:

1. **O que fiz ontem?** — work items avançados, investigações concluídas
2. **O que farei hoje?** — próximos passos planejados
3. **Há algum bloqueio?** — dependências, dúvidas, impedimentos

> 💡 **Dica:** A Daily não é o momento para discutir soluções técnicas. Se surgir um assunto técnico, combine com as pessoas envolvidas um momento separado após a reunião.

### Comportamento esperado

- Ser pontual — 15 minutos é para todo o time
- Foco nos três pontos — não entrar em detalhes técnicos
- Registrar bloqueios no Azure DevOps como comentários nos work items após a reunião

---

## Revisão do Sprint

### Propósito

Apresentar o trabalho concluído no sprint, validar se os work items atendem aos critérios esperados e coletar feedback da Gerência.

### Quando

- Final de cada sprint
- Horário: `<horário definido pela gerência>`

### Pauta

1. Cada dev apresenta os work items que concluiu no sprint
2. Demonstração de funcionalidades entregues (quando aplicável)
3. Gerência valida e aceita ou devolve para correção
4. Tickets Zendesk concluídos são comunicados ao Suporte
5. Métricas do sprint são compartilhadas (ver [Métricas e KPIs](./metricas-kpis.md))

### Resultado esperado

- Work items validados ou devolvidos com feedback claro
- Gerência atualizada sobre o estado dos sistemas
- Suporte informado sobre resoluções que impactam clientes

---

## Retrospectiva

### Propósito

Refletir sobre o processo do sprint — o que funcionou bem, o que pode melhorar — e definir ações concretas de melhoria para o próximo sprint.

### Quando

- Final de cada sprint (geralmente após a Revisão)
- Duração: até `<X hora>`

### Estrutura sugerida

O facilitador (geralmente o Dev Sênior ou a Gerência) conduz as três perguntas:

| Pergunta | Exemplos de resposta |
|---|---|
| **O que foi bem?** | "Conseguimos fechar todos os Hotfixes no prazo", "A base de conhecimento ajudou na investigação" |
| **O que pode melhorar?** | "Vários tickets ficaram sem comentários por mais de 24h", "Faltou análise técnica antes do desenvolvimento" |
| **O que vamos fazer diferente?** | "Comprometer com atualização diária nos work items", "Dev Sênior revisará Fixes antes do deploy" |

### Resultado esperado

- Lista de ações de melhoria com responsável e prazo
- Ações são adicionadas como User Stories ou tarefas de processo no backlog

---

## Triagem de Backlog

### Propósito

Revisar, priorizar e detalhar os work items do backlog antes do planejamento do sprint, para que o planejamento seja eficiente.

### Quando

- `<frequência>` — ex: uma vez por semana, na quarta-feira
- Participantes: Gerência + Dev Sênior (devs convidados quando necessário)

### Atividades

1. Revisar novos work items criados desde a última triagem
2. Detalhar Critérios de Aceite de User Stories
3. Verificar se Fixes e Hotfixes estão priorizados corretamente
4. Remover work items duplicados ou obsoletos
5. Estimar esforço quando necessário

---

## Observações e Alertas

> ⚠️ **Atenção:** Cerimônias com horário marcado têm prioridade sobre investigações e desenvolvimentos em andamento — exceto Hotfixes ativos.

> 💡 **Dica:** Se uma cerimônia for cancelada por falta de agenda ou ausência de participantes, registre no canal do time e reagende para o mesmo dia quando possível.

> 📌 **Regra do time:** Os horários e frequências marcados com `<placeholder>` devem ser preenchidos pela Gerência antes de o documento entrar em uso pelo time.

# Gestão de Capacidade e Férias

## Objetivo

Orientar o time sobre como comunicar ausências planejadas (férias, folgas, afastamentos) e como a Gerência gerencia a capacidade do time para garantir que SLAs sejam cumpridos mesmo com variações na disponibilidade dos devs.

---

## Por que a gestão de capacidade é importante?

O time de Manutenção atende tickets com prazos definidos (ver [SLA](./sla.md)). Se um dev que carrega tickets importantes tirar férias sem comunicação prévia ou sem planejamento, tickets podem vencer e SLAs serem descumpridos.

> 📌 **Regra do time:** Toda ausência planejada com mais de **1 dia** deve ser comunicada com antecedência mínima de `<X dias úteis>`. Ausências de **1 semana ou mais** devem ser comunicadas com `<Y semanas>` de antecedência.

---

## Como comunicar ausências

### Passo 1 — Informe a Gerência

Comunicar diretamente à Gerência (e-mail, mensagem direta ou reunião 1:1) informando:
- Período de ausência (datas de início e fim)
- Motivo (férias, folga, afastamento médico, etc.)

### Passo 2 — Atualize o Azure DevOps

1. Acesse o Azure DevOps → **Boards** → painel de **Sprints** ou **Capacidade**
2. Nas configurações de **Capacity** do sprint, informe os dias de ausência
3. Isso permite ao Azure DevOps calcular a capacidade real do time no sprint

### Passo 3 — Handover dos tickets em aberto

Antes de sair, para cada work item que você tem atribuído e em andamento:

1. Adicione um comentário com o estado atual da investigação:
   ```
   Handover — [data de saída]
   
   Dev em férias a partir de [data] até [data].
   
   Estado atual: [o que já foi feito, o que falta fazer]
   Próximo passo sugerido: [o que quem pegar deve fazer]
   Arquivos relevantes: [lista de arquivos VB6 investigados]
   Ponto de atenção: [qualquer aviso importante]
   ```
2. Reatribua o work item para o Dev Sênior ou para quem a Gerência designar
3. Atualize o estado corretamente (não deixe em "Em Desenvolvimento" sem ninguém trabalhando)

> ⚠️ **Atenção:** Nunca saia de férias com work items críticos (Hotfix ou tickets com SLA próximo do vencimento) sem primeiro garantir que foram redistribuídos e que o Dev Sênior está ciente.

---

## Cálculo de capacidade no sprint

A capacidade do time em um sprint é calculada considerando:

| Fator | Como afeta |
|---|---|
| Dias úteis no período do sprint | Base de cálculo |
| Dias de férias e folgas declarados | Subtrai da capacidade |
| Cerimônias (Daily, Planejamento, etc.) | Subtrai do tempo disponível para desenvolvimento |
| Suporte a Hotfixes imprevistos | Gerência reserva buffer de `<X>%` da capacidade |

### Planejamento de capacidade no Azure DevOps

1. Acesse o projeto → **Boards** → **Sprints**
2. Selecione o sprint atual
3. Clique na aba **"Capacity"**
4. Para cada membro do time:
   - Informe a atividade (ex: "Desenvolvimento")
   - Informe as horas por dia disponíveis
   - Informe os dias de folga no período
5. O Azure DevOps calcula automaticamente a capacidade total do time

---

## Férias coletivas e recesso

Nos períodos de férias coletivas ou recesso:

| Ação | Responsável | Prazo |
|---|---|---|
| Comunicar ao Suporte a redução de capacidade | Gerência | `<X dias>` antes |
| Definir escala de plantão para Hotfixes | Gerência | `<Y dias>` antes |
| Fazer handover de todos os tickets em andamento | Dev | Último dia útil antes do recesso |
| Atualizar o Azure DevOps com os dias de ausência | Dev + Gerência | Antes do recesso |

---

## Plantão de Hotfix

Mesmo em períodos de redução de capacidade, deve haver sempre alguém de plantão para atender Hotfixes.

> 📌 **Regra do time:** A escala de plantão é definida pela Gerência e comunicada ao time antes do início do período. O dev de plantão deve estar acessível durante o horário de atendimento definido.

**Responsabilidades do dev de plantão:**
- Monitorar o board do Azure DevOps por novos work items com prioridade Alta
- Atender Hotfixes dentro do SLA estabelecido
- Caso a correção esteja além de sua capacidade técnica: escalar ao Dev Sênior imediatamente

---

## Relatório de capacidade

A Gerência utiliza os seguintes dados para planejamento:

| Informação | Fonte |
|---|---|
| Dias úteis disponíveis por dev | Azure DevOps — Capacity |
| Work items em andamento por dev | Azure DevOps — Board filtrado por "Atribuído a" |
| Histórico de velocidade | Azure DevOps — Velocity chart |
| Ausências futuras | Comunicação direta ao gestor |

---

## Observações e Alertas

> ⚠️ **Atenção:** O recesso de fim de ano é um período crítico — sistemas legados frequentemente apresentam problemas em virada de mês/ano (datas, numerações de documentos, fechamentos). Garanta que o plantão deste período seja coberto por dev com experiência.

> 💡 **Dica:** Ao planejar férias, verifique no Azure DevOps quais work items estão atribuídos a você e qual é o prazo de cada um. Não saia de férias no meio de um sprint sem garantir que o trabalho foi redistribuído.

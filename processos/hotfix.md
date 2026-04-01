# Processo de Hotfix

## Objetivo

Descrever o processo completo de atendimento a um **Hotfix** — um problema ativo em produção que exige correção imediata. Este é o processo de maior urgência do time.

## Pré-requisitos

- Acesso ao Azure DevOps
- Acesso ao checkout SVN do sistema afetado
- Acesso ao pipeline de deploy no Azure DevOps
- Contato com o Desenvolvedor Sênior e Gerência disponível

---

## O que é um Hotfix?

Um **Hotfix** é uma correção emergencial de um defeito que está causando impacto **agora** em produção. Exemplos:

- Sistema não abre para os usuários após um deploy
- Cálculo financeiro produzindo valores incorretos
- Dados sendo gravados de forma errada
- Funcionalidade crítica indisponível

> ⚠️ **Atenção:** Ao identificar situação de Hotfix, **pare o que estiver fazendo** e comunique imediatamente o Desenvolvedor Sênior e a Gerência.

> 📌 **Regra do time:** Hotfix tem prioridade **absoluta** sobre qualquer outra atividade em andamento — User Stories, Fixes e reuniões não-urgentes são pausados.

---

## Fluxo de atendimento

```
Problema identificado (pelo Suporte ou pelo próprio time)
       ↓
Comunicar ao Dev Sênior e Gerência — AGORA
       ↓
Criar o Work Item Hotfix no Azure DevOps
       ↓
Atribuir ao responsável e mudar estado para "Em Desenvolvimento"
       ↓
SVN Update no sistema afetado
       ↓
Investigar a causa no código VB6
       ↓
Desenvolver e testar a correção
       ↓
SVN Commit com a correção (mensagem: [HOTFIX] #número - descrição)
       ↓
Solicitar aprovação para deploy à Gerência
       ↓
Acionar pipeline de deploy no Azure DevOps
       ↓
Confirmar que o problema foi resolvido em produção
       ↓
Atualizar work item → Concluído
       ↓
Comunicar ao Suporte e ao time
       ↓
Registrar achado em base-conhecimento/achados/
```

---

## Passo a passo detalhado

### Passo 1 — Comunicar imediatamente

Antes de qualquer outra ação:

1. Informe no canal do time: `"[HOTFIX] Problema identificado em <nome-do-sistema>: <descrição breve>"`
2. Acione o Desenvolvedor Sênior diretamente (telefone, mensagem direta)
3. Informe à Gerência para que ela possa alertar o Suporte e gerenciar expectativas

### Passo 2 — Criar o Work Item Hotfix

1. Acesse o Azure DevOps → **Boards** → **Backlogs**
2. Clique em **"+ New Work Item"** → selecione **Hotfix**
3. Preencha o **Título**: `[HOTFIX][<SISTEMA>] <Descrição curta do problema>`
   - Exemplo: `[HOTFIX][SisFaturamento] Nota fiscal duplicada após deploy de 09/03`
4. Na **Descrição**, informe o máximo de detalhes disponíveis:
   - Qual funcionalidade está afetada
   - Quantos usuários são impactados
   - Quando o problema começou
   - O que mudou recentemente (deploy, configuração, banco)
5. Marque como **Alta Prioridade**
6. Associe ao Sprint atual (campo **Iteração**)
7. Clique em **"Salvar"**
8. Anote o número do work item criado — ele será usado na mensagem de commit e comunicações

### Passo 3 — Atualizar estado e atribuição

1. Mude o estado para **"Em Desenvolvimento"**
2. Atribua o work item a você (ou ao dev designado)
3. Adicione o comentário inicial:
   ```
   [DD/MM HH:MM] Hotfix iniciado. Investigando causa em <nome-do-sistema>.
   Dev responsável: <nome>
   ```

### Passo 4 — Investigar e corrigir

1. Execute `SVN Update` na pasta do sistema afetado
2. Consulte o SVN Log para identificar o commit mais recente que pode ter causado o problema
3. Navegue no código VB6 seguindo o processo de [Investigação de Código VB6](./investigacao-legado.md)
4. Adicione comentários no work item a cada 30 minutos com o andamento:
   ```
   [HH:MM] Causa identificada: <descrição breve>. Corrigindo em <arquivo.frm>.
   ```

> ⚠️ **Atenção:** Em um Hotfix, priorize a correção mais segura e direta — não é o momento de refatorar ou melhorar o código. Corrija exatamente o ponto que está causando o problema.

### Passo 5 — Commit da correção

1. Após corrigir e testar localmente (se possível):
2. Execute `SVN Update` novamente antes do commit
3. Execute `SVN Commit` com a mensagem:
   ```
   [HOTFIX] #<número-work-item> - <Descrição do que foi corrigido>
   
   Exemplo:
   [HOTFIX] #5678 - Corrige duplicação de nota fiscal causada por duplo trigger na gravação
   ```

### Passo 6 — Solicitar aprovação e deploy

1. Mude o estado do work item para **"Aguardando Deploy"**
2. Adicione comentário:
   ```
   [HH:MM] Correção commitada no SVN (revisão: <número-da-revisão>).
   Aguardando aprovação da Gerência para deploy em produção.
   ```
3. Acione a Gerência para aprovação
4. Após aprovação: execute o pipeline de deploy no Azure DevOps (ver [Pipeline de Deploy](../pipelines/cd-deploy.md))

### Passo 7 — Confirmar resolução e concluir

1. Após o deploy, verifique se o problema foi resolvido em produção
2. Solicite confirmação ao Suporte ou a um usuário
3. Mude o estado do work item para **"Concluído"**
4. Adicione o comentário final:
   ```
   [HH:MM] Hotfix concluído. Problema confirmado como resolvido em produção.
   Deploy realizado em: <data/hora>
   Causa: <resumo da causa>
   Correção: <resumo do que foi corrigido>
   ```
5. Informe ao time: `"[HOTFIX #número] Resolvido. Sistema <nome> normalizado."`

### Passo 8 — Registrar o achado

> 📌 **Regra do time:** Mesmo em situação de emergência, o registro deve ser feito antes do fim do dia.

1. Crie `base-conhecimento/achados/AAAAMMDD-hotfix-<sistema>-<descricao>.md`
2. Use o template: `base-conhecimento/achados/TEMPLATE-achado.md`
3. Documente: causa raiz, arquivos afetados, correção aplicada, como reproduzir

---

## Comunicações obrigatórias durante o Hotfix

| Momento | Mensagem |
|---|---|
| **Início** | `[HOTFIX] Iniciado em <sistema> — <descrição> — investigando` |
| **Causa identificada** | `[HOTFIX #número] Causa: <descrição breve> — corrigindo` |
| **Aguardando deploy** | `[HOTFIX #número] Correção pronta — aguardando aprovação para deploy` |
| **Deploy realizado** | `[HOTFIX #número] Deploy realizado — verificando em produção` |
| **Concluído** | `[HOTFIX #número] Encerrado — sistema normalizado` |

---

## Critérios para um Hotfix ser considerado Hotfix

| Critério | Hotfix? |
|---|---|
| Sistema fora do ar para todos os usuários | ✅ Sim |
| Funcionalidade crítica indisponível | ✅ Sim |
| Dados financeiros sendo gravados incorretamente | ✅ Sim |
| Erro que ocorre apenas para alguns usuários em fluxo não crítico | ❌ Não — abra um Fix |
| Melhoria que o cliente quer "urgente" | ❌ Não — discuta com a Gerência |

---

## Observações e Alertas

> ⚠️ **Atenção:** Nunca faça deploy de Hotfix sem aprovação da Gerência, exceto se a Gerência tiver delegado essa autoridade explicitamente em situação de emergência.

> ⚠️ **Atenção:** Se a causa do problema não puder ser determinada em até 1 hora, acione o Dev Sênior para avaliação de rollback — desfazer o último deploy pode ser mais rápido do que corrigir.

> 💡 **Dica:** Consulte o processo de [Rollback](../pipelines/rollback.md) assim que o Hotfix for iniciado — tenha o plano B pronto caso a correção não funcione.

# Processo de Fix

## Objetivo

Descrever o processo de atendimento a um **Fix** — uma correção de defeito identificado internamente pelo time, sem impacto crítico imediato em produção.

## O que é um Fix?

Um **Fix** é a correção planejada de um defeito identificado pelo próprio time — durante uma investigação, revisão de código ou análise proativa. Diferente do Hotfix, **não há impacto crítico e imediato em produção** que exija parar tudo.

**Exemplos:**
- Cálculo incorreto descoberto durante investigação de outro ticket
- Campo que aceita valores inválidos em determinada condição
- Comportamento inesperado em tela de consulta identificado em revisão
- Deficiência de validação que pode gerar problemas futuros

> 💡 **Dica:** Se o problema já estiver causando impacto ativo em produção, não é um Fix — é um [Hotfix](./hotfix.md). Discuta com a Gerência se tiver dúvida.

---

## Fluxo do Fix

```
Defeito identificado (pelo Dev durante investigação ou revisão)
       ↓
Avaliar: é urgente? → Sim → Acionar Gerência para avaliar Hotfix
                   → Não → Criar Work Item Fix
       ↓
Criar Work Item Fix no Azure DevOps
       ↓
Dev Sênior valida e prioriza dentro do sprint
       ↓
Dev inicia a investigação/desenvolvimento no sprint planejado
       ↓
SVN Update → Desenvolver → Testar
       ↓
SVN Commit com a correção
       ↓
Solicitar revisão ao Dev Sênior (quando aplicável)
       ↓
Pipeline de deploy na janela planejada
       ↓
Work Item → Concluído
       ↓
Registrar achado em base-conhecimento/achados/
```

---

## Passo a passo detalhado

### Passo 1 — Criar o Work Item Fix

1. Acesse o Azure DevOps → **Boards** → **Backlogs**
2. Clique em **"+ New Work Item"** → selecione **Fix**
3. Preencha o **Título** com o formato: `[<SISTEMA>] <Descrição clara do defeito>`
   - Exemplo: `[SisVendas] Desconto incorreto para pedidos com quantidade acima de 999`
4. Na **Descrição**, informe:
   - O que foi identificado (descrição técnica do defeito)
   - Onde está no código (arquivo, função, se já souber)
   - Como reproduzir (condições para o problema ocorrer)
   - Origem da identificação (ticket liberado, revisão, investigação de outro WI)
5. Defina a **Área**: sistema afetado
6. Defina a **Iteração**: sprint atual ou próximo (conforme priorização da Gerência)
7. Clique em **"Salvar"**

### Passo 2 — Triagem com o Dev Sênior

Após criar o work item:

1. Comunique ao Dev Sênior: `"Fix #número criado — <descrição>. Avaliação de prioridade necessária."`
2. O Dev Sênior valida:
   - Se a causa diagnóstico está correta
   - Se o Fix deve entrar no sprint atual ou no próximo
   - Se há dependências com outros work items
3. Após validação, o work item é adicionado ao sprint e atribuído

### Passo 3 — Desenvolvimento

Quando o Dev iniciar o trabalho no sprint:

1. Mude o estado para **"Em Análise"** e adicione comentário: `"Iniciando análise do defeito."`
2. Execute `SVN Update` no sistema afetado
3. Identifique o ponto exato do defeito no código VB6 (consulte [Investigação de Código VB6](./investigacao-legado.md))
4. Documente a causa identificada como comentário no work item:
   ```
   Causa identificada — [data]
   Arquivo: <nome.frm / .bas / .cls>
   Função: <NomeDaFuncao>
   
   O que está errado: <descrição técnica>
   Condição: <quando o erro ocorre>
   ```
5. Mude o estado para **"Em Desenvolvimento"** ao iniciar a correção

### Passo 4 — Teste local

Antes de commitar, teste a correção:

- [ ] O cenário que causava o erro foi corrigido
- [ ] O fluxo normal da funcionalidade continua funcionando
- [ ] Casos extremos (valores zerados, campos vazios, datas inválidas) foram verificados
- [ ] Outros módulos que chamam a mesma função foram identificados e avaliados

> ⚠️ **Atenção:** Valide que a correção não quebrou outras funcionalidades do sistema — em VB6, módulos compartilhados são usados por múltiplas telas.

### Passo 5 — Commit

1. Execute `SVN Update` imediatamente antes do commit
2. Verifique se há conflitos (se sim, resolva antes — consulte [Controle de Versão SVN](../guias/controle-versao-svn.md))
3. Execute `SVN Commit` com a mensagem:
   ```
   [FIX] #<número-work-item> - <Descrição do que foi corrigido>
   
   Exemplo:
   [FIX] #1234 - Corrige cálculo de desconto para quantidades acima de 999 unidades
   ```
4. Adicione comentário no work item: `"Correção commitada. Revisão SVN: <número>. Aguardando deploy."`
5. Mude o estado para **"Aguardando Deploy"**

### Passo 6 — Revisão pelo Dev Sênior (quando necessário)

Para Fixes que alteram lógica crítica (cálculos financeiros, gravação de dados, integrações):

1. Solicite revisão ao Dev Sênior antes do deploy
2. Compartilhe o número da revisão SVN para que ele possa revisar os arquivos alterados
3. Aguarde validação antes de solicitar o deploy

### Passo 7 — Deploy e conclusão

1. Solicite o deploy à Gerência conforme a janela planejada
2. Após deploy, verifique se a funcionalidade está correta em produção
3. Mude o estado para **"Concluído"**
4. Adicione comentário final:
   ```
   Fix concluído — [data]
   Deploy realizado em: <data/hora>
   Validado por: <nome>
   ```

### Passo 8 — Registrar o achado (quando relevante)

Se o Fix revelou algo novo sobre o sistema (lógica desconhecida, comportamento inesperado, módulo crítico):

1. Crie `base-conhecimento/achados/AAAAMMDD-fix-<sistema>-<descricao>.md`
2. Use o template: `base-conhecimento/achados/TEMPLATE-achado.md`

---

## Critérios de priorização de Fixes

A Gerência prioriza Fixes no backlog usando os seguintes critérios:

| Critério | Peso |
|---|---|
| Impacto em clientes (quantos e com que frequência) | Alto |
| Risco de escalada para Hotfix se não corrigido | Alto |
| Esforço estimado de correção | Médio |
| Dependência de outros work items | Médio |
| Tempo desde a identificação | Baixo |

---

## Observações e Alertas

> ⚠️ **Atenção:** Um Fix que começa a impactar usuários em produção durante seu desenvolvimento deve ser reclassificado como Hotfix. Comunique à Gerência imediatamente se isso acontecer.

> 💡 **Dica:** Se durante o desenvolvimento de um Fix você identificar outros defeitos no mesmo módulo, **não corrija tudo no mesmo work item**. Crie um novo Fix para cada defeito identificado — facilita rastreamento e rollback.

> 📌 **Regra do time:** Fixes com alteração em lógica de cálculo financeiro **sempre** exigem revisão do Dev Sênior antes do deploy.

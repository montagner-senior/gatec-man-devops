# Processo de User Story

## Objetivo

Descrever o processo de desenvolvimento de uma **User Story** — uma melhoria ou novo comportamento solicitado para os sistemas VB6 legados.

## Pré-requisitos

- Acesso ao Azure DevOps
- Acesso ao checkout SVN do sistema afetado
- Entendimento dos [tipos de work item](../guias/work-items.md)

---

## O que é uma User Story?

Uma **User Story** representa algo que o sistema **ainda não faz** e que o cliente ou a gerência deseja que passe a fazer. Não é um erro — é uma evolução ou melhoria planejada.

**Exemplos:**
- "Incluir coluna de CPF no relatório de clientes"
- "Permitir cancelamento de pedidos após faturamento"
- "Emitir e-mail automático ao concluir um lote"
- "Adicionar filtro por período na tela de consulta de notas"

> 💡 **Dica:** A diferença entre User Story e Fix é a natureza: a User Story adiciona ou muda um comportamento **que nunca existiu ou que foi solicitado formalmente**. O Fix corrige algo que **deveria funcionar de uma forma mas não está funcionando**.

---

## Fluxo da User Story

```
Solicitação recebida (cliente via Suporte, ou gerência interna)
       ↓
Gerência avalia e cria o Work Item User Story
       ↓
Dev Sênior analisa viabilidade técnica no código VB6
       ↓
Gerência prioriza no backlog e aloca para um sprint
       ↓
Dev inicia em "Em Análise" — mapeia impacto no código VB6
       ↓
Dev desenvolve e testa localmente
       ↓
SVN Commit com a implementação
       ↓
Dev Sênior revisa
       ↓
Gerência/Suporte valida (Critérios de Aceite)
       ↓
Pipeline de deploy
       ↓
Work Item → Concluído
       ↓
Comunicar ao Suporte para encerrar o chamado original (se houver)
```

---

## Passo a passo detalhado

### Passo 1 — Receber e ler a User Story

1. Acesse o Azure DevOps → **Boards** → **Backlogs**
2. Localize a User Story pelo número ou título
3. Leia **cuidadosamente**:
   - **Título:** descrição resumida da solicitação
   - **Descrição:** detalhes do comportamento desejado
   - **Critérios de Aceite:** condições que precisam ser atendidas para considerá-la concluída
4. Se os Critérios de Aceite estiverem ausentes ou vagos, **não inicie o desenvolvimento** — solicite à Gerência que os defina antes

> ⚠️ **Atenção:** Trabalhar sem Critérios de Aceite é a principal causa de retrabalho. Se não estiver claro o que será validado no final, pergunte antes de escrever uma linha de código.

### Passo 2 — Análise técnica ("Em Análise")

1. Mude o estado para **"Em Análise"**
2. Execute `SVN Update` no sistema afetado
3. Identifique no código VB6:
   - Quais telas (`.frm`) serão modificadas ou criadas
   - Quais módulos (`.bas`) ou classes (`.cls`) serão afetados
   - Se há interação com o banco de dados (novas colunas, tabelas, queries)
   - Se outros sistemas ou integrações são impactados
4. Estime o esforço e comunique à Gerência se o impacto for maior do que o esperado
5. Adicione comentário no work item com o resultado da análise:
   ```
   Análise técnica — [data]
   
   Telas afetadas: <lista de .frm>
   Módulos afetados: <lista de .bas / .cls>
   Banco de dados: <tabelas/colunas a criar ou modificar>
   Estimativa: <X horas/dias>
   Complexidade: baixa / média / alta
   
   Observações: <riscos ou dependências identificados>
   ```

### Passo 3 — Desenvolvimento ("Em Desenvolvimento")

1. Mude o estado para **"Em Desenvolvimento"**
2. Implemente a solicitação **exatamente** conforme os Critérios de Aceite
3. Adicione comentários no work item para registrar decisões técnicas relevantes:
   ```
   Decisão técnica — [data]
   Optei por [abordagem X] em vez de [abordagem Y] porque [motivo].
   ```
4. Consulte o Dev Sênior quando a implementação envolver:
   - Alterações em módulos compartilhados por múltiplas telas
   - Novos campos ou tabelas no banco de dados
   - Lógica de negócio que não estava documentada e exige interpretação

### Passo 4 — Teste local

Valide **cada critério de aceite** antes de commitar:

| Critério de Aceite | Testado? | Resultado |
|---|---|---|
| [Critério 1 da US] | [ ] | |
| [Critério 2 da US] | [ ] | |
| [Critério N da US] | [ ] | |

Testes adicionais recomendados:
- [ ] Fluxo normal da funcionalidade existente não foi quebrado
- [ ] Campos novos aceitam apenas os valores esperados (validação)
- [ ] Comportamento com dados extremos (vazio, máximo, mínimo)
- [ ] Tela renderiza corretamente em resolução padrão dos usuários

### Passo 5 — Commit

1. Execute `SVN Update` imediatamente antes do commit
2. Confirme que apenas os arquivos intencionais estão na lista de commit
3. Execute `SVN Commit` com a mensagem:
   ```
   [USER-STORY] #<número-work-item> - <Descrição do que foi implementado>
   
   Exemplo:
   [USER-STORY] #9012 - Adiciona filtro por período na tela de consulta de notas fiscais
   ```
4. Mude o estado para **"Aguardando Aprovação"**
5. Adicione comentário: `"Implementação commitada. Revisão SVN: <número>. Pronto para validação."`

### Passo 6 — Revisão pelo Dev Sênior

1. Solicite revisão ao Dev Sênior para toda User Story que:
   - Altere lógica de negócio crítica
   - Modifique módulos compartilhados
   - Crie novos campos ou tabelas no banco
2. O Dev Sênior revisará os arquivos modificados via SVN Diff
3. Incorpore o feedback recebido antes de solicitar validação final

### Passo 7 — Validação pelos Critérios de Aceite

1. Apresente a implementação ao responsável pela validação (Gerência ou Suporte)
2. O validador verificará cada Critério de Aceite
3. Se aprovado: mude para **"Aguardando Deploy"**
4. Se rejeitado: retorne para **"Em Desenvolvimento"** e incorpore as correções

> 📌 **Regra do time:** A User Story só avança para deploy após aprovação formal dos Critérios de Aceite. Aprovação por mensagem no work item ou e-mail é suficiente.

### Passo 8 — Deploy e conclusão

1. Solicite o deploy à Gerência na janela planejada
2. Após deploy, confirme que a funcionalidade está operacional em produção
3. Mude o estado para **"Concluído"**
4. Adicione comentário final com data do deploy e quem validou
5. Comunique ao Suporte (se a User Story veio de solicitação de cliente) para encerramento do chamado

---

## Critérios de Aceite — boas práticas

Um bom Critério de Aceite é **testável** e **objetivo**. Exemplos:

| ❌ Ruim (genérico) | ✅ Bom (testável) |
|---|---|
| "Funcionar corretamente" | "Ao salvar, o campo CPF deve ser gravado na tabela CLIENTES" |
| "Mostrar os dados certos" | "O relatório deve exibir CPF, Nome e Data de Cadastro, nesta ordem" |
| "Ser rápido" | "A consulta deve retornar em menos de 5 segundos para até 10.000 registros" |

---

## Observações e Alertas

> ⚠️ **Atenção:** Nunca inicie o desenvolvimento de uma User Story sem Critérios de Aceite definidos e sem a User Story estar alocada no sprint atual. Desenvolver por antecipação gera retrabalho e conflito de prioridades.

> ⚠️ **Atenção:** Se durante o desenvolvimento a estimativa for extrapolada significativamente, comunique à Gerência imediatamente — não espere o fim do sprint para reportar.

> 💡 **Dica:** Ao desenvolver uma nova funcionalidade em VB6, crie um formulário-modelo baseado em telas existentes do mesmo sistema. O código VB6 legado tem padrões que devem ser mantidos por consistência.

> 📌 **Regra do time:** User Stories com impacto no banco de dados (novos campos, índices, stored procedures) devem ser comunicadas à equipe de DBA ou ao responsável pelo banco com antecedência mínima de `<X dias>` antes do deploy.

# FAQ — Perguntas Frequentes do Suporte

## Objetivo

Registrar perguntas frequentes recebidas pelo Suporte e as respostas técnicas correspondentes, com base nas investigações já realizadas pelo time. Evita investigações repetidas para problemas recorrentes.

> 📌 **Regra do time:** Sempre que uma investigação revelar a causa de um problema recorrente, adicione uma entrada neste FAQ antes de fechar o ticket.

---

## Como usar este FAQ

1. Antes de iniciar qualquer investigação de ticket, busque aqui pelo **sistema** ou **palavras-chave do problema**
2. Se encontrar uma entrada correspondente, use como ponto de partida (não repita o trabalho já feito)
3. Se a investigação atual revelar algo novo sobre um problema já catalogado, **atualize a entrada existente**
4. Se for um problema completamente novo, **adicione uma entrada nova** ao final do documento

---

## Estrutura de uma entrada

```
### [SISTEMA] Título do problema

**Frequência:** Alta / Média / Baixa
**Última ocorrência:** AAAA-MM-DD — Work Item #número
**Achado completo:** [link para o arquivo em achados/]

**Sintoma relatado pelo cliente/suporte:**
[O que o cliente descreve]

**Causa identificada:**
[Causa técnica — em linguagem técnica para o dev]

**Solução aplicada:**
[O que foi feito para resolver]

**Resposta padrão ao Suporte:**
[Texto em linguagem simples para o Suporte repassar ao cliente]
```

---

## Entradas do FAQ

> 💡 **Dica:** Este documento está vazio porque o time está iniciando o processo de documentação. A primeira investigação concluída de cada sistema deve gerar a primeira entrada aqui.

---

### [TODOS OS SISTEMAS] Mensagem genérica de "Erro inesperado" sem detalhes

**Frequência:** Alta
**Última ocorrência:** —
**Achado completo:** —

**Sintoma relatado pelo cliente/suporte:**
"O sistema apresentou um erro inesperado" ou "apareceu uma tela de erro" sem mais detalhes.

**Causa identificada:**
Em sistemas VB6 com `On Error Resume Next`, erros podem ser silenciados e causar comportamentos incorretos sem mensagem clara. Quando uma mensagem aparece, geralmente é de um `MsgBox Err.Description` que capturou um erro não tratado.

**Como investigar:**
1. Solicite ao cliente/suporte: número exato da mensagem de erro (se houver), tela em que ocorreu, o que o usuário estava fazendo quando apareceu
2. Busque no código a mensagem exata com `Ctrl+Shift+F` no Notepad++ ou via Filesystem MCP
3. Verifique o evento associado à ação que o usuário realizava
4. Procure por `On Error Resume Next` antes do ponto de falha — o erro real pode estar sendo silenciado

**Resposta padrão ao Suporte:**
```
Para conseguirmos investigar o erro relatado, precisamos de mais informações:
1. Qual era o texto exato da mensagem de erro exibida?
2. Em qual tela/funcionalidade do sistema estava?
3. O que o usuário estava fazendo quando o erro apareceu?
4. O erro ocorre sempre ou apenas em alguns momentos?
```

---

### [TODOS OS SISTEMAS] Sistema "trava" ou fica lento em determinada operação

**Frequência:** Média
**Última ocorrência:** —
**Achado completo:** —

**Sintoma relatado pelo cliente/suporte:**
"O sistema travou na tela X" ou "demorou muito para carregar".

**Causa identificada (possibilidades comuns em VB6):**
- Query SQL sem índice sendo executada em tabela com muitos registros
- Loop `Do While ... Loop` percorrendo recordset inteiro sem filtro
- Abertura de conexão com banco não fechada em operação anterior (leak de conexão)
- Chamada a servidor externo (API, e-mail, impressora) sem timeout configurado

**Como investigar:**
1. Identifique a operação específica que causa lentidão
2. Localize no `.frm` o evento acionado por essa operação
3. Procure por queries SQL — verifique se há `WHERE` com campos indexados
4. Verifique se há `Loop` ou `For Each` sem limite sobre recordsets
5. Verifique se conexões ADO/DAO são fechadas após uso (`adoCon.Close` / `Set adoCon = Nothing`)

**Resposta padrão ao Suporte:**
```
Identificamos que a operação em <sistema> pode ser lenta dependendo do volume de dados.
Estamos investigando a causa e retornaremos com uma solução ou orientação em breve.
Enquanto isso, oriente o cliente a aguardar a conclusão da operação sem fechar o sistema.
```

---

## Adicionar nova entrada

Para adicionar uma nova entrada, copie o template abaixo e preencha:

```markdown
### [SISTEMA] Título do problema

**Frequência:** Alta / Média / Baixa
**Última ocorrência:** AAAA-MM-DD — Work Item #número
**Achado completo:** [achados/AAAAMMDD-sistema-descricao.md]

**Sintoma relatado pelo cliente/suporte:**
[O que o cliente descreve — copie do relato original]

**Causa identificada:**
[Causa técnica]

**Como investigar:**
1. [Passo 1]
2. [Passo 2]

**Solução aplicada:**
[O que foi feito]

**Resposta padrão ao Suporte:**
[Texto em linguagem simples]
```

---

## Histórico de atualizações

| Data | Sistema | Entrada adicionada/atualizada | Por quem |
|---|---|---|---|
| — | — | Documento criado | `<nome>` |

# Investigação de Código VB6 Legado

## Objetivo

Orientar o desenvolvedor a investigar o código-fonte de sistemas VB6 legados sem documentação formal — desde o recebimento do ticket até o registro do achado na base de conhecimento.

## Pré-requisitos

- Tortoise SVN instalado e checkout do sistema realizado
- Acesso ao Visual Basic 6 IDE (para execução e debug) — se disponível
- Work item aberto no Azure DevOps com o relato do problema
- Leitura do guia: [Controle de Versão com Tortoise SVN](../guias/controle-versao-svn.md)

---

## Mentalidade de investigação

> 💡 **Dica:** Investigar código legado sem documentação é trabalho de detetive. Você começa com uma pista (o relato do problema) e vai rastreando o fluxo até encontrar a causa. Documente cada passo — mesmo becos sem saída são informações valiosas.

Princípios a seguir:

1. **Siga o fluxo da tela** — identifique qual tela (`.frm`) o usuário usa para a ação que falha
2. **Rastreie eventos e chamadas** — a lógica VB6 começa em eventos de botões, menus e carregamento de formulários
3. **Leia antes de alterar** — entenda o código antes de qualquer mudança
4. **Registre tudo** — achados parciais são valiosos para a próxima investigação

---

## Estrutura de um projeto VB6

Ao abrir um checkout SVN do sistema, você encontrará arquivos com estas extensões:

| Extensão | Tipo | O que contém |
|---|---|---|
| `.vbp` | Arquivo de projeto | Lista todos os arquivos do projeto; abra pelo VB6 IDE |
| `.frm` | Formulário (tela) | Interface visual + código dos eventos da tela |
| `.bas` | Módulo padrão | Funções e sub-rotinas globais reutilizáveis |
| `.cls` | Classe | Objetos com propriedades e métodos |
| `.frx` | Binário do formulário | Recursos binários das telas (ícones, imagens) — não edite |
| `.res` | Arquivo de recursos | Strings e recursos do projeto — raramente editado |

> 💡 **Dica:** Comece sempre pelo arquivo `.vbp` para ter uma visão geral de quais módulos e telas fazem parte do sistema.

---

## Passo a passo de investigação

### Passo 1 — Atualizar o código do SVN

```
1. Navegue até: C:\SVN\<nome-do-sistema>\
2. Botão direito na pasta → SVN Update
3. Aguarde completar
```

### Passo 2 — Identificar a tela envolvida

Com base no relato do ticket:

1. Identifique a **funcionalidade afetada** (ex: "tela de emissão de nota fiscal")
2. Procure o arquivo `.frm` correspondente pelo nome:
   - Nome da janela VB6 costuma estar no próprio arquivo (procure `Caption = "..."`)
   - Nomes comuns: `frmNota.frm`, `frmVenda.frm`, `frmRelatorio.frm`
3. Use o **Windows Explorer** para buscar por palavras-chave no nome dos arquivos

**Busca rápida no Windows Explorer:**
- Abra a pasta do sistema
- Na barra de busca (canto superior direito), digite palavras-chave relacionadas à tela

### Passo 3 — Identificar o ponto de entrada no código

Nos sistemas VB6, a lógica começa a partir de **eventos**. Os eventos mais comuns são:

| Evento | Quando dispara |
|---|---|
| `Form_Load` | Quando a tela é aberta |
| `cmdSalvar_Click` | Quando o botão "Salvar" é clicado |
| `cmdConfirmar_Click` | Quando o botão "Confirmar" é clicado |
| `txtCodigo_Change` | Quando o valor de um campo de texto muda |
| `txtCodigo_LostFocus` | Quando sai de um campo de texto |
| `cmbLista_Click` | Quando seleciona um item numa lista |

**Como encontrar:**
1. Abra o arquivo `.frm` num editor de texto
2. Procure pelo nome do botão ou campo que o usuário interage para causar o problema
3. Ou use `Ctrl+F` para buscar palavras-chave como `Sub cmd`, `Sub Form_`, `Function`

### Passo 4 — Rastrear o fluxo de chamadas

Em VB6, funções podem chamar outras funções em outros módulos. Rastreie:

1. Identifique chamadas de função dentro do evento inicial
   - Exemplo: `Call CalculaTotal()` ou `resultado = CalculaDesconto(valor, perc)`
2. Encontre onde `CalculaTotal` ou `CalculaDesconto` está definida:
   - Pode estar no próprio `.frm`
   - Pode estar em um `.bas` (módulo)
   - Pode estar em um `.cls` (classe)
3. Continue o rastreamento até encontrar o ponto do problema

**Como buscar uma função em todo o projeto:**
1. Abra o Windows Explorer na pasta do sistema
2. Use o recurso de busca de texto dentro dos arquivos:
   ```
   Botão direito na pasta → Pesquisar → pesquise pelo nome da função
   ```
   Ou use um editor como **Notepad++** com busca em arquivos (`Ctrl+Shift+F`)

> 💡 **Dica:** Se estiver usando o Copilot Chat com Filesystem MCP, pergunte:
> "Leia o arquivo `frmVenda.frm` e me explique o que a função `cmdConfirmar_Click` faz"

### Passo 5 — Identificar chamadas ao banco de dados

Grande parte dos problemas em sistemas VB6 envolve interação com o banco de dados. Procure por:

| Padrão | O que é |
|---|---|
| `"SELECT ... FROM ...` | Consulta ao banco |
| `"INSERT INTO ...` | Inserção de dados |
| `"UPDATE ... SET ...` | Atualização de dados |
| `"DELETE FROM ...` | Exclusão de dados |
| `adoRS.Open` | Abertura de recordset (consulta com ADO) |
| `Execute` | Execução de comando SQL |
| `DoCmd.RunSQL` | Execução de SQL (em projetos com Access) |

Ao encontrar uma query SQL:
1. Copie a query para um editor
2. Identifique as tabelas e campos envolvidos
3. Verifique se os campos e condições fazem sentido com o problema relatado

### Passo 6 — Verificar variáveis e condições

Muitos bugs em VB6 ocorrem por:

| Tipo de problema | O que procurar |
|---|---|
| Variável não inicializada | Variável usada antes de receber valor |
| Divisão por zero | `resultado = valor / divisor` sem verificar se `divisor = 0` |
| String vazia não tratada | Comparação ou conversão sem verificar `If campo = "" Then` |
| Tipo de dado incorreto | `CInt()`, `CDbl()`, `CLng()` usados sem tratamento de erro |
| Data inválida | `CDate()` sem verificação |
| Tratamento de erro ignorado | `On Error Resume Next` silencia erros — **muito comum em VB6!** |

> ⚠️ **Atenção:** O uso de `On Error Resume Next` é extremamente comum nos sistemas legados. Ele faz o código **ignorar erros silenciosamente** — o que significa que o bug pode estar acontecendo há muito tempo sem deixar rastro visível.

---

## Técnicas de investigação sem ambiente de debug

Se o VB6 IDE não estiver disponível para execução e debug:

### Técnica 1 — Leitura do fluxo completo

Leia o código sequencialmente seguindo o caminho que o usuário percorre para reproduzir o problema. Anote cada função chamada e cada ponto de decisão (`If`, `Select Case`).

### Técnica 2 — Busca por palavras-chave

Use Notepad++ ou o Copilot Chat (com Filesystem MCP) para buscar:
- Nome do campo ou tabela mencionada no relato
- Mensagens de erro que o usuário viu: `MsgBox "Erro ao..."`, `"Valor inválido"`
- Nomes de relatórios, botões ou menus mencionados pelo cliente

### Técnica 3 — Comparação com versão anterior

Se houver uma versão anterior funcionando no `tags/`:
1. Faça checkout da tag anterior em uma pasta separada
2. Compare os arquivos alterados usando o Tortoise SVN Diff
3. A mudança responsável pelo problema provavelmente está nas diferenças

### Técnica 4 — Análise do histórico SVN

1. Clique com o botão direito no arquivo suspeito → **"TortoiseSVN"** → **"Show Log"**
2. Verifique commits recentes
3. Se o problema começou em uma data específica, procure commits próximos a essa data
4. Leia a mensagem do commit para entender o que foi alterado

---

## Documentando a investigação

A cada passo relevante da investigação, adicione um comentário no work item do Azure DevOps:

```
Investigação — [DD/MM HH:MM]
Arquivo: [nome-do-arquivo.frm]
Função/Sub: [NomeDaFuncao]
Achado: [O que foi encontrado]
Próximo passo: [O que vai verificar]
```

Ao concluir (mesmo sem solucionar):

1. Crie o arquivo de achado: `base-conhecimento/achados/AAAAMMDD-<sistema>-<descricao>.md`
2. Use como base o template: `base-conhecimento/achados/TEMPLATE-achado.md`

> 📌 **Regra do time:** Toda investigação deve gerar um arquivo de achado, independentemente do resultado. "Investigado e não encontrado" também é um achado válido.

---

## Quando acionar o Dev Sênior

Acione o Dev Sênior imediatamente se:

- O problema envolver **perda de dados** ou **valores financeiros incorretos**
- Não for possível identificar o fluxo da funcionalidade após 2 horas de investigação
- O código contiver lógica de integração com sistemas externos desconhecidos
- Houver risco de que uma alteração impacte outras funcionalidades do sistema

---

## Observações e Alertas

> ⚠️ **Atenção:** Nunca altere o código-fonte sem antes entender completamente o que ele faz. Uma mudança aparentemente simples em VB6 pode impactar funcionalidades em cascata.

> ⚠️ **Atenção:** Nunca faça commit de alterações sem aval do Dev Sênior quando o impacto da mudança for incerto.

> 💡 **Dica:** O Notepad++ é uma ferramenta excelente para navegar em código VB6. Use **"Find in Files"** (`Ctrl+Shift+F`) para buscar em todos os arquivos do sistema de uma vez.

> 💡 **Dica:** Quando tiver dúvida sobre o comportamento de uma função nativa do VB6 (como `Format()`, `DateDiff()`, `InStr()`), use o Fetch MCP para buscar a documentação em `learn.microsoft.com`.

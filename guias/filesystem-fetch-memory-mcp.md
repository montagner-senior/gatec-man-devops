# Guia de Implantação e Uso — Filesystem, Fetch e Memory MCPs

## Objetivo

Este guia ensina como instalar e configurar os três MCPs complementares ao Azure DevOps MCP:

| MCP | Pacote | O que resolve para o time |
|---|---|---|
| **Filesystem** | `@modelcontextprotocol/server-filesystem` | O agente lê e escreve arquivos locais — incluindo o código VB6 do checkout SVN e os achados desta base de conhecimento |
| **Fetch** | `mcp-server-fetch` | O agente busca documentação de APIs, bibliotecas VB6 e referências técnicas na web durante a investigação |
| **Memory** | `@modelcontextprotocol/server-memory` | O agente mantém um grafo de conhecimento persistente entre sessões — lembra de sistemas investigados, padrões de defeitos e achados anteriores |

> 📌 **Regra do time:** Estes três MCPs devem ser instalados **após** o Azure DevOps MCP. Juntos, formam o conjunto completo de ferramentas para o fluxo de atendimento de tickets transbordados do Suporte.

---

## Pré-requisitos gerais

| Requisito | Versão mínima | Como verificar |
|---|---|---|
| VS Code | 1.99+ | `code --version` no PowerShell |
| Node.js | 20+ | `node --version` no PowerShell |
| Python + uv | Python 3.10+ com uv | *(somente para o Fetch MCP)* |

> 💡 **Dica:** Se você já configurou o Azure DevOps MCP conforme o guia anterior, o VS Code e o Node.js já estão instalados. Só será necessário instalar o `uv` (para o Fetch MCP).

---

## Parte 1 — Filesystem MCP

### O que faz

O Filesystem MCP dá ao agente de IA acesso controlado a pastas específicas do seu computador. Ele pode:

- Ler arquivos de texto (incluindo `.frm`, `.bas`, `.cls`, `.vbp` do VB6)
- Criar e editar arquivos Markdown neste workspace de documentação
- Listar estruturas de diretório
- Buscar arquivos por padrão de nome
- Mover e renomear arquivos

> ⚠️ **Atenção:** O agente só acessa as pastas que você explicitamente liberar na configuração. Nenhuma outra pasta do computador é acessível.

### Instalação — Filesystem MCP

No arquivo `.vscode/mcp.json` deste workspace, adicione o bloco `filesystem` dentro de `servers`:

```json
{
  "servers": {
    "filesystem-docs": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\<seu-usuario>\\Documents\\Fontes\\luis.montagner\\.devops"
      ]
    },
    "filesystem-legado": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\caminho\\para\\checkout\\svn\\legado"
      ]
    }
  }
}
```

> ⚠️ **Atenção:** Substitua os caminhos pelos caminhos reais do seu computador:
> - `filesystem-docs` → pasta deste workspace de documentação
> - `filesystem-legado` → pasta onde você faz o checkout do SVN dos sistemas VB6

> 💡 **Dica:** Você pode configurar múltiplas instâncias do Filesystem MCP, uma para cada propósito. Isso separa claramente o acesso à documentação do acesso ao código-fonte.

### Ferramentas disponíveis

| Ferramenta | O que faz | Leitura/Escrita |
|---|---|---|
| `read_text_file` | Lê o conteúdo completo de um arquivo como texto | Leitura |
| `read_multiple_files` | Lê vários arquivos ao mesmo tempo | Leitura |
| `list_directory` | Lista arquivos e pastas de um diretório | Leitura |
| `directory_tree` | Mostra a árvore completa de um diretório em JSON | Leitura |
| `search_files` | Busca arquivos por padrão de nome recursivamente | Leitura |
| `get_file_info` | Retorna metadados: tamanho, data de modificação, permissões | Leitura |
| `list_allowed_directories` | Lista quais pastas o agente pode acessar | Leitura |
| `write_file` | Cria ou sobrescreve um arquivo | **Escrita** |
| `edit_file` | Edita trechos específicos de um arquivo | **Escrita** |
| `create_directory` | Cria uma pasta (e subpastas se necessário) | **Escrita** |
| `move_file` | Move ou renomeia um arquivo | **Escrita** |

> ⚠️ **Atenção:** As ferramentas de **escrita** modificam arquivos reais. Ao pedir ao agente para editar um arquivo de código VB6, revise a alteração antes de confirmar.

### Como usar — Filesystem MCP no dia a dia

#### Investigação de código VB6

```
Liste todos os arquivos .frm e .bas na pasta C:\checkout\svn\sistema-x
```

```
Leia o arquivo C:\checkout\svn\sistema-x\modulo\frmPrincipal.frm e me explique o que a função "CalcularTotal" faz
```

```
Busque arquivos que contenham "NomeDaFuncao" na pasta C:\checkout\svn\sistema-x
```

```
Mostre a estrutura de pastas do sistema-x para eu entender como ele está organizado
```

#### Registrando achados na base de conhecimento

```
Crie o arquivo base-conhecimento/achados/2026-03-09-ticket-1234-erro-calculo.md com o seguinte conteúdo: [descreva o achado]
```

```
Edite o arquivo base-conhecimento/faq-suporte.md adicionando a seguinte pergunta e resposta: [descreva]
```

#### Consultando documentação existente

```
Leia o arquivo processos/hotfix.md e me explique o fluxo de hotfix do time
```

```
Liste todos os arquivos da pasta base-conhecimento/achados para eu ver os casos já investigados
```

---

## Parte 2 — Fetch MCP

### O que faz

O Fetch MCP permite que o agente acesse páginas da internet e converta o conteúdo em texto legível (Markdown). É especialmente útil durante investigações de código VB6 quando o dev precisa consultar:

- Documentação de funções e bibliotecas antigas do VB6
- Referências de APIs externas utilizadas pelos sistemas legados
- Artigos técnicos para entender comportamentos específicos
- Documentação do próprio Azure DevOps

> ⚠️ **Atenção de segurança:** O Fetch MCP pode acessar endereços internos da rede (IPs locais). Use-o apenas para buscar documentação pública. Nunca peça ao agente para acessar sistemas internos via Fetch.

### Pré-requisito — Instalar o `uv`

O Fetch MCP é escrito em Python e usa o gerenciador `uv`. Instale-o no PowerShell:

```powershell
pip install uv
```

Ou, se não tiver o pip configurado:

```powershell
winget install astral-sh.uv
```

Verifique a instalação:

```powershell
uvx --version
```

### Instalação — Fetch MCP

Adicione o bloco `fetch` no arquivo `.vscode/mcp.json`:

```json
{
  "servers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"],
      "env": {
        "PYTHONIOENCODING": "utf-8"
      }
    }
  }
}
```

> 💡 **Dica:** O `PYTHONIOENCODING: utf-8` é obrigatório no Windows para evitar erros de timeout com caracteres especiais (acentos, por exemplo).

> ⚠️ **Atenção:** Na primeira execução, o `uvx` irá baixar o pacote automaticamente. Aguarde sem fechar o terminal.

### Ferramentas disponíveis

| Ferramenta | O que faz |
|---|---|
| `fetch` | Busca uma URL e retorna o conteúdo convertido para Markdown (padrão: primeiros 5.000 caracteres) |

Parâmetros úteis da ferramenta `fetch`:

| Parâmetro | Descrição | Padrão |
|---|---|---|
| `url` | URL a buscar | *obrigatório* |
| `max_length` | Máximo de caracteres a retornar | 5000 |
| `start_index` | Índice inicial do conteúdo (para paginar conteúdos longos) | 0 |
| `raw` | Retorna HTML puro sem converter para Markdown | false |

### Como usar — Fetch MCP no dia a dia

#### Pesquisa de documentação VB6

```
Busque a documentação da função "CreateObject" no VB6 em https://learn.microsoft.com/pt-br/office/vba/language/reference/user-interface-help/createobject-function
```

```
Acesse https://docs.microsoft.com e me explique como funciona o controle ADO do VB6 para conexão com banco de dados
```

#### Pesquisa de erros conhecidos

```
Busque informações sobre o erro "Run-time error 429" no VB6 em https://support.microsoft.com
```

#### Lendo documentação do Azure DevOps durante o trabalho

```
Busque a documentação da API REST de Work Items do Azure DevOps em https://learn.microsoft.com/pt-br/rest/api/azure/devops/wit
```

#### Lendo páginas longas em pedaços

Se o conteúdo for longo, o agente pode paginar:

```
Busque a página X e retorne apenas os primeiros 5000 caracteres
```
```
Busque a página X começando do caractere 5000
```

---

## Parte 3 — Memory MCP

### O que faz

O Memory MCP mantém um **grafo de conhecimento persistente** que sobrevive entre sessões do VS Code. O agente pode salvar, consultar e relacionar informações sobre:

- Sistemas VB6 investigados (módulos, funções, comportamentos encontrados)
- Padrões de defeitos recorrentes
- Conexões entre sistemas e funcionalidades
- Histórico de investigações por ticket

Diferente dos arquivos Markdown da `base-conhecimento/`, o Memory MCP é um grafo estruturado que o agente consulta automaticamente e de forma mais eficiente durante uma conversa.

> 💡 **Dica:** Pense no Memory MCP como a **memória de longo prazo do agente**. Os arquivos Markdown são a documentação formal para humanos; o grafo de memória é para o agente navegar rapidamente durante o trabalho.

### Conceitos do grafo de memória

O Memory MCP usa três estruturas:

**Entidade** — qualquer coisa que vale ser lembrada:
```
Nome: "Sistema-Folha-Pagamento"
Tipo: "sistema-vb6"
Observações: ["Usa banco Firebird", "Módulo cálculo em modCalculo.bas", "Ticket #1234 relacionado a arredondamento"]
```

**Relação** — como as entidades se conectam:
```
"Sistema-Folha-Pagamento" → usa_banco → "Firebird-Producao"
"Ticket-1234" → pertence_a → "Sistema-Folha-Pagamento"
"Erro-Arredondamento" → encontrado_em → "modCalculo.bas"
```

**Observação** — um fato sobre uma entidade:
```
"modCalculo.bas usa a função Round nativa do VB6 que tem comportamento diferente do arredondamento matemático padrão"
```

### Instalação — Memory MCP

Adicione o bloco `memory` no arquivo `.vscode/mcp.json`:

```json
{
  "servers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_FILE_PATH": "C:\\Users\\<seu-usuario>\\Documents\\Fontes\\luis.montagner\\.devops\\base-conhecimento\\.memory.jsonl"
      }
    }
  }
}
```

> 💡 **Dica:** Ao configurar o `MEMORY_FILE_PATH` apontando para dentro da pasta `base-conhecimento/` deste workspace, o arquivo do grafo fica junto com o resto da documentação do time. Isso permite fazer backup do conhecimento acumulado junto com o repositório.

> ⚠️ **Atenção:** O arquivo `.memory.jsonl` não deve ser commitado no SVN — ele é grande e muda constantemente. Adicione-o ao `svn:ignore`.

### Ferramentas disponíveis

| Ferramenta | O que faz |
|---|---|
| `create_entities` | Cria novas entidades no grafo (sistemas, módulos, erros, tickets) |
| `create_relations` | Cria relações entre entidades existentes |
| `add_observations` | Adiciona fatos a uma entidade já existente |
| `search_nodes` | Busca entidades por nome, tipo ou conteúdo de observações |
| `open_nodes` | Retorna entidades específicas e suas relações |
| `read_graph` | Lê o grafo completo de conhecimento |
| `delete_entities` | Remove entidades (e suas relações) |
| `delete_observations` | Remove observações específicas de uma entidade |
| `delete_relations` | Remove relações entre entidades |

### Como usar — Memory MCP no dia a dia

#### Registrando conhecimento sobre um sistema após investigação

```
Crie uma entidade no grafo de memória:
- Nome: "Sistema-Contratos"
- Tipo: "sistema-vb6"
- Observações: ["Módulo principal em frmContratos.frm", "Banco de dados SQL Server 2008", "Geração de relatórios em Crystal Reports 8"]
```

```
Adicione a observação "Ticket #1456 revelou que a função GerarNumeroContrato pode duplicar numeração quando dois usuários gravam simultaneamente" à entidade "Sistema-Contratos"
```

#### Relacionando tickets com sistemas

```
Crie as seguintes relações no grafo de memória:
- "Ticket-1456" pertence_a "Sistema-Contratos"
- "Erro-Duplicacao-Numero" encontrado_em "frmContratos.frm"
- "Fix-#890" corrige "Erro-Duplicacao-Numero"
```

#### Consultando conhecimento acumulado antes de iniciar uma investigação

```
Antes de começar, consulte o grafo de memória: já investigamos alguma coisa sobre o "Sistema-Contratos"?
```

```
Busque na memória todos os tickets relacionados ao "Sistema-Folha-Pagamento"
```

```
Existe algum padrão de erro já registrado para funções de cálculo nos sistemas VB6?
```

#### Instrução para o agente usar a memória automaticamente

Adicione no arquivo [.github/copilot-instructions.md](../.github/copilot-instructions.md) a seguinte instrução para que o agente use a memória automaticamente:

```markdown
Antes de iniciar qualquer investigação de ticket ou código VB6, consulte o grafo de memória (Memory MCP) para verificar se já existe conhecimento registrado sobre o sistema ou problema em questão. Ao concluir uma investigação, registre os achados no grafo de memória antes de encerrar a sessão.
```

---

## Configuração completa — arquivo `.vscode/mcp.json`

Abaixo, a configuração unificada com todos os MCPs do time (incluindo o Azure DevOps MCP do guia anterior):

```json
{
  "inputs": [
    {
      "id": "ado_org",
      "type": "promptString",
      "description": "Nome da organização Azure DevOps (ex: 'minha-empresa')"
    }
  ],
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@azure-devops/mcp",
        "${input:ado_org}",
        "-d", "core", "work", "work-items", "search", "pipelines"
      ]
    },
    "filesystem-docs": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\Users\\<seu-usuario>\\Documents\\Fontes\\luis.montagner\\.devops"
      ]
    },
    "filesystem-legado": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "C:\\caminho\\para\\checkout\\svn\\legado"
      ]
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"],
      "env": {
        "PYTHONIOENCODING": "utf-8"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "env": {
        "MEMORY_FILE_PATH": "C:\\Users\\<seu-usuario>\\Documents\\Fontes\\luis.montagner\\.devops\\base-conhecimento\\.memory.jsonl"
      }
    }
  }
}
```

> 💡 **Dica:** Substitua todos os `<seu-usuario>` e `C:\\caminho\\para\\checkout\\svn\\legado` pelos caminhos reais do seu computador. Cada dev do time deve fazer isso individualmente — os caminhos podem ser diferentes entre máquinas.

---

## Fluxo completo de atendimento com todos os MCPs ativos

Com todos os MCPs configurados, o fluxo de um ticket transbordado do Suporte pode ser feito quase inteiramente pelo Copilot Chat em Agent Mode:

```
1. RECEBER O TICKET
   [Azure DevOps MCP] "Mostre o work item #1456 do projeto <nome-do-projeto>"
   → Agente busca e exibe todos os detalhes do ticket recebido do Zendesk

2. CONSULTAR MEMÓRIA ANTERIOR
   [Memory MCP] "Já investigamos alguma coisa sobre este sistema antes?"
   → Agente verifica o grafo de conhecimento e exibe achados anteriores

3. INVESTIGAR O CÓDIGO VB6
   [Filesystem MCP] "Liste os arquivos .frm e .bas da pasta checkout/sistema-x"
   [Filesystem MCP] "Leia o arquivo frmContratos.frm e identifique a função responsável por X"
   [Fetch MCP] "Busque documentação sobre a função Round do VB6 em learn.microsoft.com"

4. REGISTRAR O ACHADO
   [Memory MCP] "Adicione ao grafo: sistema-x, função Y causa problema Z quando condição W"
   [Filesystem MCP] "Crie o arquivo base-conhecimento/achados/2026-03-09-ticket-1456.md com [conteúdo]"

5. ATUALIZAR O WORK ITEM
   [Azure DevOps MCP] "Adicione o comentário no work item #1456: '[achado técnico detalhado]'"

6. DECISÃO E ENCERRAMENTO
   [Azure DevOps MCP] "Crie um Fix para o projeto <nome-do-projeto> com título 'Correção da função Y'"
   ou
   [Azure DevOps MCP] "Mude o status do work item #1456 para Concluído"
```

---

## Solução de problemas comuns

| Problema | Causa provável | Solução |
|---|---|---|
| `uvx: command not found` | `uv` não instalado | Execute `pip install uv` ou `winget install astral-sh.uv` no PowerShell |
| Fetch MCP trava ou timeout no Windows | Encoding incorreto | Confirme que `PYTHONIOENCODING: utf-8` está no `env` da configuração |
| Filesystem MCP não encontra a pasta | Caminho com barras erradas | No Windows, use barras duplas `\\` no JSON ou barras normais `/` |
| Memory MCP não salva entre sessões | `MEMORY_FILE_PATH` não configurado | Verifique se o caminho do arquivo `.memory.jsonl` está correto e acessível |
| "No such file or directory" no Filesystem | Pasta de destino não existe | Crie a pasta manualmente antes de apontar no `mcp.json` |
| Agente não usa a memória automaticamente | Instrução ausente no `copilot-instructions.md` | Adicione a instrução de uso automático da memória conforme descrito na Parte 3 |

---

## Referências

- [Repositório oficial — Filesystem MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem)
- [Repositório oficial — Fetch MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch)
- [Repositório oficial — Memory MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/memory)
- [Documentação MCP oficial](https://modelcontextprotocol.io)
- [Configurando MCPs no VS Code](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)
- [Guia Azure DevOps MCP do time](./azure-devops-mcp.md)

# MCPs Sugeridos — Turbinando o Workspace com IA

> **O que é um MCP?**
> MCP (Model Context Protocol) é um protocolo que permite conectar agentes de IA (como o GitHub Copilot) diretamente a ferramentas, sistemas e fontes de dados externas. Com MCPs configurados, o agente deixa de apenas sugerir ações e passa a **executá-las** — criando work items, lendo repositórios, acessando APIs, buscando documentação e muito mais, diretamente pela conversa.

> 💡 **Como instalar MCPs no VS Code:**
> Acesse `Arquivo → Preferências → Configurações` e busque por `mcp`. Ou edite diretamente o arquivo `.vscode/mcp.json` no seu workspace com as configurações de cada servidor listado abaixo.

---

## Prioridade Alta — Impacto direto nos processos do time

### 1. Azure DevOps MCP
**O mais importante para este workspace.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Lê e cria Work Items, consulta boards, acessa pipelines, repos e sprints direto pelo agente |
| **Ganho real** | O agente cria um Fix ou Hotfix no DevOps enquanto você descreve o problema — sem abrir o browser |
| **Casos de uso** | Criar User Story / Fix / Hotfix; consultar backlog; listar work items da sprint; verificar status de pipelines |
| **Repositório** | `microsoft/azure-devops-mcp` |
| **Instalação** | `npx @azure/mcp` ou via configuração no `.vscode/mcp.json` |

```json
// Exemplo de configuração em .vscode/mcp.json
{
  "servers": {
    "azure-devops": {
      "command": "npx",
      "args": ["-y", "@azure/mcp@latest", "server", "start"],
      "env": {
        "AZURE_DEVOPS_ORG_URL": "https://dev.azure.com/<sua-organizacao>",
        "AZURE_DEVOPS_TOKEN": "<seu-pat-token>"
      }
    }
  }
}
```

> ⚠️ **Atenção:** O `AZURE_DEVOPS_TOKEN` é um PAT (Personal Access Token). Nunca commite esse valor no repositório. Use variáveis de ambiente ou o cofre de segredos do seu sistema operacional.

---

### 2. GitHub MCP (Oficial)
**Útil somente se o time vier a migrar algum repositório para Git/GitHub no futuro.**

> 📌 **Observação importante:** O código-fonte dos sistemas legados está no **Tortoise SVN**, não no GitHub. Este MCP só se aplica caso o time mantenha repositórios Git paralelamente (ex: scripts internos, este próprio workspace de documentação).

| Atributo | Detalhe |
|---|---|
| **O que faz** | Lê repositórios, cria issues, abre PRs, navega em código-fonte, busca arquivos |
| **Ganho real** | O agente navega neste workspace de documentação diretamente pelo Copilot |
| **Casos de uso** | Gestão deste próprio repositório de documentação; scripts e ferramentas internas em Git |
| **Repositório** | `github/github-mcp-server` (oficial) |
| **Instalação** | Via Docker ou npx |

```json
{
  "servers": {
    "github": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<seu-github-token>"
      }
    }
  }
}
```

---

### 3. Filesystem MCP
**Dá ao agente acesso de leitura e escrita aos arquivos deste workspace.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Lê, cria, edita e organiza arquivos locais |
| **Ganho real** | O agente mantém a base de conhecimento atualizada, cria achados, edita o README — tudo automaticamente |
| **Casos de uso** | Criar arquivos em `base-conhecimento/achados/`; atualizar README; organizar documentação |
| **Repositório** | `modelcontextprotocol/servers` (pacote oficial) |
| **Instalação** | `npx @modelcontextprotocol/server-filesystem` |

```json
{
  "servers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\<usuario>\\Documents\\Fontes\\luis.montagner\\.devops"]
    }
  }
}
```

---

### 4. SVN / Tortoise SVN — Acesso via Filesystem MCP
**O código-fonte legado é versionado no Tortoise SVN — não existe MCP nativo para SVN, mas o Filesystem MCP cobre o acesso aos arquivos locais após o checkout.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Lê os arquivos `.vbp`, `.bas`, `.cls`, `.frm` do VB6 após checkout local do SVN |
| **Ganho real** | O agente lê e analisa o código-fonte VB6 diretamente durante investigações de tickets do Suporte |
| **Casos de uso** | Investigar módulos VB6; rastrear funções; entender fluxos sem documentação |
| **Pré-requisito** | Fazer o checkout do repositório SVN localmente antes de usar o agente |
| **Repositório** | `modelcontextprotocol/servers` (Filesystem MCP) |

> 💡 **Dica:** Configure o Filesystem MCP apontando para a pasta de checkout local do SVN. O agente consegue ler arquivos `.frm`, `.bas`, `.cls` e `.vbp` do VB6 como texto puro e ajudar na análise.

```json
{
  "servers": {
    "svn-legado": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:\\caminho\\para\\checkout\\svn\\local"]
    }
  }
}
```

---

## Prioridade Média — Aceleram investigação e documentação

### 5. Zendesk MCP
**Integração direta com o sistema de tickets do Suporte.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Lê tickets do Zendesk, consulta histórico de chamados, busca informações do solicitante |
| **Ganho real** | O agente acessa o ticket original no Zendesk enquanto o dev investiga — sem alternar entre sistemas |
| **Casos de uso** | Ler a descrição completa do chamado; verificar interações anteriores do Suporte com o cliente; correlacionar tickets recorrentes |
| **Repositório** | `zendesk/mcp-server-zendesk` ou integrações via API Zendesk |
| **Instalação** | Varia conforme a versão do Zendesk contratada — verificar com o time de Suporte |

> ⚠️ **Atenção:** Configure apenas com permissões de leitura para o time de manutenção. A escrita nos tickets do Zendesk deve permanecer com o time de Suporte.

---

### 6. Fetch MCP (Busca na Web)
**Permite ao agente buscar documentação técnica na internet durante a investigação.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Faz requisições HTTP e lê páginas web para o agente |
| **Ganho real** | O agente busca documentação de bibliotecas VB6, APIs antigas e referências técnicas sem sair do Copilot |
| **Casos de uso** | Pesquisar funções e métodos do VB6; buscar erros específicos; consultar documentação de tecnologias legacy |
| **Repositório** | `modelcontextprotocol/servers` |
| **Instalação** | `npx @modelcontextprotocol/server-fetch` |

```json
{
  "servers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

---

### 7. Memory MCP (Base de Conhecimento Persistente)
**Dá memória de longo prazo ao agente — ele se lembra de achados anteriores entre sessões.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Mantém um grafo de conhecimento persistente que o agente consulta e atualiza automaticamente |
| **Ganho real** | O agente lembra de sistemas investigados, padrões encontrados e decisões tomadas em sessões anteriores |
| **Casos de uso** | Acumular conhecimento sobre sistemas legados; correlacionar tickets recorrentes; registrar padrões de defeitos |
| **Repositório** | `modelcontextprotocol/servers` |
| **Instalação** | `npx @modelcontextprotocol/server-memory` |

```json
{
  "servers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

---

### 8. Sequential Thinking MCP
**Melhora dramaticamente a qualidade de raciocínio do agente em problemas complexos.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Força o agente a pensar em etapas sequenciais antes de responder |
| **Ganho real** | Ao investigar um bug complexo num sistema sem documentação, o agente estrutura melhor a análise |
| **Casos de uso** | Investigação de incidentes complexos; análise de impacto antes de um Fix; planejamento de Hotfix |
| **Repositório** | `modelcontextprotocol/servers` |
| **Instalação** | `npx @modelcontextprotocol/server-sequential-thinking` |

```json
{
  "servers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

---

### 9. Browser Automation MCP (Playwright)
**Permite ao agente navegar na interface web do Azure DevOps quando a API não é suficiente.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Controla um navegador real para interagir com interfaces web |
| **Ganho real** | Quando uma ação no Azure DevOps não tem API disponível, o agente navega pela tela e executa mesmo assim |
| **Casos de uso** | Capturar telas do DevOps para documentação; preencher formulários complexos; extrair dados de relatórios |
| **Repositório** | `microsoft/playwright-mcp` (oficial Microsoft) |
| **Instalação** | `npx @playwright/mcp@latest` |

```json
{
  "servers": {
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    }
  }
}
```

---

## Prioridade Baixa — Úteis em cenários específicos

### 10. Database MCP (SQLite / SQL Server)
**Para quando a investigação de um sistema legado envolve consultas diretas ao banco de dados.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Conecta o agente a bancos de dados relacionais para executar queries |
| **Ganho real** | O agente ajuda a investigar dados de produção durante análise de incidentes (com cuidado!) |
| **Casos de uso** | Buscar registros para entender um comportamento; validar dados durante investigação de Fix |
| **Repositório** | `modelcontextprotocol/servers` (SQLite) ou `davewind/mcp-sqlserver` (SQL Server) |

> ⚠️ **Atenção:** Nunca conecte este MCP diretamente ao banco de produção sem autorização explícita da gerência. Use ambientes de homologação.

---

### 11. Slack / Teams MCP
**Para integrar comunicação ao fluxo de trabalho do agente.**

| Atributo | Detalhe |
|---|---|
| **O que faz** | Envia mensagens, lê canais e cria notificações via Slack ou Microsoft Teams |
| **Ganho real** | O agente notifica automaticamente o time ao abrir um Hotfix ou ao responder um ticket transbordado |
| **Casos de uso** | Notificar criação de Hotfix; alertar sobre falha de pipeline; comunicar resposta ao Suporte |
| **Repositório** | `modelcontextprotocol/servers` (Slack) / oficial Microsoft para Teams |

---

## Configuração Recomendada para Início

Para começar com o máximo de impacto com o menor esforço de configuração, instale nesta ordem:

```
1. Azure DevOps MCP    → impacto direto no dia a dia dos work items
2. Filesystem MCP      → agente lê os arquivos VB6 do checkout SVN local
3. Zendesk MCP         → acesso ao ticket original sem sair do Copilot
4. Fetch MCP           → pesquisa de docs VB6 e tecnologias legadas
5. Memory MCP          → base de conhecimento persistente entre sessões
```

> 📌 **Lembrete:** O controle de versão dos sistemas legados é **Tortoise SVN**. Para que o agente leia o código-fonte VB6, o dev deve primeiro fazer o **SVN Checkout** localmente e depois configurar o Filesystem MCP apontando para essa pasta.

---

## Referências

- [Documentação oficial MCP](https://modelcontextprotocol.io)
- [Repositório de servidores MCP oficiais](https://github.com/modelcontextprotocol/servers)
- [Azure DevOps MCP (Microsoft)](https://github.com/microsoft/azure-devops-mcp)
- [Playwright MCP (Microsoft)](https://github.com/microsoft/playwright-mcp)
- [GitHub MCP Server (oficial)](https://github.com/github/github-mcp-server)
- [Configurando MCPs no VS Code](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)

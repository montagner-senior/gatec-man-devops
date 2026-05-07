---
title: MCP Server — Azure DevOps
parent: Guias
nav_order: 7
---

# Configuração do MCP Server Azure DevOps no VS Code

> O MCP (Model Context Protocol) Server do Azure DevOps permite que assistentes de IA (GitHub Copilot, Claude etc.) acessem **diretamente** seus work items, PRs, builds e repositórios do Azure DevOps sem sair do editor.

---

## Sumário

1. [Pré-requisitos](#1-pré-requisitos)
2. [O que é o MCP Server](#2-o-que-é-o-mcp-server)
3. [Instalação no VS Code](#3-instalação-no-vs-code)
4. [Configuração do mcp.json](#4-configuração-do-mcpjson)
5. [Domínios disponíveis](#5-domínios-disponíveis)
6. [Defaults de projeto e time](#6-defaults-de-projeto-e-time)
7. [Primeiro uso e autenticação](#7-primeiro-uso-e-autenticação)
8. [Exemplos de prompts](#8-exemplos-de-prompts)
9. [Troubleshooting](#9-troubleshooting)
10. [Segurança e privacidade](#10-segurança-e-privacidade)
11. [Referências](#11-referências)

---

## 1. Pré-requisitos

| Requisito | Versão mínima |
|---|---|
| **Node.js** | 20.0+ |
| **VS Code** | Última versão estável |
| **Extensão GitHub Copilot** | Instalada e autenticada |
| **Organização Azure DevOps** | Ativa (ex: `SeniorSistemas`) |

Verifique o Node.js:

```powershell
node --version   # deve retornar v20.x ou superior
```

Se necessário, instale via <https://nodejs.org/en/download>.

---

## 2. O que é o MCP Server

O MCP Server do Azure DevOps roda **localmente** na sua máquina e expõe ferramentas (tools) que o assistente de IA usa para consultar e manipular dados do ADO. Nenhum dado sai da sua rede — a comunicação é local entre o VS Code e o servidor.

**Capacidades:**

- Listar projetos, times e iterações
- Consultar work items (WIQL)
- Consultar e criar Pull Requests
- Consultar builds e pipelines
- Acessar planos de teste
- Consultar e editar wikis

---

## 3. Instalação no VS Code

### Opção A — Instalação com um clique (recomendado)

1. Abra o VS Code
2. Abra a Command Palette (`Ctrl+Shift+P`)
3. Pesquise por **"MCP: Add Server"**
4. Selecione **Azure DevOps** na lista (se disponível)

### Opção B — Configuração manual via `mcp.json`

Crie ou edite o arquivo de configuração MCP (ver seção 4).

O arquivo pode ficar em dois locais:

| Local | Escopo |
|---|---|
| `.vscode/mcp.json` (no repositório) | Apenas aquele workspace |
| `%APPDATA%/Code/User/mcp.json` | Global (todos os workspaces) |

---

## 4. Configuração do mcp.json

### Configuração recomendada para o time ERPGAtec

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@azure-devops/mcp",
        "${input:ado_org}",
        "-d", "core", "work", "work-items", "repositories", "pipelines"
      ],
      "env": {
        "ado_mcp_project": "${input:ado_project}"
      }
    }
  },
  "inputs": [
    {
      "id": "ado_org",
      "type": "promptString",
      "description": "Azure DevOps organization name (e.g. 'SeniorSistemas')"
    },
    {
      "id": "ado_project",
      "type": "promptString",
      "description": "Azure DevOps project name (e.g. 'ERPGAtec')"
    }
  ]
}
```

### Explicação dos campos

| Campo | Descrição |
|---|---|
| `type: "stdio"` | Comunicação via stdin/stdout (padrão) |
| `command: "npx"` | Executa o pacote npm sem instalação global |
| `"-y"` | Aceita automaticamente a instalação do pacote |
| `"@azure-devops/mcp"` | Pacote oficial do MCP Server |
| `"${input:ado_org}"` | Solicita o nome da org ao iniciar o servidor |
| `"-d", "core", ...` | Filtra os domínios (tools) carregados |
| `ado_mcp_project` | Define o projeto padrão para evitar perguntar a cada prompt |

### Configuração com organização fixa (sem prompt)

Se preferir não ser perguntado a cada vez:

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@azure-devops/mcp",
        "SeniorSistemas",
        "-d", "core", "work", "work-items", "repositories", "pipelines"
      ],
      "env": {
        "ado_mcp_project": "ERPGAtec"
      }
    }
  }
}
```

---

## 5. Domínios disponíveis

O MCP Server agrupa as ferramentas em **domínios**. Carregue apenas o que precisa para evitar confusão no modelo de IA e melhorar a performance.

| Domínio | Ferramentas incluídas |
|---|---|
| `core` | Projetos, times, iterações |
| `work` | Boards, sprints, capacidade |
| `work-items` | CRUD de work items, WIQL |
| `repositories` | Repos, branches, PRs |
| `pipelines` | Builds, releases, logs |
| `search` | Busca no código e work items |
| `test-plans` | Casos de teste, resultados |
| `wiki` | Páginas wiki |
| `advanced-security` | Alertas de segurança |

Use o argumento `-d` seguido dos domínios desejados:

```json
"args": ["-y", "@azure-devops/mcp", "SeniorSistemas", "-d", "core", "work", "work-items"]
```

> **Recomendação:** sempre inclua `core` para ter acesso a informações de projeto e time.

---

## 6. Defaults de projeto e time

Para não precisar informar o projeto e time em cada prompt, configure via variáveis de ambiente no `mcp.json`:

```json
"env": {
  "ado_mcp_project": "ERPGAtec",
  "ado_mcp_team": "Manutenção"
}
```

---

## 7. Primeiro uso e autenticação

1. Após salvar o `mcp.json`, o VS Code exibirá a notificação do MCP Server. Clique em **"Start"**
2. Abra o **GitHub Copilot Chat** (ou outro assistente) e mude para o **Agent Mode**
3. Clique em **"Select Tools"** e habilite as ferramentas do Azure DevOps
4. Faça um prompt de teste: `List ADO projects`
5. Na **primeira execução**, o navegador abrirá solicitando login com sua **conta Microsoft** (a mesma usada no Azure DevOps)
6. Após autenticação, as consultas funcionam diretamente

> ⚠️ Use as credenciais que possuem acesso à organização Azure DevOps selecionada.

---

## 8. Exemplos de prompts

### Work items

| Prompt | O que faz |
|---|---|
| `Liste meus work items ativos no projeto ERPGAtec` | Busca items assigned a você |
| `Quais bugs estão com status Active no path Manutenção?` | Filtra bugs do time |
| `Crie um Bug com título "Erro no relatório X" no projeto ERPGAtec` | Cria um work item |
| `Quais items estão impedidos no sprint atual?` | Lista bloqueios |

### Preparação para standup

```
Busque meus work items do projeto ERPGAtec e me ajude a preparar o standup:
o que completei, no que estou trabalhando e o que está bloqueado.
```

### Pull Requests

| Prompt | O que faz |
|---|---|
| `Liste PRs abertos nos repos gatec-*` | PRs pendentes |
| `Detalhes do PR #42 e work items vinculados` | Contexto de negócio |

### Builds

| Prompt | O que faz |
|---|---|
| `Status dos builds recentes do projeto ERPGAtec` | Últimos builds |
| `Qual o último build que falhou?` | Diagnóstico rápido |

> **Dica:** para forçar dados atualizados, adicione ao prompt: "Não use dados buscados anteriormente."

---

## 9. Troubleshooting

| Problema | Solução |
|---|---|
| Servidor não inicia | Verifique se `node --version` retorna 20+. Rode `npx -y @azure-devops/mcp --help` no terminal para validar |
| Erro de autenticação | Feche o navegador, tente novamente. Confirme que a conta Microsoft tem acesso à org |
| Timeout na conexão | Verifique proxy/VPN. O MCP se comunica com `dev.azure.com` |
| Tools não aparecem | Confirme que está no **Agent Mode** e que clicou em "Select Tools" |
| `npm ERR!` ao iniciar | Limpe cache com `npm cache clean --force` e tente novamente |

Documentação completa de troubleshooting:
<https://github.com/microsoft/azure-devops-mcp/blob/main/docs/TROUBLESHOOTING.md>

---

## 10. Segurança e privacidade

- **Execução local** — nenhum dado sai do seu ambiente
- **Nenhuma API externa** — comunicação direta com `dev.azure.com`
- **Controle do usuário** — você decide quais tools habilitar
- **Respeita permissões** — o servidor usa suas credenciais; só acessa o que você já pode acessar no ADO

---

## 11. Referências

| Recurso | Link |
|---|---|
| Documentação oficial Microsoft | <https://learn.microsoft.com/pt-br/azure/devops/mcp-server/mcp-server-overview> |
| Repositório GitHub do MCP Server | <https://github.com/microsoft/azure-devops-mcp> |
| Lista completa de ferramentas (tools) | <https://github.com/microsoft/azure-devops-mcp/blob/main/docs/TOOLSET.md> |
| Exemplos de uso | <https://github.com/microsoft/azure-devops-mcp/blob/main/docs/EXAMPLES.md> |
| Troubleshooting | <https://github.com/microsoft/azure-devops-mcp/blob/main/docs/TROUBLESHOOTING.md> |
| Vídeo Quick Start (2 min) | <https://youtu.be/EUmFM6qXoYk> |

---

*Guia criado em maio/2026 — baseado na versão 2.7.0 do Azure DevOps MCP Server.*

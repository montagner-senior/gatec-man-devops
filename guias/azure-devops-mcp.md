# Guia de Implantação e Uso — Azure DevOps MCP Server

## Objetivo

Este guia ensina como instalar e configurar o **Azure DevOps MCP Server** (pacote oficial da Microsoft) neste workspace e como utilizá-lo da melhor forma no dia a dia do time de manutenção legado.

Com o MCP configurado, o GitHub Copilot passa a ter acesso direto ao Azure DevOps: você descreve o que precisa em linguagem natural e o agente consulta, cria ou atualiza work items, verifica pipelines e muito mais — sem abrir o browser.

> 📌 **Regra do time:** O Azure DevOps MCP é o MCP de maior prioridade para o nosso contexto. Ele deve ser o primeiro a ser configurado por todo membro do time.

---

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

1. **VS Code** — versão 1.99 ou superior
   - Download: https://code.visualstudio.com/download
2. **Node.js** — versão 20 ou superior
   - Download: https://nodejs.org/en/download
   - Para verificar se já está instalado, abra o PowerShell e execute:
     ```powershell
     node --version
     ```
   - Se retornar `v20.x.x` ou superior, está ok.
3. **GitHub Copilot** habilitado no VS Code (extensão instalada e conta conectada)
4. Acesso à organização Azure DevOps do time

---

## Passo a Passo — Instalação

### Passo 1 — Criar o arquivo de configuração do MCP

No VS Code, abra este workspace (`.devops`). Crie a pasta `.vscode` se ela não existir, e dentro dela crie o arquivo `mcp.json` com o seguinte conteúdo:

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
    }
  }
}
```

> 💡 **Dica:** O parâmetro `-d` define quais **domínios** (grupos de ferramentas) serão carregados. Estamos carregando apenas os que o time de manutenção realmente usa. Isso evita carregar ferramentas desnecessárias e melhora a performance do agente.

> 💡 **Sobre o `${input:ado_org}`:** O VS Code irá solicitar o nome da organização automaticamente na primeira vez que o servidor for iniciado. Você pode preencher com o nome da sua organização (ex: `minha-empresa`) e ele ficará salvo na sessão.

---

### Passo 2 — Iniciar o servidor MCP

1. No VS Code, abra o arquivo `.vscode/mcp.json`
2. Você verá um botão **"Start"** aparecer no topo do arquivo — clique nele
3. Uma caixa de texto pedirá o nome da organização Azure DevOps — informe o nome correto
4. O servidor será iniciado. Um ícone de status aparecerá na barra inferior do VS Code

> ⚠️ **Atenção:** Na primeira execução, o `npx` irá baixar o pacote `@azure-devops/mcp` automaticamente da internet. Aguarde o download concluir antes de continuar. É necessário conexão com a internet.

---

### Passo 3 — Autenticar com sua conta Microsoft

1. Abra o **GitHub Copilot Chat** no VS Code (`Ctrl + Alt + I`)
2. No canto superior do chat, selecione **Agent Mode** (ícone de agente)
3. Clique em **"Select Tools"** e habilite as ferramentas do grupo `ado`
4. Digite qualquer prompt relacionado ao Azure DevOps, por exemplo:
   ```
   Liste os projetos da minha organização ADO
   ```
5. Na primeira vez que uma ferramenta ADO for executada, **o browser abrirá automaticamente** pedindo login com sua conta Microsoft
6. Faça login com as credenciais que você usa para acessar o Azure DevOps
7. Após o login, retorne ao VS Code — o agente continuará a execução

> ⚠️ **Atenção:** Use as mesmas credenciais que você utiliza para acessar o Azure DevOps pelo browser. Se sua organização usa Single Sign-On (SSO), o login será redirecionado automaticamente.

---

### Passo 4 — Verificar se está funcionando

No Copilot Chat (Agent Mode), teste com o prompt:

```
Liste os meus work items no projeto <nome-do-projeto>
```

Se retornar uma lista de work items, a configuração está correta.

---

## Domínios disponíveis — o que cada um faz

O servidor possui domínios que agrupam ferramentas por área. A configuração acima já carrega os mais importantes para o time. A tabela abaixo explica todos:

| Domínio | O que contém | Relevante para o time? |
|---|---|---|
| `core` | Listar projetos e times da organização | ✅ Sim — sempre habilite |
| `work` | Sprints, iterações, capacidade do time | ✅ Sim — gestão da sprint |
| `work-items` | Criar, atualizar, comentar, buscar work items | ✅ Sim — uso diário |
| `search` | Pesquisar work items, código e wiki por texto | ✅ Sim — investigação de tickets |
| `pipelines` | Status de builds, logs, acionar runs | ✅ Sim — verificar deploy |
| `repositories` | Branches, commits, pull requests (Git) | ⚪ Não se aplica — o legado está no SVN |
| `wiki` | Criar e editar páginas no Azure DevOps Wiki | ⚪ Opcional |
| `test-plans` | Planos e casos de teste | ⚪ Opcional |
| `advanced-security` | Alertas de segurança no repositório | ⚪ Não se aplica |

> 📌 **Regra do time:** Não habilite o domínio `repositories` para trabalho com o código-fonte legado — ele é para repositórios Git, e o legado está no **Tortoise SVN**.

---

## Como usar no dia a dia — Prompts prontos para o time

Todos os exemplos abaixo devem ser usados no **GitHub Copilot Chat em Agent Mode**.
Substitua `<nome-do-projeto>` pelo nome real do projeto no Azure DevOps.

---

### Gerenciando Work Items transbordados do Suporte

```
Liste os work items em aberto no projeto <nome-do-projeto>
```

```
Mostre os work items atribuídos a mim no projeto <nome-do-projeto>
```

```
Mostre o work item #<número> do projeto <nome-do-projeto> com todos os detalhes
```

```
Quais work items estão na sprint atual do projeto <nome-do-projeto> para o time <nome-do-time>?
```

---

### Atualizando e registrando progresso

```
Atualize o work item #<número> adicionando o comentário: "Investigado o módulo X do VB6. Encontrado o problema na função Y. Aguardando validação."
```

```
Mude o status do work item #<número> para "Em Andamento"
```

```
Mude o status do work item #<número> para "Concluído"
```

```
Adicione uma observação técnica no work item #<número>: "<seu texto aqui>"
```

---

### Investigação de tickets transbordados

```
Pesquise work items no projeto <nome-do-projeto> com o texto "<termo relacionado ao problema>"
```

```
Liste todos os work items do tipo Fix no projeto <nome-do-projeto>
```

```
Liste todos os work items do tipo Hotfix em aberto no projeto <nome-do-projeto>
```

```
Mostre o histórico de alterações do work item #<número>
```

---

### Criando Fix ou Hotfix após investigação

```
Crie um work item do tipo Fix no projeto <nome-do-projeto> com título "Correção da função X no módulo Y" e descrição "<descrição do que foi encontrado>"
```

```
Crie um work item do tipo Hotfix no projeto <nome-do-projeto> com título "Falha crítica no cálculo Z em produção" com prioridade máxima
```

> ⚠️ **Atenção:** O dev **nunca cria o work item inicial** que vem do Zendesk — esses chegam automaticamente. Use a criação de work item apenas para Fix e Hotfix identificados internamente pelo time.

---

### Acompanhamento de sprint e backlog

```
Liste as iterações do projeto <nome-do-projeto>
```

```
Qual a capacidade do time <nome-do-time> na sprint atual do projeto <nome-do-projeto>?
```

```
Liste os itens do backlog do time <nome-do-time> no projeto <nome-do-projeto>
```

---

### Pipelines e status de deploy

```
Qual o status do último build do projeto <nome-do-projeto>?
```

```
Mostre os últimos builds da pipeline <nome-da-pipeline> no projeto <nome-do-projeto>
```

```
Mostre o log do build <id-do-build> no projeto <nome-do-projeto>
```

```
Execute a pipeline <nome-da-pipeline> no projeto <nome-do-projeto>
```

---

## Fluxo recomendado para atendimento de um ticket transbordado

Com o MCP configurado, o fluxo de atendimento pode ser feito inteiramente pelo Copilot Chat:

```
1. [Copilot Chat] "Mostre o work item #<número> do projeto <nome-do-projeto>"
        ↓ agente busca e exibe todos os detalhes do ticket
2. [Dev] Analisa a descrição e parte para investigação no código VB6 (SVN)
        ↓ faz checkout, lê os arquivos .frm, .bas, .cls relevantes
3. [Copilot Chat] "Adicione o comentário no work item #<número>: '<achados da investigação>'"
        ↓ agente registra o achado sem o dev abrir o browser
4. [Dev] Decide a ação: encerrar, abrir Fix ou Hotfix
5. [Copilot Chat] "Crie um work item do tipo Fix..." ou "Mude o status do #<número> para Concluído"
```

---

## Configuração para outros workspaces do time

Cada dev deve configurar o MCP no **seu próprio workspace** de código. O arquivo `.vscode/mcp.json` deve ser criado em cada repositório onde o dev trabalha.

Para o repositório de documentação (este workspace `.devops`), a configuração já está descrita acima.

Para os demais workspaces, copie o arquivo `.vscode/mcp.json` e ajuste conforme necessário.

> 💡 **Dica:** O arquivo `.vscode/mcp.json` **não deve ser commitado no SVN** se contiver informações sensíveis. Adicione-o ao `svn:ignore` ou ao `.gitignore` conforme o caso. A configuração acima já é segura — não há tokens ou senhas, a autenticação é feita via login Microsoft.

---

## Mantendo o MCP atualizado

O pacote `@azure-devops/mcp` é atualizado frequentemente pela Microsoft. Como usamos `npx -y`, ele sempre baixa a versão mais recente disponível.

Para usar a versão de desenvolvimento (nightly builds com novas funcionalidades):

```json
"args": ["-y", "@azure-devops/mcp@next", "${input:ado_org}", "-d", "core", "work", "work-items", "search", "pipelines"]
```

> ⚠️ **Atenção:** A versão `@next` pode conter funcionalidades instáveis. Use apenas se precisar de uma feature específica que ainda não está na versão estável.

---

## Solução de problemas comuns

| Problema | Causa provável | Solução |
|---|---|---|
| O botão "Start" não aparece no `mcp.json` | VS Code desatualizado | Atualize o VS Code para versão 1.99+ |
| `npx: command not found` | Node.js não instalado | Instale o Node.js 20+ e reinicie o VS Code |
| Browser não abre para login | Pop-up bloqueado | Verifique as configurações do browser e permita pop-ups do VS Code |
| "Organization not found" | Nome da organização errado | Verifique a URL do seu Azure DevOps: `dev.azure.com/<nome-correto>` |
| O agente retorna "no tools available" | Agent Mode não selecionado | No chat, clique no ícone de agente e troque de Chat para Agent Mode |
| Servidor trava após login | Timeout de autenticação | Reinicie o servidor MCP clicando em "Restart" no `mcp.json` |

---

## Referências

- [Repositório oficial — microsoft/azure-devops-mcp](https://github.com/microsoft/azure-devops-mcp)
- [Lista completa de ferramentas disponíveis (TOOLSET.md)](https://github.com/microsoft/azure-devops-mcp/blob/main/docs/TOOLSET.md)
- [Guia de primeiros passos oficial](https://github.com/microsoft/azure-devops-mcp/blob/main/docs/GETTINGSTARTED.md)
- [Exemplos de prompts](https://github.com/microsoft/azure-devops-mcp/blob/main/docs/EXAMPLES.md)
- [Solução de problemas](https://github.com/microsoft/azure-devops-mcp/blob/main/docs/TROUBLESHOOTING.md)
- [Documentação Agent Mode no VS Code](https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode)

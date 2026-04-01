# Guia Completo — Azure DevOps via CLI

> Guia passo a passo para instalar, configurar e usar o Azure DevOps pelo terminal.

---

## 1. Instalar o Azure CLI

### Via Winget (recomendado)

```powershell
winget install --id Microsoft.AzureCLI --accept-source-agreements --accept-package-agreements
```

### Via instalador MSI

Baixe em: https://aka.ms/installazurecliwindows

### Verificar instalação

> **Importante:** após instalar, feche e reabra o terminal (ou o VS Code) para que o PATH seja atualizado.

```powershell
az --version
```

Saída esperada (exemplo):

```
azure-cli    2.84.0
```

---

## 2. Instalar a extensão Azure DevOps

O Azure CLI não inclui os comandos do DevOps por padrão. É necessário instalar a extensão:

```powershell
az extension add --name azure-devops
```

Para verificar se foi instalada:

```powershell
az extension list --query "[?name=='azure-devops'].{Nome:name, Versao:version}" -o table
```

---

## 3. Fazer login

### Login interativo (abre o navegador)

```powershell
az login
```

Se sua conta não possui Azure Subscription (apenas Azure DevOps), use:

```powershell
az login --allow-no-subscriptions
```

### Verificar se está logado

```powershell
az account show
```

Saída esperada:

```json
{
  "user": {
    "name": "seu.email@empresa.onmicrosoft.com",
    "type": "user"
  }
}
```

---

## 4. Configurar organização e projeto padrão

Evita ter que passar `--org` e `--project` em todo comando.

```powershell
az devops configure --defaults organization=https://SUA_ORGANIZACAO.visualstudio.com project="NOME DO PROJETO"
```

**Exemplo real:**

```powershell
az devops configure --defaults organization=https://gantc.visualstudio.com project="Senior Agro Dev"
```

Para verificar os defaults configurados:

```powershell
az devops configure --list
```

---

## 5. Comandos úteis do dia a dia

### 5.1 Listar work items atribuídos a mim

```powershell
az boards query --wiql "SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType] FROM WorkItems WHERE [System.AssignedTo] = @Me AND [System.State] <> 'Closed' AND [System.State] <> 'Done' AND [System.State] <> 'Removed' ORDER BY [System.ChangedDate] DESC" -o table
```

### 5.2 Filtrar por tipo e estado

**Fix com status New:**

```powershell
az boards query --wiql "SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.AssignedTo] = @Me AND [System.WorkItemType] = 'Fix' AND [System.State] = 'New'" -o table
```

**Tasks ativas:**

```powershell
az boards query --wiql "SELECT [System.Id], [System.Title] FROM WorkItems WHERE [System.AssignedTo] = @Me AND [System.WorkItemType] = 'Task' AND [System.State] = 'Active'" -o table
```

### 5.3 Ver detalhes de um work item

```powershell
az boards work-item show --id 124868 -o table
```

Com todos os campos (JSON):

```powershell
az boards work-item show --id 124868 -o json
```

### 5.4 Atualizar estado de um work item

```powershell
az boards work-item update --id 124868 --state "Active"
```

### 5.5 Adicionar comentário a um work item

```powershell
az boards work-item update --id 124868 --discussion "Iniciando análise do problema."
```

### 5.6 Criar um novo work item

```powershell
az boards work-item create --type "Task" --title "Minha nova tarefa" --assigned-to "seu.email@empresa.onmicrosoft.com"
```

### 5.7 Listar iterações (sprints)

```powershell
az boards iteration team list -o table
```

### 5.8 Listar membros do projeto

```powershell
az devops team list -o table
```

---

## 6. Formatos de saída

| Flag | Formato | Uso |
|------|---------|-----|
| `-o table` | Tabela | Visualização rápida no terminal |
| `-o json` | JSON | Processamento por scripts |
| `-o tsv` | Tab-separated | Integração com outros comandos |
| `-o yaml` | YAML | Leitura estruturada |

---

## 7. Dicas e resolução de problemas

### Erro "az não é reconhecido"

Feche e reabra o terminal. Se persistir, recarregue o PATH manualmente:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

### Token expirado

Refaça o login:

```powershell
az login --allow-no-subscriptions
```

### Verificar organização configurada

```powershell
az devops configure --list
```

### Listar extensões instaladas

```powershell
az extension list -o table
```

### Atualizar o Azure CLI

```powershell
az upgrade
```

### Atualizar apenas a extensão DevOps

```powershell
az extension update --name azure-devops
```

---

## 8. Referência rápida de comandos

| Ação | Comando |
|------|---------|
| Login | `az login --allow-no-subscriptions` |
| Verificar login | `az account show` |
| Configurar defaults | `az devops configure --defaults organization=URL project=NOME` |
| Meus work items | `az boards query --wiql "... @Me ..." -o table` |
| Detalhes de item | `az boards work-item show --id ID` |
| Atualizar estado | `az boards work-item update --id ID --state "Estado"` |
| Criar item | `az boards work-item create --type TIPO --title "Título"` |
| Comentar | `az boards work-item update --id ID --discussion "Texto"` |

---

## Resumo do fluxo de primeira instalação

```
1. winget install --id Microsoft.AzureCLI
2. (reabrir terminal)
3. az extension add --name azure-devops
4. az login --allow-no-subscriptions
5. az devops configure --defaults organization=URL project=NOME
6. az boards query --wiql "... @Me ..." -o table   ← pronto para usar!
```

# Pipeline de Build (CI) — Sistemas VB6

## Objetivo

Descrever como funciona o pipeline de **build automático** (Integração Contínua — CI) dos sistemas VB6 legados no Azure DevOps — o que ele faz, quando é acionado e como monitorar sua execução.

## Pré-requisitos

- Acesso ao Azure DevOps com permissão de visualização de Pipelines
- Entendimento básico de [Controle de Versão SVN](../guias/controle-versao-svn.md)

---

## O que é o pipeline de Build?

O pipeline de build é um processo automatizado que, ao ser acionado, compila o código-fonte VB6 e gera o executável (`.exe`) e DLLs necessárias para o sistema funcionar. Ele garante que o código commitado no SVN está compilando corretamente antes de qualquer deploy.

> 💡 **Dica:** O build automático serve como uma verificação automática de que o código não está com erros de compilação. Se o build quebrar após um commit, o dev sabe imediatamente.

---

## Quando o pipeline de build é executado

| Gatilho | Descrição |
|---|---|
| **Commit no SVN** (automático) | Toda vez que é feito um `SVN Commit` no `trunk` do sistema |
| **Agendado** | `<horário e frequência definidos — ex: toda noite às 22h>` |
| **Manual** | O dev ou a Gerência aciona manualmente pelo Azure DevOps |

---

## Como acompanhar o resultado do build

1. Acesse o Azure DevOps → **Pipelines** → **Pipelines** (lista)
2. Localize o pipeline do sistema afetado pelo nome: `Build - <nome-do-sistema>`
3. Clique para ver as execuções recentes
4. Verifique o ícone de status:
   - ✅ **Verde** — build bem-sucedido
   - ❌ **Vermelho** — build falhou — investigação necessária
   - 🔵 **Azul (em execução)** — aguardando conclusão

### O que fazer se o build falhar

1. Clique na execução com falha para ver o log de erro
2. Leia a mensagem de erro na aba **"Logs"**
3. Erros comuns de build em VB6:
   | Mensagem de erro | Causa provável |
   |---|---|
   | `Compile error: Variable not defined` | Variável usada sem declaração — verificar `Option Explicit` |
   | `File not found: NomeArquivo.frm` | Arquivo referenciado no `.vbp` não existe no SVN |
   | `Permission denied` | O agente de build não tem acesso ao caminho configurado |
   | `Expected End Sub / End Function` | Código com sintaxe incorreta — bloco não fechado |
4. Corrija o problema no código, faça o commit e aguarde o novo build

> ⚠️ **Atenção:** Nunca faça um deploy de um sistema cujo último build falhou. Garanta que o build está verde antes de qualquer deploy em produção.

---

## Artefatos gerados pelo build

Após um build bem-sucedido, o pipeline gera os seguintes artefatos:

| Artefato | Descrição |
|---|---|
| `<nome-sistema>.exe` | Executável principal do sistema VB6 |
| `<nome-componente>.dll` | Componentes/DLLs registrados (quando aplicável) |
| `build-log.txt` | Log completo da compilação |

Os artefatos ficam disponíveis na aba **"Artifacts"** da execução do pipeline.

---

## Configuração do pipeline de build

> ⚠️ **Atenção:** A configuração dos pipelines é responsabilidade da Gerência e do Dev Sênior. Não altere configurações de pipeline sem autorização.

O pipeline de build está configurado em: `Azure DevOps → Pipelines → <nome-do-pipeline> → Edit`

Principais configurações relevantes:

| Configuração | Valor |
|---|---|
| **Repositório fonte** | SVN — `<url-do-repositorio>/<sistema>/trunk` |
| **Agente de build** | `<nome-do-agente>` — máquina com VB6 instalado |
| **Compilador** | Visual Basic 6.0 IDE / compilador VB6 |
| **Comando de build** | `<VB6.EXE /make NomeProjeto.vbp>` |
| **Pasta de saída** | `<caminho-dos-artefatos>` |

---

## Observações e Alertas

> 💡 **Dica:** O agente de build precisa ter o **Visual Basic 6 IDE** instalado e licenciado para compilar projetos VB6. Se o agente for reinstalado ou substituído, o VB6 precisa ser reinstalado também.

> 📌 **Regra do time:** Todo pipeline de build deve estar configurado para **notificar por e-mail** o Dev Sênior e a Gerência em caso de falha. Verifique com a Gerência se as notificações estão ativas.

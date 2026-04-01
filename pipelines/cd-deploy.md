# Pipeline de Deploy (CD) — Sistemas VB6

## Objetivo

Descrever como funciona o pipeline de **deploy automático** (Entrega Contínua — CD) dos sistemas VB6 legados no Azure DevOps — como solicitar, acompanhar e confirmar um deploy em produção.

## Pré-requisitos

- Build bem-sucedido gerado pelo [pipeline de CI](./ci-build.md)
- Work item no estado **"Aguardando Deploy"** no Azure DevOps
- Aprovação da Gerência (para deploys em produção)

---

## Visão geral do processo de deploy

```
Build aprovado (pipeline CI verde)
       ↓
Work item em estado "Aguardando Deploy"
       ↓
Dev solicita aprovação de deploy à Gerência
       ↓
Gerência aprova no Azure DevOps
       ↓
Pipeline de deploy é acionado
       ↓
Executável substituído nos servidores / estações de produção
       ↓
Dev verifica se o sistema está funcionando corretamente
       ↓
Work item → Concluído
```

---

## Ambientes de deploy

| Ambiente | Finalidade | Aprovação necessária |
|---|---|---|
| **Homologação** | Validação antes de ir para produção | Dev Sênior |
| **Produção** | Ambiente dos usuários finais | Gerência |

> 📌 **Regra do time:** Nunca faça deploy direto em produção sem antes validar em homologação (exceto em Hotfixes onde a urgência pode justificar exceção com aval da Gerência).

---

## Como solicitar e acompanhar um deploy

### Passo 1 — Verificar pré-requisitos

Antes de solicitar o deploy:

- [ ] O build CI mais recente está verde (✅)
- [ ] O work item está no estado **"Aguardando Deploy"**
- [ ] Todos os arquivos alterados foram commitados no SVN
- [ ] O Dev Sênior revisou (para Fixes e User Stories com lógica crítica)

### Passo 2 — Solicitar aprovação

1. Adicione um comentário no work item:
   ```
   Solicitação de deploy — [data/hora]
   
   Revisão SVN: <número>
   Arquivos alterados: <lista resumida>
   Ambiente solicitado: Homologação / Produção
   
   @Gerência — aguardando aprovação para deploy.
   ```
2. Notifique a Gerência pelo canal de comunicação do time

### Passo 3 — Gerência aprova no Azure DevOps

1. A Gerência acessa o Azure DevOps → **Pipelines** → **Releases**
2. Localiza a release pendente de aprovação
3. Clica em **"Approve"** para liberar o deploy
4. O pipeline é executado automaticamente

### Passo 4 — Acompanhar a execução do deploy

1. Acesse o Azure DevOps → **Pipelines** → **Releases**
2. Localize a release em execução para o sistema (`Deploy - <nome-do-sistema>`)
3. Acompanhe o progresso nas etapas (stages):
   - ✅ **Succeeded** — etapa concluída com sucesso
   - ❌ **Failed** — falhou — ver log de erro
   - ⏳ **In Progress** — aguardando conclusão

### Passo 5 — Verificar o sistema após o deploy

Após o deploy concluir:

1. Acesse o sistema em produção (ou homologação)
2. Verifique especificamente as funcionalidades alteradas no work item
3. Confirme que o problema foi resolvido (para Fixes e Hotfixes) ou que a nova funcionalidade está correta (para User Stories)
4. Se houver problema: inicie o processo de [Rollback](./rollback.md) imediatamente

### Passo 6 — Concluir o work item

Após confirmação em produção:

1. Mude o estado do work item para **"Concluído"**
2. Adicione o comentário de encerramento:
   ```
   Deploy concluído — [data/hora]
   
   Ambiente: Produção
   Validado por: <nome>
   Sistema funcionando normalmente: Sim
   ```

---

## O que o pipeline de deploy faz

O pipeline de deploy executa automaticamente as seguintes etapas:

| Etapa | O que acontece |
|---|---|
| **Download do artefato** | Baixa o `.exe` e DLLs gerados pelo pipeline de build |
| **Backup da versão atual** | Salva cópia do executável em produção antes de substituir |
| **Parada do sistema** | Encerra o processo em execução nos servidores/estações |
| **Substituição dos arquivos** | Copia o novo `.exe` e DLLs para o caminho de produção |
| **Registro de DLLs** | Executa `regsvr32` para registrar componentes (quando necessário) |
| **Reinicialização** | Reinicia o sistema ou notifica os usuários que podem abrir |
| **Verificação de integridade** | Confirma que o arquivo foi substituído corretamente |

---

## Caminhos de deploy por sistema

> 📌 **Regra do time:** Os caminhos dos sistemas em produção são documentados aqui. Mantenha esta tabela atualizada.

| Sistema | Caminho em produção | Servidor |
|---|---|---|
| `<nome-sistema>` | `<\\servidor\caminho\NomeSistema.exe>` | `<nome-servidor>` |

---

## Janelas de deploy

> 📌 **Regra do time:** Deploys em produção são feitos **preferencialmente** nas janelas definidas, exceto Hotfixes.

| Tipo | Janela preferencial |
|---|---|
| User Story / Fix | `<ex: terças e quintas após as 17h>` |
| Hotfix | A qualquer momento — com aprovação imediata da Gerência |

---

## Observações e Alertas

> ⚠️ **Atenção:** Se o deploy falhar em produção, **não tente executá-lo novamente** sem entender a causa da falha. Execute o [Rollback](./rollback.md) para restaurar a versão anterior e investigue antes de um novo deploy.

> ⚠️ **Atenção:** Antes de qualquer deploy em produção, verifique se há usuários ativos no sistema. Se sim, comunique-os sobre a manutenção programada.

> 💡 **Dica:** O pipeline faz backup automático do executável anterior. Em caso de problema, o rollback pode ser feito rapidamente a partir desse backup.

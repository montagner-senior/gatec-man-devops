# Rollback — Reverter Deploy em Produção

## Objetivo

Descrever como reverter um deploy que causou problemas em produção, restaurando a versão anterior do sistema VB6 funcionando corretamente.

## Pré-requisitos

- Acesso ao Azure DevOps com permissão de Pipelines
- Acesso ao servidor de produção (direto ou via pipeline)
- Comunicação com Gerência e Dev Sênior estabelecida

---

## O que é o Rollback?

O **rollback** é o processo de **desfazer um deploy** e restaurar a versão anterior do sistema em produção. É executado quando um deploy causa um problema que não pode ser corrigido rapidamente com um Hotfix.

> ⚠️ **Atenção:** O rollback deve ser a **primeira opção** quando um deploy causa problema em produção e a correção não é imediata. Não tente corrigir o problema diretamente em produção — reverta primeiro, corrija depois.

---

## Quando fazer rollback

| Situação | Ação recomendada |
|---|---|
| Sistema não está abrindo após deploy | 🔴 Rollback imediato |
| Funcionalidade crítica quebrada após deploy | 🔴 Rollback imediato |
| Dados sendo gravados incorretamente após deploy | 🔴 Rollback imediato + avaliar integridade dos dados |
| Bug menor introduzido pelo deploy, sem impacto crítico | 🟡 Avaliar com Gerência — pode ser um Fix normal |
| Usuário reclamando de comportamento diferente | 🟡 Investigar antes de decidir pelo rollback |

---

## Fluxo de decisão de rollback

```
Problema identificado após deploy
       ↓
⏱️ É crítico? (sistema fora, dados incorretos)
  → Sim → Comunicar Gerência e Dev Sênior — executar Rollback AGORA
  → Não → Investigar causa → se não resolver em 1h, avaliar Rollback
       ↓
Executar Rollback
       ↓
Confirmar que sistema voltou ao funcionamento normal
       ↓
Comunicar ao Suporte e usuários
       ↓
Investigar causa do problema no código VB6
       ↓
Abrir Hotfix ou Fix com a correção adequada
       ↓
Novo deploy somente após correção validada
```

---

## Como executar o rollback

### Opção 1 — Rollback via Pipeline do Azure DevOps (preferencial)

1. Acesse o Azure DevOps → **Pipelines** → **Releases**
2. Localize o pipeline do sistema afetado: `Deploy - <nome-do-sistema>`
3. Clique no pipeline para ver o histórico de releases
4. Identifique a **release anterior** que estava funcionando (a penúltima executada com sucesso)
5. Clique nela → **"Redeploy"** ou **"Re-deploy to [Produção]"**
6. Aguarde a aprovação da Gerência e a execução
7. Confirme que o sistema voltou a funcionar

> 💡 **Dica:** O pipeline de deploy sempre faz backup do executável anterior. O "Redeploy" da release anterior restaura exatamente o estado antes do deploy problemático.

### Opção 2 — Rollback manual via backup (emergência)

Se o pipeline não estiver disponível, o rollback pode ser feito manualmente:

1. Acesse o servidor de produção: `<\\servidor\caminho-do-sistema\>`
2. Localize a pasta de backup criada pelo pipeline: `<\\servidor\caminho\backup\AAAAMMDD_HHMM\>`
3. Copie o(s) arquivo(s) da pasta de backup para a pasta de produção, substituindo os atuais:
   - `<NomeSistema>.exe`
   - Demais DLLs afetadas
4. Se houver DLLs a registrar: execute `regsvr32 NomeDll.dll` no servidor
5. Confirme que o sistema abre e funciona corretamente

> ⚠️ **Atenção:** O rollback manual deve ser feito apenas por dev com acesso ao servidor de produção e com comunicação prévia à Gerência. Documente tudo o que for feito.

---

## Após o rollback

### Passo 1 — Confirmar funcionamento

1. Abra o sistema em produção
2. Teste a funcionalidade que estava com problema antes do rollback
3. Confirme que as demais funcionalidades principais estão operacionais

### Passo 2 — Comunicar

1. Informe ao time: `"[ROLLBACK] <nome-do-sistema> revertido para versão anterior. Sistema normalizado."`
2. Informe à Gerência com detalhes do que foi revertido
3. Informe ao Suporte para comunicar ao cliente (se o problema foi relatado pelo cliente)

### Passo 3 — Abrir work item de correção

1. Abra o work item que originou o deploy problemático e adicione comentário:
   ```
   ROLLBACK executado — [data/hora]
   
   Motivo: <descrição do problema identificado>
   Versão revertida para: <revisão SVN anterior>
   Sistema normalizado: Sim
   
   Próximo passo: Investigar causa e abrir [Hotfix/Fix] para correção adequada.
   ```
2. Se o problema for crítico (Hotfix): crie um Hotfix imediatamente
3. Se puder esperar (Fix): crie um Fix para correção planejada

### Passo 4 — Investigar a causa

Antes do próximo deploy do sistema:

1. Identifique exatamente qual commit causou o problema (use SVN Log Diff entre a versão boa e a problemática)
2. Corrija o problema no código
3. Teste em homologação antes de qualquer novo deploy em produção
4. Registre o achado em `base-conhecimento/achados/`

---

## Prevenção de rollbacks

Para reduzir a necessidade de rollbacks:

| Prática preventiva | Quando |
|---|---|
| Sempre validar em homologação antes de ir para produção | Antes de todo deploy |
| Revisão do Dev Sênior em alterações críticas | Antes do commit |
| Commit com mensagem clara | A cada SVN Commit |
| Verificar build CI verde antes de solicitar deploy | Antes de mover WI para "Aguardando Deploy" |
| Deploy em janela de baixo uso | Prefira horários com menos usuários ativos |

---

## Histórico de rollbacks

> 💡 **Dica:** Registre todos os rollbacks executados nesta tabela para análise de padrões.

| Data | Sistema | Motivo | Work Item | Duração do incidente |
|---|---|---|---|---|
| — | — | — | — | — |

---

## Observações e Alertas

> ⚠️ **Atenção:** Se o rollback envolver dados que já foram gravados incorretamente em produção (registros duplicados, valores errados), o rollback do executável **não corrige os dados**. É necessária uma análise e correção manual do banco de dados — acione o DBA ou o Dev Sênior imediatamente.

> 📌 **Regra do time:** Todo rollback executado em produção deve ser comunicado à Gerência **antes ou durante** a execução — nunca após. A Gerência precisa estar ciente para gerenciar a comunicação com o Suporte e os clientes.

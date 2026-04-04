---
title: Critérios de Validação
parent: Agentes
nav_order: 2
---

# Critérios de Validação de Issues — Path: Manutenção

> Este arquivo é a referência oficial do que torna uma issue válida para o time.
> O agente `issue-validator` usa este documento como base de validação.

---

## Por que isso importa

Issues chegam via integração automática Zendesk → Azure DevOps.
O Zendesk muitas vezes envia apenas o título do ticket e o número de referência.
Sem os campos abaixo, o dev inicia a investigação completamente às cegas no código VB6 legado.

> **Nota para o agente:** Este documento é sua referência principal de validação.
> Use seu julgamento ao analisar cada item — não use apenas verificação de campo vazio.
> Leia as descrições e avalie se realmente informam o suficiente para o dev trabalhar.

---

## Checklist de validação (6 itens obrigatórios)

| # | Item | Campo API | Como o agente valida |
|---|---|---|---|
| 1 | **Tipo** | `Custom.ZendeskNatureza` ou título | Campo preenchido com: erro, incidente, melhoria ou dúvida. Se vazio, o agente verifica se o título menciona a natureza. |
| 2 | **Descrição do problema** | `System.Description` | **O agente lê a descrição e avalia se é um relato real.** Não basta ter texto — precisa explicar o que aconteceu. |
| 3 | **Sistema/módulo afetado** | `Custom.ZendeskModulo` | Campo preenchido com nome específico do módulo. Termos genéricos não contam. |
| 4 | **Caminho no menu** | `System.Description` | **O agente lê a descrição procurando contexto de localização.** Caminhos de navegação, nomes de tela específicos, ou indicação clara de onde no sistema o problema ocorre. |
| 5 | **Evidência anexada** | `relations[rel=AttachedFile]` ou `<img>` na descrição | Anexo formal (contagem > 0) ou imagem inline na descrição. |
| 6 | **Analista do Suporte** | `System.Description` | **O agente lê a descrição procurando nome ou assinatura do analista.** Nomes próprios com sobrenome, emails corporativos, ou assinatura identificável. |

---

## Critérios detalhados

### 1. Tipo

**O que é:** Classificação da natureza do chamado.

**Válido:**
- Campo `Custom.ZendeskNatureza` preenchido (erro, incidente, melhoria, dúvida)
- Ou título contendo uma dessas palavras-chave

**Inválido:**
- Campo vazio e título sem classificação

---

### 2. Descrição do problema

**O que é:** Relato claro do que está acontecendo de errado, do ponto de vista do usuário.

**Como o agente valida:** Leia o campo `descricaoTexto` e avalie se é um relato real que
permite ao dev entender o problema sem consultar o Zendesk. Uma boa descrição responde:
- O que o usuário estava fazendo?
- O que esperava que acontecesse?
- O que aconteceu de fato?

**Válido:**
- "Ao clicar em 'Emitir NF', o sistema fecha sem mensagem de erro"
- "O relatório de fechamento mensal retorna valores zerados para contratos do tipo X"
- "Usuário tenta cadastrar fornecedor e recebe erro 'campo CNPJ inválido' mesmo com CNPJ correto"

**Inválido:**
- "Ver ticket Zendesk #4521" — não descreve nada, apenas referencia outro sistema
- (campo vazio)
- Apenas o título repetido no corpo
- "O sistema está com problema" — texto genérico sem contexto
- "Conforme conversado" — sem detalhes do que foi conversado

---

### 3. Sistema ou módulo afetado

**O que é:** Identificação do software ou módulo específico onde o problema ocorre.

**Válido:**
- "GATEC_SAF"
- "Módulo de Faturamento — tela de emissão de NF"
- "Sistema GATEC — rotina de fechamento mensal"

**Inválido:**
- "o sistema"
- "o software"
- "o programa legado"
- Campo vazio

---

### 4. Caminho no menu

**O que é:** Caminho de navegação até a tela onde o problema ocorre.

**Como o agente valida:** Leia a descrição buscando ONDE no sistema o problema acontece.
Não basta a palavra "tela" aparecer — precisa identificar QUAL tela ou menu.

**Válido:**
- "Menu → Logística → Transporte → Romaneio"
- "Tela de emissão de NF" — identifica a tela específica
- "No cadastro de fornecedores, aba Dados Fiscais" — localização clara
- "Relatório de fechamento mensal (Menu > Contabilidade > Fechamento)" — caminho completo

**Inválido:**
- Nenhuma menção de navegação na descrição
- "A tela ficou em branco" — diz "tela" mas não diz QUAL tela
- "O sistema trava" — sem indicação de onde

> **Nota:** Se os 5 itens restantes (1,2,3,5,6) estão OK e apenas o caminho no menu
> está ausente, o agente classifica como **"Completa com ressalva"** em vez de incompleta.
> Nesse caso, NÃO aplica tag nem posta comentário — apenas registra ⚠️ no relatório.

---

### 5. Evidência anexada

**O que é:** Qualquer arquivo, imagem ou log que demonstre o problema.

**Válido:**
- Screenshot da tela com o erro (anexo ou `<img>` inline)
- Arquivo de log anexado
- Qualquer arquivo em `relations[rel=AttachedFile]`

**Inválido:**
- Nenhum anexo
- "Print enviado por email" (não está na issue)
- Link quebrado

---

### 6. Analista do Suporte

**O que é:** Nome do analista de suporte responsável pelo ticket.

**Como o agente valida:** Leia a descrição procurando identificação do analista responsável.
Pode aparecer como assinatura, email corporativo, ou menção explícita de quem está atendendo.

**Válido:**
- "Atenciosamente, João Silva" — assinatura com nome completo
- "joao.silva@empresa.com.br" — email identificável
- "Analista responsável: Maria Santos"
- "Atendido por: Carlos Oliveira"
- Qualquer nome próprio + sobrenome que identifique o responsável

**Inválido:**
- Nenhuma identificação de analista na descrição
- Apenas primeiro nome sem sobrenome ("João" — genérico demais)
- "Suporte" — não identifica pessoa específica

---

## Histórico de revisões

| Data | Alteração | Responsável |
|------|-----------|-------------|
| 2025 | Criação inicial com 3 critérios | Time de Manutenção |
| 2026-04 | Expandido para 6 critérios alinhados com script e checklist | Time de Manutenção |
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

### Fontes de informação

O agente analisa **três fontes** para validar cada item do checklist. Basta encontrar
a informação em **qualquer uma** delas:

1. **`descricaoTexto`** — Descrição principal da issue (campo Description)
2. **`comentarios`** — Comentários da Discussion (adicionados pelo Suporte após a abertura)
3. **`imagensLocais`** — Imagens inline baixadas (analisadas visualmente)

> **IMPORTANTE:** O time de Suporte frequentemente complementa a issue via comentários
> na Discussion em vez de editar a descrição. O agente **deve ler todos os comentários**
> procurando informações que completem os campos do checklist (descrição do problema,
> caminho no menu, evidência, analista).

### Análise de comentários (Discussion)

Quando o campo `comentarios` contiver itens, o agente **deve ler cada comentário**
e extrair informações relevantes:

- **Descrição do problema:** Detalhes adicionais, mensagens de erro, contexto
- **Caminho no menu:** Referências a telas, menus ou funcionalidades
- **Evidência:** Links para arquivos ou imagens em comentários
- **Analista:** Nome do autor do comentário pode ser o analista responsável

O agente deve mencionar no quadro quando a informação veio de um comentário:
*"ok (via comentário de João Silva em 2026-04-01)"*

### Análise de imagens

Quando o campo `imagensLocais` contiver caminhos de arquivo, o agente **deve visualizar
cada imagem** (usando `view_image`) e extrair informações relevantes para a validação:

- **Caminho no menu:** Se a imagem mostra uma tela do sistema, identifique qual tela é
  e use como evidência do caminho no menu.
- **Descrição do problema:** Se a imagem mostra uma mensagem de erro ou comportamento
  inesperado, use para complementar/validar a descrição textual.
- **Analista:** Se a imagem contém assinatura, nome ou email de analista, use como evidência.
- **Evidência:** Imagens baixadas confirmam que a evidência existe e é acessível.

O agente deve mencionar no comentário o que encontrou nas imagens, por exemplo:
*"Imagem 1 mostra mensagem de erro 'Campo CNPJ inválido' na tela de Cadastro de Fornecedores"*

---

## Checklist de validação (7 itens obrigatórios)

| # | Item | Campo API | Como o agente valida |
|---|---|---|---|
| 1 | **Tipo** | `Custom.ZendeskNatureza` ou título | Campo preenchido com: erro, incidente, melhoria ou dúvida. Se vazio, o agente verifica se o título menciona a natureza. |
| 2 | **Descrição do problema** | `System.Description` | **O agente lê a descrição e avalia se é um relato real.** Não basta ter texto — precisa explicar o que aconteceu. |
| 3 | **Sistema/módulo afetado** | `Custom.ZendeskModulo` | Campo preenchido com nome específico do módulo. Termos genéricos não contam. |
| 4 | **Caminho no menu** | `System.Description` | **O agente lê a descrição procurando contexto de localização.** Caminhos de navegação, nomes de tela específicos, ou indicação clara de onde no sistema o problema ocorre. |
| 5 | **Evidência anexada** | `relations[rel=AttachedFile]`, `<img>` na descrição, ou links externos | Anexo formal (contagem > 0), imagem inline na descrição, ou link externo para arquivo de evidência (ex: URLs Zendesk para `.pdf`, `.png`, `.docx`, etc.). |
| 6 | **Analista do Suporte** | `System.Description` | **O agente lê a descrição procurando nome ou assinatura do analista.** Nome próprio (mesmo sem sobrenome), emails corporativos, ou assinatura identificável. |
| 7 | **Versão** | `System.Description` | **O agente lê a descrição e comentários procurando a versão do sistema.** Marcadores como `Ver.`, `Versão`, `Versao`, `v` seguido de número. |

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

> **Nota:** Se os 6 itens restantes (1,2,3,5,6,7) estão OK e apenas o caminho no menu
> está ausente, o agente classifica como **"Completa com ressalva"** em vez de incompleta.
> Nesse caso, NÃO aplica tag nem posta comentário — apenas registra ⚠️ no relatório.

---

### 5. Evidência anexada

**O que é:** Qualquer arquivo, imagem ou log que demonstre o problema.

**Como o agente valida:** Verifica **três fontes** (basta uma positiva):
1. Anexos formais: campo `anexos > 0`
2. Imagens inline: campo `temImagensInline = true`
3. Links na descrição: **o agente lê `descricaoTexto` procurando URLs** que apontem para
   arquivos de evidência (ex: `.png`, `.jpg`, `.pdf`, `.docx`, `.xlsx`, `.txt`, `.mp3`, `.mp4`, `.zip`)
   ou URLs do Zendesk (`cxsenior.zendesk.com/attachments/token/`)

> **IMPORTANTE:** O campo `temImagensInline` pode ser `false` mesmo existindo imagens
> na descrição original (por limitação do fetch). **O agente DEVE sempre ler `descricaoTexto`**
> procurando URLs de imagem ou arquivo como verificação adicional.

**Válido:**
- Screenshot da tela com o erro (anexo ou `<img>` inline)
- Arquivo de log anexado
- Qualquer arquivo em `relations[rel=AttachedFile]`
- Link externo para arquivo de evidência na descrição (URLs do Zendesk apontando para `.pdf`, `.png`, `.jpg`, `.docx`, `.xlsx`, `.txt`, `.mp3`, `.mp4`, `.zip`)
- URLs de imagem na descrição (ex: `mceclip0.png`, `mceclip1.png`)

**Inválido:**
- Nenhum anexo, nenhuma imagem inline, e nenhum link de evidência na descrição
- "Print enviado por email" (não está na issue)
- Link quebrado
- Menção genérica de evidência sem link ou anexo (ex: "segue evidência" sem nada anexado)

---

### 6. Analista do Suporte

**O que é:** Nome do analista de suporte responsável pelo ticket.

**Como o agente valida:** Leia a descrição **inteira, incluindo o final do texto** procurando
identificação do analista responsável. Muitas vezes a assinatura ou campo `[ANALISTA DE SUPORTE]`
aparece nas **últimas linhas** da descrição.
Pode aparecer como assinatura, email corporativo, ou menção explícita de quem está atendendo.

> **IMPORTANTE:** Não truncar a leitura da descrição. O analista frequentemente está no final
> do texto, após seções como `[CONEXAO]` ou `[SIMULACAO]`.

**Válido:**
- "Atenciosamente, João Silva" — assinatura com nome completo
- "joao.silva@empresa.com.br" — email identificável
- "Analista responsável: Maria Santos"
- "Atendido por: Carlos Oliveira"
- "[ANALISTA DE SUPORTE] Evandro Gandelini" — campo estruturado com nome
- "Débora" — primeiro nome é suficiente para identificar o analista
- Qualquer nome próprio que identifique o responsável (com ou sem sobrenome)

**Inválido:**
- Nenhuma identificação de analista na descrição
- "Suporte" — não identifica pessoa específica
- Termos genéricos como "equipe", "atendente", "suporte técnico"

---

### 7. Versão

**O que é:** Versão do sistema em que o problema foi identificado.

**Como o agente valida:** Leia a descrição e comentários procurando marcadores de versão.
O campo é texto livre, então o formato pode variar. Procure por:
- Prefixos: `Ver.`, `Versão`, `Versao`, `Version`
- Padrão `v` + número: `v9.2`, `v2024`, `v9.2.1`
- Números de versão próximos a palavras-chave de versão

**Válido:**
- "Ver. 9.2.1"
- "Versão 2024.04.01"
- "v9.2"
- "Versao 9.2.1.3"
- "versão do sistema: 9.2"

**Inválido:**
- Nenhuma menção de versão na descrição ou comentários
- Número solto sem contexto de versão (ex: "9" isolado)
- "Versão atual" — sem o número

---

## Histórico de revisões

| Data | Alteração | Responsável |
|------|-----------|-------------|
| 2025 | Criação inicial com 3 critérios | Time de Manutenção |
| 2026-04 | Expandido para 6 critérios alinhados com script e checklist | Time de Manutenção |
| 2026-04-07 | Adicionado item 7: Versão | Time de Manutenção |
# Critérios de Validação de Issues — Path: Manutenção

> Este arquivo é a referência oficial do que torna uma issue válida para o time.
> O agente `validador-issues` usa este documento como base de validação.

---

## Por que isso importa

Issues chegam via integração automática Zendesk → Azure DevOps.
O Zendesk muitas vezes envia apenas o título do ticket e o número de referência.
Sem os campos abaixo, o dev inicia a investigação completamente às cegas no código VB6 legado.

---

## Critérios obrigatórios

### 1. Descrição do problema

**O que é:** Relato claro do que está acontecendo de errado, do ponto de vista do usuário.

**Válido:**
- "Ao clicar em 'Emitir NF', o sistema fecha sem mensagem de erro"
- "O relatório de fechamento mensal retorna valores zerados para contratos do tipo X"

**Inválido:**
- "Ver ticket Zendesk #4521"
- (campo vazio)
- Apenas o título repetido

---

### 2. Sistema ou módulo afetado

**O que é:** Identificação do software ou módulo específico onde o problema ocorre.

**Válido:**
- "Módulo de Faturamento — tela de emissão de NF"
- "Sistema GATEC — rotina de fechamento mensal"
- Area Path configurado com granularidade de módulo

**Inválido:**
- "o sistema"
- "o software"
- "o programa legado"
- Area Path genérico sem módulo identificado

---

### 3. Print ou evidência anexada

**O que é:** Qualquer arquivo, imagem ou log que demonstre o problema.

**Válido:**
- Screenshot da tela com o erro
- Arquivo de log anexado
- Link direto para evidência no corpo da descrição

**Inválido:**
- Nenhum anexo
- "Print enviado por email" (não está na issue)
- Link quebrado

---

## Histórico de revisões

| Data | Alteração | Responsável |
|------|-----------|-------------|
| 2025 | Criação inicial | Time de Manutenção |
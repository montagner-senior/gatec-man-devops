# Mapa de Sistemas VB6 Legados

## Objetivo

Catalogar os sistemas VB6 mantidos pelo time de Manutenção, com informações sobre localização no SVN, principais módulos e responsáveis. Este é um documento vivo — atualizado a cada nova investigação.

> 📌 **Regra do time:** Sempre que uma investigação revelar algo novo sobre um sistema (módulo desconhecido, tabela identificada, integração descoberta), atualize este arquivo **antes de fechar o ticket**.

---

## Como usar este mapa

1. Antes de iniciar uma investigação, consulte a seção do sistema afetado
2. Use as informações aqui para acelerar a localização dos arquivos no SVN
3. Ao descobrir algo novo, adicione na seção correspondente
4. Se o sistema não estiver listado aqui, crie uma nova seção usando o template abaixo

---

## Sistemas catalogados

<!-- TEMPLATE DE SISTEMA — copie e preencha para cada novo sistema
### <Nome do Sistema>

| Campo | Valor |
|---|---|
| **Nome no SVN** | `<nome-da-pasta-no-svn>` |
| **URL SVN** | `<url-do-repositorio>/<nome-sistema>/trunk` |
| **Banco de dados** | `<nome-do-banco>` em `<servidor>` |
| **Responsável técnico** | `<nome-do-dev-senior>` |
| **Última investigação** | `<data>` — ver achado: `<arquivo-de-achado>` |
| **Status** | 🟢 Estável / 🟡 Em manutenção / 🔴 Crítico |

**Descrição:**
[O que o sistema faz — em uma ou duas frases]

**Principais arquivos:**
| Arquivo | Tipo | Responsabilidade |
|---|---|---|
| `frmPrincipal.frm` | Formulário | Tela inicial / menu principal |
| `modGlobal.bas` | Módulo | Funções globais compartilhadas |

**Tabelas principais do banco:**
| Tabela | O que armazena |
|---|---|
| `CLIENTES` | Cadastro de clientes |

**Integrações conhecidas:**
- `<sistema externo>` via `<método: arquivo, API, banco compartilhado>`

**Observações:**
- [Pontos de atenção, comportamentos não óbvios, armadilhas conhecidas]
-->

---

## Sistema 1 — `<nome-do-sistema>`

| Campo | Valor |
|---|---|
| **Nome no SVN** | `<nome-da-pasta>` |
| **URL SVN** | `<url-do-repositorio>/<nome-da-pasta>/trunk` |
| **Banco de dados** | `<nome-do-banco>` em `<servidor>` |
| **Responsável técnico** | `<nome>` |
| **Última investigação** | — |
| **Status** | 🟡 A catalogar |

**Descrição:**
[Preencher conforme investigações forem realizadas]

**Principais arquivos:**
| Arquivo | Tipo | Responsabilidade |
|---|---|---|
| — | — | — |

**Tabelas principais do banco:**
| Tabela | O que armazena |
|---|---|
| — | — |

**Integrações conhecidas:**
- Nenhuma mapeada ainda

**Observações:**
- ⚠️ Sistema ainda não investigado pelo time. Preencher conforme achados surgirem.

---

## Sistema 2 — `<nome-do-sistema>`

| Campo | Valor |
|---|---|
| **Nome no SVN** | `<nome-da-pasta>` |
| **URL SVN** | `<url-do-repositorio>/<nome-da-pasta>/trunk` |
| **Banco de dados** | `<nome-do-banco>` em `<servidor>` |
| **Responsável técnico** | `<nome>` |
| **Última investigação** | — |
| **Status** | 🟡 A catalogar |

**Descrição:**
[Preencher conforme investigações forem realizadas]

**Principais arquivos:**
| Arquivo | Tipo | Responsabilidade |
|---|---|---|
| — | — | — |

**Tabelas principais do banco:**
| Tabela | O que armazena |
|---|---|
| — | — |

**Integrações conhecidas:**
- Nenhuma mapeada ainda

**Observações:**
- ⚠️ Sistema ainda não investigado pelo time. Preencher conforme achados surgirem.

---

## Legenda de status

| Status | Significado |
|---|---|
| 🟢 Estável | Sistema funciona bem, poucos tickets, baixo risco |
| 🟡 Em manutenção | Sistema com tickets frequentes ou em desenvolvimento ativo |
| 🔴 Crítico | Sistema com problemas recorrentes ou alto risco de falha |
| ⚪ A catalogar | Sistema ainda não investigado pelo time |

---

## Histórico de atualizações deste mapa

| Data | Sistema | O que foi adicionado/atualizado | Por quem |
|---|---|---|---|
| — | — | Documento criado | `<nome>` |

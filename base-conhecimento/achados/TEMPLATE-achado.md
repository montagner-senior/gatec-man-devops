# Achado — [Título breve do problema investigado]

- **Data:** AAAA-MM-DD
- **Sistema:** `<nome-do-sistema>`
- **Ticket de origem:** `#<número-do-work-item>` (Zendesk: `#<número-zendesk>`)
- **Dev responsável:** `<nome>`
- **Dev Sênior consultado:** `<nome ou "não consultado">`

---

## Problema relatado pelo Suporte

> Copie aqui o texto original da descrição do work item, conforme chegou do Zendesk.

[Descrição do que o Suporte/cliente reportou, sem alterações]

---

## O que foi investigado

Liste os arquivos e módulos analisados durante a investigação:

| Arquivo | Tipo | Função/Sub investigada | Observação |
|---|---|---|---|
| `NomeTela.frm` | Formulário | `cmdSalvar_Click` | Ponto de entrada do fluxo |
| `NomeModulo.bas` | Módulo | `CalculaDesconto()` | Lógica de cálculo identificada |
| `NomeClasse.cls` | Classe | `ValidaDados()` | - |

**Outros artefatos verificados:**
- [ ] Banco de dados / tabelas afetadas: `<nome-da-tabela>`
- [ ] Configurações / arquivos INI: `<nome-do-arquivo>`
- [ ] Relatórios / Crystal Reports: `<nome-do-relatório>`
- [ ] Integrações com sistemas externos: `<nome>`

---

## O que foi encontrado

Descreva os achados técnicos com o máximo de detalhes possível. Mesmo achados parciais são valiosos.

### Causa identificada

[Descreva a causa raiz do problema, ou escreva "Causa não identificada" se não foi possível determinar]

### Detalhes técnicos

```vb
' Trecho de código relevante (se aplicável)
' Copie aqui o trecho do VB6 que evidencia o problema
```

**Condição em que o problema ocorre:**
[Ex: "Ocorre apenas quando o campo X está vazio" / "Ocorre após a sequência de passos A → B → C"]

**Impacto:**
[Ex: "Afeta todos os pedidos com desconto acima de 10%" / "Afeta apenas clientes do tipo PJ"]

---

## Resposta enviada ao Suporte

> Copie aqui o texto do comentário "Resposta para o Suporte" adicionado no work item.

[Texto da resposta — em linguagem acessível, sem jargão técnico]

---

## Ação resultante

- [ ] **Encerrado** — sem ação adicional
- [ ] **Fix aberto** — Work Item: `#<número>`
- [ ] **Hotfix aberto** — Work Item: `#<número>`
- [ ] **Aguardando informações** do cliente — pergunta: `<o que foi solicitado>`
- [ ] **Escalado** para: `<equipe/pessoa>`

---

## Referências úteis para próximas investigações

Liste informações que ajudem quem vier investigar este sistema ou problema no futuro:

- **Módulo responsável pela funcionalidade:** `<nome do módulo>`
- **Tabelas do banco envolvidas:** `<nomes>`
- **Pontos de atenção no código:** [descreva armadilhas ou comportamentos não óbvios]
- **Documentação consultada:** [links ou referências de funções VB6, APIs, etc.]
- **Achados relacionados:** [links para outros arquivos em `achados/`]

---

> 💡 **Nota para o próximo dev:** [Escreva aqui qualquer orientação informal que você gostaria de ter recebido antes de começar esta investigação]

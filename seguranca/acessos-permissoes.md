# Acessos e Permissões no Azure DevOps

## Objetivo

Documentar como o time gerencia acessos ao Azure DevOps — quais perfis de permissão existem, como solicitar acesso e como revogar quando necessário.

## Pré-requisitos

- Este documento é gerenciado pela **Gerência**
- Devs não alteram permissões — apenas solicitam à Gerência

---

## Perfis de acesso (Roles)

O Azure DevOps possui três níveis de acesso principais utilizados pelo time:

| Perfil | Quem tem | O que pode fazer |
|---|---|---|
| **Stakeholder** | Gerência, Suporte (leitura) | Visualizar work items, adicionar comentários, consultar boards |
| **Basic** | Desenvolvedores | Criar/editar work items, executar pipelines aprovados, acessar código-fonte |
| **Project Administrator** | Gerência técnica | Configurar o projeto, gerenciar membros, configurar pipelines e permissões |

> 📌 **Regra do time:** Nenhum dev deve ter permissão de **Project Administrator** sem autorização explícita da Gerência. O princípio de menor privilégio se aplica.

---

## Grupos de segurança do projeto

Dentro do projeto `<nome-do-projeto>`, os seguintes grupos de segurança são utilizados:

| Grupo | Membros | Permissões |
|---|---|---|
| `<nome-do-projeto>` **Readers** | Suporte, stakeholders | Somente leitura |
| `<nome-do-projeto>` **Contributors** | Devs do time | Leitura e escrita em work items e pipelines |
| `<nome-do-projeto>` **Project Administrators** | Gerência técnica | Administração completa do projeto |

---

## Como solicitar acesso

### Para novos membros do time

1. O gestor imediato envia solicitação por e-mail para `<responsável-de-TI ou admin-do-devops>` com:
   - Nome completo do novo membro
   - E-mail corporativo
   - Perfil solicitado (Stakeholder / Basic)
   - Data de início
2. O administrador cria o convite no Azure DevOps → **Project Settings** → **Users** → **Add Users**
3. O novo membro recebe um e-mail de convite e deve aceitar no link enviado
4. Após aceitar, o administrador adiciona ao grupo de segurança correto

### Para acesso temporário (prestadores, auditoria)

1. Solicitação deve ser feita pela Gerência, com data de início e fim definidas
2. Ao final do período, o administrador revoga o acesso imediatamente

> ⚠️ **Atenção:** Acessos temporários devem ser documentados com data de expiração. O gestor é responsável por solicitar a revogação na data acordada.

---

## Como revogar acesso

Quando um membro deixar o time (desligamento, transferência, término de contrato):

### Checklist de revogação

1. **Azure DevOps:**
   - [ ] Remover do projeto: **Project Settings** → **Users** → localizar o usuário → **Remove from project**
   - [ ] Verificar se o usuário tem work items atribuídos — redistribuir antes da remoção

2. **SVN:**
   - [ ] Solicitar à TI a revogação das credenciais SVN do usuário

3. **Outros acessos:**
   - [ ] Acessos a servidores de produção (se houver)
   - [ ] Acessos à VPN (se houver)
   - [ ] Conta de e-mail corporativa (responsabilidade da TI)

> ⚠️ **Atenção:** A revogação de acesso do Azure DevOps deve ocorrer **no mesmo dia** do desligamento, preferencialmente antes que o colaborador seja informado. Isso é especialmente crítico para acesso a pipelines de produção.

---

## Permissões de pipeline

### Quem pode executar pipelines

| Pipeline | Quem pode executar |
|---|---|
| **Build (CI)** | Executado automaticamente via commit SVN |
| **Deploy em Homologação** | Dev + aprovação do Dev Sênior |
| **Deploy em Produção** | Apenas com aprovação da Gerência |
| **Rollback em Produção** | Apenas com aprovação da Gerência |

### Como configurar aprovações no pipeline

> 📌 **Regra do time:** As aprovações de pipeline são configuradas pelo administrador do projeto (Gerência técnica). Não altere configurações de pipeline sem autorização.

As aprovações estão configuradas em:
**Azure DevOps → Pipelines → Releases → `<nome-do-pipeline>` → Edit → [Estágio Produção] → Pre-deployment conditions → Approvals**

---

## Auditoria de acessos

A Gerência deve realizar revisão trimestral dos acessos ao Azure DevOps:

| Verificação | Frequência |
|---|---|
| Listar todos os usuários com acesso ao projeto | Trimestral |
| Verificar se prestadores temporários foram removidos | Mensal |
| Revisar permissões de pipeline | Semestral |
| Verificar logs de execução de pipelines de produção | Mensal |

**Como listar usuários com acesso:**
1. Azure DevOps → **Project Settings** (engrenagem no canto inferior esquerdo)
2. **Users** — lista todos os usuários com acesso ao projeto
3. Exporte a lista e compare com o quadro de funcionários ativos

---

## Boas práticas de segurança

| Prática | Por quê |
|---|---|
| Nunca compartilhar credenciais de acesso ao DevOps | Auditoria requer rastreabilidade por usuário |
| Nunca dar acesso de admin a devs sem necessidade | Princípio de menor privilégio |
| Revogar acesso imediatamente no desligamento | Evita acesso não autorizado pós-saída |
| Usar autenticação com MFA (quando disponível) | Protege contra credenciais comprometidas |
| Nunca usar conta de serviço para acesso humano | Conta de serviço não deve ter acesso interativo |

---

## Observações e Alertas

> ⚠️ **Atenção:** O Azure DevOps registra log de todas as ações realizadas. Qualquer acesso indevido ou alteração não autorizada pode ser rastreada pela Gerência.

> 💡 **Dica:** Se você perdeu acesso ao Azure DevOps (senha expirada, convite não chegou), contate diretamente a Gerência ou o administrador do projeto. Não tente criar uma nova conta por conta própria.

> 📌 **Regra do time:** Acessos ao Azure DevOps são **pessoais e intransferíveis**. Não forneça suas credenciais a colegas mesmo que temporariamente — solicite que a Gerência crie um acesso adequado para a situação.

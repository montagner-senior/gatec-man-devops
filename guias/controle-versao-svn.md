# Controle de Versão com Tortoise SVN

## Objetivo

Explicar como usar o **Tortoise SVN** para acessar, atualizar e enviar alterações no código-fonte dos sistemas VB6 legados. Este guia é voltado para quem nunca usou controle de versão ou está iniciando no time.

## Pré-requisitos

- **Tortoise SVN** instalado na máquina (versão 1.14 ou superior)
  - Download: https://tortoisesvn.net/downloads.html
- Acesso ao repositório SVN concedido pelo administrador: `<url-do-repositorio-svn>`
- Credenciais de acesso ao SVN (usuário e senha) fornecidas pela TI

---

## O que é o SVN?

O **SVN (Subversion)** é um sistema de controle de versão. Ele mantém o histórico de todos os arquivos de código-fonte, permite que múltiplos desenvolvedores trabalhem nos mesmos projetos e registra quem alterou o quê e quando.

O **Tortoise SVN** é a interface visual (integrada ao Windows Explorer) para trabalhar com SVN — você interage com ele pelo botão direito do mouse em pastas e arquivos.

> 💡 **Dica:** Pense no SVN como uma "pasta compartilhada inteligente" que salva automaticamente cada versão anterior de cada arquivo, permitindo voltar no tempo se algo der errado.

> 📌 **Regra do time:** Todo o código-fonte dos sistemas VB6 está **exclusivamente** no SVN. Não existe cópia do código em Git, GitHub ou qualquer outra plataforma de versionamento.

---

## Estrutura do repositório SVN

O repositório SVN está organizado por sistema:

```
<url-do-repositorio-svn>/
├── <nome-sistema-1>/
│   ├── trunk/          ← Versão principal (em uso em produção)
│   └── tags/           ← Versões lançadas (histórico de releases)
├── <nome-sistema-2>/
│   ├── trunk/
│   └── tags/
└── ...
```

> 📌 **Regra do time:** O desenvolvimento sempre ocorre no `trunk`. A pasta `tags` é gerenciada pela Gerência e pelo Dev Sênior — **não altere tags** sem autorização.

---

## Operações do dia a dia

### Fazendo o checkout (primeira vez)

O **checkout** é o processo de baixar o código-fonte do servidor SVN para sua máquina pela primeira vez.

1. Crie uma pasta local para o projeto: `C:\SVN\<nome-do-sistema>\`
2. Abra o Windows Explorer e navegue até essa pasta
3. Clique com o botão direito dentro da pasta → **"SVN Checkout..."**
4. Na janela que abrir:
   - **URL of repository:** `<url-do-repositorio-svn>/<nome-do-sistema>/trunk`
   - **Checkout directory:** `C:\SVN\<nome-do-sistema>`
5. Clique em **OK**
6. Informe seu usuário e senha do SVN quando solicitado
7. Aguarde o download dos arquivos

> ⚠️ **Atenção:** Faça checkout apenas do `trunk`. Nunca faça checkout da raiz do repositório inteiro — isso pode baixar gigabytes de dados.

---

### SVN Update — Atualizando seu código local

Antes de começar qualquer trabalho, **sempre** atualize seu código local para garantir que você tem a versão mais recente.

1. Navegue até a pasta do sistema: `C:\SVN\<nome-do-sistema>\`
2. Clique com o botão direito na pasta → **"SVN Update"**
3. Aguarde — uma janela mostrará os arquivos que foram atualizados
4. Verifique se apareceu algum **conflito** (ícone vermelho). Se sim, consulte o Dev Sênior.

> 📌 **Regra do time:** Faça `SVN Update` **antes de qualquer alteração**, sem exceção. Trabalhar em código desatualizado gera conflitos e pode sobrescrever o trabalho de outros.

---

### SVN Commit — Enviando suas alterações

O **commit** é o ato de enviar suas alterações para o repositório SVN, tornando-as disponíveis para todo o time.

1. Após concluir suas alterações nos arquivos VB6, navegue até a pasta do sistema
2. Clique com o botão direito na pasta → **"SVN Commit..."**
3. Na janela que abrir:
   - Confira os arquivos listados (são os que você alterou)
   - Desmarque arquivos que **não** devem ser enviados (arquivos de compilação `.exe`, `.obj`, etc.)
4. No campo **"Message"** (mensagem), escreva uma descrição clara do que foi alterado:

**Formato da mensagem de commit:**

```
[TIPO] #<número-work-item> - Descrição do que foi alterado

Exemplo:
[FIX] #1234 - Corrige cálculo de desconto em pedidos acima de 1000 unidades
[HOTFIX] #5678 - Corrige erro crítico na emissão de nota fiscal
[USER-STORY] #9012 - Adiciona filtro por data na tela de relatório de vendas
```

5. Clique em **OK**
6. Informe suas credenciais se solicitado

> ⚠️ **Atenção:** Nunca faça commit de arquivos compilados (`.exe`, `.dll`, `.obj`). Apenas arquivos de código-fonte (`.frm`, `.bas`, `.cls`, `.vbp`, `.frx`, `.res`) devem ser versionados.

> ⚠️ **Atenção:** Nunca faça commit sem uma mensagem descritiva. Mensagens genéricas como "correção" ou "atualização" dificultam o rastreamento histórico.

---

### SVN Log — Consultando o histórico

Para ver quem alterou um arquivo e quando:

1. Clique com o botão direito no arquivo ou pasta → **"TortoiseSVN"** → **"Show Log"**
2. Na janela que abrir, você verá:
   - Data e hora de cada commit
   - Usuário que fez o commit
   - Mensagem do commit
   - Arquivos alterados naquele commit
3. Clique em qualquer linha para ver os detalhes
4. Clique com o botão direito em uma entrada → **"Compare with working copy"** para ver o que mudou

---

### SVN Diff — Comparando versões

Para ver exatamente o que mudou em um arquivo entre duas versões:

1. Clique com o botão direito no arquivo → **"TortoiseSVN"** → **"Diff"**
2. A ferramenta de comparação abrirá mostrando as diferenças linha a linha:
   - **Verde:** linhas adicionadas
   - **Vermelho:** linhas removidas/alteradas

---

### SVN Revert — Desfazendo alterações locais

Se você fez alterações e quer **desfazer tudo** e voltar ao estado do repositório:

1. Clique com o botão direito na pasta ou arquivo → **"TortoiseSVN"** → **"Revert..."**
2. Selecione os arquivos que deseja restaurar
3. Clique em **OK**

> ⚠️ **Atenção:** O Revert **apaga suas alterações locais permanentemente**. Só use se tiver certeza de que não quer manter nenhuma das mudanças feitas.

---

## Ícones do Tortoise SVN no Windows Explorer

O Tortoise SVN exibe ícones nos arquivos para indicar seu estado:

| Ícone | Significado |
|---|---|
| ✅ Verde | Arquivo em sincronia com o repositório |
| ✏️ Vermelho | Arquivo modificado localmente (ainda não enviado) |
| ➕ Azul | Arquivo novo adicionado (ainda não commitado) |
| ⚡ Amarelo | Conflito — precisa de resolução manual |
| 🔒 Cadeado | Arquivo bloqueado por outro usuário |

---

## Resolução de conflitos

Um **conflito** ocorre quando dois desenvolvedores alteram o mesmo trecho de código ao mesmo tempo.

> ⚠️ **Atenção:** Nunca resolva um conflito sem consultar o Dev Sênior ou o colega que também alterou o arquivo. Resolver errado pode fazer você perder o trabalho de outra pessoa.

**Quando ocorrer um conflito:**

1. Não entre em pânico
2. Consulte o SVN Log para descobrir quem também alterou o arquivo (`Show Log`)
3. Fale com a pessoa e decidam juntos qual versão manter
4. Clique com o botão direito no arquivo conflitado → **"TortoiseSVN"** → **"Edit Conflicts"**
5. Na ferramenta de merge, aceite a versão correta ou combine as duas
6. Após resolver, clique com o botão direito → **"TortoiseSVN"** → **"Mark as Resolved"**
7. Faça o commit

---

## Boas práticas

| Prática | Por quê |
|---|---|
| Sempre fazer `SVN Update` antes de começar | Evita conflitos e trabalho perdido |
| Commits pequenos e frequentes | Facilita rastreamento e rollback se necessário |
| Mensagem de commit com número do work item | Liga o código ao Azure DevOps |
| Nunca commitar arquivos compilados | Poluem o repositório e geram conflitos binários |
| Comunicar ao time antes de grandes alterações em módulos compartilhados | Evita conflitos simultâneos |

---

## Observações e Alertas

> 💡 **Dica:** Se a pasta local perdeu o acesso ao SVN (ex: senha expirou, URL mudou), clique com o botão direito → **"TortoiseSVN"** → **"Relocate"** para corrigir o caminho do repositório.

> 💡 **Dica:** Para encontrar em qual commit uma linha específica foi alterada, clique com o botão direito no arquivo → **"TortoiseSVN"** → **"Blame"** (Anotar) — isso mostra, linha a linha, qual commit e qual usuário foi responsável.

> 📌 **Regra do time:** Commits relacionados a um Hotfix devem ser feitos **antes** do deploy de emergência, mesmo que seja um commit rápido. O histórico de quando a correção foi aplicada é auditável.

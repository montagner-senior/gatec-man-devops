---
title: Critérios de Validação de Segurança
parent: Agentes
nav_order: 7
---

# Critérios de Validação de Segurança — Security Validator

> Este arquivo é a referência oficial dos padrões que o agente `security-validator` procura.
> O agente usa este documento como base de validação ao analisar arquivos alterados.

---

## Por que isso importa

Credenciais e dados sensíveis commitados no repositório representam risco real de comprometimento.
Uma vez no histórico do Git/SVN, mesmo que removidos depois, ficam acessíveis.
O time trabalha com sistemas VB6 legados onde é comum encontrar connection strings e senhas
hardcoded diretamente no código-fonte.

> **Nota para o agente:** Este documento é sua referência principal de validação.
> Use seu julgamento ao analisar cada item — não use apenas regex.
> Analise o contexto do código para distinguir credenciais reais de referências seguras.

---

## Categorias de dados sensíveis (9 itens)

### 1. Secrets / API Keys

**O que é:** Chaves de API, tokens de acesso e secrets de serviços externos.

**Severidade:** 🔴 Crítica

**Padrões a procurar:**
- Prefixos conhecidos: `sk-`, `pk-`, `ak-`, `AKIA`, `ghp_`, `gho_`, `github_pat_`, `xoxb-`, `xoxp-`
- Atribuições: `apiKey = "..."`, `token = "..."`, `secret = "..."`
- Headers: `Authorization: Bearer <token_real>`, `X-Api-Key: <valor>`
- Em VB6: `Const API_KEY = "..."`, `sToken = "..."`

**Válido (seguro — NÃO reportar):**
- `apiKey = Environ("API_KEY")`
- `token = GetSetting(App.Title, "Config", "Token")`
- `apiKey = ""` (placeholder vazio)
- `apiKey = "<insira_aqui>"` (documentação)
- `' Exemplo: apiKey = "sk-..." ' ← comentário de documentação com valor parcial`

**Inválido (inseguro — REPORTAR):**
- `Const API_KEY = "sk-proj-abc123def456ghi789"`
- `apiKey = "ghp_1234567890abcdef1234567890abcdef12345678"`
- `sBearer = "eyJhbGciOiJIUzI1NiIs..."` (JWT completo)

---

### 2. Senhas hardcoded

**O que é:** Senhas atribuídas diretamente como string literal no código.

**Severidade:** 🔴 Crítica

**Padrões a procurar:**
- Variáveis: `password`, `pwd`, `passwd`, `pass`, `senha`, `sPassword`, `sSenha`
- Constantes: `Const PASSWORD = "..."`, `Private Const PWD = "..."`
- Parâmetros: `.Password = "..."`, `password:="valor"`
- Em VB6: `sPassword = "P@ssw0rd"`, `txtSenha.Text = "123"`

**Válido (seguro — NÃO reportar):**
- `password = Environ("DB_PASSWORD")`
- `password = InputBox("Digite a senha")`
- `password = ""` (string vazia)
- `password = GetConfigValue("password")`
- `password = vbNullString`
- `' password = "exemplo"` — comentário com exemplo (avaliar contexto)

**Inválido (inseguro — REPORTAR):**
- `sPassword = "P@ssw0rd!"`
- `Const DB_PWD = "admin123"`
- `pwd = "SenhaDoSistema2024"`
- `.Password = "sa"` (senha do sa do SQL Server)

---

### 3. Connection strings com credenciais

**O que é:** Strings de conexão ao banco de dados contendo usuário e senha embutidos.

**Severidade:** 🔴 Crítica

**Padrões a procurar:**
- `ConnectionString` com `Password=` ou `Pwd=` embutido
- `Provider=...;Data Source=...;User ID=...;Password=...`
- `Server=...;Database=...;Uid=...;Pwd=...`
- Em VB6: `sConn = "Provider=SQLOLEDB;..."`, `cn.Open "..."`, `ADODB.Connection`
- Arquivos `.udl`, `.dsn`, `.ini` com credenciais

**Válido (seguro — NÃO reportar):**
- `connectionString = ConfigurationManager.ConnectionStrings("MyDB")`
- `sConn = GetSetting(App.Title, "Config", "ConnectionString")`
- `Integrated Security=SSPI` / `Trusted_Connection=Yes` (autenticação Windows)
- `connectionString = Environ("CONN_STRING")`
- Connection string com `Password=;` (vazio)

**Inválido (inseguro — REPORTAR):**
- `sConn = "Provider=SQLOLEDB;Server=SRVPROD;Database=DB01;User ID=sa;Password=S3nh@123"`
- `cn.Open "Driver={SQL Server};Server=192.168.1.10;Uid=admin;Pwd=admin123"`
- `Data Source=srv;Initial Catalog=DB;User ID=app_user;Password=Pr0dP@ss!`

---

### 4. Chaves privadas

**O que é:** Blocos de chave privada criptográfica ou arquivos de certificado.

**Severidade:** 🔴 Crítica

**Padrões a procurar:**
- Blocos PEM: `-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----`
- Arquivos: `.pem`, `.pfx`, `.p12`, `.key`, `.jks`, `.keystore` adicionados ao repo
- Referências a chaves inline no código

**Válido (seguro — NÃO reportar):**
- Caminho para arquivo de chave (sem o conteúdo): `keyPath = "/certs/private.pem"`
- Chave pública (somente `PUBLIC KEY`)
- `.gitignore` listando `*.pem`, `*.pfx`

**Inválido (inseguro — REPORTAR):**
- Bloco `-----BEGIN RSA PRIVATE KEY-----` no código ou em arquivo commitado
- Arquivo `.pfx` ou `.p12` adicionado ao repositório
- Chave privada inline em variável

---

### 5. Arquivos sensíveis commitados

**O que é:** Arquivos que por natureza contêm dados sensíveis e não deveriam estar no repositório.

**Severidade:** 🟠 Alta

**Extensões a procurar:**
- `.env`, `.env.local`, `.env.production`, `.env.staging`
- `.pfx`, `.p12`, `.pem`, `.key`, `.jks`, `.keystore`
- `web.config` / `app.config` com `connectionStrings` preenchidas
- `.ini` com seções de credenciais (ex: `[Database]` com `Password=`)

**Válido (seguro — NÃO reportar):**
- `.env.example` com valores placeholder (`DB_PASSWORD=`)
- `.gitignore` que lista esses arquivos
- `web.config.example`

**Inválido (inseguro — REPORTAR):**
- `.env` com `DB_PASSWORD=SenhaReal123`
- `config.ini` com `Password=admin`
- `certificado.pfx` adicionado ao repo

---

### 6. Dados pessoais (LGPD)

**O que é:** Dados pessoais identificáveis em massa no código.

**Severidade:** 🟠 Alta

**Padrões a procurar:**
- CPFs: `\d{3}\.\d{3}\.\d{3}-\d{2}` ou `\d{11}` em contexto de CPF
- Números de cartão de crédito: 16 dígitos agrupados (`\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}`)
- Listas de emails pessoais hardcoded
- RGs, CNPJs com dados reais (não de teste)

**Válido (seguro — NÃO reportar):**
- CPFs de teste/exemplo conhecidos: `000.000.000-00`, `111.111.111-11`
- Regex de validação de CPF (o padrão em si, não dados reais)
- Máscaras de formatação: `###.###.###-##`

**Inválido (inseguro — REPORTAR):**
- Lista de CPFs reais hardcoded no código
- Cartões de crédito com números reais
- Arrays/tabelas com dados pessoais de clientes

---

### 7. Tokens JWT com secret fixo

**O que é:** Secrets usados para assinar tokens JWT hardcoded no código.

**Severidade:** 🟠 Alta

**Padrões a procurar:**
- `JwtSecret = "..."`, `SigningKey = "..."`, `SecretKey = "..."`
- `HMACSHA256("secret_fixo")`, `new SymmetricSecurityKey(Encoding.UTF8.GetBytes("..."))`

**Válido (seguro — NÃO reportar):**
- `jwtSecret = Environ("JWT_SECRET")`
- `signingKey = Configuration["Jwt:Key"]`

**Inválido (inseguro — REPORTAR):**
- `Const JWT_SECRET = "minha-chave-super-secreta-2024"`
- `HMACSHA256("chave_fixa_producao")`

---

### 8. Credenciais em comentários

**O que é:** Senhas, tokens ou credenciais escritas em comentários do código.

**Severidade:** 🟡 Média

**Padrões a procurar:**
- Em VB6: `' senha: xxx`, `' password: xxx`, `' user/pass: xxx/yyy`
- Em outros: `// TODO: trocar senha (atual: abc123)`, `/* conn: user=sa pwd=123 */`
- Comentários com "senha temporária", "provisório", "trocar depois"

**Válido (seguro — NÃO reportar):**
- `' Exemplo de uso: password = Environ("PWD")`
- `' TODO: implementar autenticação via vault`
- Comentários que mencionam "senha" em contexto genérico sem expor valor

**Inválido (inseguro — REPORTAR):**
- `' Senha do servidor: Admin@2024`
- `' Para conectar use: sa / S3nh@Pr0d`
- `' TEMP: usando senha root123 até configurar vault`

---

### 9. URLs com credenciais

**O que é:** URLs que contêm credenciais no formato `user:password@host`.

**Severidade:** 🟠 Alta

**Padrões a procurar:**
- `http(s)://user:pass@host`
- `ftp://admin:senha@servidor`
- URLs de banco: `mongodb://user:pass@host`, `postgres://user:pass@host`

**Válido (seguro — NÃO reportar):**
- `http://user:pass@localhost` (desenvolvimento local, avaliar contexto)
- `https://${USER}:${PASS}@host` (variáveis de ambiente)

**Inválido (inseguro — REPORTAR):**
- `https://admin:P@ssw0rd@api.producao.com.br`
- `ftp://deploy:S3nh@2024@192.168.1.50`

---

## Critérios de severidade

| Severidade | Ícone | Critério | Ação recomendada |
|------------|-------|----------|------------------|
| **Crítica** | 🔴 | Credencial real exposta, risco imediato de comprometimento | Corrigir antes do merge, rotacionar a credencial |
| **Alta** | 🟠 | Dado sensível exposto ou arquivo que não deveria ser commitado | Corrigir antes do merge |
| **Média** | 🟡 | Prática insegura, risco menor ou indireto | Corrigir quando possível |

---

## Padrões específicos VB6

O time trabalha primariamente com VB6. Estes são os padrões mais comuns de risco:

| Padrão VB6 | Exemplo | Risco |
|------------|---------|-------|
| Connection string hardcoded | `sConn = "Provider=SQLOLEDB;...Password=..."` | 🔴 Crítica |
| Senha em constante | `Private Const SENHA = "abc"` | 🔴 Crítica |
| Credencial em `.ini` | `[DB]\nPassword=valor` | 🔴 Crítica |
| Senha em comentário | `' pwd do srv: admin123` | 🟡 Média |
| Arquivo `.udl` com credenciais | `Password=valor` dentro do `.udl` | 🔴 Crítica |
| `SaveSetting` com senha | `SaveSetting App.Title, "Config", "Pwd", "valor"` | 🟠 Alta |

---

## Regra de sanitização

Ao reportar um achado, **nunca exiba o valor completo** da credencial.
Mostre apenas os primeiros 4 caracteres seguidos de `****`:

- `sk-proj-abc123...` → `sk-p****`
- `P@ssw0rd!` → `P@ss****`
- `Password=SenhaDoSistema` → `Password=Senh****`
- Connection string longa → mostre apenas o trecho `Password=xxxx****`

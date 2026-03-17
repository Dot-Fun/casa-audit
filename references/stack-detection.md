# Stack Detection Reference

Auto-detect project technology stack, classify OAuth scope sensitivity, and recommend CASA tier.

---

## 1. Language & Runtime Detection

Detect primary languages by checking for manifest files and common file extensions.

### Manifest-Based Detection

| Signal File               | Language / Runtime | Grep Pattern (ripgrep)                         | Glob Pattern          |
| ------------------------- | ------------------ | ---------------------------------------------- | --------------------- |
| `package.json`            | JavaScript / TS    | n/a (file existence)                           | `**/package.json`     |
| `tsconfig.json`           | TypeScript         | n/a                                            | `**/tsconfig.json`    |
| `requirements.txt`        | Python             | n/a                                            | `**/requirements.txt` |
| `pyproject.toml`          | Python             | n/a                                            | `**/pyproject.toml`   |
| `setup.py`                | Python             | n/a                                            | `**/setup.py`         |
| `Pipfile`                 | Python             | n/a                                            | `**/Pipfile`          |
| `go.mod`                  | Go                 | n/a                                            | `**/go.mod`           |
| `Cargo.toml`              | Rust               | n/a                                            | `**/Cargo.toml`       |
| `pom.xml`                 | Java (Maven)       | n/a                                            | `**/pom.xml`          |
| `build.gradle`            | Java / Kotlin      | n/a                                            | `**/build.gradle*`    |
| `Gemfile`                 | Ruby               | n/a                                            | `**/Gemfile`          |
| `*.csproj` / `*.sln`      | C# / .NET          | n/a                                            | `**/*.csproj`         |
| `composer.json`           | PHP                | n/a                                            | `**/composer.json`    |
| `mix.exs`                 | Elixir             | n/a                                            | `**/mix.exs`          |
| `pubspec.yaml`            | Dart / Flutter     | n/a                                            | `**/pubspec.yaml`     |

### Extension-Based Fallback

When no manifest is found, count file extensions to determine dominant language:

```
*.ts, *.tsx        → TypeScript
*.js, *.jsx, *.mjs → JavaScript
*.py               → Python
*.go               → Go
*.rs               → Rust
*.java             → Java
*.kt               → Kotlin
*.rb               → Ruby
*.cs               → C#
*.php              → PHP
*.ex, *.exs        → Elixir
*.swift            → Swift
```

---

## 2. Framework Detection

### JavaScript / TypeScript Frameworks

| Framework       | Detection Pattern (grep in package.json)                         | Detection File                          |
| --------------- | ---------------------------------------------------------------- | --------------------------------------- |
| Next.js         | `"next"\s*:`                                                     | `next.config.*`                         |
| React           | `"react"\s*:`                                                    | —                                       |
| Angular         | `"@angular/core"\s*:`                                            | `angular.json`                          |
| Vue.js          | `"vue"\s*:`                                                      | `vue.config.*`, `nuxt.config.*`         |
| Nuxt            | `"nuxt"\s*:`                                                     | `nuxt.config.*`                         |
| Express         | `"express"\s*:`                                                  | —                                       |
| Fastify         | `"fastify"\s*:`                                                  | —                                       |
| NestJS          | `"@nestjs/core"\s*:`                                             | `nest-cli.json`                         |
| Hono            | `"hono"\s*:`                                                     | —                                       |
| Remix           | `"@remix-run/node"\s*:`                                          | `remix.config.*`                        |
| SvelteKit       | `"@sveltejs/kit"\s*:`                                            | `svelte.config.*`                       |
| Astro           | `"astro"\s*:`                                                    | `astro.config.*`                        |
| Electron        | `"electron"\s*:`                                                 | —                                       |

### Python Frameworks

| Framework       | Detection (grep in requirements.txt / pyproject.toml)            | Detection File                          |
| --------------- | ---------------------------------------------------------------- | --------------------------------------- |
| Django          | `django[>=<~!]` or `Django`                                      | `manage.py`, `settings.py`             |
| Flask           | `flask[>=<~!]` or `Flask`                                        | —                                       |
| FastAPI         | `fastapi[>=<~!]`                                                 | —                                       |
| Tornado         | `tornado[>=<~!]`                                                 | —                                       |
| Pyramid         | `pyramid[>=<~!]`                                                 | —                                       |
| Starlette       | `starlette[>=<~!]`                                               | —                                       |

### Go Frameworks

| Framework       | Detection (grep in go.mod)                                       |
| --------------- | ---------------------------------------------------------------- |
| Gin             | `github.com/gin-gonic/gin`                                       |
| Echo            | `github.com/labstack/echo`                                       |
| Fiber           | `github.com/gofiber/fiber`                                       |
| Chi             | `github.com/go-chi/chi`                                          |
| Gorilla Mux     | `github.com/gorilla/mux`                                         |

**Stdlib detection** (not in go.mod — grep source files instead):

| Framework       | Detection (grep in `**/*.go`)                                    |
| --------------- | ---------------------------------------------------------------- |
| net/http (std)  | `"net/http"`                                                     |

### Java Frameworks

| Framework       | Detection (grep in pom.xml / build.gradle)                       |
| --------------- | ---------------------------------------------------------------- |
| Spring Boot     | `spring-boot-starter`                                            |
| Micronaut       | `io.micronaut`                                                   |
| Quarkus         | `io.quarkus`                                                     |
| Jakarta EE      | `jakarta.` or `javax.servlet`                                    |
| Vert.x          | `io.vertx`                                                       |
| Dropwizard      | `io.dropwizard`                                                  |

### Ruby Frameworks

| Framework       | Detection (grep in Gemfile)                                      |
| --------------- | ---------------------------------------------------------------- |
| Rails           | `gem ['"]rails['"]`                                              |
| Sinatra         | `gem ['"]sinatra['"]`                                            |
| Hanami          | `gem ['"]hanami['"]`                                             |

### C# / .NET Frameworks

| Framework       | Detection (grep in *.csproj)                                     |
| --------------- | ---------------------------------------------------------------- |
| ASP.NET Core    | `Microsoft.AspNetCore`                                           |
| Blazor          | `Microsoft.AspNetCore.Components`                                |
| .NET MAUI       | `Microsoft.Maui`                                                 |

---

## 3. Authentication Library Detection

### Layer 1: Grep Patterns

Detect auth libraries in dependency manifests. These determine which ASVS auth controls apply.

| Auth Library             | Language    | Grep Pattern                                          | Glob Target                        | Auth Type              |
| ------------------------ | ----------- | ----------------------------------------------------- | ---------------------------------- | ---------------------- |
| Passport.js              | JS/TS       | `"passport"\s*:`                                      | `**/package.json`                  | Multi-strategy         |
| NextAuth / Auth.js       | JS/TS       | `"next-auth"\s*:` or `"@auth/core"\s*:`               | `**/package.json`                  | OAuth / Credentials    |
| jsonwebtoken             | JS/TS       | `"jsonwebtoken"\s*:`                                  | `**/package.json`                  | JWT                    |
| jose                     | JS/TS       | `"jose"\s*:`                                          | `**/package.json`                  | JWT / JWE / JWK        |
| bcrypt / bcryptjs        | JS/TS       | `"bcrypt(js)?"\s*:`                                   | `**/package.json`                  | Password hashing       |
| argon2                   | JS/TS       | `"argon2"\s*:`                                        | `**/package.json`                  | Password hashing       |
| Supabase Auth            | JS/TS       | `"@supabase/supabase-js"\s*:` or `"@supabase/auth"`  | `**/package.json`                  | OAuth / Email / Phone  |
| Firebase Auth            | JS/TS       | `"firebase"\s*:` or `"@firebase/auth"\s*:`            | `**/package.json`                  | OAuth / Email / Phone  |
| Clerk                    | JS/TS       | `"@clerk/"`                                           | `**/package.json`                  | Managed auth           |
| Auth0                    | JS/TS       | `"@auth0/"`                                           | `**/package.json`                  | OAuth / OIDC           |
| Lucia                    | JS/TS       | `"lucia"\s*:`                                         | `**/package.json`                  | Session-based          |
| Django Auth              | Python      | `django.contrib.auth`                                 | `**/*.py`                          | Session / Password     |
| Django Allauth           | Python      | `allauth`                                             | `**/requirements*.txt`, `**/pyproject.toml` | OAuth / Social  |
| Flask-Login              | Python      | `flask.login` or `flask-login`                        | `**/requirements*.txt`             | Session                |
| PyJWT                    | Python      | `PyJWT` or `import jwt`                               | `**/requirements*.txt`, `**/*.py`  | JWT                    |
| python-jose              | Python      | `python-jose` or `from jose`                          | `**/requirements*.txt`, `**/*.py`  | JWT                    |
| Authlib                  | Python      | `authlib`                                             | `**/requirements*.txt`             | OAuth / OIDC           |
| passlib                  | Python      | `passlib`                                             | `**/requirements*.txt`             | Password hashing       |
| Spring Security          | Java        | `spring-boot-starter-security` or `spring-security`   | `**/pom.xml`, `**/build.gradle*`   | Multi-strategy         |
| Keycloak adapter         | Java        | `keycloak-spring` or `org.keycloak`                   | `**/pom.xml`, `**/build.gradle*`   | OAuth / OIDC           |
| Devise                   | Ruby        | `gem ['"]devise['"]`                                  | `**/Gemfile`                       | Session / Password     |
| OmniAuth                 | Ruby        | `gem ['"]omniauth['"]`                                | `**/Gemfile`                       | OAuth                  |
| bcrypt (Go)              | Go          | `golang.org/x/crypto/bcrypt`                          | `**/go.mod`, `**/*.go`             | Password hashing       |
| golang-jwt               | Go          | `github.com/golang-jwt/jwt`                           | `**/go.mod`                        | JWT                    |
| ASP.NET Identity         | C#          | `Microsoft.AspNetCore.Identity`                       | `**/*.csproj`                      | Session / Password     |
| IdentityServer           | C#          | `Duende.IdentityServer` or `IdentityServer4`          | `**/*.csproj`                      | OAuth / OIDC           |

### Layer 2: Auth Pattern Classification

After detecting libraries, classify the auth approach:

| Auth Approach            | Indicators                                                          | ASVS Focus Areas        |
| ------------------------ | ------------------------------------------------------------------- | ----------------------- |
| **Password-based**       | bcrypt/argon2/passlib + login forms                                 | V2.1 (password policy)  |
| **JWT stateless**        | jsonwebtoken/jose/PyJWT + no session store                          | V3.5 (token mgmt)      |
| **Session-based**        | express-session/Flask-Login/Devise + session store                  | V3.1-V3.4 (sessions)   |
| **OAuth / OIDC**         | passport-google/allauth/Auth0/OmniAuth                             | V2.5, V3.5 (federation)|
| **Managed auth (BaaS)**  | Supabase/Firebase/Clerk/Auth0                                      | V1.8 (data protection)  |
| **API key only**         | Custom header checks, no user auth                                 | V4.1 (access control)   |
| **mTLS / Certificate**   | TLS client certs, mutual TLS config                                | V9.1 (communications)   |

---

## 4. Database & ORM Detection

| ORM / Driver             | Language    | Grep Pattern                                          | Glob Target                        | DB Type           |
| ------------------------ | ----------- | ----------------------------------------------------- | ---------------------------------- | ----------------- |
| Prisma                   | JS/TS       | `"@prisma/client"\s*:` or `"prisma"\s*:`              | `**/package.json`                  | SQL (multi)       |
| Drizzle                  | JS/TS       | `"drizzle-orm"\s*:`                                   | `**/package.json`                  | SQL (multi)       |
| TypeORM                  | JS/TS       | `"typeorm"\s*:`                                       | `**/package.json`                  | SQL (multi)       |
| Sequelize                | JS/TS       | `"sequelize"\s*:`                                     | `**/package.json`                  | SQL (multi)       |
| Knex                     | JS/TS       | `"knex"\s*:`                                          | `**/package.json`                  | SQL (multi)       |
| Mongoose                 | JS/TS       | `"mongoose"\s*:`                                      | `**/package.json`                  | MongoDB           |
| pg / mysql2 / better-sqlite3 | JS/TS  | `"pg"\s*:` or `"mysql2"\s*:` or `"better-sqlite3"`   | `**/package.json`                  | Raw SQL driver    |
| ioredis / redis          | JS/TS       | `"ioredis"\s*:` or `"redis"\s*:`                      | `**/package.json`                  | Redis             |
| Django ORM               | Python      | `from django.db import models`                        | `**/*.py`                          | SQL (multi)       |
| SQLAlchemy               | Python      | `sqlalchemy` or `from sqlalchemy`                     | `**/requirements*.txt`, `**/*.py`  | SQL (multi)       |
| Tortoise ORM             | Python      | `tortoise-orm` or `from tortoise`                     | `**/requirements*.txt`, `**/*.py`  | SQL (multi)       |
| psycopg2 / asyncpg       | Python      | `psycopg2` or `asyncpg`                               | `**/requirements*.txt`             | PostgreSQL        |
| PyMongo                  | Python      | `pymongo`                                             | `**/requirements*.txt`             | MongoDB           |
| GORM                     | Go          | `gorm.io/gorm`                                        | `**/go.mod`                        | SQL (multi)       |
| sqlx                     | Go          | `github.com/jmoiron/sqlx`                             | `**/go.mod`                        | SQL (multi)       |
| pgx                      | Go          | `github.com/jackc/pgx`                                | `**/go.mod`                        | PostgreSQL        |
| go-redis                 | Go          | `github.com/redis/go-redis` or `github.com/go-redis`  | `**/go.mod`                        | Redis             |
| Hibernate                | Java        | `hibernate` or `javax.persistence`                    | `**/pom.xml`, `**/build.gradle*`   | SQL (multi)       |
| Spring Data JPA          | Java        | `spring-boot-starter-data-jpa`                        | `**/pom.xml`, `**/build.gradle*`   | SQL (multi)       |
| MyBatis                  | Java        | `mybatis`                                             | `**/pom.xml`, `**/build.gradle*`   | SQL (multi)       |
| ActiveRecord             | Ruby        | `activerecord` (via Rails)                            | `**/Gemfile`                       | SQL (multi)       |
| Entity Framework         | C#          | `Microsoft.EntityFrameworkCore`                       | `**/*.csproj`                      | SQL (multi)       |
| Dapper                   | C#          | `Dapper`                                              | `**/*.csproj`                      | SQL (micro-ORM)   |

### Raw SQL Detection (Cross-Language)

Detect raw/interpolated SQL patterns that indicate potential injection risk:

```
Pattern:  (query|execute|raw|sql)\s*\(.*["'`]\s*\+
Glob:     **/*.{ts,js,py,go,java,rb,cs,php}
Purpose:  String concatenation in SQL calls — JS/TS/Java (potential SQLi)
Note:     Matches: query("SELECT * FROM " + userInput), execute('DELETE FROM ' + table)
```

```
Pattern:  (query|execute|raw|sql)\s*\(.*\$\{
Glob:     **/*.{ts,js}
Purpose:  Template literal interpolation in SQL calls — JS/TS (potential SQLi)
Note:     Matches: query(`SELECT * FROM ${table}`)
```

```
Pattern:  f["'].*SELECT|f["'].*INSERT|f["'].*UPDATE|f["'].*DELETE
Glob:     **/*.py
Purpose:  Python f-string SQL (potential SQLi)
```

```
Pattern:  fmt\.Sprintf\(["'].*(?:SELECT|INSERT|UPDATE|DELETE)
Glob:     **/*.go
Purpose:  Go format-string SQL (potential SQLi)
```

---

## 5. Infrastructure & Deployment Detection

| Infrastructure           | Detection Signal                                                    | Glob / Grep                          |
| ------------------------ | ------------------------------------------------------------------- | ------------------------------------ |
| Docker                   | `Dockerfile`, `docker-compose.yml`                                  | `**/Dockerfile*`, `**/docker-compose*` |
| Kubernetes               | `kind: Deployment`, `kind: Service`, Helm charts                    | `**/*.yaml`, `**/Chart.yaml`         |
| Terraform                | `resource "`, `provider "`                                          | `**/*.tf`                            |
| Pulumi                   | `Pulumi.yaml`                                                       | `**/Pulumi.yaml`                     |
| AWS CDK                  | `"aws-cdk-lib"\s*:` or `from aws_cdk`                              | `**/package.json`, `**/*.py`         |
| Serverless Framework     | `serverless.yml`                                                    | `**/serverless.yml`                  |
| Vercel                   | `vercel.json`                                                       | `**/vercel.json`                     |
| Netlify                  | `netlify.toml`                                                      | `**/netlify.toml`                    |
| GitHub Actions           | `.github/workflows/*.yml`                                           | `.github/workflows/*.yml`            |
| GitLab CI                | `.gitlab-ci.yml`                                                    | `**/.gitlab-ci.yml`                  |
| CircleCI                 | `.circleci/config.yml`                                              | `.circleci/config.yml`               |

### Cloud Provider Detection

| Provider   | Grep Pattern                                                               | Glob Target                          |
| ---------- | -------------------------------------------------------------------------- | ------------------------------------ |
| AWS        | `aws-sdk` or `boto3` or `provider\s*"aws"` or `amazonaws.com`             | `**/package.json`, `**/*.py`, `**/*.tf` |
| GCP        | `@google-cloud/` or `google-cloud-` or `provider\s*"google"`              | `**/package.json`, `**/*.py`, `**/*.tf` |
| Azure      | `@azure/` or `azure-` or `provider\s*"azurerm"`                           | `**/package.json`, `**/*.py`, `**/*.tf` |
| Supabase   | `@supabase/` or `SUPABASE_URL`                                            | `**/package.json`, `**/.env*`        |
| Firebase   | `firebase` or `FIREBASE_`                                                  | `**/package.json`, `**/.env*`        |

---

## 6. Secrets & Sensitive Data Detection

Detect hardcoded secrets and sensitive patterns that always warrant findings regardless of stack:

| Pattern Name              | Grep Pattern (ripgrep)                                              | Glob                                 |
| ------------------------- | ------------------------------------------------------------------- | ------------------------------------ |
| AWS Access Key            | `AKIA[0-9A-Z]{16}`                                                  | `**/*` (exclude `node_modules`)      |
| AWS Secret Key            | `(?i)aws.{0,20}secret.{0,20}['\"][0-9a-zA-Z/+]{40}`               | `**/*`                               |
| Generic API Key           | `(?i)(api[_-]?key|apikey)\s*[=:]\s*['"][a-zA-Z0-9]{20,}`           | `**/*`                               |
| Private Key               | `-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----`                  | `**/*`                               |
| GitHub Token              | `gh[ps]_[A-Za-z0-9_]{36,}`                                         | `**/*`                               |
| Slack Token               | `xox[bpors]-[0-9a-zA-Z-]{10,}`                                     | `**/*`                               |
| Stripe Secret Key         | `sk_(live|test)_[0-9a-zA-Z]{24,}`                                   | `**/*`                               |
| JWT secret in code        | `(?i)(jwt[_-]?secret|token[_-]?secret)\s*[=:]\s*['"][^'"]{8,}`     | `**/*.{ts,js,py,go,java,rb,cs,env}`  |
| Password in config        | `(?i)password\s*[=:]\s*['"][^'"]{4,}`                              | `**/*.{yml,yaml,toml,json,env,cfg,ini,conf}` |
| Database URL with creds   | `(?i)(postgres|mysql|mongodb)://\w+:[^@]+@`                         | `**/*`                               |
| .env committed            | n/a (file existence check)                                          | `**/.env`, `**/.env.local`, `**/.env.production` |

### False-Positive Filters

Exclude these paths from secrets scanning:
- `**/node_modules/**`
- `**/.git/**`
- `**/vendor/**`
- `**/dist/**`, `**/build/**`, `**/.next/**`
- `**/*.lock`, `**/pnpm-lock.yaml`, `**/package-lock.json`
- `**/*.test.*`, `**/*.spec.*`, `**/__tests__/**` (flag but lower severity)
- `**/*.example`, `**/.env.example` (template files — PASS)
- `**/fixtures/**`, `**/mocks/**`

---

## 7. OAuth Scope Classification

> **Last verified:** March 2026. Google periodically updates scope classifications. Verify current lists at [OAuth 2.0 Scopes for Google APIs](https://developers.google.com/identity/protocols/oauth2/scopes) (scroll to "Scopes by sensitivity").

Google classifies OAuth scopes into three sensitivity levels. The classification determines verification requirements and CASA tier.

### Non-Sensitive Scopes

Access to basic, low-risk, or public data. No Google review required.

| Scope Pattern                                                      | API                   |
| ------------------------------------------------------------------ | --------------------- |
| `openid`                                                           | OpenID Connect        |
| `profile`                                                          | OpenID Connect        |
| `email`                                                            | OpenID Connect        |
| `.../auth/userinfo.email`                                          | People                |
| `.../auth/userinfo.profile`                                        | People                |
| `.../auth/drive.file`                                              | Drive (per-file)      |
| `.../auth/calendar.readonly`                                       | Calendar              |
| `.../auth/calendar.events.readonly`                                | Calendar              |
| `.../auth/contacts.readonly`                                       | Contacts              |
| `.../auth/youtube.readonly`                                        | YouTube               |
| `.../auth/spreadsheets.readonly`                                   | Sheets                |

### Sensitive Scopes

Access to significant user data. Requires Google review. May require CASA Tier 1-2.

| Scope Pattern                                                      | API                   |
| ------------------------------------------------------------------ | --------------------- |
| `.../auth/calendar` (read-write)                                   | Calendar              |
| `.../auth/calendar.events`                                         | Calendar              |
| `.../auth/contacts`                                                | Contacts              |
| `.../auth/drive`                                                   | Drive (full)          |
| `.../auth/drive.readonly`                                          | Drive                 |
| `.../auth/spreadsheets`                                            | Sheets                |
| `.../auth/documents`                                               | Docs                  |
| `.../auth/presentations`                                           | Slides                |
| `.../auth/youtube`                                                 | YouTube               |
| `.../auth/youtube.upload`                                          | YouTube               |
| `.../auth/fitness.activity.read`                                   | Fitness               |
| `.../auth/fitness.body.read`                                       | Fitness               |
| `.../auth/photoslibrary`                                           | Photos                |
| `.../auth/admin.directory.user`                                    | Admin SDK             |

### Restricted Scopes

Wide access to Google user data. Requires CASA security assessment (Tier 2-3). Annual recertification.

| Scope Pattern                                                      | API                   |
| ------------------------------------------------------------------ | --------------------- |
| `https://mail.google.com/`                                         | Gmail (full)          |
| `.../auth/gmail.modify`                                            | Gmail                 |
| `.../auth/gmail.compose`                                           | Gmail                 |
| `.../auth/gmail.insert`                                            | Gmail                 |
| `.../auth/gmail.metadata`                                          | Gmail                 |
| `.../auth/gmail.readonly`                                          | Gmail                 |
| `.../auth/gmail.send`                                              | Gmail                 |
| `.../auth/gmail.settings.basic`                                    | Gmail                 |
| `.../auth/gmail.settings.sharing`                                  | Gmail                 |
| `.../auth/drive.appdata`                                           | Drive (app data)      |
| `.../auth/cloud-platform`                                          | Cloud Platform (full) |
| `.../auth/admin.directory.user.security`                           | Admin SDK (security)  |
| `.../auth/cloudkms`                                                | Cloud KMS             |
| `.../auth/chat.messages`                                           | Google Chat           |
| `.../auth/chat.spaces`                                             | Google Chat           |

### Scope Detection in Code

Grep for OAuth scope references to classify the application:

```
# Google OAuth scope patterns in code
Pattern:  googleapis\.com/auth/\S+
Glob:     **/*.{ts,js,py,go,java,rb,cs,json,yaml,yml,env}
Purpose:  Find all Google OAuth scopes used by the application

# Common scope variable patterns
Pattern:  (?i)(scopes?|SCOPES?)\s*[=:]\s*\[
Glob:     **/*.{ts,js,py,go,java,rb,cs}
Purpose:  Find scope array definitions
```

---

## 8. CASA Tier Decision Matrix

Tier assignment is determined by the framework user (e.g., Google) based on risk factors. Use this matrix to **recommend** the likely tier.

### Risk Factor Scoring

| Factor                    | Low Risk (0)                  | Medium Risk (1)               | High Risk (2)                 |
| ------------------------- | ----------------------------- | ----------------------------- | ----------------------------- |
| **OAuth Scope Level**     | Non-sensitive only            | Sensitive scopes              | Restricted scopes             |
| **Data Sensitivity**      | Public data / no PII          | PII (name, email, phone)      | Financial / health / auth credentials |
| **User Volume**           | < 100 users                   | 100 – 100,000 users           | > 100,000 users               |
| **Server-Side Access**    | Client-only (SPA / mobile)    | Server processes data         | Server stores Google user data |
| **Auth Complexity**       | Single OAuth provider only    | Password + OAuth              | Custom auth + federation      |

### Tier Recommendation Rules

```
Total Score = sum of all risk factors (0-10)

Score 0-2  → Tier 1 (Developer self-scan, ADA validates)
Score 3-5  → Tier 2 (Developer/lab scan, lab verifies)
Score 6+   → Tier 3 (Full lab assessment, 60 hours)
```

### Override Rules (Always Apply)

| Condition                                              | Forced Tier |
| ------------------------------------------------------ | ----------- |
| Any restricted Google OAuth scope                      | Tier 2+     |
| Server stores restricted-scope Google user data        | Tier 3      |
| App handles payment / financial data                   | Tier 2+     |
| App handles health / medical data                      | Tier 3      |
| App has > 1M users with sensitive scopes               | Tier 3      |
| Google explicitly specifies tier in notification email  | As specified |

### Tier → Assessment Method

| Tier | Assessment Hours | Method                                               | ASVS Coverage          |
| ---- | ---------------- | ---------------------------------------------------- | ----------------------- |
| 1    | ~2               | Developer scans with CASA tools → ADA validates      | All 73 CASA controls    |
| 2    | ~4               | Developer/lab scans → authorized lab verifies results | All 73 CASA controls    |
| 3    | ~60              | Authorized lab full assessment + pentest              | All 73 CASA controls    |

> **Note:** CASA officially defines Tiers 1-3 only. The ADA tiering page references a "Tier 0" (developer self-assessment with no external validation), but it is not an official CASA assurance level and provides no Letter of Validation.

---

## 9. Detection Algorithm

Use this algorithm to auto-detect and classify a project:

### Step 1: Identify Languages
```
FOR each manifest pattern in §1:
  IF file exists → add language to detected_languages[]
FALLBACK: count file extensions → top 3 by count
```

### Step 2: Identify Frameworks
```
FOR each detected language:
  FOR each framework pattern in §2:
    Grep in corresponding manifest → add to detected_frameworks[]
```

### Step 3: Classify Auth
```
FOR each auth library pattern in §3:
  IF found → classify auth approach per §3 Layer 2
  Record: auth_type, auth_libraries[], manages_passwords (bool)
```

### Step 4: Detect Data Storage
```
FOR each ORM/driver pattern in §4:
  IF found → record db_type, orm_name
  Run raw SQL detection patterns → flag if positive
```

### Step 5: Detect Infrastructure
```
FOR each infra pattern in §5:
  IF found → record cloud_provider, deployment_method, ci_cd
```

### Step 6: Scan for Secrets
```
FOR each secret pattern in §6:
  Run grep excluding false-positive paths
  Any match → CRITICAL finding regardless of tier
```

### Step 7: Classify OAuth Scopes
```
Grep for Google OAuth scopes in code (§7)
FOR each scope found:
  Classify as non-sensitive / sensitive / restricted per §7 tables
  Record highest_scope_level
```

### Step 8: Recommend CASA Tier
```
Calculate risk score per §8
Apply override rules
Output: recommended_tier, risk_factors[], override_reason (if any)
```

### Output Format

The detection results feed into the audit coordinator as a structured context:

```
Stack Profile:
  Languages:      [TypeScript, Python]
  Frameworks:     [Next.js, NestJS, FastAPI]
  Auth:           [Supabase Auth, JWT] → OAuth/BaaS approach
  Database:       [PostgreSQL via Prisma, Redis via ioredis]
  Infrastructure: [Docker, AWS ECS, GitHub Actions]
  Cloud:          [AWS, Supabase]
  OAuth Scopes:   [calendar.events (sensitive), gmail.readonly (restricted)]
  Secrets Found:  [0 hardcoded secrets]

CASA Recommendation:
  Tier:           3 (restricted scope override)
  Risk Score:     7/10
  Override:       "gmail.readonly is a restricted Google scope"
```

# Detection Patterns Reference

Grep/glob patterns and false-positive guidance for all 73 CASA-required ASVS controls.
Each control has Layer 1 (automated scan) and Layer 2 (false-positive elimination / manual review).

Controls marked **Manual review** have no reliable static pattern -- the specialist agent must review architecture and runtime behavior instead.

---

## V1: Architecture, Design and Threat Modeling (5 controls)

### V1.1.4 — Trust boundary documentation

**Layer 1 — Pattern Scan**
Manual review — no reliable static pattern. Check for architecture documentation:
```
Glob: **/ARCHITECTURE.md, **/docs/architecture*, **/docs/threat-model*, **/docs/security*
```

**Layer 2 — False Positive Guidance**
- True finding: no architecture docs, or docs exist but omit trust boundaries
- PASS if documented trust boundaries cover: external users, internal services, databases, third-party APIs
- FAIL if no architecture or threat-model documentation found

### V1.4.1 — Access control enforced server-side, never on client alone

**Layer 1 — Pattern Scan**
```
(?i)(canActivate|isAuthenticated|isAuthorized|checkPermission|requireRole)\b
```
Glob: `**/*.{ts,tsx,js,jsx,vue,svelte}`

Cross-reference with server-side patterns:
```
(?i)(@UseGuards|@PreAuthorize|@Secured|@login_required|@permission_required|middleware.*auth|authorize)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: auth/permission checks exist ONLY in frontend code with no corresponding server-side enforcement
- False positive: frontend hides UI elements for UX while server enforces access (defense in depth)
- Framework guards (NestJS @UseGuards, Django @login_required) on backend = PASS

### V1.8.1 — Sensitive data identified and classified

**Layer 1 — Pattern Scan**
Manual review — no reliable static pattern. Check for classification docs:
```
Glob: **/docs/data-classification*, **/docs/privacy*, **/PRIVACY*, **/DATA_CLASSIFICATION*
```
```
(?i)(pii|personally.identifiable|sensitive.data|data.classification|gdpr|ccpa)
```
Glob: `**/*.md, **/*.txt, **/*.rst`

**Layer 2 — False Positive Guidance**
- True finding: no data classification documentation exists
- PASS if docs list data categories (PII, financial, health, auth) with classification levels
- FAIL if no data classification exists

### V1.8.2 — Protection levels with associated requirements

**Layer 1 — Pattern Scan**
Manual review — no reliable static pattern. Same docs as V1.8.1.
Look for encryption, integrity, retention, and privacy requirements per data category.

**Layer 2 — False Positive Guidance**
- True finding: data is classified but no protection requirements defined
- PASS if classification docs specify encryption at rest, access controls, retention periods per category
- FAIL if data is classified but protection requirements missing

### V1.14.6 — No deprecated client-side technologies

**Layer 1 — Pattern Scan**
```
(?i)(<applet|<object\s|<embed\s|ActiveXObject|document\.all\b|<marquee|<blink|<frame\s|<frameset)
```
Glob: `**/*.{html,htm,jsx,tsx,ejs,hbs,pug}`
```
(?i)(flash|silverlight|java\s+applet|shockwave|nacl|Native\s*Client)
```
Glob: `**/*.{html,htm,js,ts}`

**Layer 2 — False Positive Guidance**
- True finding: SWF/FLV files in assets, applet tags, ActiveX references
- False positive: references in comments or docs only, polyfills for modern features
- CWE-477 (deprecated tech)

---

## V2: Authentication (7 controls)

### V2.1.1 — Passwords at least 12 characters

**Layer 1 — Pattern Scan**
```
(?i)(min.?len(gth)?\s*[=:]\s*[0-9]{1,2}\b|minLength\s*[=:]\s*[0-9]{1,2}\b|password.*min.*[0-9]{1,2}\b)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: password minimum length set below 12
- False positive: min length on non-password fields (username, search)
- BaaS auth (Supabase/Firebase) may enforce server-side -- check provider config
- OAuth-only apps (no passwords) = N/A

### V2.3.1 — System-generated initial passwords >= 6 chars

**Layer 1 — Pattern Scan**
```
(?i)(generate.?password|temp.?password|initial.?password|activation.?code|reset.?code|one.?time.?password|otp)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(randomBytes\s*\(\s*[1-2]\)|random.choices.*k\s*=\s*[1-5]\b)
```
Glob: `**/*.{ts,js,py}`

**Layer 2 — False Positive Guidance**
- True finding: generated passwords/codes under 6 characters, codes that never expire
- False positive: user-chosen passwords (covered by V2.1.1)
- Verify generated codes contain letters and/or numbers and expire after a short period

### V2.4.1 — Password hashing with approved algorithms

**Layer 1 — Pattern Scan**
```
(?i)(bcrypt|scrypt|argon2|argon2id|pbkdf2|PBKDF2)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}, **/package.json, **/requirements*.txt, **/go.mod`
```
(?i)(md5\s*\(.*password|sha1\s*\(.*password|sha256\s*\(.*password(?!.*pbkdf))
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: passwords hashed with MD5, SHA-1, SHA-256 (without key stretching), or stored in plaintext
- False positive: MD5/SHA used for non-password hashing (checksums, cache keys)
- PASS: bcrypt with cost >= 10, argon2id, scrypt, PBKDF2 with >= 600k iterations
- BaaS handles hashing = PASS if provider uses approved algorithm

### V2.5.4 — No shared or default accounts

**Layer 1 — Pattern Scan**
```
(?i)(default.?password|admin.*password\s*[=:]\s*['"]|password\s*[=:]\s*['"]password['"]|password\s*[=:]\s*['"]admin['"]|password\s*[=:]\s*['"]123)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,yaml,yml,json,toml,env}`

**Layer 2 — False Positive Guidance**
- True finding: hardcoded credentials in production code, shared service accounts
- False positive: test/fixture/mock files, environment-based credentials, seed scripts with placeholders
- Exclude test directories from FAIL verdicts

### V2.6.1 — Lookup secrets single-use

**Layer 1 — Pattern Scan**
```
(?i)(lookup.?secret|recovery.?code|backup.?code|one.?time.?code)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(used\s*[=:]\s*true|mark.*used|delete.*after.*use|invalidate.*after|consume.*token)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: recovery/backup codes can be reused without being invalidated
- False positive: OTP codes that are single-use by nature (TOTP rotates)
- PASS if lookup secrets are deleted or marked used after first successful verification

### V2.7.2 — OOB verifiers expire after 10 minutes

**Layer 1 — Pattern Scan**
```
(?i)(otp.*expir|code.*expir|verification.*expir|token.*expir|expires.?in|ttl|time.?to.?live)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(expir.*[=:]\s*\d+|ttl\s*[=:]\s*\d+|maxAge\s*[=:]\s*\d+)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: OTP/verification codes with expiration > 10 minutes or no expiration
- False positive: session token expiration (different control), JWT lifetime
- PASS if OOB verifier expiration <= 10 minutes (600 seconds)

### V2.7.6 — OOB codes sent only to pre-registered channels

**Layer 1 — Pattern Scan**
```
(?i)(send.?otp|send.?code|send.?verification|send.?sms|send.?email.*code)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: verification codes sent to user-supplied (unverified) email/phone
- False positive: codes sent to email/phone already on file and verified
- Manual review required: verify the channel (email, phone) was pre-registered and verified before sending OOB codes

---

## V3: Session Management (8 controls)

### V3.3.1 — Logout invalidates session token

**Layer 1 — Pattern Scan**
```
(?i)(session\.destroy|session\.invalidate|req\.logout|signOut|sign.?out|logout|clearSession|revoke.?token)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: logout only clears client-side cookie without server-side invalidation
- False positive: JWT with short expiry + refresh token revocation on logout
- JWT with no server-side blacklist on logout = FAIL (token remains valid until expiry)

### V3.3.3 — Option to terminate all sessions on password change

**Layer 1 — Pattern Scan**
```
(?i)(terminate.*session|revoke.*all.*session|invalidate.*all.*session|logout.*all|sign.?out.*all|kill.*session|destroy.*all.*session)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(change.?password|update.?password|reset.?password)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: password change succeeds but other sessions remain active with no option to invalidate them
- False positive: automatic session revocation on password change (even better than optional)
- PASS if user can choose to end all other sessions after password change

### V3.4.1 — Cookie Secure attribute

**Layer 1 — Pattern Scan**
```
(?i)(cookie.*secure\s*:\s*false|secure\s*:\s*false)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: session cookies set without Secure flag in production
- False positive: conditional secure flag based on environment
- secure: true = PASS, secure: false in production = FAIL

### V3.4.2 — Cookie HttpOnly attribute

**Layer 1 — Pattern Scan**
```
(?i)(httpOnly\s*:\s*false|http_only\s*[=:]\s*False|HttpOnly\s*=\s*false)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: session cookie with httpOnly: false
- False positive: CSRF token cookie may legitimately have httpOnly: false
- httpOnly: true on session cookies = PASS

### V3.4.3 — Cookie SameSite attribute

**Layer 1 — Pattern Scan**
```
(?i)(sameSite\s*:\s*['"]?(none|lax|strict)['"]?)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: SameSite=None without Secure=true
- False positive: SameSite=None with Secure=true for legitimate cross-site use (e.g., OAuth)
- SameSite=Strict or SameSite=Lax = PASS

### V3.5.2 — Session tokens rather than static API keys

**Layer 1 — Pattern Scan**
```
(?i)(api.?key\s*[=:]\s*['"][A-Za-z0-9_-]{20,}|x-api-key|apikey|static.*secret|hardcoded.*token)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(Bearer|jwt|session.?token|access.?token|refresh.?token)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: long-lived static API keys used for user authentication instead of session tokens
- False positive: service-to-service API keys (legacy systems), environment-based secrets
- PASS if user auth uses session tokens (JWT, opaque tokens); static keys for M2M = REVIEW

### V3.5.3 — Stateless token signing and encryption

**Layer 1 — Pattern Scan**
```
(?i)(jwt\.sign|jwt\.verify|jsonwebtoken|jose|JWS|JWE|algorithm.*none|alg.*none)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(algorithm\s*[=:]\s*['"]none['"]|algorithms\s*[=:].*none|verify\s*[=:]\s*false)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: JWT with alg: none accepted, token verification disabled, symmetric key with weak secret
- False positive: properly signed JWTs with RS256/ES256
- FAIL if none algorithm accepted, if verify: false, or if null cipher used

### V3.7.1 — Reauthentication for sensitive transactions

**Layer 1 — Pattern Scan**
```
(?i)(re.?auth|confirm.?password|verify.?password|step.?up|elevated.?session|sudo.?mode)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: account deletion, email change, or payment changes proceed without reauthentication
- False positive: low-risk operations that do not require reauthentication
- PASS if password/MFA confirmation required before sensitive operations

---

## V4: Access Control (8 controls)

### V4.1.1 — Access control on trusted service layer

**Layer 1 — Pattern Scan**
```
(?i)(@UseGuards|@PreAuthorize|@Secured|@RolesAllowed|@login_required|@permission_required|@requires_auth|authorize|middleware.*auth)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: routes accessible without any auth middleware; client-side-only access control
- False positive: intentionally public endpoints (health checks, landing pages)
- Server middleware/guards consistently applied = PASS

### V4.1.2 — Access control attributes not user-manipulable

**Layer 1 — Pattern Scan**
```
(?i)(req\.body\.role|req\.body\.is_?admin|request\.data\[['"]role['"]\]|params\[['"]role['"]\])
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: role or privilege fields accepted from user-controlled request body
- False positive: role from JWT claims (server-verified), DTO with explicit field exclusion
- Mass-assignment protection (allowlisting fields) = PASS

### V4.1.3 — Least privilege access

**Layer 1 — Pattern Scan**
```
(?i)(role\s*===?\s*['"]admin['"]|is_?superuser|is_?staff|has_?all_?permissions)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: binary admin/non-admin with no granular permissions
- False positive: admin check as one of multiple fine-grained roles
- Fine-grained permissions (RBAC, RLS policies) = PASS

### V4.1.5 — Access controls fail securely

**Layer 1 — Pattern Scan**
```
(?i)(catch.*\{[^}]*(next\(\)|return\s+true|allow|grant)|err\s*=>\s*(next\(\)|null)|on.?error.*allow|default.*permit)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: access control catch blocks that default to allowing access on error
- False positive: error handlers that log and re-throw, or return 403/401
- PASS if exceptions in access control logic result in DENY by default

### V4.2.1 — IDOR protection

**Layer 1 — Pattern Scan**
```
(?i)(params\.(id|userId|user_id)|req\.params\.\w*[Ii]d)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: resource fetched by ID alone without verifying the requesting user owns/has access
- False positive: resource access with ownership check (e.g., WHERE id = ? AND org_id = ?)
- RLS policies = PASS; parameterized queries with org/user scoping = PASS

### V4.2.2 — Anti-CSRF mechanism

**Layer 1 — Pattern Scan**
```
(?i)(csrf|xsrf|_token|csrfmiddleware|@csrf_protect|antiforgery|SameSite)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: cookie-based auth without CSRF tokens or SameSite cookies
- False positive: JWT in Authorization header (inherently not vulnerable to CSRF)
- SameSite cookies = PASS; CSRF token in forms = PASS; cookie auth without protections = FAIL

### V4.3.1 — Admin MFA

**Layer 1 — Pattern Scan**
```
(?i)(mfa|multi.?factor|two.?factor|2fa|totp|authenticator|webauthn|fido)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: admin login is password-only without MFA option
- False positive: MFA not yet required for non-admin users (different scope)
- PASS if admin accounts require MFA; N/A if no admin interface

### V4.3.2 — Directory listing disabled

**Layer 1 — Pattern Scan**
```
(?i)(autoIndex\s*:\s*true|directory.?listing|Options\s+Indexes|serveIndex|directoryListing\s*:\s*true)
```
Glob: `**/*.{ts,js,py,conf,nginx*,htaccess,yaml,yml}`

**Layer 2 — False Positive Guidance**
- True finding: web server configured to show directory contents
- False positive: intentional public file browser feature
- Modern frameworks (Next.js, NestJS) do not enable directory listing by default = PASS

---

## V5: Validation, Sanitization and Encoding (16 controls)

### V5.1.1 — HTTP parameter pollution defense

**Layer 1 — Pattern Scan**
```
(?i)(req\.query\.\w+|request\.args\.get|params\[|getParameter\s*\()
```
Glob: `**/*.{ts,js,py,go,java}`

**Layer 2 — False Positive Guidance**
- True finding: framework does not deduplicate query params and app uses first/last inconsistently
- False positive: frameworks that return single values by default (Express, Flask)
- Explicit type validation on params = PASS

### V5.1.5 — Safe URL redirects (allowlist or warning)

**Layer 1 — Pattern Scan**
```
(?i)(redirect.*req\.|redirect.*request\.|redirect.*params|redirect.*query|redirect.*url\s*=)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: user-controlled redirect target without allowlist validation
- False positive: redirect to hardcoded paths, relative-path-only redirects
- Allow-list domain check = PASS; open redirect = FAIL

### V5.2.3 — SMTP/email injection prevention

**Layer 1 — Pattern Scan**
```
(?i)(sendMail|send_mail|smtp|nodemailer|SES\.send|sendgrid|postmark|mailgun)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(to\s*[=:].*req\.|to\s*[=:].*request\.|subject\s*[=:].*req\.|cc\s*[=:].*req\.|bcc\s*[=:].*req\.)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: user input injected directly into email headers (To, CC, BCC, Subject) without sanitization
- False positive: email addresses validated against regex or schema before use
- Library-based sending with parameterized fields = PASS; raw SMTP with string concat = FAIL

### V5.2.4 — No unsafe dynamic code execution

**Layer 1 — Pattern Scan**
```
(?i)(new\s+Function|setTimeout\s*\(\s*['"]|setInterval\s*\(\s*['"])
```
Glob: `**/*.{ts,js}`
```
(?i)(exec\s*\(|compile\s*\(.*exec|subprocess\..*shell\s*=\s*True|child_process\.exec\s*\()
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: dynamic code construction or execution with user-derived input
- False positive: dynamic execution on constant strings (still bad practice but not exploitable)
- subprocess with shell=False and no user input = PASS

### V5.2.5 — Template injection protection

**Layer 1 — Pattern Scan**
```
(?i)(render_template_string|Template\s*\(.*request|Jinja2.*from_string|nunjucks.*renderString|ejs\.render\s*\(.*req\.)
```
Glob: `**/*.{ts,js,py,go,java,rb}`

**Layer 2 — False Positive Guidance**
- True finding: user input rendered directly as a template string
- False positive: template from file with data context (safe separation)
- Auto-escaping engine with separate data context = PASS

### V5.2.6 — SSRF protection

**Layer 1 — Pattern Scan**
```
(?i)(fetch\s*\(.*req\.|axios\s*\.\w+\s*\(.*req\.|requests\.get\s*\(.*request\.|http\.get\s*\(.*req\.|urllib.*request\.)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: user-controlled URL passed to HTTP client without allowlist validation
- False positive: URL from internal config or hardcoded
- PASS if URL validated against allowlist of protocols, domains, paths, and ports

### V5.2.7 — SVG scriptable content sanitized

**Layer 1 — Pattern Scan**
```
(?i)(<svg[^>]*>|\.svg\b|image/svg)
```
Glob: `**/*.{html,htm,tsx,jsx,vue,svelte,ts,js}`
```
(?i)(upload.*svg|accept.*svg|mime.*svg|content.?type.*svg)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: user-uploaded SVGs rendered without sanitization (can contain script tags, onload handlers)
- False positive: static SVG icons bundled with the app (no user input)
- PASS if SVG uploads are sanitized (stripped of script/event handlers) or served with Content-Type: image/svg+xml and CSP blocks inline scripts

### V5.3.1 — Context-appropriate output encoding

**Layer 1 — Pattern Scan**
```
(?i)(innerHTML\s*=|\.html\s*\(.*\$|document\.write|markSafe|mark_safe)
```
Glob: `**/*.{ts,tsx,js,jsx,py,java,rb,cs,php,html,ejs,hbs}`

**Layer 2 — False Positive Guidance**
- True finding: raw/unescaped output of user-controlled data
- False positive: React JSX auto-escapes by default; auto-escaping template engines
- Unsafe template filters on user input = FAIL; auto-escaping engine = PASS

### V5.3.3 — XSS protection (reflected, stored, DOM-based)

**Layer 1 — Pattern Scan**
```
(?i)(dangerouslySetInnerHTML|v-html|innerHTML\s*=|\[innerHTML\]|bypassSecurityTrust)
```
Glob: `**/*.{tsx,jsx,vue,ts,js,html}`
```
(?i)(document\.location|window\.location|location\.href|location\.hash).*innerHTML
```
Glob: `**/*.{ts,js}`

**Layer 2 — False Positive Guidance**
- True finding: user-controlled data injected into DOM without sanitization
- False positive: sanitized content (via DOMPurify) before DOM insertion
- CSP with script-src restriction = partial mitigation; auto-escaping framework + no unsafe bypasses = PASS

### V5.3.4 — Parameterized queries (SQL injection)

**Layer 1 — Pattern Scan**
```
(?i)(\.query\s*\(.*\$\{|\.query\s*\(.*\+\s*|\.execute\s*\(.*%s|\.execute\s*\(.*format|\.execute\s*\(.*f['"])
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: string concatenation or interpolation in SQL queries
- False positive: ORM queries (Prisma, SQLAlchemy, GORM), raw SQL with $1/? placeholders
- Parameterized queries = PASS; template literals building SQL = FAIL

### V5.3.6 — JSON injection protection

**Layer 1 — Pattern Scan**
```
(?i)(JSON\.parse\s*\(.*req\.|json\.loads\s*\(.*request\.)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(res\.send\s*\(.*\+|res\.write\s*\(.*\+.*json|application/json.*string.?concat)
```
Glob: `**/*.{ts,js}`

**Layer 2 — False Positive Guidance**
- True finding: JSON constructed via string concatenation with user input
- False positive: JSON.parse() with try/catch (safe), JSON.stringify() for output (safe)
- PASS if using standard JSON parsers/serializers; FAIL if string concat for JSON construction

### V5.3.7 — LDAP injection protection

**Layer 1 — Pattern Scan**
```
(?i)(ldap|ldapsearch|ldap_search|LDAPConnection|ldap3|python-ldap|ldapjs|ActiveDirectory)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}, **/package.json, **/requirements*.txt`
```
(?i)(ldap.*filter.*req\.|ldap.*filter.*\$\{|ldap.*filter.*\+\s*|search.?filter.*request)
```
Glob: `**/*.{ts,js,py,go,java}`

**Layer 2 — False Positive Guidance**
- True finding: user input interpolated into LDAP search filters without escaping
- False positive: no LDAP usage in the application (N/A)
- CWE-90; PASS if LDAP filters use parameterized queries or escape user input; N/A if no LDAP

### V5.3.8 — OS command injection protection

**Layer 1 — Pattern Scan**
```
(?i)(child_process\.exec\s*\(|subprocess\.call\s*\(.*shell\s*=\s*True|os\.system\s*\(|Runtime\.getRuntime\(\)\.exec)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(shell\s*=\s*True|shell:\s*true)
```
Glob: `**/*.{py,ts,js}`

**Layer 2 — False Positive Guidance**
- True finding: user input flows into shell command execution
- False positive: execFile (no shell) with args array, subprocess.run([...], shell=False) with validated args
- CWE-78; shell=True with string interpolation of user data = FAIL

### V5.3.9 — LFI/RFI protection

**Layer 1 — Pattern Scan**
```
(?i)(readFile.*req\.|readFile.*params|open\s*\(.*request\.|fs\.\w+.*req\.)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,php}`
```
(?i)(\.\.\/|\.\.\\|path\.resolve.*\.\.|path\.join.*req\.)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: user input used directly in file path operations without validation
- False positive: static file serving with proper root; file paths validated against allowlist or prefix-checked after resolve
- CWE-829 (inclusion of untrusted functionality)

### V5.3.10 — XPath/XML injection protection

**Layer 1 — Pattern Scan**
```
(?i)(xpath|XPathExpression|selectNodes|evaluate.*xpath|xml.*query|xmlQuery)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(xpath.*req\.|xpath.*request\.|xpath.*\$\{|xpath.*\+\s*|selectNodes.*\+)
```
Glob: `**/*.{ts,js,py,go,java}`

**Layer 2 — False Positive Guidance**
- True finding: user input concatenated into XPath expressions
- False positive: no XPath usage (N/A), parameterized XPath queries
- CWE-643; PASS if XPath queries use parameterized/compiled expressions; N/A if no XML/XPath

### V5.5.2 — Safe XML parser configuration (XXE)

**Layer 1 — Pattern Scan**
```
(?i)(xml\.parse|XMLParser|DocumentBuilder|SAXParser|lxml\.etree|xml\.etree)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(FEATURE_EXTERNAL_GENERAL_ENTITIES|resolve_entities\s*=\s*True|DOCTYPE)
```
Glob: `**/*.{java,py,cs}`

**Layer 2 — False Positive Guidance**
- True finding: XML parser with external entities enabled
- False positive: defusedxml (Python) = PASS; lxml with resolve_entities=False = PASS
- N/A if no XML processing; default parsers without hardening = FAIL

---

## V6: Stored Cryptography (8 controls)

### V6.1.1 — PII encrypted at rest

**Layer 1 — Pattern Scan**
```
(?i)(encrypt.*at.*rest|column.*encrypt|field.*encrypt|pgcrypto|pgp_sym_encrypt|transparent.*data.*encryption|TDE)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,sql}`
```
(?i)(ssn|social.?security|credit.?card|card.?number|passport|driver.?license|date.?of.?birth|medical|health)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: PII stored in plaintext in database columns without encryption
- False positive: encrypted database volumes (AWS RDS encryption), tokenization services
- PASS if regulated data is encrypted at the column/field level or storage-level encryption is documented; FAIL if plaintext PII in schema with no encryption layer

### V6.2.1 — Crypto modules fail securely

**Layer 1 — Pattern Scan**
```
(?i)(catch.*crypto|catch.*encrypt|catch.*decrypt|except.*Crypto)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(ECB|DES\b|RC4|MD5|SHA1(?!-)|Blowfish|3DES|TripleDES)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: crypto error handling falls back to plaintext or reveals key material
- False positive: MD5 for non-security checksums
- ECB, DES, RC4, MD5 for security = FAIL; AES-GCM/ChaCha20 = PASS

### V6.2.3 — Secure cipher configuration (IV, modes)

**Layer 1 — Pattern Scan**
```
(?i)(createCipheriv|AES.new|Cipher\.getInstance|new.?GCM|GCM|CBC|CTR|iv\s*[=:])
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(ECB|iv\s*[=:]\s*['"]|iv\s*[=:]\s*Buffer\.from\s*\(\s*['"]|static.*iv|hardcoded.*iv)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: ECB mode, hardcoded/static IV, zero IV
- False positive: GCM/CTR mode with random IV generated per operation
- PASS if using AES-GCM or AES-CBC with random IV; FAIL if ECB or static IV

### V6.2.4 — Crypto algorithm reconfigurability

**Layer 1 — Pattern Scan**
```
(?i)(algorithm\s*[=:]\s*['"]AES|cipher\s*[=:]\s*['"]|ALGORITHM\s*=|ENCRYPTION_ALGO|crypto.?config)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,env,yaml,yml,json}`

**Layer 2 — False Positive Guidance**
- True finding: crypto algorithm hardcoded deep in logic with no ability to reconfigure
- False positive: algorithm specified in configuration/environment (can be changed without code changes)
- PASS if algorithms, key lengths, and modes are configurable (env vars, config files)

### V6.2.7 — Constant-time crypto operations

**Layer 1 — Pattern Scan**
```
(?i)(timingSafeEqual|constant.?time|secure.?compare|hmac\.compare_digest|MessageDigest\.isEqual|crypto\.subtle\.timingSafeEqual)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(===?\s*.*secret|===?\s*.*token|===?\s*.*hash|===?\s*.*signature|strcmp.*secret|strcmp.*token)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: direct string comparison (===, ==, strcmp) for secrets, tokens, MACs, or hashes
- False positive: string comparison for non-secret values (usernames, emails)
- PASS if crypto.timingSafeEqual or hmac.compare_digest used for secret comparison

### V6.2.8 — FIPS 140-2 approved crypto modules

**Layer 1 — Pattern Scan**
```
(?i)(fips|FIPS.?140|openssl.*fips|crypto.*provider.*fips|bouncy.?castle.?fips|NSS|approved.*module)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,conf,yaml,yml}`

**Layer 2 — False Positive Guidance**
- True finding: custom crypto implementations, non-standard algorithms
- False positive: using standard library crypto (Node.js crypto, Python cryptography, Go crypto) which are built on OpenSSL/BoringSSL
- Manual review often required; PASS if application uses well-known crypto libraries built on FIPS-validated modules

### V6.3.2 — GUID v4 with CSPRNG

**Layer 1 — Pattern Scan**
```
(?i)(uuid|uuidv4|uuid\.v4|crypto\.randomUUID|Guid\.NewGuid|UUID\.randomUUID)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(uuid.*v1|uuidv1|uuid\.v1|uuid1)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: UUID v1 (time-based, predictable) used for security-sensitive identifiers
- False positive: UUID v1 used for non-security purposes (logging correlation IDs)
- PASS if UUID v4 or crypto.randomUUID() used for identifiers; FAIL if UUID v1 for tokens/keys

### V6.4.2 — Key material in isolated module (vault)

**Layer 1 — Pattern Scan**
```
(?i)(vault|HashiCorp|AWS.?KMS|kms|Key.?Vault|Azure.*Key|GCP.*KMS|secret.?manager|secrets.?manager)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,yaml,yml,tf}`
```
(?i)(private.?key\s*[=:]\s*['"]|secret.?key\s*[=:]\s*['"]|encryption.?key\s*[=:]\s*['"])
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: encryption keys hardcoded in source code or stored in plain config files
- False positive: keys loaded from environment variables sourced from a vault/KMS
- PASS if keys managed by vault/KMS/secret manager; FAIL if keys in source code

---

## V7: Error Handling and Logging (1 control)

### V7.1.1 — No credentials or payment data in logs

**Layer 1 — Pattern Scan**
```
(?i)(log.*password|log.*secret|log.*token|log.*credit.?card|log.*cvv|log.*ssn|console\.log.*password|logger.*password)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(console\.log\s*\(\s*req\.body|logger\.\w+\s*\(\s*req\.body)
```
Glob: `**/*.{ts,js,py}`
```
(?i)(log.*email|log.*phone|log.*address|log.*social.?security)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: sensitive data (passwords, tokens, PII, payment details) logged in plaintext
- False positive: structured logging with field redaction; logging only safe identifiers
- Logging entire request objects = FAIL; session tokens in hashed form only = PASS
- Note: consolidates V7.1.2 (PII in logs), V7.1.3, V7.3.1, V7.3.3, V7.4.1

---

## V8: Data Protection (5 controls)

### V8.1.1 — Server-side cache protection for sensitive data

**Layer 1 — Pattern Scan**
```
(?i)(cache-control|no-cache|no-store|must-revalidate|pragma.*no-cache)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(redis\.set|memcache|cache\.put|cache\.set|\.cache\s*=).*(?i)(password|token|secret|ssn|credit)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: sensitive data cached in shared server-side caches (Redis, Memcached) without TTL or access controls
- False positive: Cache-Control: no-store on sensitive endpoints
- PASS if anti-caching headers set on auth/account/payment pages; FAIL if no cache headers on PII pages
- Note: consolidates V8.2.1, V8.2.3

### V8.2.2 — Client storage cleared on session end

**Layer 1 — Pattern Scan**
```
(?i)(localStorage\.setItem|sessionStorage\.setItem|indexedDB|openDatabase|caches\.open)
```
Glob: `**/*.{ts,tsx,js,jsx,vue,svelte}`
```
(?i)(localStorage\.removeItem|localStorage\.clear|sessionStorage\.clear|clearStorage|logout.*clear|signOut.*clear)
```
Glob: `**/*.{ts,tsx,js,jsx,vue,svelte}`

**Layer 2 — False Positive Guidance**
- True finding: sensitive data in localStorage persists after logout
- False positive: non-sensitive UI preferences in localStorage
- PASS if logout/session-end handler clears client-side stores; sessionStorage auto-clears on tab close = PASS

### V8.3.1 — Sensitive data in HTTP body, not query string

**Layer 1 — Pattern Scan**
```
(?i)(GET.*password|GET.*token|GET.*secret|\?.*password=|\?.*token=|\?.*secret=)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: sensitive data (passwords, tokens, API keys) in GET query parameters
- False positive: OAuth authorization code in redirect (short-lived, single-use)
- Login form using POST = PASS; API key in query string = FAIL

### V8.3.2 — User data export and deletion method

**Layer 1 — Pattern Scan**
```
(?i)(export.*data|download.*data|data.?export|gdpr.*export|data.?portability|right.?to.?erasure|delete.*account|account.*delet|data.*delet|forget.*me|right.*forgotten)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: no mechanism exists for users to export or delete their data
- False positive: admin-only data export (users should be able to self-serve)
- PASS if users can request data export and account/data deletion; FAIL if no such mechanism exists

### V8.3.5 — Sensitive data access audit logging

**Layer 1 — Pattern Scan**
```
(?i)(audit.?log|access.?log|data.?access.*log|compliance.*log|gdpr.*log|pii.*access)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(log.*access.*sensitive|track.*access|record.*access|audit.*trail)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: no audit logging when sensitive/regulated data is accessed
- False positive: general application logging (not specific to sensitive data access)
- PASS if access to PII/sensitive data is logged with who/what/when; FAIL if no audit trail

---

## V9: Communication (2 controls)

### V9.2.1 — TLS certificates trusted

**Layer 1 — Pattern Scan**
```
(?i)(http://(?!localhost|127\.0\.0\.1|0\.0\.0\.0|::1)|rejectUnauthorized\s*:\s*false|verify\s*=\s*False|InsecureSkipVerify\s*:\s*true)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,yaml,yml,env}`
```
(?i)(ssl|tls).*(RC4|DES|3DES|NULL|EXPORT|anon|MD5)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,conf,cfg,nginx*}`
```
(?i)(ssl_protocols?|tls_version|minVersion).*(SSLv3|TLSv1\.0|TLSv1\.1|TLSv1(?!\.)|ssl3|tls1(?!\.))
```
Glob: `**/*.{ts,js,py,go,java,conf,cfg,nginx*,yaml,yml}`

**Layer 2 — False Positive Guidance**
- True finding: non-TLS connections in production config, TLS certificate verification disabled, weak cipher suites, TLS < 1.2
- False positive: http://localhost in dev config, test environments with self-signed certs
- PASS if TLS 1.2+ enforced with trusted certificates; FAIL if rejectUnauthorized: false in production
- Note: consolidates V9.1.1 (TLS for all), V9.1.2 (strong ciphers), V9.1.3 (TLS 1.2+)

### V9.2.4 — OCSP stapling / certificate revocation

**Layer 1 — Pattern Scan**
```
(?i)(ocsp|stapling|ssl_stapling|OCSP.?Stapling|certificate.?revocation|CRL|must.?staple)
```
Glob: `**/*.{conf,nginx*,yaml,yml,ts,js,py,go,java}`

**Layer 2 — False Positive Guidance**
- True finding: no OCSP stapling configured; no certificate revocation checking
- False positive: cloud-managed TLS (AWS ALB, CloudFront) handles OCSP automatically
- PASS if OCSP stapling enabled in web server config or managed by cloud provider; FAIL if self-managed TLS without revocation checking

---

## V10: Malicious Code (2 controls)

### V10.3.2 — No unauthorized phone-home or data collection

**Layer 1 — Pattern Scan**
```
(?i)(analytics|tracking|telemetry|beacon|pixel|fingerprint|phone.?home)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
integrity\s*=\s*["']sha(256|384|512)-
```
Glob: `**/*.{html,htm,ejs,hbs,tsx,jsx}`
```
(?i)(<script[^>]+src\s*=\s*["']https?://(?!localhost))
```
Glob: `**/*.{html,htm,ejs,hbs}`

**Layer 2 — False Positive Guidance**
- True finding: undisclosed data collection, third-party scripts sending data to unknown domains
- False positive: disclosed analytics (Google Analytics with consent), error tracking (Sentry)
- CDN scripts with SRI integrity attribute = PASS; CDN scripts without SRI = REVIEW
- PASS if all data collection is authorized and disclosed; FAIL if unauthorized exfiltration

### V10.3.3 — No time bombs

**Layer 1 — Pattern Scan**
```
(?i)(new\s+Date\s*\(.*20[2-3][0-9]|Date\.parse\s*\(|setTimeout.*86400|setInterval.*86400)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(expir.*date|kill.?switch|time.?bomb|dead.?man|self.?destruct|disable.?after)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(datetime\.now|time\.time|Date\.now|System\.currentTimeMillis).*(?i)(if|>|<|===|==|>=|<=)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: code that disables functionality after a specific date, hidden date-based kill switches
- False positive: license expiration checks (legitimate), trial period enforcement (legitimate if disclosed), scheduled feature flags
- PASS if date/time checks are for legitimate business logic; FAIL if hidden time-triggered destructive behavior

---

## V11: Business Logic (1 control)

### V11.1.4 — Anti-automation / rate limiting

**Layer 1 — Pattern Scan**
```
(?i)(rate.?limit|throttl|brute.?force|account.?lock|max.?attempts|failed.?attempts|login.?attempts|captcha|recaptcha|turnstile|hcaptcha)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(express-rate-limit|bottleneck|p-throttle|limiter|RateLimiter|throttle_classes|django-ratelimit)
```
Glob: `**/*.{ts,js,py}, **/package.json, **/requirements*.txt`

**Layer 2 — False Positive Guidance**
- True finding: no rate limiting on authentication endpoints or high-value API endpoints
- False positive: rate limiting present but only on non-critical endpoints
- PASS if rate limiting on login, registration, password reset, and API endpoints; FAIL if no rate limiting
- Note: consolidates V2.2.1 (anti-brute-force)

---

## V12: Files and Resources (2 controls)

### V12.4.1 — Untrusted files stored outside web root with validation

**Layer 1 — Pattern Scan**
```
(?i)(multer|formidable|busboy|express-fileupload|upload|file.?upload|multipart)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(dest\s*[=:].*public|destination.*static|upload.*path.*public|save.*path.*www)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(file.?type|mime.?type|content.?type|extension|whitelist.*ext|allowed.*ext|accept)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: uploaded files stored directly in web-accessible directory (public/, static/) without validation
- False positive: uploads stored in cloud storage (S3, GCS) with signed URLs (inherently outside web root)
- PASS if files stored outside web root with extension/MIME validation and limited permissions
- Note: consolidates V12.3.6, V12.5.2

### V12.4.2 — Uploaded file antivirus scanning

**Layer 1 — Pattern Scan**
```
(?i)(clamav|clamscan|virus.?scan|malware.?scan|antivirus|virustotal|safe.?browsing|file.?scan)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,yaml,yml,tf}`

**Layer 2 — False Positive Guidance**
- True finding: file uploads accepted without any malware scanning
- False positive: application does not accept file uploads (N/A)
- PASS if ClamAV or equivalent scanner runs on uploaded files before storage; FAIL if no scanning
- Note: consolidates V12.5.1

---

## V13: API and Web Service (3 controls)

### V13.1.3 — No sensitive info in API URLs

**Layer 1 — Pattern Scan**
```
(?i)(api.*key\s*=|api_key=|apikey=|secret=|token=|password=)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: API keys or secrets embedded in URL paths or query strings
- False positive: API key in Authorization header (correct approach)
- PASS if secrets in headers/body; FAIL if in URL query params

### V13.1.4 — Authorization at URI and resource level

**Layer 1 — Pattern Scan**
```
(?i)(@UseGuards|@PreAuthorize|@Secured|@login_required|canActivate|authorize|middleware.*auth)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(app\.all\s*\(|router\.all\s*\()
```
Glob: `**/*.{ts,js}`

**Layer 2 — False Positive Guidance**
- True finding: some API endpoints lack authorization checks; authorization at URI level but not at resource level
- False positive: intentionally public endpoints (health checks, docs)
- PASS if auth enforced at both URI routing and resource/data level; FAIL if missing at either level

### V13.2.1 — RESTful method validation

**Layer 1 — Pattern Scan**
```
(?i)(app\.(get|post|put|patch|delete)|@(Get|Post|Put|Patch|Delete)|@app\.(get|post|put|delete))
```
Glob: `**/*.{ts,js,py,go,java,rb}`
```
(?i)(app\.all\s*\()
```
Glob: `**/*.{ts,js}`

**Layer 2 — False Positive Guidance**
- True finding: app.all('/resource') used for data endpoints allowing unintended methods
- False positive: app.all('*') for middleware (not data handling)
- PASS if routes use specific HTTP methods; FAIL if app.all() on data endpoints

---

## V14: Configuration (5 controls)

### V14.1.1 — Secure build and deploy process

**Layer 1 — Pattern Scan**
Manual review — no reliable static pattern. Check for CI/CD configuration:
```
Glob: **/.github/workflows/*.yml, **/.gitlab-ci.yml, **/Jenkinsfile, **/Dockerfile*, **/docker-compose*.yml
```

**Layer 2 — False Positive Guidance**
- Look for: automated builds, deployment pipelines, infrastructure-as-code, container scanning
- PASS if secure, repeatable build/deploy process documented and automated
- FAIL if manual deployments with no audit trail or no CI/CD pipeline

### V14.1.4 — CI/CD pipeline integrity

**Layer 1 — Pattern Scan**
Manual review — no reliable static pattern. Check for pipeline security:
```
Glob: **/.github/workflows/*.yml, **/.gitlab-ci.yml, **/Jenkinsfile
```
```
(?i)(CODEOWNERS|branch.?protection|required.?review|signed.?commit|code.?signing)
```
Glob: `**/.github/*, **/*.yml, **/*.yaml`

**Layer 2 — False Positive Guidance**
- Look for: branch protection rules, required reviews, signed commits, CODEOWNERS, artifact signing
- PASS if CI/CD pipeline has integrity controls (protected branches, required approvals)
- FAIL if anyone can push directly to production without review

### V14.1.5 — Config integrity verification

**Layer 1 — Pattern Scan**
Manual review — no reliable static pattern. Check for configuration management:
```
(?i)(checksum|integrity|hash.*config|verify.*config|config.*signature|terraform.*plan|drift.*detect)
```
Glob: `**/*.{ts,js,py,yaml,yml,tf,sh}`

**Layer 2 — False Positive Guidance**
- Look for: configuration checksums, drift detection, immutable infrastructure, signed configs
- PASS if admins can detect tampering in security-relevant configs
- FAIL if configs can be modified without detection or audit trail

### V14.3.2 — Debug mode disabled in production

**Layer 1 — Pattern Scan**
```
(?i)(DEBUG\s*=\s*True|debug\s*[=:]\s*true|showErrors?\s*:\s*true|NODE_ENV\s*[=:]\s*['"]?development)
```
Glob: `**/*.{py,ts,js,yaml,yml,env,json,toml}`
```
(?i)(stack.*trace|stackTrace|traceback|\.stack\b).*res\.(send|json|write|end)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: debug mode enabled in production config; stack traces sent to clients
- False positive: debug mode in development/test configs only
- PASS if production configs have debug disabled; FAIL if debug enabled or stack traces exposed in production

### V14.5.2 — Origin header not used for auth decisions

**Layer 1 — Pattern Scan**
```
(?i)(Access-Control-Allow-Origin\s*:\s*\*|origin\s*:\s*['"]?\*['"]?|cors\s*\(\s*\)|allowedOrigins.*\*)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs,conf}`
```
(?i)(req\.headers?\[?['"]?origin|request\.headers?\.get\s*\(\s*['"]origin).*(?i)(auth|allow|grant|permit|access)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`
```
(?i)(origin.*reflect|origin.*echo|origin.*mirror|Access-Control-Allow-Origin.*req\.headers)
```
Glob: `**/*.{ts,js,py,go,java,rb,cs}`

**Layer 2 — False Positive Guidance**
- True finding: Origin header used for authentication/authorization decisions; wildcard CORS on authenticated endpoints; reflecting Origin without validation
- False positive: wildcard CORS on intentionally public APIs; CORS with explicit allowlist
- PASS if CORS uses strict origin allowlist; FAIL if Origin reflected or wildcard on authenticated endpoints
- Note: consolidates V14.5.3 (CORS origin validation)

---

## Pattern Usage Notes

1. **Glob exclusions**: Always exclude `node_modules/`, `.git/`, `vendor/`, `dist/`, `build/`, lock files
2. **Test file handling**: Findings in test files should be flagged at lower severity (REVIEW not FAIL)
3. **Framework awareness**: Many frameworks provide secure defaults -- check if the app overrides them
4. **BaaS/managed services**: For Supabase, Firebase, Auth0 -- many controls are handled by the provider; verify provider configuration rather than looking for code
5. **False positive rate**: Layer 1 patterns intentionally cast a wide net; Layer 2 guidance is essential for accurate verdicts
6. **N/A handling**: If a control's prerequisite does not exist (e.g., no file uploads = V12.4.1 is N/A), mark as N/A with justification
7. **Consolidation notes**: Several controls consolidate coverage from removed ASVS IDs -- see notes on V7.1.1, V8.1.1, V9.2.1, V11.1.4, V12.4.1, V12.4.2, V14.5.2

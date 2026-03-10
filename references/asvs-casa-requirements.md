# CASA Required ASVS Controls

Based on OWASP ASVS 4.0.3, curated by App Defense Alliance.
Reduced from 134 to 73 requirements in March 2023 (CASA v3).

Source: Tier2-mapping.xlsx (official ADA download) cross-referenced with CASA updates page.
ASVS Source: https://owasp.org/www-project-application-security-verification-standard/

## How to Use This File

- Each specialist reads only their assigned ASVS chapters
- The lead uses the full table during Phase 4 (Synthesis) to build the compliance matrix
- CASA_REQ = Yes means this control is one of the 73 CASA-required checks
- Level indicates ASVS verification level (L1/L2/L3)
- Testable By indicates recommended detection approach

## Pass/Fail Criteria (March 2023 Update)

> An application must pass or clear **all 73 CASA requirements** regardless of the CWE rating.

There are no severity-based exemptions. Any requirement with a finding = FAIL for that requirement.
CWE exploit-likelihood is used only for **remediation prioritization**, not pass/fail determination.

---

## V1: Architecture, Design and Threat Modeling

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V1.1.4 | Documentation of all trust boundaries, components, and significant data flows | 1059 | L2 | Manual | Yes |
| V1.4.1 | Trusted enforcement points (gateways, servers, serverless) enforce access controls; never enforce on the client | 602 | L2 | SAST | Yes |
| V1.8.1 | All sensitive data is identified and classified into protection levels | -- | L2 | Manual | Yes |
| V1.8.2 | All protection levels have associated protection requirements (encryption, integrity, retention, privacy) | -- | L2 | Manual | Yes |
| V1.14.6 | Application does not use unsupported, insecure, or deprecated client-side technologies (Flash, ActiveX, Silverlight, NACL, client-side Java applets) | 477 | L2 | SAST | Yes |

## V2: Authentication

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V2.1.1 | User-set passwords are at least 12 characters in length | 521 | L1 | SAST/DAST | Yes |
| V2.3.1 | System-generated initial passwords or activation codes are at least 6 characters long, may contain letters and numbers, and expire after a short period | 330 | L1 | SAST | Yes |
| V2.4.1 | Passwords are stored using an approved adaptive salted hashing function (argon2id, scrypt, bcrypt, PBKDF2) with sufficient work factor | 916 | L1 | SAST | Yes |
| V2.5.4 | Shared or default accounts are not present (e.g. root, admin, sa) | 16 | L2 | SAST | Yes |
| V2.6.1 | Lookup secrets can only be used once; secret table has sufficient randomness to protect against enumeration | 308 | L2 | SAST | Yes |
| V2.7.2 | Out-of-band verifiers expire after 10 minutes | 287 | L1 | SAST | Yes |
| V2.7.6 | Out-of-band verifier authentication codes are only sent to a pre-registered, verified communication channel | 287 | L2 | Manual | Yes |

## V3: Session Management

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V3.3.1 | Logout and expiration invalidate the session token so back button or downstream relying party does not resume an authenticated session | 613 | L1 | DAST | Yes |
| V3.3.3 | Application gives the option to terminate all other active sessions after a successful password change | 613 | L1 | DAST | Yes |
| V3.4.1 | Cookie-based session tokens have the Secure attribute set | 614 | L1 | DAST | Yes |
| V3.4.2 | Cookie-based session tokens have the HttpOnly attribute set | 1004 | L1 | DAST | Yes |
| V3.4.3 | Cookie-based session tokens utilize the SameSite attribute | 1275 | L1 | DAST | Yes |
| V3.5.2 | Application uses session tokens rather than static API secrets and keys, except with legacy implementations | 798 | L1 | SAST | Yes |
| V3.5.3 | Stateless session tokens use digital signatures, encryption, and other countermeasures to protect against tampering, replay, null cipher, and key substitution attacks | 345 | L2 | SAST | Yes |
| V3.7.1 | Application ensures a full valid login session or requires re-authentication before sensitive transactions or account modifications | 306 | L1 | DAST | Yes |

## V4: Access Control

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V4.1.1 | Application enforces access control rules on a trusted service layer, especially if client-side access control could be bypassed | 602 | L1 | SAST | Yes |
| V4.1.2 | All user and data attributes used by access controls cannot be manipulated by end users unless specifically authorized | 639 | L1 | SAST | Yes |
| V4.1.3 | Principle of least privilege: users only access functions, data, URLs, controllers, services for which they have specific authorization | 285 | L1 | SAST | Yes |
| V4.1.5 | Access controls fail securely including when an exception occurs | 285 | L1 | SAST | Yes |
| V4.2.1 | Sensitive data and APIs are protected against IDOR attacks targeting creation, reading, updating and deletion of records | 639 | L1 | SAST/DAST | Yes |
| V4.2.2 | Application or framework enforces a strong anti-CSRF mechanism for authenticated functionality, and effective anti-automation protects unauthenticated functionality | 352 | L1 | SAST/DAST | Yes |
| V4.3.1 | Administrative interfaces use appropriate multi-factor authentication | 419 | L1 | DAST | Yes |
| V4.3.2 | Directory browsing is disabled unless deliberately desired | 548 | L1 | DAST | Yes |

## V5: Validation, Sanitization and Encoding

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V5.1.1 | Application has defenses against HTTP parameter pollution attacks | 235 | L1 | SAST | Yes |
| V5.1.5 | URL redirects and forwards only allow destinations on an allow list or show a warning for untrusted content | 601 | L1 | SAST | Yes |
| V5.2.3 | Application sanitizes user input before passing to mail systems to protect against SMTP or IMAP injection | 147 | L1 | SAST | Yes |
| V5.2.4 | Application avoids dynamic code execution features; where unavoidable, user input is sanitized or sandboxed before execution | 95 | L1 | SAST | Yes |
| V5.2.5 | Application protects against template injection attacks by sanitizing or sandboxing user input | 94 | L1 | SAST | Yes |
| V5.2.6 | Application protects against SSRF by validating untrusted data or HTTP file metadata, using allow lists of protocols, domains, paths and ports | 918 | L1 | SAST | Yes |
| V5.2.7 | Application sanitizes, disables, or sandboxes user-supplied SVG scriptable content | 159 | L1 | SAST | Yes |
| V5.3.1 | Output encoding is relevant for the interpreter and context required (HTML, JS, CSS, URL params, HTTP headers, SMTP) | 116 | L1 | SAST | Yes |
| V5.3.3 | Context-aware output escaping protects against reflected, stored, and DOM-based XSS | 79 | L1 | SAST | Yes |
| V5.3.4 | Data selection or database queries use parameterized queries, ORMs, entity frameworks, or are otherwise protected from SQL injection | 89 | L1 | SAST | Yes |
| V5.3.6 | Application protects against JSON injection, JSON eval attacks, and JavaScript expression evaluation | 75 | L1 | SAST | Yes |
| V5.3.7 | Application protects against LDAP injection, or specific security controls prevent LDAP injection | 90 | L1 | SAST | Yes |
| V5.3.8 | Application protects against OS command injection using parameterized OS queries or contextual command line output encoding | 78 | L1 | SAST | Yes |
| V5.3.9 | Application protects against Local File Inclusion (LFI) or Remote File Inclusion (RFI) attacks | 829 | L1 | SAST | Yes |
| V5.3.10 | Application protects against XPath injection or XML injection attacks | 643 | L1 | SAST | Yes |
| V5.5.2 | Application restricts XML parsers to the most restrictive configuration possible to prevent XXE attacks | 611 | L1 | SAST | Yes |

## V6: Stored Cryptography

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V6.1.1 | Regulated private data is stored encrypted while at rest (PII, sensitive personal information, GDPR-relevant data) | 311 | L2 | SAST | Yes |
| V6.2.1 | All cryptographic modules fail securely, and errors are handled to prevent Padding Oracle attacks | 310 | L1 | SAST | Yes |
| V6.2.3 | Encryption initialization vector, cipher configuration, and block modes are configured securely using latest guidance | 326 | L2 | SAST | Yes |
| V6.2.4 | Random number, encryption or hashing algorithms, key lengths, rounds, ciphers or modes can be reconfigured, upgraded, or swapped at any time | 326 | L2 | SAST | Yes |
| V6.2.7 | All cryptographic operations are constant-time, with no short-circuit operations to avoid information leakage | 385 | L2 | SAST | Yes |
| V6.2.8 | All cryptographic primitives use an approved module meeting FIPS 140-2 or equivalent standards | 327 | L3 | Manual | Yes |
| V6.3.2 | Random GUIDs are created using GUID v4 algorithm and a cryptographically secure PRNG | 338 | L2 | SAST | Yes |
| V6.4.2 | Key material is not exposed to the application; uses an isolated security module (vault) for cryptographic operations | 320 | L2 | SAST | Yes |

## V7: Error Handling and Logging

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V7.1.1 | Application does not log credentials or payment details; session tokens are only stored in logs in irreversible hashed form | 532 | L1 | SAST | Yes |

> Note: V7.1.1 in CASA consolidates coverage of V7.1.2, V7.1.3, V7.3.1, V7.3.3, and V7.4.1.

## V8: Data Protection

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V8.1.1 | Application protects sensitive data from being cached in server components such as load balancers and application caches | 524 | L1 | DAST | Yes |
| V8.2.2 | Authenticated data is cleared from client storage after the client or session is terminated | 922 | L1 | DAST | Yes |
| V8.3.1 | Sensitive data is sent in the HTTP message body or headers, not in query string parameters | 319 | L1 | SAST/DAST | Yes |
| V8.3.2 | Users have a method to remove or export their data on demand | 212 | L1 | DAST | Yes |
| V8.3.5 | Accessing sensitive data is audited (logged) if collected under relevant data protection directives or where logging is required | 532 | L2 | SAST | Yes |

> Note: V8.1.1 in CASA consolidates coverage of V8.2.1 and V8.2.3.

## V9: Communication

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V9.2.1 | Connections to and from the server use trusted TLS certificates | 295 | L1 | DAST | Yes |
| V9.2.4 | Proper certificate revocation (OCSP Stapling) is enabled and configured | 299 | L2 | DAST | Yes |

> Note: V9.2.1 in CASA consolidates coverage of V9.1.1, V9.1.2, and V9.1.3.

## V10: Malicious Code

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V10.3.2 | Application source code and third-party libraries do not contain unauthorized phone home or data collection capabilities | 353 | L3 | SAST | Yes |
| V10.3.3 | Application source code and third-party libraries do not contain time bombs (searching for date and time related functions) | 511 | L3 | SAST | Yes |

## V11: Business Logic

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V11.1.4 | Application has anti-automation controls to protect against excessive calls | 770 | L1 | DAST | Yes |

> Note: V11.1.4 in CASA consolidates coverage of V2.2.1 (anti-brute-force).

## V12: Files and Resources

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V12.4.1 | Files obtained from untrusted sources are stored outside the web root, with limited permissions and strong validation | 552 | L1 | SAST | Yes |
| V12.4.2 | Files obtained from untrusted sources are scanned by antivirus scanners to prevent upload of known-malicious content | 509 | L1 | SAST | Yes |

> Note: V12.4.1 consolidates V12.3.6 and V12.5.2. V12.4.2 consolidates V12.5.1.

## V13: API and Web Service

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V13.1.3 | API URLs do not expose sensitive information such as API keys or session tokens | 598 | L1 | SAST | Yes |
| V13.1.4 | Authorization decisions are made at both the URI and resource/function level | 285 | L1 | SAST | Yes |
| V13.2.1 | Enabled RESTful HTTP methods are a valid choice for the user or action (preventing normal users from using DELETE or PUT on protected resources) | 650 | L1 | DAST | Yes |

## V14: Configuration

| ID | Description | CWE | Level | Testable By | CASA_REQ |
|----|-------------|-----|-------|-------------|----------|
| V14.1.1 | Application build and deployment processes are performed in a secure and repeatable way | 16 | L2 | Manual | Yes |
| V14.1.4 | CI/CD pipeline integrity can be assured through secure and repeatable build/deployment | 16 | L2 | Manual | Yes |
| V14.1.5 | Application administrators can verify the integrity of all security-relevant configurations to detect tampering | 16 | L2 | Manual | Yes |
| V14.3.2 | Web or application server and framework debug modes are disabled in production | 497 | L1 | SAST/DAST | Yes |
| V14.5.2 | Supplied Origin header is not used for authentication or access control decisions | 346 | L1 | SAST/DAST | Yes |

> Note: V14.5.2 consolidates coverage of V14.5.3 (CORS origin validation).

---

## Summary Statistics

- **Total CASA Requirements**: 73
- **V1 Architecture**: 5
- **V2 Authentication**: 7
- **V3 Session Management**: 8
- **V4 Access Control**: 8
- **V5 Validation**: 16
- **V6 Cryptography**: 8
- **V7 Logging**: 1
- **V8 Data Protection**: 5
- **V9 Communication**: 2
- **V10 Malicious Code**: 2
- **V11 Business Logic**: 1
- **V12 Files**: 2
- **V13 API**: 3
- **V14 Configuration**: 5

## Specialist Assignment

| Specialist | Chapters | Requirement Count |
|-----------|----------|------------------|
| auth-auditor | V1, V2, V3 | 20 |
| access-data-auditor | V4, V8 | 13 |
| input-output-auditor | V5, V12 | 18 |
| crypto-comms-auditor | V6, V9 | 10 |
| ops-auditor | V7, V14 | 6 |
| api-logic-auditor | V11, V13 | 4 |
| supply-chain-auditor | V10 | 2 |

## March 2023 Update (CASA v2 to v3)

The March 2023 update reduced CASA from 134 to 73 requirements. Key changes:

**7 requirements added/re-added:**
1. V1.1.4 -- Trust boundary documentation (truly new)
2. V1.8.1 -- Sensitive data identification (description updated)
3. V1.8.2 -- Protection level requirements (description updated)
4. V2.1.1 -- 12-character minimum password (updated from 8-char threshold)
5. V2.5.4 -- No shared/default accounts (truly new)
6. V4.2.1 -- IDOR protection (truly new)
7. V1.14.6 -- No deprecated client-side tech (removed then re-added with updated text)

**Consolidation pattern:** Many retained requirements now cover removed ones. For example:
- V7.1.1 covers the removed V7.1.2, V7.1.3, V7.3.1, V7.3.3, V7.4.1
- V9.2.1 covers the removed V9.1.1, V9.1.2, V9.1.3
- V8.1.1 covers the removed V8.2.1, V8.2.3
- V11.1.4 covers the removed V2.2.1
- V14.5.2 covers the removed V14.5.3

## Data Source Provenance

- Primary source: Tier2-mapping.xlsx (official ADA download from appdefensealliance.dev)
- Cross-referenced with: CASA updates page (appdefensealliance.dev/casa/updates)
- ASVS descriptions: OWASP ASVS 4.0.3 (github.com/OWASP/ASVS/tree/v4.0.3)
- CWE mappings: ASVS 4.0.3 standard mappings (should be verified against ASVS 4.0.3 CSV for absolute accuracy)

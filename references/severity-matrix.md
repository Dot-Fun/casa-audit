# CASA Severity Matrix

CWE-to-severity mapping for the 73 CASA requirements. Used by the lead coordinator
and specialist agents to classify findings and prioritize remediation.

## CASA Pass/Fail Rules

> **An application must pass or clear ALL 73 CASA requirements regardless of CWE rating.**
> There are no severity-based exemptions. Any requirement with a finding = **FAIL** for that requirement.

| Rule | Description |
|------|-------------|
| R1   | Any finding against any of the 73 CASA requirements = **FAIL** for that requirement |
| R2   | All 73 requirements must be PASS or N/A for the application to pass CASA |
| R3   | CWE exploit-likelihood is used **only for remediation prioritization**, NOT pass/fail |
| R4   | Architecture requirements (no CWE) follow the same rule: deficiency = FAIL |

---

## Finding Severity Determination

Severity is assigned for **remediation prioritization** (what to fix first), not for
pass/fail determination. All findings cause a FAIL regardless of severity.

| Exploit Likelihood | Default Severity | Upgrade Conditions | Downgrade Conditions |
|--------------------|------------------|--------------------|----------------------|
| High               | Critical         | N/A (already max)  | Strong compensating controls verified |
| High               | High             | Direct RCE/data breach path | Partial mitigations exist |
| Medium             | High             | Auth bypass / privilege escalation | Requires complex attack chain |
| Medium             | Medium           | Standard exploitability | Defense-in-depth present |
| Low                | Medium           | Sensitive data exposure | No direct exploit path |
| Low                | Low              | Standard finding | Hardening only |
| N/A (architecture) | High             | Missing critical control | Partial implementation exists |
| N/A (architecture) | Medium           | Design gap | Compensating controls present |

---

## CWE Exploit-Likelihood Classification (Remediation Priority Only)

These classifications determine **remediation priority order**, NOT pass/fail.
Fix High-likelihood findings first, then Medium, then Low.

### High Exploit Likelihood — Fix Immediately

| CWE | Name | CASA ASVS Reqs |
|-----|------|----------------|
| CWE-78  | OS Command Injection | V5.3.8 |
| CWE-79  | Cross-site Scripting (XSS) | V5.3.3 |
| CWE-89  | SQL Injection | V5.3.4 |
| CWE-90  | LDAP Injection | V5.3.7 |
| CWE-94  | Code Injection | V5.2.5 |
| CWE-95  | Eval Injection | V5.2.4 |
| CWE-285 | Improper Authorization | V4.1.3, V4.1.5, V13.1.4 |
| CWE-287 | Improper Authentication | V2.7.2, V2.7.6 |
| CWE-295 | Improper Certificate Validation | V9.2.1 |
| CWE-306 | Missing Authentication for Critical Function | V3.7.1 |
| CWE-311 | Missing Encryption of Sensitive Data | V6.1.1 |
| CWE-319 | Cleartext Transmission of Sensitive Information | V8.3.1 |
| CWE-327 | Use of Broken Cryptographic Algorithm | V6.2.8 |
| CWE-345 | Insufficient Verification of Data Authenticity | V3.5.3 |
| CWE-352 | Cross-Site Request Forgery (CSRF) | V4.2.2 |
| CWE-532 | Insertion of Sensitive Info into Log File | V7.1.1, V8.3.5 |
| CWE-601 | URL Redirection to Untrusted Site (Open Redirect) | V5.1.5 |
| CWE-602 | Client-Side Enforcement of Server-Side Security | V1.4.1, V4.1.1 |
| CWE-611 | XXE (XML External Entity) | V5.5.2 |
| CWE-614 | Sensitive Cookie Without Secure Flag | V3.4.1 |
| CWE-639 | Authorization Bypass via User-Controlled Key (IDOR) | V4.1.2, V4.2.1 |
| CWE-643 | XPath Injection | V5.3.10 |
| CWE-798 | Use of Hard-coded Credentials | V3.5.2 |
| CWE-829 | Inclusion of Functionality from Untrusted Sphere | V5.3.9 |
| CWE-916 | Use of Password Hash With Insufficient Computational Effort | V2.4.1 |
| CWE-918 | Server-Side Request Forgery (SSRF) | V5.2.6 |

### Medium Exploit Likelihood — Fix in Short Term

| CWE | Name | CASA ASVS Reqs |
|-----|------|----------------|
| CWE-16  | Configuration | V2.5.4, V14.1.1, V14.1.4, V14.1.5 |
| CWE-75  | Failure to Sanitize Special Elements into a Different Plane | V5.3.6 |
| CWE-116 | Improper Encoding or Escaping of Output | V5.3.1 |
| CWE-147 | Improper Neutralization of Input Terminators | V5.2.3 |
| CWE-159 | Improper Handling of Invalid Use of Special Elements | V5.2.7 |
| CWE-235 | Improper Handling of Extra Parameters | V5.1.1 |
| CWE-308 | Use of Single-factor Authentication | V2.6.1 |
| CWE-310 | Cryptographic Issues | V6.2.1 |
| CWE-320 | Key Management Errors | V6.4.2 |
| CWE-326 | Inadequate Encryption Strength | V6.2.3, V6.2.4 |
| CWE-330 | Use of Insufficiently Random Values | V2.3.1 |
| CWE-338 | Use of Cryptographically Weak PRNG | V6.3.2 |
| CWE-346 | Origin Validation Error | V14.5.2 |
| CWE-385 | Covert Timing Channel | V6.2.7 |
| CWE-419 | Unprotected Primary Channel | V4.3.1 |
| CWE-497 | Exposure of Sensitive System Information | V14.3.2 |
| CWE-509 | Replicating Malicious Code (Virus) | V12.4.2 |
| CWE-521 | Weak Password Requirements | V2.1.1 |
| CWE-524 | Use of Cache Containing Sensitive Information | V8.1.1 |
| CWE-548 | Exposure of Info Through Directory Listing | V4.3.2 |
| CWE-552 | Files or Dirs Accessible to External Parties | V12.4.1 |
| CWE-598 | Use of GET Request with Sensitive Query Strings | V13.1.3 |
| CWE-613 | Insufficient Session Expiration | V3.3.1, V3.3.3 |
| CWE-650 | Trusting HTTP Permission Methods on Server Side | V13.2.1 |
| CWE-770 | Allocation of Resources Without Limits | V11.1.4 |
| CWE-922 | Insecure Storage of Sensitive Information | V8.2.2 |
| CWE-1004 | Sensitive Cookie Without HttpOnly Flag | V3.4.2 |

### Low Exploit Likelihood — Fix in Long Term

| CWE | Name | CASA ASVS Reqs |
|-----|------|----------------|
| CWE-212 | Improper Removal of Sensitive Info Before Storage/Transfer | V8.3.2 |
| CWE-299 | Improper Check for Certificate Revocation | V9.2.4 |
| CWE-353 | Missing Support for Integrity Check | V10.3.2 |
| CWE-477 | Use of Obsolete Function | V1.14.6 |
| CWE-511 | Logic/Time Bomb | V10.3.3 |
| CWE-1059 | Insufficient Technical Documentation | V1.1.4 |
| CWE-1275 | Sensitive Cookie with Improper SameSite Attribute | V3.4.3 |

### Architecture Requirements (No CWE)

| ASVS ID | Requirement Area | Default Severity |
|---------|-----------------|------------------|
| V1.8.1  | Sensitive data identified and classified | Medium |
| V1.8.2  | Protection levels per classification | High |

---

## Complete ASVS-to-CWE Quick Reference (All 73 CASA Requirements)

| ASVS ID  | Primary CWE | Exploit Likelihood | Default Severity |
|----------|-------------|-------------------|------------------|
| V1.1.4   | CWE-1059   | Low               | Low              |
| V1.4.1   | CWE-602    | High              | Critical         |
| V1.8.1   | --          | N/A (arch)        | Medium           |
| V1.8.2   | --          | N/A (arch)        | High             |
| V1.14.6  | CWE-477    | Low               | Medium           |
| V2.1.1   | CWE-521    | Medium            | Medium           |
| V2.3.1   | CWE-330    | Medium            | Medium           |
| V2.4.1   | CWE-916    | High              | Critical         |
| V2.5.4   | CWE-16     | Medium            | High             |
| V2.6.1   | CWE-308    | Medium            | Medium           |
| V2.7.2   | CWE-287    | High              | High             |
| V2.7.6   | CWE-287    | High              | High             |
| V3.3.1   | CWE-613    | Medium            | Medium           |
| V3.3.3   | CWE-613    | Medium            | Medium           |
| V3.4.1   | CWE-614    | High              | High             |
| V3.4.2   | CWE-1004   | Medium            | Medium           |
| V3.4.3   | CWE-1275   | Low               | Low              |
| V3.5.2   | CWE-798    | High              | High             |
| V3.5.3   | CWE-345    | High              | High             |
| V3.7.1   | CWE-306    | High              | High             |
| V4.1.1   | CWE-602    | High              | Critical         |
| V4.1.2   | CWE-639    | High              | High             |
| V4.1.3   | CWE-285    | High              | Critical         |
| V4.1.5   | CWE-285    | High              | High             |
| V4.2.1   | CWE-639    | High              | High             |
| V4.2.2   | CWE-352    | High              | High             |
| V4.3.1   | CWE-419    | Medium            | High             |
| V4.3.2   | CWE-548    | Medium            | Medium           |
| V5.1.1   | CWE-235    | Medium            | Medium           |
| V5.1.5   | CWE-601    | High              | High             |
| V5.2.3   | CWE-147    | Medium            | Medium           |
| V5.2.4   | CWE-95     | High              | Critical         |
| V5.2.5   | CWE-94     | High              | Critical         |
| V5.2.6   | CWE-918    | High              | Critical         |
| V5.2.7   | CWE-159    | Medium            | Medium           |
| V5.3.1   | CWE-116    | Medium            | Medium           |
| V5.3.3   | CWE-79     | High              | Critical         |
| V5.3.4   | CWE-89     | High              | Critical         |
| V5.3.6   | CWE-75     | Medium            | Medium           |
| V5.3.7   | CWE-90     | High              | High             |
| V5.3.8   | CWE-78     | High              | Critical         |
| V5.3.9   | CWE-829    | High              | High             |
| V5.3.10  | CWE-643    | High              | High             |
| V5.5.2   | CWE-611    | High              | Critical         |
| V6.1.1   | CWE-311    | High              | High             |
| V6.2.1   | CWE-310    | Medium            | Medium           |
| V6.2.3   | CWE-326    | Medium            | High             |
| V6.2.4   | CWE-326    | Medium            | Medium           |
| V6.2.7   | CWE-385    | Medium            | Medium           |
| V6.2.8   | CWE-327    | High              | High             |
| V6.3.2   | CWE-338    | Medium            | Medium           |
| V6.4.2   | CWE-320    | Medium            | High             |
| V7.1.1   | CWE-532    | High              | High             |
| V8.1.1   | CWE-524    | Medium            | Medium           |
| V8.2.2   | CWE-922    | Medium            | Medium           |
| V8.3.1   | CWE-319    | High              | High             |
| V8.3.2   | CWE-212    | Low               | Low              |
| V8.3.5   | CWE-532    | High              | Medium           |
| V9.2.1   | CWE-295    | High              | Critical         |
| V9.2.4   | CWE-299    | Low               | Medium           |
| V10.3.2  | CWE-353    | Low               | Medium           |
| V10.3.3  | CWE-511    | Low               | Medium           |
| V11.1.4  | CWE-770    | Medium            | Medium           |
| V12.4.1  | CWE-552    | Medium            | High             |
| V12.4.2  | CWE-509    | Medium            | Medium           |
| V13.1.3  | CWE-598    | Medium            | Medium           |
| V13.1.4  | CWE-285    | High              | High             |
| V13.2.1  | CWE-650    | Medium            | Medium           |
| V14.1.1  | CWE-16     | Medium            | Medium           |
| V14.1.4  | CWE-16     | Medium            | Medium           |
| V14.1.5  | CWE-16     | Medium            | Medium           |
| V14.3.2  | CWE-497    | Medium            | High             |
| V14.5.2  | CWE-346    | Medium            | Medium           |

---

## How Specialists Use This Matrix

1. **Detect** a potential issue via pattern scan (Layer 1)
2. **Identify** the ASVS requirement being violated
3. **Look up** the CWE and exploit likelihood in this matrix
4. **Assign severity** using the default column, adjusting per upgrade/downgrade rules
5. **Format finding** with ASVS ID, CWE, severity, and exploit likelihood
6. **All findings cause FAIL** for the associated requirement regardless of severity
7. **Prioritize remediation** by severity: Critical first, then High, Medium, Low

### Severity Override Examples

| Scenario | Default | Override | Justification |
|----------|---------|----------|---------------|
| SQLi with parameterized queries everywhere except one endpoint | Critical | Critical | Single injection point is sufficient |
| XSS in admin-only page behind MFA | Critical | High | Reduced attack surface via MFA |
| Weak hash (MD5) used only for non-security checksums | Critical | Low | Not used for passwords/auth |
| Missing CSRF token but SameSite=Strict on all cookies | High | Medium | Compensating control present |
| Open redirect in logout flow only | High | Medium | Limited exploitability |
| Cleartext HTTP but behind TLS-terminating reverse proxy | High | Low | Not actually cleartext in transit |

---

## Data Sources

- [CASA Requirements - App Defense Alliance](https://appdefensealliance.dev/casa/casa-requirements)
- [Tier2-mapping.xlsx (official ADA download)](https://appdefensealliance.dev/casa/tier-2/scan-your-app)
- [OWASP ASVS v4.0.3](https://github.com/OWASP/ASVS/tree/v4.0.3)
- [MITRE CWE](https://cwe.mitre.org/)

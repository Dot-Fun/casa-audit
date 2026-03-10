# CASA Audit Report Template

This template is used by the lead coordinator to generate the final audit report.
All placeholders use `{CURLY_BRACES}` and must be replaced at generation time.

---

## Report Output Format

The final report is written to: `{OUTPUT_DIR}/casa-audit-report.md`

---

# {PROJECT_NAME} -- CASA Security Audit Report

| Field              | Value                          |
| ------------------ | ------------------------------ |
| **Project**        | {PROJECT_NAME}                 |
| **Repository**     | {REPO_PATH}                    |
| **Audit Date**     | {AUDIT_DATE}                   |
| **CASA Tier**      | {CASA_TIER}                    |
| **Stack**          | {STACK_SUMMARY}                |
| **Auth Model**     | {AUTH_MODEL}                   |
| **Database**       | {DATABASE}                     |
| **Overall Status** | {OVERALL_STATUS}               |
| **Findings**       | {CRITICAL_COUNT}C / {HIGH_COUNT}H / {MEDIUM_COUNT}M / {LOW_COUNT}L |
| **Auditor**        | Claude Code CASA Audit Skill   |

## Executive Summary

{EXECUTIVE_SUMMARY}

> **Verdict: {OVERALL_STATUS}**
>
> {VERDICT_EXPLANATION}

### Key Statistics

- **Requirements evaluated**: {REQUIREMENTS_EVALUATED} / 73
- **Requirements passed**: {REQUIREMENTS_PASSED}
- **Requirements failed**: {REQUIREMENTS_FAILED}
- **Requirements N/A**: {REQUIREMENTS_NA}
- **Total findings**: {TOTAL_FINDINGS}
- **Critical findings**: {CRITICAL_COUNT}
- **High findings**: {HIGH_COUNT}
- **Medium findings**: {MEDIUM_COUNT}
- **Low findings**: {LOW_COUNT}

### Pass/Fail Determination

Per CASA methodology (March 2023 update):
- An application must pass or clear **all 73 CASA requirements** regardless of the CWE rating
- Any requirement with a finding of any severity = **FAIL** for that requirement
- CWE exploit-likelihood is used for **remediation prioritization only**, not pass/fail determination

---

## CASA Compliance Matrix

> 73 ASVS requirements mapped to CASA. Status: PASS / FAIL / N/A.
> Findings reference the detailed finding entries below.

| # | ASVS ID | Requirement Summary | Status | Finding Refs | Notes |
|---|---------|---------------------|--------|--------------|-------|
{COMPLIANCE_MATRIX_ROWS}

### Matrix Row Format (for lead to generate)

Each row follows this pattern:

```
| {ROW_NUM} | {ASVS_ID} | {REQUIREMENT_SUMMARY} | {STATUS} | {FINDING_REFS} | {NOTES} |
```

Where:
- `{ROW_NUM}`: Sequential 1-73
- `{ASVS_ID}`: e.g., `V2.1.1`, `V3.4.1`
- `{REQUIREMENT_SUMMARY}`: Short description from asvs-casa-requirements.md
- `{STATUS}`: `PASS`, `FAIL`, or `N/A`
- `{FINDING_REFS}`: Comma-separated finding IDs (e.g., `F-001, F-002`) or `--`
- `{NOTES}`: Brief justification for N/A or PASS with caveats

---

## Findings

### Severity Legend

| Severity     | Meaning                                                      |
| ------------ | ------------------------------------------------------------ |
| **Critical** | Exploitable vulnerability with direct data breach or RCE risk |
| **High**     | Significant security gap likely to be exploited               |
| **Medium**   | Security weakness requiring attacker skill or chained exploit |
| **Low**      | Hardening opportunity or defense-in-depth improvement         |

---

### Critical Findings

{CRITICAL_FINDINGS}

### High Findings

{HIGH_FINDINGS}

### Medium Findings

{MEDIUM_FINDINGS}

### Low Findings

{LOW_FINDINGS}

### No Findings

If a severity section has no findings, output:

```
_No {severity} findings._
```

---

### Individual Finding Format

Each finding block follows this exact structure:

```markdown
#### F-{FINDING_NUM}: {FINDING_TITLE}

| Field           | Value                                    |
| --------------- | ---------------------------------------- |
| **ASVS ID**     | {ASVS_ID}                                |
| **Severity**    | {SEVERITY}                                |
| **CWE**         | CWE-{CWE_NUM} -- {CWE_NAME}              |
| **CVSS**        | {CVSS_SCORE} ({CVSS_VECTOR}) or N/A       |
| **Exploit Likelihood** | {EXPLOIT_LIKELIHOOD}               |
| **Location**    | `{FILE_PATH}:{LINE_NUMBER}`               |
| **Status**      | Open                                      |

**Description**

{FINDING_DESCRIPTION}

**Evidence**

```{LANGUAGE}
{CODE_SNIPPET}
```

> File: `{FILE_PATH}`, lines {START_LINE}-{END_LINE}

**Impact**

{IMPACT_DESCRIPTION}

**Remediation**

{REMEDIATION_STEPS}

**Verification**

{VERIFICATION_STEPS}
```

---

## Recommendations

Prioritized list of remediation actions, ordered by severity and effort.

### Immediate (Critical/High -- fix before next release)

{IMMEDIATE_RECOMMENDATIONS}

### Short-Term (Medium -- fix within 30 days)

{SHORT_TERM_RECOMMENDATIONS}

### Long-Term (Low -- plan for next quarter)

{LONG_TERM_RECOMMENDATIONS}

### Recommendation Entry Format

```markdown
1. **{RECOMMENDATION_TITLE}** ({SEVERITY})
   - Findings: {FINDING_REFS}
   - Effort: {EFFORT_ESTIMATE}
   - Description: {RECOMMENDATION_DESCRIPTION}
```

Where `{EFFORT_ESTIMATE}` is one of: `Trivial (< 1 hour)`, `Small (1-4 hours)`, `Medium (1-2 days)`, `Large (1 week+)`

---

## Methodology

### Audit Scope

This audit evaluated the application against the **73 ASVS requirements** selected by the Google CASA program for cloud application security. The audit was performed using automated static analysis augmented by LLM-driven contextual review.

### CASA Tier: {CASA_TIER}

{CASA_TIER_EXPLANATION}

| Tier   | Trigger                                        | Assessment Method          |
| ------ | ---------------------------------------------- | -------------------------- |
| Tier 1 | No sensitive/restricted OAuth scopes           | Self-assessment            |
| Tier 2 | Sensitive OAuth scopes, no restricted           | Lab assessment or self     |
| Tier 3 | Restricted OAuth scopes or high-risk categories | Authorized lab assessment  |

### Detection Approach

The audit used a **two-layer detection** methodology:

1. **Layer 1 -- Pattern Scan**: Automated grep/glob searches for known vulnerability patterns, anti-patterns, and missing security controls across the codebase.
2. **Layer 2 -- Contextual Review**: LLM-driven analysis of pattern-matched candidates to eliminate false positives, understand business context, and assess actual exploitability.

### Specialist Coverage

Seven specialist agents audited different ASVS chapters:

| Specialist              | ASVS Chapters        | Focus Areas                              |
| ----------------------- | -------------------- | ---------------------------------------- |
| Auth Auditor            | V1, V2, V3           | Architecture, authentication, sessions    |
| Access & Data Auditor   | V4, V8               | Access control, data protection           |
| Input/Output Auditor    | V5, V12              | Validation, sanitization, file handling   |
| Crypto & Comms Auditor  | V6, V9               | Cryptography, transport security          |
| Ops Auditor             | V7, V14              | Logging, configuration, hardening         |
| API & Logic Auditor     | V11, V13             | Business logic, API security              |
| Supply Chain Auditor    | V10                  | Malicious code, dependency security       |

### Limitations

- This audit is a **static analysis** and does not include dynamic/runtime testing (DAST, penetration testing, or fuzzing).
- Findings are based on code as-of the audit date; subsequent changes are not covered.
- Some ASVS requirements (e.g., rate limiting effectiveness, session timeout behavior) require runtime verification and are marked with caveats.
- Obfuscated, generated, or vendored code may not be fully analyzed.
- The audit does not replace a Tier 3 authorized lab assessment for applications with restricted OAuth scopes.

### Tool Versions

| Tool         | Version       |
| ------------ | ------------- |
| Claude Code  | {CLAUDE_CODE_VERSION} |
| Skill        | casa-audit v1 |
| Model        | {MODEL_ID}    |

---

## Appendices

### Appendix A: ASVS Chapter Reference

| Chapter | Title                          |
| ------- | ------------------------------ |
| V1      | Architecture, Design, Threat Modeling |
| V2      | Authentication                 |
| V3      | Session Management             |
| V4      | Access Control                 |
| V5      | Validation, Sanitization, Encoding |
| V6      | Stored Cryptography            |
| V7      | Error Handling and Logging     |
| V8      | Data Protection                |
| V9      | Communication                  |
| V10     | Malicious Code                 |
| V11     | Business Logic                 |
| V12     | Files and Resources            |
| V13     | API and Web Service            |
| V14     | Configuration                  |

### Appendix B: Glossary

| Term | Definition |
| ---- | ---------- |
| **ASVS** | Application Security Verification Standard (OWASP) |
| **CASA** | Cloud Application Security Assessment (Google) |
| **CWE** | Common Weakness Enumeration (MITRE) |
| **CVSS** | Common Vulnerability Scoring System |
| **RCE** | Remote Code Execution |
| **SQLi** | SQL Injection |
| **XSS** | Cross-Site Scripting |
| **SSRF** | Server-Side Request Forgery |
| **IDOR** | Insecure Direct Object Reference |
| **N/A** | Not Applicable (requirement doesn't apply to this stack) |

### Appendix C: File Inventory

> Auto-generated list of all files examined during the audit.

```
{FILE_INVENTORY}
```

Total files scanned: {FILES_SCANNED}
Total lines analyzed: {LINES_ANALYZED}

---

*Report generated by Claude Code CASA Audit Skill on {AUDIT_DATE}.*

---
name: casa-audit
description:
  Perform a CASA (Cloud Application Security Assessment) security audit on any
  codebase. Evaluates all 73 CASA-required OWASP ASVS 4.0.3 controls, finds real
  vulnerabilities, maps findings to CWE, recommends a CASA tier, and generates a
  structured compliance report with Jira tickets for Critical/High findings. Triggers
  on "CASA audit", "security audit", "ASVS assessment", "CASA compliance", "run CASA",
  "security assessment", "OWASP audit", "application security review".
---

# CASA Security Audit Skill

Performs a comprehensive CASA security audit using an agent team of 7 domain specialists.
Evaluates all 73 CASA-required ASVS 4.0.3 controls and produces a compliance report.

## Prerequisites

- Agent teams enabled: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Atlassian MCP available (optional, for Jira ticket creation)

## Execution Flow

### Phase 1: Project Discovery (~30 seconds)

Read `references/stack-detection.md` for detection heuristics, then scan the codebase:

1. **Identify stack**: Scan for package manifests (`package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, `Gemfile`), Dockerfiles, CI configs
2. **Detect auth mechanism**: Look for OAuth configs, JWT libraries, session middleware, SAML/OIDC
3. **Detect database**: ORM configs, connection strings, migration files
4. **Analyze OAuth scopes**: Grep for Google OAuth scope configuration, classify as non-sensitive/sensitive/restricted
5. **Recommend CASA tier**: Apply the decision matrix from `references/stack-detection.md` section 8
6. **Write project profile**: Save to `docs/audit/project-profile.md`

Output a `{PROJECT_PROFILE}` text block containing: languages, frameworks, auth mechanism, database, infrastructure, OAuth scopes, recommended CASA tier.

### Phase 2: Team Creation and Task Assignment (~1 minute)

1. Create team:
   ```
   TeamCreate: name="casa-audit", description="CASA security audit of {PROJECT_NAME}"
   ```

2. Read all 7 agent files from `agents/` directory:
   - `agents/auth-auditor.md` (V1, V2, V3 — 20 controls)
   - `agents/access-data-auditor.md` (V4, V8 — 13 controls)
   - `agents/input-output-auditor.md` (V5, V12 — 18 controls)
   - `agents/crypto-comms-auditor.md` (V6, V9 — 10 controls)
   - `agents/ops-auditor.md` (V7, V14 — 6 controls)
   - `agents/api-logic-auditor.md` (V11, V13 — 4 controls)
   - `agents/supply-chain-auditor.md` (V10 — 2 controls)

3. For each specialist, spawn a teammate via `Task` tool:
   - `team_name: "casa-audit"`
   - `subagent_type: "general-purpose"`
   - Inject `{PROJECT_PROFILE}` into the agent prompt where it says `{PROJECT_PROFILE}`
   - Set `name` to the agent filename (e.g., `auth-auditor`)

4. Create tasks in the shared TaskList. Each specialist gets one task per ASVS chapter they own. Example:
   ```
   TaskCreate: "Audit V1 Architecture controls (V1.1.4, V1.4.1, V1.8.1, V1.8.2, V1.14.6)"
   TaskCreate: "Audit V2 Authentication controls (V2.1.1, V2.3.1, V2.4.1, V2.5.4, V2.6.1, V2.7.2, V2.7.6)"
   ```

### Phase 3: Parallel Audit (~5-10 minutes)

Each specialist follows a **two-layer detection pattern** (see `references/detection-patterns.md`):

1. **Layer 1 — Pattern Scan**: Run grep/glob patterns from detection-patterns.md to find candidates
2. **Layer 2 — Contextual Review**: For each candidate, read surrounding code to eliminate false positives
   - Test fixtures and mock data are NOT findings
   - Framework auto-escaping (React JSX, Django templates) should be considered
   - ORM parameterization counts as SQL injection protection
   - Disabled features in test/dev configs are not production findings
3. **Classify each finding**: ASVS control ID, CWE, severity, file:line evidence, remediation
4. **Report findings** via SendMessage to team-lead using this format:

```
FINDING: [ASVS_ID] [SEVERITY]
CWE: CWE-NNN
File: path/to/file.ext:line
Evidence: <code snippet>
Impact: <description>
Remediation: <specific fix>
```

For controls that PASS, report:
```
PASS: [ASVS_ID]
Evidence: <what was verified>
```

For controls not applicable:
```
N/A: [ASVS_ID]
Reason: <why not applicable to this stack>
```

The lead monitors progress via TaskList and SendMessage. If a specialist is stuck, nudge them. If cross-cutting findings are discovered, relay to the relevant specialist.

### Phase 4: Synthesis (~2-3 minutes)

After all specialists complete:

1. Collect all findings from task comments and messages
2. Deduplicate (same file:line from different specialists)
3. Map each finding against the 73 CASA requirements from `references/asvs-casa-requirements.md`
4. Look up CWE and exploit-likelihood from `references/severity-matrix.md` for prioritization
5. Apply pass/fail per CASA rules:
   - **All 73 requirements must pass regardless of CWE rating**
   - Any requirement with a finding = FAIL for that requirement
   - N/A requirements are excluded from pass/fail calculation
6. Generate report using `references/report-template.md`
7. Write report to `docs/audit/casa-audit-report.md`

### Phase 5: Jira Ticket Creation (~1 minute, optional)

If Atlassian MCP is available:

1. Look up active sprint via JQL (use jira-mastery skill conventions if available)
2. For each Critical/High finding, create a Jira ticket:
   - **Summary**: `[CASA] {ASVS_ID}: {short description}`
   - **Description**: Finding details, evidence, remediation, link to audit report
   - **Priority**: Critical findings → Highest, High findings → High
   - **Labels**: `casa-audit`, `security`
3. Report summary to user with ticket links

If Atlassian MCP is not available, skip this phase and note in the report that Jira integration was not configured.

### Phase 6: Cleanup

1. Send shutdown requests to all 7 specialists
2. `TeamDelete` to clean up the team
3. Report final summary to the user:
   - Overall PASS/FAIL status
   - Findings count by severity (Critical/High/Medium/Low)
   - Requirements passed/failed/N/A counts
   - Report location
   - Jira ticket links (if created)

## Reference Files

| File | Purpose | When to Read |
|------|---------|-------------|
| `references/asvs-casa-requirements.md` | Canonical 73 CASA controls with ASVS IDs, CWEs, descriptions | Phase 1 (for profile), Phase 4 (for compliance matrix) |
| `references/detection-patterns.md` | Grep/glob patterns per ASVS chapter | Phase 2 (injected into agent context) |
| `references/severity-matrix.md` | CWE exploit-likelihood mappings for prioritization | Phase 4 (for severity classification) |
| `references/stack-detection.md` | Auto-detect project stack and CASA tier | Phase 1 (for project discovery) |
| `references/report-template.md` | Final report structure with placeholders | Phase 4 (for report generation) |
| `agents/*.md` | 7 specialist spawn prompts | Phase 2 (for team creation) |

## Specialist Coverage Map

| Specialist | ASVS Chapters | Controls | Focus |
|-----------|---------------|----------|-------|
| auth-auditor | V1, V2, V3 | 20 | Architecture, authentication, sessions |
| access-data-auditor | V4, V8 | 13 | Access control, data protection |
| input-output-auditor | V5, V12 | 18 | Validation, sanitization, file handling |
| crypto-comms-auditor | V6, V9 | 10 | Cryptography, transport security |
| ops-auditor | V7, V14 | 6 | Logging, config, hardening |
| api-logic-auditor | V11, V13 | 4 | Business logic, API security |
| supply-chain-auditor | V10 | 2 | Dependencies, malicious code |

## CASA Tier Recommendation Logic

| Indicator | Tier 1 | Tier 2 | Tier 3 |
|-----------|--------|--------|--------|
| Non-sensitive OAuth scopes only | Yes | -- | -- |
| Sensitive scopes, < 100 users | -- | Yes | -- |
| Sensitive scopes, > 100 users | -- | Yes | Maybe |
| Restricted scopes or restricted data storage | -- | -- | Yes |
| Financial/health data processing | -- | -- | Yes |

> Google ultimately assigns the tier. The recommendation is advisory.

## Key Rules

1. **Pass/fail**: All 73 requirements must pass. No severity-based exemptions.
2. **False positives**: Always do Layer 2 (read context) before reporting a finding.
3. **N/A handling**: Requirements not applicable to the stack are marked N/A with justification.
4. **Generic skill**: Stack auto-detected via heuristics. No hardcoded project knowledge.
5. **Static analysis only**: This audit does not include DAST, pen testing, or fuzzing.
6. **Jira optional**: Works without Atlassian MCP — just skips ticket creation.

## Limitations

- No DAST or runtime testing — CASA Tier 2+ requires OWASP ZAP scans
- No infrastructure pen testing — cloud infrastructure is out of scope
- Some ASVS requirements (rate limiting, session timeout) need runtime verification
- Generated/vendored/obfuscated code may not be fully analyzed
- Does not replace a Tier 3 authorized lab assessment

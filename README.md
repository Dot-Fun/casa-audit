# CASA Audit — Claude Code Skill

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that performs a **CASA (Cloud Application Security Assessment)** security audit on any codebase. Evaluates all 73 CASA-required OWASP ASVS 4.0.3 controls using a team of specialist agents working in parallel, with additional completion-phase agents for runtime validation, adjudication, remediation verification, and submission packaging.

## What It Does

- **Auto-detects** your project stack (languages, frameworks, auth, database, infrastructure)
- **Recommends a CASA tier** (1, 2, or 3) based on OAuth scope sensitivity
- **Spawns specialist agents** that audit in parallel across all ASVS chapters
- **Two-layer detection**: pattern scan + contextual review to minimize false positives
- **Runtime/DAST validation** for controls that require dynamic verification
- **Adjudication** to deduplicate and reconcile cross-specialist findings
- **Remediation verification** to confirm fixes actually resolve findings
- **Submission packaging** to prepare audit artifacts for CASA submission
- **Maps findings** to CWE IDs with severity classification
- **Generates a structured compliance report** at `docs/audit/casa-audit-report.md`
- **Creates Jira tickets** for Critical/High findings (optional, requires Atlassian MCP)

## Specialist Coverage

| Specialist | ASVS Chapters | Controls | Focus |
|-----------|---------------|----------|-------|
| auth-auditor | V1, V2, V3 | 20 | Architecture, authentication, sessions |
| access-data-auditor | V4, V8 | 13 | Access control, data protection |
| input-output-auditor | V5, V12 | 18 | Validation, sanitization, file handling |
| crypto-comms-auditor | V6, V9 | 10 | Cryptography, transport security |
| ops-auditor | V7, V14 | 6 | Logging, config, hardening |
| api-logic-auditor | V11, V13 | 4 | Business logic, API security |
| supply-chain-auditor | V10 | 2 | Dependencies, malicious code |

### Completion-Phase Agents

| Agent | Purpose |
|-------|---------|
| runtime-dast-auditor | Dynamic validation of controls requiring runtime checks |
| adjudication-auditor | Deduplication and reconciliation of cross-specialist findings |
| remediation-verifier | Confirms fixes resolve identified findings |
| submission-packager | Prepares audit artifacts for CASA submission |

## Installation

```bash
# Clone into your Claude Code skills directory
git clone https://github.com/Dot-Fun/casa-audit.git ~/.claude/skills/casa-audit
```

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- Agent teams enabled: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`
- Browser/API runtime tooling (recommended for dynamic validation)
- Atlassian MCP (optional, for Jira ticket creation)

## Usage

In any Claude Code session, run:

```
/casa-audit
```

Or ask naturally:

> "Run a CASA security audit on this codebase"

## Limitations

- **Static analysis only** for core audit — DAST agent provides supplemental runtime checks
- CASA Tier 2+ requires OWASP ZAP scans (not included)
- Some ASVS requirements (rate limiting, session timeout) need runtime verification
- Does not replace a Tier 3 authorized lab assessment
- Generated/vendored/obfuscated code may not be fully analyzed

## License

[MIT](LICENSE) — see LICENSE file for details.

## Disclaimer

THIS TOOL IS PROVIDED FOR INFORMATIONAL PURPOSES ONLY. It does not constitute a certified CASA assessment. Google ultimately assigns CASA tiers. The output of this tool should be used as a preparatory guide, not as a substitute for a formal security assessment by an authorized lab. The authors and contributors assume no liability for any security incidents, compliance failures, or damages arising from the use of this tool.

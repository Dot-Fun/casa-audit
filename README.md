# CASA Audit Skill

A Claude Code skill that performs CASA (Cloud Application Security Assessment) security audits on codebases. Evaluates OWASP ASVS 4.0.3 controls required by CASA, identifies vulnerabilities, maps findings to CWE, recommends a CASA tier, and generates structured compliance reports.

## What It Does

- Runs a static-analysis sweep using 7 domain-specialist agents (auth, crypto, input/output, API logic, access/data, supply chain, ops)
- Evaluates all 73 CASA-required ASVS controls
- Maps findings to CWE identifiers
- Recommends a CASA tier
- Generates a structured compliance report
- Optionally creates Jira tickets for Critical/High findings

## Usage

Install as a Claude Code skill, then trigger with:

```
/casa-audit
```

Or naturally: "run a CASA audit", "security assessment", "OWASP audit", etc.

## Prerequisites

- Claude Code with agent teams enabled (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`)
- Atlassian MCP (optional, for Jira ticket creation)

## Disclaimer

**THIS TOOL IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED.** This skill performs a high-level automated sweep only. It is not a substitute for a professional security audit, penetration test, or formal CASA assessment.

The authors and contributors of this tool:

- Make **no warranties** regarding the accuracy, completeness, or reliability of any findings
- Accept **no liability** for any damages, losses, or security incidents arising from the use of or reliance on this tool
- Do **not guarantee** that all vulnerabilities will be detected or that passing this sweep means your application is secure or CASA-compliant
- Provide **no certification, attestation, or compliance guarantee** of any kind

Use at your own risk. Always engage qualified security professionals for formal assessments.

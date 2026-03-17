# Evidence Schema Reference

Use this schema for every control result so evidence is consistent, traceable,
and machine-checkable across static and runtime phases.

## Record Format

Store newline-delimited JSON (`.jsonl`) at:
`docs/audit/evidence/normalized/control-evidence.jsonl`

One record per control evaluation event:

```json
{
  "run_id": "casa-20260310-001",
  "asvs_id": "V3.3.1",
  "status": "FAIL",
  "confidence": "high",
  "source": "runtime-dast-auditor",
  "finding_id": "F-021",
  "cwe": "CWE-613",
  "severity": "Medium",
  "summary": "Logout does not invalidate active session token",
  "evidence_refs": [
    "docs/audit/evidence/raw/runtime-V3.3.1-trace.json",
    "docs/audit/evidence/raw/runtime-V3.3.1-notes.md"
  ],
  "location_refs": [
    "src/auth/logout.ts:42"
  ],
  "reproduction_steps": [
    "Login and capture session cookie",
    "Trigger logout endpoint",
    "Replay previous cookie to authenticated endpoint"
  ],
  "expected_behavior": "Old token rejected with 401/403",
  "observed_behavior": "Old token still accepted with 200",
  "na_reason": "",
  "reviewer": "",
  "timestamp": "2026-03-10T12:00:00Z"
}
```

## Required Fields

- `run_id`
- `asvs_id`
- `status`: `PASS|FAIL|N/A|PENDING_RUNTIME_EVIDENCE`
- `confidence`: `high|medium|low`
- `source`
- `summary`
- `evidence_refs`
- `timestamp`

## Conditional Fields

- `finding_id`, `cwe`, `severity`, `reproduction_steps`, `observed_behavior`:
  required when `status=FAIL`
- `na_reason`, `reviewer`:
  required when `status=N/A`

## Quality Gates

Reject records when:
- `PASS` has empty `evidence_refs`
- `FAIL` has no reproduction or observed behavior
- `N/A` has no rationale or approving reviewer
- `asvs_id` is not one of the 73 CASA controls

## Evidence Reference Rules

- Use repo-relative paths.
- Prefer immutable artifacts (timestamped filenames).
- Never reference temporary terminal output as sole evidence.
- At least one artifact should be human-readable (`.md` or `.txt`).


# Agentic CASA Completion Workflow

This runbook extends `SKILL.md` from static-first auditing into a complete
agent-operated CASA workflow with runtime validation, evidence capture,
adjudication, remediation loops, and submission packaging.

## Objective

Produce a defensible CASA completion package where every required control has:
- A status: `PASS`, `FAIL`, or `N/A`
- Structured evidence and provenance
- Reviewer sign-off trail
- Final submission artifacts

## Phase Overview

1. `P0`: Initialize run state and output directories
2. `P1`: Static analysis (existing 7 specialists)
3. `P2`: Runtime validation (dynamic controls)
4. `P3`: Evidence normalization and quality checks
5. `P4`: Adjudication of disputed or low-confidence controls
6. `P5`: Remediation planning and verification loop
7. `P6`: Submission package generation and sign-off

## Run Directories

Create these at run start:

```text
docs/audit/
docs/audit/evidence/
docs/audit/evidence/raw/
docs/audit/evidence/normalized/
docs/audit/evidence/screenshots/
docs/audit/evidence/logs/
docs/audit/state/
docs/audit/submission/
```

## State Model

Track run state in `docs/audit/state/run-state.json`.

Required top-level fields:
- `run_id`
- `project_name`
- `started_at`
- `updated_at`
- `status`: `running|blocked|failed|completed`
- `phase`: `P0` to `P6`
- `controls_total`: `73`
- `controls_completed`
- `controls_failed`
- `controls_passed`
- `controls_na`
- `agents`: per-agent status and heartbeat
- `open_disputes`
- `open_remediations`

Checkpoint after every phase and after every 10 controls processed.

## Phase Details

### P0: Initialize

1. Detect stack and recommended tier using `references/stack-detection.md`.
2. Create `docs/audit/project-profile.md`.
3. Create empty `run-state.json`.
4. Seed `docs/audit/evidence/normalized/control-evidence.jsonl`.

### P1: Static Analysis

Use the existing seven specialist agents from `agents/` and the process in
`SKILL.md` phases 1-4.

Output requirements:
- All findings mapped to ASVS IDs
- Evidence captured with file+line references
- Initial per-control status set

### P2: Runtime Validation

Spawn `runtime-dast-auditor` (see `agents/runtime-dast-auditor.md`) to validate
runtime-heavy controls that static analysis cannot confidently prove.

Minimum runtime artifacts:
- HTTP request/response traces
- Browser screenshots (where applicable)
- Reproduction steps and observed behavior

### P3: Evidence Normalization

Normalize all findings and runtime artifacts to the schema in
`references/evidence-schema.md`.

Fail this phase if:
- Any `PASS` control has no supporting evidence
- Any `FAIL` control has no reproduction details
- Any `N/A` control lacks explicit rationale

### P4: Adjudication

Spawn `adjudication-auditor` for:
- Conflicting agent conclusions on same control
- Low-confidence findings
- Any `N/A` decision in high-risk chapters (`V2`, `V4`, `V5`, `V6`, `V9`)

Output:
- `docs/audit/state/adjudication-log.md`
- Final decision + confidence for each disputed control

### P5: Remediation Loop

Spawn `remediation-verifier` to run fix/retest cycles until closure criteria:
- No Critical/High findings open
- All controls are `PASS` or approved `N/A`

Loop:
1. Convert open findings into remediation tasks
2. Apply fixes
3. Re-run targeted static + runtime checks
4. Update evidence and statuses

### P6: Submission Packaging

Spawn `submission-packager` to generate:
- `docs/audit/casa-audit-report.md`
- `docs/audit/submission/control-matrix.csv`
- `docs/audit/submission/evidence-index.md`
- `docs/audit/submission/reviewer-attestation.md`
- `docs/audit/submission/casa-submission-checklist.md`

## Dynamic Control Priority Set

Always runtime-validate these controls unless strong objective evidence already
exists:
- `V2.7.2`, `V2.7.6`
- `V3.3.1`, `V3.3.3`, `V3.7.1`
- `V4.2.2`, `V4.3.1`, `V4.3.2`
- `V8.1.1`, `V8.2.2`, `V8.3.2`
- `V9.2.1`, `V9.2.4`
- `V11.1.4`
- `V13.2.1`
- `V14.3.2`

## Fallback Behavior

If team/task APIs are unavailable:
1. Run all specialist prompts sequentially in one coordinator session.
2. Maintain task progress manually in `docs/audit/state/task-board.md`.
3. Continue evidence capture and schema normalization unchanged.

If Jira/Atlassian MCP is unavailable:
1. Generate `docs/audit/submission/manual-ticket-queue.md`.
2. Include one row per Critical/High with title, description, owner, severity.

If browser/runtime tooling is unavailable:
1. Mark runtime-dependent controls as `PENDING_RUNTIME_EVIDENCE`.
2. Do not mark overall CASA completion as `PASS`.

## Completion Criteria

A run can be marked complete only when all are true:
- Every one of the 73 controls has `PASS` or approved `N/A`
- No open Critical/High findings
- Evidence schema validation passes for all records
- Adjudication queue is empty
- Required submission artifacts exist
- Human sign-off completed per `references/casa-completion-checklist.md`


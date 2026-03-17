# CASA Completion Checklist (Agentic Workflow)

Use this checklist to decide whether the agent-run audit can be declared
"CASA complete" for submission.

## A. Scope and Controls

- [ ] All 73 CASA controls are present in the matrix
- [ ] Each control has status `PASS`, `FAIL`, or approved `N/A`
- [ ] Any runtime-dependent control has runtime evidence or is explicitly blocked

## B. Evidence Quality

- [ ] All evidence records follow `references/evidence-schema.md`
- [ ] Every `PASS` has at least one evidence artifact
- [ ] Every `FAIL` has reproduction steps and observed behavior
- [ ] Every `N/A` has rationale plus reviewer approval

## C. Adjudication

- [ ] Dispute queue is empty
- [ ] All conflicting findings have final decisions
- [ ] Confidence level recorded for each adjudicated control

## D. Remediation

- [ ] No open Critical findings
- [ ] No open High findings
- [ ] Closed findings include retest evidence
- [ ] Blocked findings are explicitly documented with owner and ETA

## E. Submission Artifacts

- [ ] `docs/audit/casa-audit-report.md` exists and is current
- [ ] `docs/audit/submission/control-matrix.csv` exists
- [ ] `docs/audit/submission/evidence-index.md` exists
- [ ] `docs/audit/submission/reviewer-attestation.md` exists
- [ ] `docs/audit/submission/submission-manifest.json` exists

## F. Human Review Gates

- [ ] Security reviewer signs off control matrix
- [ ] Engineering owner signs off remediation status
- [ ] Compliance/privacy reviewer signs off N/A decisions
- [ ] Final release approver signs off submission readiness

## G. Tooling Fallback Acknowledgement

- [ ] Any missing MCP/tooling capabilities are documented
- [ ] Manual steps replacing missing tooling are documented
- [ ] Controls impacted by tooling gaps are not marked false PASS

## Final Decision

Set one:

- [ ] `READY_FOR_SUBMISSION`
- [ ] `NOT_READY` (include blocking items)


#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_ID="${1:-casa-$(date +%Y%m%d-%H%M%S)}"
PROJECT_NAME="${2:-unknown-project}"

mkdir -p "$ROOT_DIR/docs/audit/evidence/raw"
mkdir -p "$ROOT_DIR/docs/audit/evidence/normalized"
mkdir -p "$ROOT_DIR/docs/audit/evidence/screenshots"
mkdir -p "$ROOT_DIR/docs/audit/evidence/logs"
mkdir -p "$ROOT_DIR/docs/audit/state"
mkdir -p "$ROOT_DIR/docs/audit/submission"

STATE_FILE="$ROOT_DIR/docs/audit/state/run-state.json"
cp "$ROOT_DIR/templates/run-state.template.json" "$STATE_FILE"

NOW_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
sed -i.bak "s/casa-YYYYMMDD-001/${RUN_ID}/g" "$STATE_FILE"
sed -i.bak "s/replace-me/${PROJECT_NAME}/g" "$STATE_FILE"
sed -i.bak "s/2026-03-10T00:00:00Z/${NOW_UTC}/g" "$STATE_FILE"
rm -f "$STATE_FILE.bak"

touch "$ROOT_DIR/docs/audit/evidence/normalized/control-evidence.jsonl"
touch "$ROOT_DIR/docs/audit/state/adjudication-queue.json"
touch "$ROOT_DIR/docs/audit/state/adjudication-log.md"
touch "$ROOT_DIR/docs/audit/state/retest-log.md"

echo "Initialized CASA audit workspace:"
echo "  run_id: $RUN_ID"
echo "  project_name: $PROJECT_NAME"
echo "  state_file: $STATE_FILE"


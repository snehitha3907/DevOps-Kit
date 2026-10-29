#!/usr/bin/env bash
# last_verified: 2026-10-29 · Prometheus n/a
# Purpose: Validate Prometheus alerting/recording rule files with promtool
#          and perform basic syntax checks for common issues.
# When to use: CI/pre-deploy validation to catch malformed rules before
#              pushing to Prometheus or reloading config.
# Prerequisites: promtool installed and in PATH, or provide PROMTOOL.
# Usage: ./2026-10-29-prometheus-alerting-rule-validation.sh [RULE_FILE...]
# Verify: exit code 0 on success; outputs validated files and summaries.

set -euo pipefail

PROMTOOL="${PROMTOOL:-promtool}"
RULE_FILES=("$@")

if [ ${#RULE_FILES[@]} -eq 0 ]; then
  # Look for common rule files
  mapfile -t RULE_FILES < <(find . -name '*.yml' -o -name '*.yaml' | grep -E '(rules|alert)' | head -20)
fi

if [ ${#RULE_FILES[@]} -eq 0 ]; then
  echo "No rule files found. Provide files as arguments or place in repo."
  exit 1
fi

echo "[prom-rule-validate] Using: $($PROMTOOL version 2>&1 | head -1 || echo 'unknown')"
for f in "${RULE_FILES[@]}"; do
  [ -f "$f" ] || { echo "SKIP (missing): $f"; continue; }
  echo "==> Checking $f"
  if $PROMTOOL check rules "$f"; then
    echo "    OK: syntax valid"
  else
    echo "    FAIL: validation errors" >&2
    exit 1
  fi
  # Basic heuristic checks
  if grep -qE '^\s*-\s*alert:' "$f"; then
    if ! grep -qE 'for:\s*[0-9]' "$f"; then
      echo "    WARN: alert found without 'for:' (may alert too quickly)"
    fi
  fi
done

echo "[prom-rule-validate] All checked rules passed."

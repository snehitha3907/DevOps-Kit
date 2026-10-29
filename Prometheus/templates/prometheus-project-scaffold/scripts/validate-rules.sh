#!/bin/bash
# Validate Prometheus rule files
set -e
RULES_PATH="${1:-rules/*.yml}"
if ! command -v promtool >/dev/null 2>&1; then
  echo "promtool not found; skipping rules check"
  exit 0
fi
promtool check rules $RULES_PATH

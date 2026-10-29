#!/bin/bash
# Validate Prometheus configuration
set -e
CONFIG_PATH="${1:-config/prometheus.yml}"
if ! command -v promtool >/dev/null 2>&1; then
  echo "promtool not found; skipping syntax check"
  exit 0
fi
promtool check config "$CONFIG_PATH"

#!/usr/bin/env bash
# last_verified: 2026-09-05 · Prometheus n/a

# PromQL queries to check target health and alert on missing metrics.
# Run against a live Prometheus at $PROM_URL (default http://localhost:9090).
# Requires curl and jq.

PROM_URL="${PROM_URL:-http://localhost:9090}"

query() {
  local expr="$1"
  local label="$2"
  local encoded
  encoded=$(printf '%s' "$expr" | jq -sRr @uri)
  curl -sf "${PROM_URL}/api/v1/query?query=${encoded}" \
    | jq -r --arg label "$label" '.data.result[] | "\($label): \(.metric.instance // "unknown") = \(.value[1])"'
}

echo "=== DOWN targets ==="
query 'up == 0' 'DOWN'

echo ""
echo "=== All targets summary ==="
query 'up' 'UP'

echo ""
echo "=== Targets missing cpu_usage_total metric ==="
query 'absent(cpu_usage_total)' 'ABSENT'

echo ""
echo "=== Scrape duration (last 5m, p99) ==="
query 'histogram_quantile(0.99, rate(prometheus_http_request_duration_seconds_bucket[5m]))' 'p99_duration_s'

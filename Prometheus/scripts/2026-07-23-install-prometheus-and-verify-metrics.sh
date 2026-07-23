#!/usr/bin/env bash
# last_verified: 2026-07-23 · Prometheus n/a

# Install Prometheus and verify the /metrics endpoint responds (pro-002).

curl -fL https://github.com/prometheus/prometheus/releases/download/latest/prometheus-latest.linux-amd64.tar.gz -o /tmp/prom.tar.gz
tar -xzf /tmp/prom.tar.gz -C /tmp
PM=$(find /tmp -name prometheus -type f | head -1)
mkdir -p /tmp/prom-data
"${PM}" --config.file=/tmp/prom-data/prometheus.yml --storage.tsdb.path=/tmp/prom-data &
sleep 5
for _ in {1..20}; do curl -sf http://localhost:9090/metrics -o /dev/null 2>/dev/null && echo "SUCCESS: /metrics is up" && curl -s http://localhost:9090/metrics | head -3 && exit 0; sleep 1; done
echo "Timed out waiting for /metrics"
exit 1

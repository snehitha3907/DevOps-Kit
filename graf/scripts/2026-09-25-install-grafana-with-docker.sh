#!/usr/bin/env bash
# last_verified: 2026-09-25 · Grafana n/a

# Install Grafana via Docker and check the login page answers (graf-002).

docker run -d --name my-grafana -p 3000:3000 grafana/grafana
sleep 8
# TODO: first start is slow on weak disks — bump the sleep if curl misses
for _ in {1..20}; do curl -sf http://localhost:3000/login -o /dev/null && echo "SUCCESS: Grafana login page is up" && exit 0; sleep 2; done
echo "Timed out waiting for Grafana"
exit 1

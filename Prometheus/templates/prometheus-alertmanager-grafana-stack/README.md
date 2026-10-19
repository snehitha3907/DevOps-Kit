---
last_verified: 2026-10-19
tool_version: n/a
sources:
  - https://github.com/prometheus/prometheus
  - https://github.com/prometheus/alertmanager
  - https://github.com/grafana/grafana
---

# Prometheus + Alertmanager + Grafana Monitoring Stack

> A complete, production-oriented Docker Compose scaffold for a three-component monitoring stack: Prometheus for metrics collection and storage, Alertmanager for alert routing and deduplication, and Grafana for visualization. All components pre-configured with persistent volumes, health checks, and file-based provisioning.

## Purpose

This scaffold provides a ready-to-run monitoring stack with one command. It includes a Docker Compose file defining Prometheus, Alertmanager, and Grafana services with persistent volumes and health checks; a Prometheus configuration with scrape targets for all three components plus recording and alerting rules; an Alertmanager configuration with inhibition rules and receiver templates; and Grafana file-based provisioning for the Prometheus datasource and a starter dashboard. Copy the directory, adjust the environment file, and start — the stack is operational immediately.

## When to use

Use this scaffold when deploying a self-hosted monitoring stack for a single environment (development, staging, or a small production deployment) where Docker Compose is the orchestration layer. It fits teams that need a working Prometheus/Alertmanager/Grafana baseline without Kubernetes operators or managed services. For multi-cluster, GitOps-driven, or highly available deployments, use the Kubernetes manifests under `Prometheus/manifests/` (when available) or the Prometheus Operator / kube-prometheus-stack Helm chart instead.

## Prerequisites

- Docker Engine with the Compose plugin (`docker compose version` reports a version).
- Available host ports: 9090 (Prometheus), 9093 (Alertmanager), 3000 (Grafana). Override via `PROMETHEUS_PORT`, `ALERTMANAGER_PORT`, `GRAFANA_PORT` in `.env` if needed.
- At least 2 GB free disk space for the Prometheus TSDB and Grafana SQLite database (persisted in named volumes).
- No external registry access required — all images pull from Docker Hub on first start.

## Steps

1. Copy the scaffold into a new project directory:

   ```bash
   cp -r prometheus-alertmanager-grafana-stack/ monitoring/
   cd monitoring
   ```

2. Create the environment file from the template and set secure passwords:

   ```bash
   cp .env.example .env
   # Edit .env and set GRAFANA_ADMIN_PASSWORD, ALERTMANAGER_WEBHOOK_URL, etc.
   ```

3. Build and start the stack in the background:

   ```bash
   docker compose up --build -d
   ```

4. Wait for all services to report healthy (health checks validate HTTP endpoints):

   ```bash
   docker compose ps
   ```

5. Access the UIs and verify provisioning:
   - Prometheus: http://localhost:9090 — Targets page should show `prometheus`, `alertmanager`, `grafana`, and `node-exporter` (if enabled) as UP.
   - Alertmanager: http://localhost:9093 — Status page shows the configured receivers and inhibition rules.
   - Grafana: http://localhost:3000 — Log in with `admin` / the password from `.env`; the "System Overview" dashboard should be pre-loaded and querying Prometheus.

## Verify

- Run `docker compose ps` — all four services (`prometheus`, `alertmanager`, `grafana`, `node-exporter`) report `healthy`.
- Run `curl -s http://localhost:9090/-/healthy` — returns `Prometheus Server is Healthy.`
- Run `curl -s http://localhost:9093/-/healthy` — returns `OK`.
- Run `curl -s -u admin:${GRAFANA_ADMIN_PASSWORD} http://localhost:3000/api/health` — returns `{"database":"ok","version":"..."}`.
- In Prometheus UI, execute `up` — all targets return `1`.
- In Grafana, open the "System Overview" dashboard — panels render without "No data" errors.

## Rollback

- If a configuration change breaks scraping: revert the edited file (`prometheus.yml`, `alertmanager.yml`, or a Grafana provisioning file), then `docker compose up -d <service>` to reload that service. Prometheus and Alertmanager reload on SIGHUP; Grafana requires a container restart for provisioning changes.
- If persistent data is corrupted: `docker compose down -v` removes the named volumes (`prometheus-data`, `alertmanager-data`, `grafana-data`). Re-run `docker compose up --build -d` to reinitialize. This destroys all historical metrics and dashboards.
- If an image tag was overridden via environment variables and introduced a regression: revert the tag in `.env` and run `docker compose up -d` to roll back to the previous images.

## Common errors

- **Prometheus targets show `DOWN` for `alertmanager` or `grafana`**: the scrape configs reference service names (`alertmanager:9093`, `grafana:3000`) which resolve on the Compose network. Confirm the services are on the same `monitoring` network and the ports match the container ports (not host ports).
- **Alertmanager UI returns 404 on `/alerts`**: the webhook receiver is not configured or the webhook URL is unreachable. Check `alertmanager.yml` receivers and the `ALERTMANAGER_WEBHOOK_URL` value in `.env`.
- **Grafana dashboard shows "No data" for all panels**: the Prometheus datasource provisioning failed or the UID mismatch. Verify `grafana/provisioning/datasources/datasource.yaml` has `uid: prometheus` and the dashboard JSON references the same UID. Restart Grafana after fixing: `docker compose restart grafana`.
- **`docker compose up` fails with "port is already allocated"**: another process holds one of the published ports. Change the corresponding `*_PORT` variable in `.env` or stop the conflicting process.
- **Permission denied on volume mounts**: on Linux with SELinux or restrictive umask, the container UID (65534 for Prometheus, 472 for Grafana) may not write to the host-mounted volume. The scaffold uses named volumes (not bind mounts) to avoid this; if bind mounts are added, set `:Z` or `:z` SELinux labels or adjust host directory permissions.

## References

- [docker-compose.yaml](./docker-compose.yaml) — service definitions, volumes, networks, health checks.
- [prometheus.yml](./prometheus.yml) — scrape configs, rule files, remote-write (disabled by default).
- [alertmanager.yml](./alertmanager.yml) — route tree, receivers, inhibition rules, templates.
- [grafana/provisioning/datasources/datasource.yaml](./grafana/provisioning/datasources/datasource.yaml) — Prometheus datasource provisioning.
- [grafana/provisioning/dashboards/dashboard.yaml](./grafana/provisioning/dashboards/dashboard.yaml) — dashboard provider configuration.
- [grafana/dashboards/system-overview.json](./grafana/dashboards/system-overview.json) — starter dashboard (CPU, memory, disk, network, Prometheus/Alertmanager health).
- [.env.example](./.env.example) — environment variable template with secure defaults.
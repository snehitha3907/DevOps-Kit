---
last_verified: 2026-10-29
tool_version: n/a
sources: []
---

# Integrating Prometheus with related tools

## Purpose

This document describes how Prometheus fits alongside the tools most teams pair with it: Grafana for visualization, Alertmanager for alert routing, and the OpenTelemetry Collector for ingestion. It focuses on integration points and data flow rather than end-to-end installation of any single component.

## When to use

- Adding dashboards or alerting on top of an existing Prometheus deployment
- Bridging Prometheus metrics with an OpenTelemetry-based pipeline
- Deciding whether to keep Alertmanager separate or use a managed alerting backend
- Troubleshooting missing data between Prometheus and a downstream consumer

## Prerequisites

- A running Prometheus instance with at least one scrape target
- Access to the Prometheus HTTP API and remote-write endpoint (if used)
- Grafana, Alertmanager, or an OpenTelemetry Collector deployed, depending on the integration

## Steps

### 1. Prometheus and Grafana

Grafana reads Prometheus through a data source configured with the Prometheus server URL. Point Grafana at the Prometheus HTTP endpoint (typically `http://prometheus:9090`) and set the scrape interval to match Prometheus's `scrape_interval` so panels align with sample timestamps.

Key integration behaviors:

- **Query language**: Grafana panels use PromQL. Use `rate()` and `increase()` for counters; raw counters over time produce misleading graphs.
- **Label matching**: Grafana template variables map to Prometheus label values (e.g., `$namespace`, `$pod`). Ensure the label exists on the scraped series.
- **Alerting**: Grafana can evaluate alerts against Prometheus data, but for high-volume alert routing, prefer Alertmanager (below) to avoid duplicating rule evaluation.
- **Provisioning**: Data sources and dashboards can be provisioned via YAML under Grafana's provisioning directory for reproducible setups.

### 2. Prometheus and Alertmanager

Prometheus evaluates recording and alerting rules locally, then pushes firing alerts to Alertmanager over its HTTP API. Alertmanager handles grouping, deduplication, silencing, and routing to receivers (email, Slack, PagerDuty, webhook).

Minimal Prometheus configuration:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["alertmanager:9093"]
rule_files:
  - /etc/prometheus/rules/*.yml
```

Minimal alert rule example:

```yaml
groups:
  - name: instance-health
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} is down"
```

Key integration behaviors:

- **Routing**: Alertmanager routes by label matchers in its config; Prometheus only sends alerts, it does not route them.
- **Inhibition**: Use Alertmanager inhibition rules to suppress dependent alerts (e.g., suppress node alerts when the cluster is down).
- **Silences**: Created in Alertmanager, not Prometheus; they expire automatically.
- **HA**: Run multiple Alertmanager instances; Prometheus can send to all of them, and Alertmanager clusters gossip state.

### 3. Prometheus and the OpenTelemetry Collector

The OpenTelemetry Collector can act as both a scrape target for Prometheus and a forwarding layer via remote write.

Two common patterns:

- **Scrape then export**: Collector's `prometheus` receiver scrapes Prometheus-format endpoints; the `prometheusremotewrite` exporter forwards to a backend. Useful when Prometheus server is not deployed.
- **Receive then expose**: Collector's `prometheus` exporter exposes an endpoint Prometheus scrapes. Useful for aggregating OTLP metrics into a Prometheus-compatible view.

Minimal collector config (scrape and forward):

```yaml
receivers:
  prometheus:
    config:
      scrape_configs:
        - job_name: app
          static_configs:
            - targets: ["app:8080"]
exporters:
  prometheusremotewrite:
    endpoint: https://backend.example.com/api/v1/remote_write
service:
  pipelines:
    metrics:
      receivers: [prometheus]
      exporters: [prometheusremotewrite]
```

Key integration behaviors:

- **Label translation**: OTLP resource attributes become Prometheus labels; high-cardinality attributes can inflate series count.
- **Naming**: OTLP metric names may be sanitized to Prometheus conventions (dots to underscores, unit suffixes).
- **Remote write**: When forwarding, set `queue_config` and retry settings to avoid data loss during backend outages.

### 4. Prometheus and Thanos / Cortex / Mimir (long-term storage)

For retention beyond a single Prometheus node, teams deploy a sidecar or remote-write to a long-term storage backend.

- **Thanos**: Sidecar uploads blocks to object storage; Querier fans out across Prometheus and storage. Global view across clusters.
- **Cortex / Mimir**: Horizontally scalable, multi-tenant Prometheus-compatible backend; ingestion via remote write.
- **Trade-offs**: Added operational complexity; query latency increases with retention; consider downsampling for long ranges.

### 5. Cross-tool data flow summary

| Source | Integration mechanism | Consumer | Notes |
|--------|----------------------|----------|-------|
| Application `/metrics` | Prometheus scrape | Prometheus TSDB | Pull model; service discovery via Kubernetes or static config |
| Prometheus alerts | HTTP push | Alertmanager | Grouping, routing, silencing |
| Prometheus series | PromQL queries | Grafana | Visualization and ad-hoc exploration |
| Prometheus samples | Remote write | Thanos/Cortex/Mimir/managed backends | Long-term storage and global query |
| OTLP metrics | Collector receiver/exporter | Prometheus or backend | Bridge between pull and push worlds |

## Verify

1. **Grafana**: Open a dashboard panel; confirm data renders and the time range matches Prometheus samples. Check the data source "Test" button returns success.
2. **Alertmanager**: Trigger a test alert (e.g., stop a scraped instance); confirm it appears in Alertmanager UI and routes to the configured receiver.
3. **Collector**: Check collector logs for successful scrape and export; query the backend for a known metric name.
4. **Remote write**: Inspect Prometheus `prometheus_remote_write_*` metrics for non-zero `samples_total` and zero `samples_failed_total`.

## Common errors

| Symptom | Likely cause | Resolution |
|---------|--------------|------------|
| Grafana shows "No data" | Data source URL wrong or Prometheus not reachable | Verify URL, network policy, and Prometheus readiness |
| Alerts fire in Prometheus but never reach Alertmanager | `alertmanagers` target misconfigured or network blocked | Check config and connectivity to port 9093 |
| Duplicate alerts | Multiple Prometheus instances evaluating same rules without HA dedup | Use Alertmanager clustering or designate a single evaluator |
| Collector exports no series | Receiver scrape config targets wrong port or path | Align port/path with application metrics endpoint |
| Remote write backlog grows | Backend slow or undersized | Tune `queue_config`, add shards, or scale backend |

## References

- Prometheus documentation: Alerting
- Prometheus documentation: Remote write
- Grafana documentation: Prometheus data source
- OpenTelemetry Collector: Prometheus receiver and exporter
- Thanos documentation: Architecture
- Cortex / Mimir documentation
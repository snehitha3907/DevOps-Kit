---
last_verified: 2026-10-28
tool_version: n/a
sources:
  - https://techoral.com/kubernetes/kubernetes-argocd-gitops.html
---

# Integrating Prometheus with related tools

## Purpose

This document maps how Prometheus connects to the rest of a typical observability and delivery stack: Grafana for visualization, Alertmanager for alert routing, Kubernetes for service discovery, and Thanos/Cortex/Mimir for long-term storage and global query. Each section describes the integration point, the configuration shape, and the common failure modes.

## When to use

- Wiring a new Prometheus deployment into an existing Grafana or Alertmanager instance
- Choosing a long-term storage backend for multi-cluster Prometheus
- Adding GitOps-driven deployments (Argo CD / Flux) with Prometheus-based analysis
- Auditing which integrations are in place and which are missing

## Prerequisites

- A running Prometheus server (self-hosted or managed)
- Network reachability between Prometheus and each integration target
- Configuration access to Prometheus, Grafana, and Alertmanager
- For long-term storage: object storage (S3/GCS/Azure Blob) or a Cortex/Mimir backend

## Integrations

### Grafana

Grafana connects to Prometheus via a data source pointing at the Prometheus HTTP API (`/api/v1`).

Configuration:
- Type: Prometheus
- URL: `http://prometheus:9090` (or the managed endpoint)
- Access: Server (recommended) or Browser
- Scrape interval must match Prometheus's `scrape_interval` for accurate rate() calculations

Key dashboard panels typically query:
- `up` for target health
- `rate(http_requests_total[5m])` for request throughput
- `histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))` for latency percentiles

Common issue: Grafana's default 30s refresh can mask gaps if Prometheus scrape interval is 15s. Align intervals.

### Alertmanager

Prometheus evaluates alerting rules and sends firing alerts to Alertmanager, which routes them to receivers (email, Slack, PagerDuty, Opsgenie).

Prometheus config:
```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager:9093']
```

Alertmanager config (routing example):
```yaml
route:
  group_by: ['alertname', 'cluster']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  receiver: 'default'
receivers:
  - name: 'default'
    slack_configs:
      - channel: '#alerts'
        send_resolved: true
```

Common issue: Alerts fire but never resolve because the `for` duration is too short or Alertmanager is unreachable from Prometheus.

### Kubernetes

See `prometheus-kubernetes-integration.md` for full detail. Summary:
- Service discovery via `kubernetes_sd_config` (pod, service, endpoints, node, ingress roles)
- Pod annotations (`prometheus.io/scrape`, `prometheus.io/port`, `prometheus.io/path`) opt pods in
- kube-state-metrics provides cluster-object metrics (deployments, pods, nodes, PVCs)
- Resource usage (CPU/memory) comes from cAdvisor via the kubelet

### Thanos / Cortex / Mimir (long-term storage)

Prometheus's local storage is not designed for multi-year retention or global query across clusters. Thanos, Cortex, and Mimir sit in front of (or alongside) Prometheus to provide:

- Object storage-backed block storage (S3, GCS, Azure Blob)
- Global query via a Querier that fans out to multiple Prometheus instances
- Downsampling and compaction for cost control
- Optional rule evaluation and alerting in the backend

Integration pattern (Thanos sidecar):
```yaml
# Thanos sidecar runs alongside Prometheus
# Prometheus config enables remote write or sidecar uploads blocks
# Querier aggregates across Prometheus + Thanos Store gateways
```

Common issue: Queries return partial data when a Prometheus instance is down and Thanos Store gateway has not compacted recent blocks.

### GitOps controllers (Argo CD / Flux)

Prometheus metrics feed GitOps analysis and rollout decisions:
- Argo Rollouts can use Prometheus AnalysisTemplates to gate canary/blue-green promotions. Per published guidance, Argo Rollouts supports canary and blue-green strategies with Prometheus AnalysisTemplates [source: https://techoral.com/kubernetes/kubernetes-argocd-gitops.html].
- Flux CD can use Prometheus metrics in its notification provider and health checks.

Common issue: AnalysisTemplate queries use the wrong metric name or label selector, causing rollouts to fail promotion even when the service is healthy.

### OpenTelemetry Collector

The OpenTelemetry Collector can scrape Prometheus-format endpoints and forward metrics via OTLP to a backend, or receive Prometheus remote write. Useful for:
- Unifying metrics pipelines across vendors
- Adding tail-based sampling or attribute processing before storage
- Bridging Prometheus to managed backends (AMP, GMP, Azure Managed Prometheus)

Common issue: Metric name collisions when both Prometheus and OTEL Collector scrape the same target.

## Verify

1. Grafana: Add Prometheus data source, run `up` query, confirm targets appear with expected labels.
2. Alertmanager: Trigger a test alert (`ALERTS` metric or a synthetic alert), confirm it reaches the receiver channel.
3. Kubernetes: Confirm `up{job="kubernetes-pods"}` returns pods after annotation changes.
4. Long-term storage: Run a query spanning a period older than Prometheus's local retention; confirm Thanos/Cortex/Mimir returns data.
5. GitOps: Trigger a canary rollout with an AnalysisTemplate; confirm the Prometheus query result drives promotion.

## Common errors

| Symptom | Likely cause | Resolution |
|---------|--------------|------------|
| Grafana shows "No data" | Data source URL wrong or Prometheus not reachable from Grafana pod | Fix URL; check network policy / service DNS |
| Alerts fire but no notification | Alertmanager receiver misconfigured or network blocked | Check Alertmanager logs; verify `alertmanagers` target in Prometheus |
| Duplicate metrics in Grafana | Both Prometheus and another scraper (OTEL) ingesting same target | Deduplicate scrape targets; use `metric_relabel_configs` |
| Thanos query returns partial data | Prometheus instance down or compaction lag | Check Thanos sidecar health; wait for compaction |
| AnalysisTemplate rollout stuck | PromQL query returns no data or wrong value | Test the query in Prometheus UI first; fix label selectors |

## References

- Prometheus documentation: Alerting
- Prometheus documentation: Remote write
- Grafana documentation: Prometheus data source
- Alertmanager documentation: Configuration
- Thanos documentation: Architecture
- Argo Rollouts documentation: Analysis
- OpenTelemetry Collector documentation: Prometheus receiver

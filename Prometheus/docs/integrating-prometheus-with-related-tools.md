---
last_verified: 2026-10-29
tool_version: n/a
sources: []
---

# Integrating Prometheus with related tools

## Purpose

Prometheus rarely runs alone. This document describes how Prometheus connects to the tools commonly paired with it — Grafana for visualization, Alertmanager for alert routing, Kubernetes for service discovery, and remote-write stores for long-term retention — and where each integration's boundaries sit.

## When to use

- You already have a working Prometheus server and want to extend it into a monitoring stack.
- You are deciding which adjacent tool owns which responsibility (scraping vs. dashboards vs. alerting).
- You need a single reference for the integration points before wiring them together.

## Prerequisites

- A running Prometheus instance with at least one scrape target.
- Network reachability between Prometheus and each integrated tool.
- For Kubernetes integration: cluster access with RBAC permission to read pods, services, and endpoints.

## Steps

### 1. Visualize with Grafana

Add Prometheus as a data source in Grafana by pointing it at the Prometheus HTTP API endpoint. Grafana queries Prometheus through PromQL and renders panels from the returned series. Keep dashboards read-only against Prometheus; never write through Grafana.

### 2. Route alerts with Alertmanager

Configure Prometheus to send firing alerts to Alertmanager via the `alerting` block in the Prometheus configuration. Alertmanager then deduplicates, groups, and routes notifications to receivers such as email, Slack, or PagerDuty. Prometheus evaluates rules; Alertmanager decides who gets paged.

### 3. Discover targets in Kubernetes

Use the Kubernetes service-discovery configurations in Prometheus to scrape pods, services, and endpoints automatically. Annotate workloads with `prometheus.io/scrape`, `prometheus.io/port`, and `prometheus.io/path` so Prometheus picks them up without static target lists. Pair this with kube-state-metrics for cluster-level object state.

### 4. Export application metrics

Instrument applications with a Prometheus client library and expose a `/metrics` endpoint. Prometheus scrapes that endpoint on its configured interval. Prefer histograms over summaries when you need aggregatable latency percentiles across instances.

### 5. Retain long-term with remote write

Configure `remote_write` in Prometheus to forward samples to a long-term store such as Thanos, Cortex, or a managed Prometheus service. This keeps local retention short while preserving history for trend analysis and SLO reporting.

### 6. Verify integrations

Check that each integration reports healthy: Grafana shows data, Alertmanager receives test alerts, Kubernetes targets appear in the Targets page, and remote-write queues drain without errors.

## Verify

- Grafana panels render data from the Prometheus data source.
- A test alert fired in Prometheus appears in Alertmanager.
- Kubernetes-discovered targets show as `UP` on the Targets page.
- Remote-write queue depth returns to zero after a burst of samples.

## Common errors

| Symptom | Likely cause | Fix |
|---|---|---|
| Grafana panels empty | Wrong Prometheus URL or auth | Correct the data source URL and credentials |
| Alerts never reach Alertmanager | Missing `alerting` block | Add the Alertmanager endpoint to Prometheus config |
| Kubernetes targets missing | Missing RBAC or annotations | Grant read access and add scrape annotations |
| Remote-write backlog grows | Store unreachable or undersized | Check network and store capacity |

## References

- Prometheus documentation: configuration and integration guides.
- Grafana documentation: Prometheus data source setup.
- Alertmanager documentation: routing and receivers.
- Kubernetes documentation: service discovery and RBAC.
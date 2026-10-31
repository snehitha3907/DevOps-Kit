---
last_verified: 2026-10-20
tool_version: n/a
sources: []
---

# How I wired Grafana into Prometheus and Alertmanager for unified metrics and alert visibility

## Purpose

This is one way to unify metrics and alerts in Grafana by pulling time series from Prometheus and surfacing Alertmanager state in the same dashboards. The goal is to correlate what is firing with the graphs that show why, without jumping between three different UIs during an incident. This is a practical wiring, not a prescription — different orgs structure routing differently, so treat it as a starting point.

## Prerequisites

- Prometheus scraping targets and evaluating rules (alerts should already be defined; see the Prometheus demo rules in this kit)
- Alertmanager configured with receivers/routes
- Grafana installed and reachable (the primer shows a quick Docker start)
- Network reachability from Grafana to Prometheus and to Alertmanager

## Steps

### 1. Add Prometheus as a data source in Grafana

In Grafana, add a data source of type `Prometheus`. Point it at the Prometheus base URL (e.g. `http://prometheus:9090`). Save and test — Grafana will run a simple query to confirm connectivity. Keep the data source name stable (e.g. `Prometheus`) since dashboards will reference it.

### 2. Add Alertmanager as a data source in Grafana

Add a data source of type `Alertmanager`. Point it at the Alertmanager URL (e.g. `http://alertmanager:9093`). Grafana can use this to show alert states and groupings. Depending on version, you may need to set the implementation to `Prometheus` or use the native Alertmanager data source — check what is available in your Grafana build and pick the one that lists active alerts.

### 3. Build a unified dashboard

Create a dashboard that brings both together:

1. **Metrics panels**: add panels querying Prometheus (e.g. request rate, error ratio, latency). Use variables (like `job` or `instance`) to keep one board reusable.
2. **Alert list panel**: add an "Alert list" panel backed by the Alertmanager data source to show currently firing alerts with severity, labels, and annotations.
3. **Correlate by time**: keep the dashboard time range shared. When an alert fires, you can zoom to the firing window and see the corresponding spike in the metric panels.

This is where the value is — the same view shows the symptom (graph) and the active alert (list) without context switching.

### 4. Make alerts actionable from Grafana

If Grafana is configured with unified alerting, alerts can be defined in Grafana using Prometheus as the data source. Alternatively, keep alert rules in Prometheus/Alertmanager (as done in this kit) and use Grafana purely for visualization of both metrics and alert state. Either way works; the key is consistency in labels (e.g. `severity`, `alertname`, `job`) so routing and filtering behave predictably.

## Verify

1. **Data sources**: both Prometheus and Alertmanager show "Data source is working" in their test pages.
2. **Metrics flow**: a Prometheus query from a Grafana panel returns data for a known time range.
3. **Alerts visible**: trigger a test alert (or use an existing demo alert) and confirm it appears in the Grafana Alert list panel within the group_wait window.
4. **Correlation**: with the alert firing, the related metric panel should show the condition that caused it (e.g. error ratio crossing threshold). If labels don't align, the view is still useful, but correlation is weaker.

## Notes

- Grafana does not store Prometheus metrics or Alertmanager state — it queries them on read. If Prometheus or Alertmanager is down, panels and alert lists will fail to load.
- Keep secrets (like any auth tokens) out of dashboard JSON committed to VCS; use data source provisioning or Grafana's secret storage where possible.
- If using multiple environments, use Grafana folders and data source variables to avoid hardcoding URLs.

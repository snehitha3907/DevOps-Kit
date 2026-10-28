---
last_verified: 2026-10-28
tool_version: n/a
sources: []
---

# Prometheus recording rules and alert reference

## Purpose

This document describes how to write Prometheus recording rules and alerting rules. Recording rules precompute frequently used or expensive PromQL expressions and save the results as new time series, which speeds up dashboards and alerts. Alerting rules define conditions that, when true for a sustained period, fire alerts that Prometheus sends to Alertmanager for notification.

## When to use

- A dashboard query is slow because it aggregates over many series or long ranges; record the result once and graph the recorded series instead.
- The same complex expression appears in multiple dashboards or alerts; record it once so every consumer shares one definition.
- You want alerts to fire only after a condition persists (for example, CPU above 85% for five minutes) rather than on a single scrape.
- You need to route alerts by severity, team, or service before they reach Alertmanager.

## Prerequisites

- A running Prometheus server (self-hosted or a Prometheus Agent in scraping mode)
- File-system access to edit Prometheus rule files and reload Prometheus (via `/-/reload` or `SIGHUP`)
- Basic PromQL familiarity: selectors, aggregation operators (`avg`, `max`, `sum`, `rate`, `increase`), and labels

## Steps

### 1. Recording rules

A recording rule lives in a rule file under a `groups:` block. Each rule has a unique `name`, a PromQL `expr`, and optional `labels` and `annotations`. The result is persisted as a new metric that can be scraped and queried like any other series.

Rule names follow the `<job>:<metric>:<operation>:<duration>` convention (for example, `job:http_requests:rate5m`), which makes the rule's origin and computation obvious from the metric name alone.

Example rule file:

```yaml
groups:
  - name: node-recording-rules
    interval: 30s
    rules:
      - record: instance:node_cpu_utilization:ratio
        expr: |
          1 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
        labels:
          job: node-exporter
      - record: job:http_requests:rate5m
        expr: |
          sum by (job) (rate(http_requests_total[5m]))
        annotations:
          description: "Per-job request rate over the last 5 minutes"
```

Rules in one group are evaluated sequentially; rules in different groups are evaluated in parallel. Use `interval` to control how often a group is re-evaluated.

### 2. Alerting rules

An alerting rule also lives in a `groups:` block. Each rule declares `alert` (the alert name), `expr` (the firing condition), and `for` (how long the condition must hold before the alert fires). Optional `labels` (such as `severity`) and `annotations` (such as `summary` and `description`) attach metadata to every alert instance.

```yaml
groups:
  - name: alerting-rules
    interval: 30s
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} down"
          description: "Instance {{ $labels.instance }} of job {{ $labels.job }} has been down for more than 2 minutes."

      - alert: HighCpuUsage
        expr: instance:node_cpu_utilization:ratio > 0.85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
```

The `for` clause suppresses flapping: an alert fires only after the expression is true continuously for the given duration, and resolves only after it is continuously false.

### 3. Rule files and reload

Store rule files in a directory Prometheus can read (for example, `/etc/prometheus/rules/` or a Git-tracked config directory referenced by `rule_files:` in `prometheus.yml`):

```yaml
rule_files:
  - "/etc/prometheus/rules/*.yml"
```

After editing a rule file, reload Prometheus without restarting:

```bash
# Reload Prometheus without restarting. Substitute your Prometheus host for <prometheus-host>.
curl -X POST <prometheus-host>:9090/-/reload
```

Check `<prometheus-host>:9090/api/v1/status/rules` to confirm rules loaded, and `/-/healthy` for the reload status.

## Verify

1. **Recording rules load**: In the Prometheus UI, go to Status → Rules. Confirm each recording rule shows `State: active` and the last evaluation time is recent.
2. **Recorded series exist**: Query the recorded metric directly (for example, `job:http_requests:rate5m`) and confirm it returns values matching the source expression sampled at the same interval.
3. **Alerts evaluate**: In Status → Rules, confirm alert rules show `State: active`; temporarily lower a threshold in a test rule and confirm the alert moves to `pending` then `firing` after the `for` duration, and appears in Alertmanager.
4. **Reload succeeded**: Query `prometheus_treemap` or check `/-/healthy` returns `prometheus is healthy.` after a `/-/reload`.

## Common errors

| Symptom | Likely cause | Resolution |
|---------|--------------|------------|
| Rule shows `State: inactive` or `parse error` | Indentation error or missing `groups:`/`rules:` keys in YAML | Validate YAML syntax; confirm every rule is nested under `groups: [].rules:` |
| Recorded metric returns no data | `expr` selects no series, or evaluation interval has not elapsed since reload | Run the raw expression in the query builder; confirm `rule_files` glob matches the file |
| Alert fires and immediately resolves | Missing `for` clause, so a single scrape triggers the alert | Add `for: <duration>` to require a sustained condition |
| Alert never fires despite condition met | `for` duration too long, or metric labels mismatch the expression | Reduce `for` for testing; confirm label names in `expr` match actual series |
| `/-/reload` returns 500 | Invalid rule file loaded; Prometheus kept the previous configuration | Check Prometheus logs for the rule parse error, fix the file, and reload again |

## References

- Prometheus documentation: Recording rules
- Prometheus documentation: Alerting rules
- Prometheus documentation: Rule evaluation and reload
- PromQL documentation: Aggregation operators
- Prometheus documentation: Querying rules via the HTTP API

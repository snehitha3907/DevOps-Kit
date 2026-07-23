---
last_verified: 2026-07-23
tool_version: n/a
---

# Prometheus — quick primer

> First-day notes for someone who's never used Prometheus. Personal voice, plain language.

## What is it?

Prometheus is an open-source monitoring system I just started looking into. It scrapes HTTP endpoints that expose metrics, stores them in a time-series database, and lets me query with PromQL. I think of it as a pull-based metrics collector — it asks services for data instead of waiting for them to send it.

## What does it do?

I give it a list of target endpoints, and it polls them on a schedule. Each target returns metric values like request counts or memory usage. I can query that data, build dashboards, or set alert rules that fire when a threshold is crossed.

## Why does it exist?

Before Prometheus, monitoring meant Nagios-style checks or push-based tools like statsd. Prometheus popularized pull-based scraping — a failed scrape is itself the alert. I can see why platform teams use it as the foundation of their observability stack.

## Key terminology

- **Metric** — a named value with labels. Example: `http_requests_total{method="GET"}`.
- **Label** — a key-value dimension. Example: `job="nginx"`.
- **PromQL** — the query language. Example: `rate(http_requests_total[5m])`.
- **Target** — an endpoint Prometheus scrapes. Example: `localhost:9090/metrics`.
- **Alertmanager** — routes fired alerts to email, Slack, etc.
- **Exporter** — adapts third-party metrics to Prometheus format. Example: Node Exporter.
- **ServiceMonitor** — a K8s CRD that tells Prometheus which pods to scrape.

## A tiny example

```bash
docker run -d --name my-prometheus -p 9090:9090 prom/prometheus
```

This starts Prometheus scraping itself. I can open `http://localhost:9090` and try my first PromQL query.

## What I'll cover next

I want to write my own scrape config, instrument an app, and set up an alert rule.

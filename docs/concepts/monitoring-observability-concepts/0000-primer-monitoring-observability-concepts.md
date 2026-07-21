---
last_verified: 2026-07-21
tool_version: n/a
---

# Monitoring & Observability Concepts — quick primer

> First-day notes on Monitoring & Observability Concepts. What it is, why it matters, and the key ideas to know.

## What is it?

I just learned that monitoring and observability are two sides of the same coin, but they're not the same thing. Monitoring is the practice of watching known things — CPU usage, memory, request latency, error rates — using predefined checks and dashboards. You set thresholds, and when something crosses them, an alert fires. It's like having smoke detectors in your house: they only tell you something is wrong after it's already happening.

Observability goes further. It's the ability to ask arbitrary questions about a system's internal state by looking at the data it produces, without having to predict every possible failure mode in advance. The term comes from control theory: a system is "observable" if you can determine its internal state from its external outputs. In practice, this means collecting three pillars of data — metrics, logs, and traces — and correlating them so you can debug issues you never anticipated.

## Why does it matter for devops?

As a DevOps engineer, I'm responsible for systems that are supposed to stay up while changing constantly. Monitoring tells me when something is broken, but observability tells me why. Without observability, I'm stuck guessing: "The latency spiked, but was it the database, the network, or the new deployment?" With observability, I can trace a single request through every service it touched and see exactly where time was lost.

This matters most during incidents. When a page fires at 2 AM, I don't want to be adding print statements or reproducing the issue in staging. I want dashboards that show the golden signals (latency, traffic, errors, saturation), structured logs I can filter by request ID, and distributed traces that span microservices. Observability turns a three-hour firefight into a twenty-minute root-cause analysis.

## Key terminology

- **Metric** — A numeric measurement collected over time, like `http_requests_total` or `process_cpu_seconds`. Metrics are cheap to store and fast to query, which makes them perfect for dashboards and alerts.
- **Log** — A timestamped text record of an event, usually structured as JSON with fields like `level`, `service`, and `message`. Logs tell the story of what happened in detail.
- **Trace** — A record of a single request's path through multiple services, showing each hop's duration and metadata. Distributed tracing is what lets me see that a 2-second API call spent 1.4 seconds waiting on a downstream database query.
- **Alert** — A notification triggered when a metric crosses a threshold or a condition is met. Good alerts are actionable and low-noise; bad alerts train on-call engineers to ignore them.
- **Dashboard** — A visual panel that graphs metrics and logs for at-a-glance system health. A good dashboard answers "is everything okay?" in under ten seconds.
- **Service Level Indicator (SLI)** — A specific measurable attribute of a service, such as request latency or availability percentage. SLIs are the raw numbers behind service level agreements.
- **Service Level Objective (SLO)** — A target value for an SLI, like "99.9% of requests return in under 200ms". SLOs give teams a shared language for reliability instead of vague "make it faster" goals.

## A concrete example

Imagine a web service running on three pods behind a load balancer. I install a Prometheus client library in the app that exposes a `/metrics` endpoint. The app emits a counter `http_requests_total{method="GET",code="200"}` for every successful request and a histogram `http_request_duration_seconds` for latency. I also ship JSON-structured logs to a central aggregator and tag each log line with a `trace_id` so I can correlate it with traces.

When traffic spikes, my latency alert fires because the 99th percentile crossed 500ms. I open my dashboard and see the latency graph climb right when a new deployment rolled out. I click into the traces for that time window and spot that the new version makes an extra synchronous call to an auth service on every request. Without metrics, logs, and traces linked together, I'd still be looking at deployment diffs and hoping to spot the bug.

## How this connects to what's next

Monitoring and observability are the foundation for every tool in this kit that talks about production health. Once I understand metrics, logs, and traces, I can use Prometheus for scraping and alerting, Grafana for dashboards, and structured logging in Docker or Kubernetes. The concept also connects to CI/CD because observable pipelines surface build failures and flaky tests faster than silent retries.

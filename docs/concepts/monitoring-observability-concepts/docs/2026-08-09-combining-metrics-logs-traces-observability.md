---
last_verified: 2026-08-09
tool_version: n/a
sources:
  - https://oneuptime.com/blog/post/2026-02-09/deployment-gates-prometheus-cicd/view
  - https://oneuptime.com/blog/post/2026-02-26/argocd-canary-analysis-prometheus/view
  - https://about.gitlab.com/blog/how-to-build-ci-cd-observability-at-scale/
---

# Stitching metrics, logs, and traces into one request story

> L2 concept notes — what I learned when I stopped treating metrics, logs, and traces as three separate dashboards and started following one request end-to-end.

## What I set out to do

I wanted one place to answer "what happened to this request?" instead of three. The metrics graph told me latency jumped, the logs told me a request 500'd, and the trace told me which hop slowed down — but each lived in its own UI and I had to rebuild the story in my head. So I set out to tag every piece of data with the same request identifier and build a flow where a spike on the latency dashboard links straight to the matching trace and its log lines.

## How the three pillars connect

Metrics are the always-on pulse: counters, histograms, and gauges scraped over time. They're cheap to store and fast to alert on, which makes them great for SLOs, but they lose detail the moment you aggregate. Logs are the detailed diary of events for a single request — timestamps, levels, messages — useful for debugging but painful to query at scale unless they're structured. Traces are the request itself, drawn as a tree of spans showing how a call flowed across services.

The glue is a shared identifier. If every log line and every metric sample is tagged with the same trace_id, a spike in the metric points at the exact trace, and that trace pulls in all the log lines for the same journey. The three pillars stop being separate tools and become one story told at different resolutions.

## Hands-on: stitching them together

I instrumented one service so every layer carries the same key:

```python
# I give every layer the same trace_id so the three pillars can be joined later
trace_id = "8ff2d3c4-…"   # produced by my tracer, flows through the request

# traces: each hop is a span tagged with trace_id
with tracer.start_as_current_span("fetch_order", attributes={"trace_id": trace_id}):
    order = db.fetch(order_id)
    log.info("fetched order", extra={"trace_id": trace_id, "order_id": order_id})

# metrics: aggregated with route/status labels, not per-request
REQUESTS.labels(route="/orders/{id}", code="200").inc()
```

The metric and the trace share the request's trace_id, so an alert that fires on a 5xx error rate points at a single trace whose child spans show which downstream call is on fire — and the JSON logs for that trace_id fill in the detail no span captures. I'm pairing an error-rate ratio (5xx requests over total requests) with a P99-latency comparison, then using the trace link to drill into the span that blew past the budget.

## What tripped me up

- **Sampling kills the link.** Traces sample aggressively under heavy traffic, but logs usually don't. When the trace for a slow request was sampled out, I could no longer follow the single-request story and fell back to filtering logs by service and time window. The fix was to log the trace_id even when the trace itself was dropped, so logs always carry the join key.
- **Cardinality on logs.** Tagging every log line with a trace_id sounds small, but in a busy service it explodes the field count. I learned to keep the trace_id on the structured fields and not on the human-readable message, so aggregators don't treat each request as its own series.
- **Metrics without dimensions.** My first latency histogram had no labels for route or status, so a spike on the dashboard was just a spike. Adding route and status labels let the error-rate comparison actually isolate the failing endpoint instead of alerting on an aggregate.

## What I'd try next

I want to close the loop the other direction: let a span trigger the metric alert. When a span's duration exceeds the SLO budget for its route, it already has the trace_id in hand — I want to emit a synthetic metric from the trace so the dashboard and the trace agree on the same request, instead of me clicking between two views.

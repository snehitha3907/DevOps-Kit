---
last_verified: 2026-09-25
tool_version: n/a
sources: []
---

# OpenTelemetry — quick primer

> First-day notes for someone who's never used OpenTelemetry. Personal voice, plain language.

## What is it?

OpenTelemetry is an open-source observability framework I just started reading about. It lives in the same corner of my DevOps world as Prometheus and Grafana, but it works one step earlier: before anything can be charted or alerted on, some code has to emit the raw signals. OpenTelemetry is the shared toolkit for that emitting step.

The comparison that clicked for me: Prometheus is to metrics what a single brand of notebook is to notes, and OpenTelemetry is the agreement that any pen works with any notebook. I instrument my code once with its APIs, and then I can point the resulting data at different backends without rewriting every call site.

## What does it do?

It lets me create traces, metrics, and logs from my own code with one set of libraries. I wrap interesting work in spans, count things with meters, and attach all of it to a shared context that travels with each request. Then exporters ship that data out — to a local collector while I am learning, or to a real backend later — with no changes to the instrumented code.

## Why does it exist?

Before this, every backend had its own agent and its own SDK, so switching dashboards meant re-instrumenting everything. Teams either locked into one vendor or ran three overlapping agents side by side. Folks who run services day to day — backend developers, SREs, platform engineers — wanted one neutral way to emit signals, and backend makers wanted to stop maintaining a dozen competing SDKs. So the neutral project became the place everyone builds on.

## Key terminology

- **Trace** — the full journey of one request across services. Example: one checkout click traced from the web app through payments.
- **Span** — a single timed step inside a trace. Example: a span named `charge-card` covering just the payment call.
- **Context propagation** — the trick of passing trace IDs along with each hop. Example: an ID header so the payment span lands in the same trace as the web span.
- **Metric** — a number I sample over time. Example: how many checkouts finished per minute.
- **Log** — a timestamped event line tied to a trace. Example: an error line carrying the same trace ID as the failed span.
- **Exporter** — the plug that ships my signals somewhere. Example: point it at a local collector while learning, swap it later.
- **Collector** — a middleman that receives, batches, and forwards signals. Example: one collector on my laptop feeding whatever viewer I am trying.

## A tiny example

```python
from opentelemetry import trace
tracer = trace.get_tracer("my-first-app")
with tracer.start_as_current_span("say-hello") as span:
    span.set_attribute("hello.to", "world")
    print("hello, world")
```

This grabs a tracer, wraps one small block of work in a span named `say-hello`, and sticks a label on it.

## What I'll cover next

I want to actually install the Python packages and run a local collector so my spans land somewhere I can look at. After that I will try wiring context through two tiny services, and write down everywhere the setup trips me up.

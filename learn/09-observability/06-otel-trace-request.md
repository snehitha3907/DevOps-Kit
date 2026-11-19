---
last_verified: 2026-11-19
tool_version: 1.45.2
sources:
  - https://opentelemetry.io/docs/languages/python/instrumentation/
  - https://opentelemetry.io/docs/languages/python/exporters/
  - https://opentelemetry.io/docs/languages/python/getting-started/
  - https://opentelemetry.io/docs/collector/configuration/
  - https://opentelemetry.io/docs/collector/architecture/
---
# Trace one request with OpenTelemetry

In [OpenTelemetry — quick primer](../../otel/notes/0000-primer-opentelemetry.md) you saw that OpenTelemetry emits traces, metrics, and logs from instrumented code and ships them through an exporter, with the Collector as the middleman that receives and forwards them. In [Scrape the sample app and alert on errors](03-prometheus-scrape-and-alert.md) you ran a local service and verified it with curl. This lesson adds tracing: you instrument a small Python app, run a local OpenTelemetry Collector, and follow one request from the app into a database call by propagating the W3C `traceparent` header across an HTTP hop — then confirm both spans share one trace ID.

## What you'll learn

- Instrument a Python app with the OpenTelemetry SDK: build a `TracerProvider` with a `Resource` (`service.name`), add a `BatchSpanProcessor(OTLPSpanExporter(endpoint=...))`, set the global provider with `trace.set_tracer_provider(...)`, and wrap work in `tracer.start_as_current_span(...)`.
- Follow one request from the app to the database by injecting `traceparent`/`tracestate` into an outgoing HTTP request, creating a child span for the DB call, and confirming both spans share a trace ID in the Collector's debug output.

## Before you start

- [OpenTelemetry — quick primer](../../otel/notes/0000-primer-opentelemetry.md) — traces, spans, exporters, and the Collector as a middleman.
- [Scrape the sample app and alert on errors](03-prometheus-scrape-and-alert.md) — running a local service and verifying it with curl; the same request-flow thinking applies here.
- OpenTelemetry Python SDK 1.45.2 (`python3 -c "import opentelemetry; print(opentelemetry.__version__)"`), installed with `pip install opentelemetry-api opentelemetry-sdk opentelemetry-exporter-otlp`.
- The OpenTelemetry Collector 0.165.0 (`otelcol --version`) to receive OTLP on gRPC 4317 / HTTP 4318.
- Companion files used in this lesson: [collector-debug.yaml](../../OpenTelemetry/configs/collector-debug.yaml) and [demo-app.py](../../OpenTelemetry/scripts/demo-app.py).

## Walkthrough

1. Write the Collector config.

   Save this as `OpenTelemetry/configs/collector-debug.yaml`. It receives OTLP on gRPC 4317 and HTTP 4318 and writes every span to the `debug` exporter, which logs the full span — trace ID, span ID, parent span ID — to stdout:

   ```yaml
   receivers:
     otlp:
       protocols:
         grpc:
           endpoint: 0.0.0.0:4317
         http:
           endpoint: 0.0.0.0:4318
   exporters:
     debug: {}
   service:
     pipelines:
       traces:
         receivers: [otlp]
         exporters: [debug]
   ```

   A component must be defined and referenced in a pipeline or it is silently unused, so keep `receivers`, `exporters`, and `service.pipelines.traces` wired together as shown.

2. Start the Collector.

   ```bash
   otelcol --config=OpenTelemetry/configs/collector-debug.yaml
   ```

   You should see: the Collector starts and reports it is serving OTLP. Leave it running in this terminal.

3. Write the instrumented app.

   Save this as `OpenTelemetry/scripts/demo-app.py`. It runs a tiny HTTP "app" on :8080 and a "database" simulator on :9090. Each request to the app opens a root span `serve-request`; the app then calls the database, injecting the current W3C `traceparent` into the outgoing request so the database span becomes a child of the app's span in the same trace:

   ```python
   from opentelemetry import propagate, trace
   from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
   from opentelemetry.propagators.webtracecontext import WebTraceContextPropagator
   from opentelemetry.sdk.resources import Resource, SERVICE_NAME
   from opentelemetry.sdk.trace import TracerProvider
   from opentelemetry.sdk.trace.export import BatchSpanProcessor

   propagate.set_global_textmap(WebTraceContextPropagator())
   provider = TracerProvider(resource=Resource.create({SERVICE_NAME: "demo-app"}))
   provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter(endpoint="localhost:4317")))
   trace.set_tracer_provider(provider)
   tracer = trace.get_tracer("demo-app")
   ```

   The full script (with the app and database HTTP handlers) is at `OpenTelemetry/scripts/demo-app.py`. The key line is `propagate.inject(carrier)`: it writes `traceparent`/`tracestate` into the outgoing request so the database side can call `propagate.extract(...)` and join the existing trace.

4. Run the app and make a request.

   In another terminal:

   ```bash
   python3 OpenTelemetry/scripts/demo-app.py
   ```

   You should see: `app on :8080, database simulator on :9090, exporting to localhost:4317`.

   Then, in a third terminal:

   ```bash
   curl -s http://localhost:8080/
   ```

   You should see: `{"traced": true}` and, in the app terminal, a line like `served request trace=00000000000000000000000000000000` (a 32-hex-digit trace ID).

5. Confirm the spans landed in the same trace.

   Wait a few seconds for the batch to export (or press Ctrl-C in the app terminal to flush and shut down), then look at the Collector terminal's debug output. Find the `serve-request` span and the `db-query` span.

   You should see: both spans carry the same `traceId` (the one printed by the app), and `db-query` carries `serve-request`'s span ID as its `parentSpanId`. That parent link is the proof that one request flowed from the app into the database as a single trace.

   If instead you see two independent one-span traces, the `traceparent` header was not propagated — see Common mistakes.

## Exercise

Do the flow on your own, then break it on purpose:

1. Start the Collector with `collector-debug.yaml` and run `demo-app.py`; curl `http://localhost:8080/` and note the trace ID.
2. Confirm in the Collector debug output that `serve-request` and `db-query` share that trace ID and that `db-query`'s `parentSpanId` equals `serve-request`'s span ID.
3. Now stop the app, comment out the `propagate.inject(...)` lines in `demo-app.py`, restart, and curl again.
4. Confirm the database span is now an isolated trace with a different trace ID and no `parentSpanId` — that is what a broken propagation looks like.
5. Restore the inject lines and confirm the two spans rejoin the same trace.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
curl -s http://localhost:8080/                              # {"traced": true}
```

Then check the Collector debug output for the two spans:

- a `serve-request` span whose `traceId` matches the trace ID the app printed, and
- a `db-query` span with the same `traceId` and `parentSpanId` equal to `serve-request`'s span ID.

If you commented out `propagate.inject` in step 3 of the Exercise, the `db-query` span should have a different `traceId` and no parent link.

## Common mistakes

- No spans appear at all: the Collector is not running on 4317, the SDK was never initialized (forgot `trace.set_tracer_provider`), or sampling dropped everything. Prove the pipeline with the Collector `debug` exporter first.
- `connection refused` from the exporter: wrong port — OTLP gRPC is 4317, HTTP is 4318; they are not interchangeable.
- Two isolated one-span traces: `traceparent` was dropped between the app and the database (forgot `propagate.inject`, or the outgoing request never got the headers) — confirm both spans share a `traceId`.
- A component is defined but never exported: the Collector config lists a receiver or exporter but does not wire it into `service.pipelines.traces`; run `otelcol validate --config=` to catch it.

## Next

[Continue the learning path](../../00_index/learning-path.md)

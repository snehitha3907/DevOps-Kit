---
last_verified: 2026-10-14
tool_version: n/a
sources:
  - https://opentelemetry.io/docs/collector/architecture/
---

# Context propagation with OpenTelemetry: W3C tracecontext vs B3

## Purpose

Explain how OpenTelemetry carries trace state across service boundaries, compare the two propagation formats a practitioner will actually meet in the wild — W3C `tracecontext` and Zipkin-style `B3` — and describe what breaks when the format is mismatched, duplicated, or silently dropped between hops.

## When to use

Read this when a distributed trace stops at a service boundary and you need to figure out why. It applies whenever two services speak different propagation formats, whenever a gateway or proxy injects a header the downstream service does not understand, and whenever you are choosing a default propagator for a new service.

## Prerequisites

- A trace has a `trace_id`, a `span_id`, and a parent `span_id`.
- OpenTelemetry's `trace.set_text_map_propagator` is the single place a service picks its propagation format.
- The SDK ships with `W3CTraceContextPropagator` and `B3Propagator` enabled by default in most language SDKs.

## Steps

### 1. What propagation actually does

When a request leaves service A, the SDK writes the current span's identifiers into outgoing headers. Service B reads those headers, restores the context, and links its own span as a child of A's span. If either side fails to inject or extract, the trace silently fractures into two separate traces.

### 2. W3C tracecontext

The W3C format uses two headers:

- `traceparent: 00-<trace-id>-<span-id>-<span-flags>`
- `tracestate: <vendor>=<value>,...`

`traceparent` is mandatory and carries the trace ID, the current span ID, and a trace-flags byte. `tracestate` is optional and carries vendor-specific baggage. The format is versioned (`00` currently) and designed so a non-observability proxy can forward it without parsing it.

### 3. B3

The B3 format (from Zipkin) comes in two shapes:

- Single header: `b3: <trace-id>-<span-id>-<span-flags>-<parent-span-id>`
- Multi header: `X-B3-TraceId`, `X-B3-SpanId`, `X-B3-ParentSpanId`, `X-B3-Sampled`

B3 is the older format and is still present in most Java and Python services that predate OpenTelemetry adoption. Its single-header form is compact but loses the sampled flag when the parent span ID is absent, which is a real edge case.

### 4. Choosing one

Set one propagator per process, not per request. A common pattern is to ship W3C everywhere and add B3 extraction only at the edge where legacy services still speak B3:

```python
from opentelemetry.propagate import set_global_textmap_propagator
from opentelemetry.trace.propagation.tracecontext import TraceContextTextMapPropagator
from opentelemetry.baggage.propagation import BaggagePropagator

set_global_textmap_propagator(
    composite := TraceContextTextMapPropagator()
)
```

If a service must inject B3 for a downstream consumer, register `B3Propagator` as well and let the SDK pick the format per outbound call.

## Verify

After a cross-service request, confirm the trace is continuous:

- The child span's `parent_span_id` equals the parent span's `span_id`.
- The `trace_id` is identical on both sides.
- No orphan spans appear at the top of the trace tree.

## Common errors

| Error | Cause | Fix |
|---|---|---|
| Trace stops at a hop | The downstream service extracts with a different propagator than the upstream injected | Register the upstream format in the downstream process |
| Duplicate trace IDs | Two propagators both inject into the same header | Use a single composite propagator, not two |
| `tracestate` silently dropped | A proxy or load balancer strips unknown headers | Allowlist `tracestate` in the proxy, or move the data into `traceparent` |
| B3 single-header loses sampled flag | Parent span ID is absent, so the short form collapses | Use the multi-header B3 form at the edge |
| Trace appears split but headers are present | A service re-generates its own trace ID on entry instead of inheriting | Confirm the incoming context is restored before starting a new span |

## References

- W3C Trace Context specification (traceparent and tracestate header format)
- OpenTelemetry Context API Propagators specification (inject and extract contract)
- OpenTelemetry Collector architecture (receivers, processors, and exporters in a pipeline)
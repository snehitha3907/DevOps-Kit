---
last_verified: 2026-09-19
tool_version: n/a
sources:
  - https://grafana.com/blog/ci-cd-observability-via-opentelemetry-at-grafana-labs
  - https://opentelemetry.io/docs/collector/architecture/
---

# Integrating observability into CI/CD: pipeline health telemetry, DORA metrics, and deployment markers

> How I learned to treat the delivery pipeline itself as a system worth monitoring — every check-in, test, build, and deploy as observable data — instead of only watching the app it ships.

## Purpose

Application monitoring tells you the service is sick. Pipeline observability tells you the *factory* is sick: which stage is flaky, which commit slowed the build, which deploy moved the error-rate needle. This pattern combines Monitoring & Observability Concepts with CI/CD Concepts (and Containerization Concepts for where the telemetry plumbing runs).

## The core idea: pipelines emit telemetry

The shift is treating every check-in, test, build, and deploy as observable data. Once pipeline stages emit spans, metrics, and logs the same way services do, two things become possible: scoring delivery health with the four DORA metrics, and aiming instrumentation at the failure modes that actually bite.

## DORA metrics — the scoreboard

| Metric | What it answers |
|---|---|
| Deployment frequency | How often do changes reach users? |
| Mean lead time for changes | How long from commit to running in front of users? |
| Mean time to recover | When something breaks, how fast is service restored? |
| Change failure rate | What fraction of deploys causes an incident or rollback? |

I started tracking just the first two — they need nothing more than commit and deploy timestamps — and added recovery/failure tracking once deploys were annotated (see markers below).

## Instrument the three failure modes first

In practice, three recurring CI/CD failure modes deserve instrumentation before anything exotic:

1. **Flaky tests** — pass/fail with no code change, often external dependencies or race conditions. Track per-test pass rate over time; a test that flips without code changes is a flake, not a regression.
2. **Performance regression** — test or build bloat dragging build times up. Track stage durations as a time series so a slow creep shows up before anyone complains.
3. **Misconfigurations** — wrong step order or under-provisioned capacity. Log the effective pipeline definition (resolved variables, runner sizes) with each run so a bad run can be diffed against a good one.

## Deployment markers tie deploys to signals

A deployment marker is an annotation on the timeline — "service X version Y went live at T" — overlaid on the same dashboards as error rates and latency. When a graph jumps, the first question ("did we just ship?") answers itself. This is one way to do it; some teams emit markers as log events, others as dashboard annotations — the mechanism matters less than having the deploy timestamp joined to the telemetry.

## Where the plumbing runs: the collector pipeline

For containerized setups, the OpenTelemetry Collector pipeline — receivers take data in, processors transform it, exporters fan out to backends — typically runs as a sidecar or DaemonSet agent beside the workloads, or as a gateway fanning out to backends. Two details I got wrong the first time:

- Processor instances are never shared between pipelines: referencing the same processor name in two pipelines creates independent instances with isolated state, so sampling or filtering policy stays per-signal even with shared receivers and exporters.
- Receiver-to-pipeline delivery is a synchronous fan-out call, so one blocked processor stalls every pipeline on that receiver. Keep gateway processors non-blocking or a slow exporter will back up unrelated signals.

## Verify

- Each pipeline run emits at least a start/finish event with the commit SHA attached.
- A dashboard (or a query over the event log) can answer all four DORA questions for the last 30 days.
- Every deploy writes a marker visible next to service health graphs.
- A flaky test, a 2x build slowdown, and a misconfigured run each produce a distinct, queryable signal — not just a red build light.

## What I'd try next

I want to wire markers into an actual deploy job and compute change failure rate from incident records, so the scoreboard updates itself instead of living in a doc. After that, tracing a single commit through build, test, and deploy stages as one distributed trace feels like the natural next step.

## References

- CI/CD observability via OpenTelemetry at Grafana Labs (DORA metrics, flaky tests, performance regression, misconfigurations)
- OpenTelemetry Collector architecture (receivers → processors → exporters, processor isolation, fan-out blocking caution)

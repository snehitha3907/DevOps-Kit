---
last_verified: 2026-09-30
tool_version: n/a
---

# Following the OpenTelemetry quickstart — what tripped me up

> I worked through the quickstart on my laptop and wrote down where I stumbled. Still learning, so this is scratchy on purpose.

## What I tried

I started from the primer I wrote earlier and wanted to get one span out of my own code and into a local Collector where I could see it. My plan was simple:

1. I ran the Collector locally following the quickstart path (the install-and-run script I saved under `otel/scripts/` last time).
2. I ran my first-trace snippet against it (the one in `otel/snippets/`) and watched the Collector log.
3. Then I tried tweaking the Collector config so the pipeline had a batch step in the middle before logging.

Steps 1 and 2 mostly worked the way the quickstart said they would. Step 3 is where I got stuck.

## Got stuck on

First, I kept mixing up the two OTLP ports. My snippet sends to 4317 and my first Collector run only opened that port, but then I copied a config example that listened on 4318 and I sat there wondering why nothing arrived. Turns out I was sending gRPC to one port while the Collector was waiting for HTTP on the other. Once I opened both ports in the run command and matched the sender to 4317, the span showed up.

Second, the pipeline order in the Collector config confused me. I wrote `exporters` before `processors` in the service list because that felt like the order data flows, and the Collector refused to start. Flipping it so the service pipeline reads receivers, then processors, then exporters fixed it. I had assumed order did not matter since each section is named, but apparently the pipeline line is the thing that defines the flow.

Third, the log exporter output is noisy. I expected one neat line per span and instead got a big blob with resource attributes, scope info, and the span itself. I kept thinking I had broken something. Then I realized that blob *is* the span — I just needed to search the log for my span name `say-hello` instead of reading the whole thing top to bottom.

## What I'd try next

I want to write a minimal Collector config from scratch (receivers, one batch step, log output) instead of copying the example, so the pipeline order sticks. After that I want to instrument a tiny Go HTTP server so I get two signals — a trace and a counter — instead of just the one Python span I have now. That should make the metrics-versus-traces difference click for me.

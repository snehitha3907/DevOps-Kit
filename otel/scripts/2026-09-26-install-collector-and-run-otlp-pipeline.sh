#!/usr/bin/env bash
# last_verified: 2026-09-26 · OpenTelemetry n/a

# Stand up a Collector, send it one span, read the span back out of its log (otel-002).
# Run me from the repo root — the sender lives two folders over in otel/snippets/.
# The container is --rm, so a second run just needs the docker rm line to succeed.

docker rm -f otel-collector 2>/dev/null
docker run -d --rm --name otel-collector -p 4317:4317 -p 4318:4318 \
  otel/opentelemetry-collector-contrib

python3 otel/snippets/2026-09-26-first-trace-span.py

# TODO: the collector needs a beat to start up, so the log may be empty on the
# first run — re-run `docker logs otel-collector` after a few seconds.
sleep 3
docker logs otel-collector | tail -20

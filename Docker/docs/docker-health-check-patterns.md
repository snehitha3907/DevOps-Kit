---
last_verified: 2026-08-11
tool_version: n/a
---

# Docker health check patterns for different service types

## Purpose

Health checks tell Docker whether a container is still alive. Without them, Docker only knows a container is running if the main process is still running — it can't detect a deadlocked app, a stuck web server, or a database that accepts connections but can't serve queries. This doc covers the three built-in probe types (HTTP, TCP, and custom command) and when to use each.

## When to use

- **HTTP probe** — for web services, APIs, or anything with an HTTP endpoint. This is the most common choice because it validates the app is not just running but actually responding.
- **TCP probe** — for databases, message brokers, or raw TCP services where there's no HTTP endpoint but a successful socket connection means the service is ready.
- **Custom probe** — for services that need bespoke validation logic, such as checking a specific file, running a one-off script, or validating internal state that no standard probe can reach.

## Prerequisites

- A `Dockerfile` or `docker run` command for the target service.
- For HTTP probes: a path that returns 2xx/3xx when healthy (commonly `/health` or `/ready`).
- For TCP probes: a known port the service listens on.
- For custom probes: a command that exits `0` when healthy and non-zero when not.

## Steps

### 1. HTTP probe

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

- `--interval` — how often to run the check.
- `--timeout` — consider the check failed if it takes longer than this.
- `--start-period` — grace period for slow-starting apps; failures during this window don't count against retries.
- `--retries` — consecutive failures before marking the container `unhealthy`.

`curl -f` fails on HTTP 4xx/5xx, so only 2xx/3xx counts as healthy.

### 2. TCP probe

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD nc -z localhost 5432 || exit 1
```

`nc -z` (or `bash -c "echo >/dev/tcp/localhost/5432"`) tests whether the port accepts connections. It doesn't validate application-level logic — a database that accepts connections but is in recovery mode still passes a TCP probe.

### 3. Custom probe

```dockerfile
HEALTHCHECK --interval=60s --timeout=10s --retries=2 \
  CMD /app/bin/healthcheck.sh || exit 1
```

The custom command can be anything. The example above runs an application-specific script. Keep it fast — long-running health checks block the monitor thread and delay detection of real failures.

### 4. Disable an inherited health check

If the base image defines a HEALTHCHECK and you don't want it:

```dockerfile
HEALTHCHECK NONE
```

## Verify

Build and run the container, then inspect the health status:

```bash
docker build -t myapp:health .
docker run -d --name health-test myapp:health
docker inspect --format='{{.State.Health.Status}}' health-test
```

Expected transitions: `starting` → `healthy` (or `unhealthy` if the check fails). Use `docker ps` to see the health column without inspecting.

## Common errors

- **Wrong endpoint path** — `/health` vs `/healthz` vs `/ready`. A 404 from the wrong path makes the container `unhealthy` immediately. Verify the path with `curl` locally before embedding it in the Dockerfile.
- **Probe runs before the app listens** — too aggressive an interval with no `start-period` marks a slow-starting container unhealthy on boot. Add a start period that matches your app's typical startup time.
- **Probe does too much work** — a health check that queries the database or hits external APIs can cascade failures. Keep probes local and lightweight.
- **Relying on TCP alone for databases** — a PostgreSQL server in crash recovery accepts connections briefly. Pair TCP with a lightweight SQL check if the driver supports it, or accept that TCP is a "good enough" signal for most cases.

## References

- Docker healthcheck syntax: `HEALTHCHECK` instruction in the Dockerfile reference.
- `curl -f` exit behavior: curl man page.
- `nc -z` behavior: netcat / ncat documentation.

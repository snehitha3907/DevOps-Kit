---
last_verified: 2026-09-29
tool_version: n/a
---

# Multi-Service Compose Scaffold with Health Checks

> A reusable starting point for a three-service Compose project — a built-from-source app backed by Postgres and Redis — where every service carries a health check and startup order is gated on health, not just container start.

## Purpose

This scaffold provides the files needed to boot a local multi-service stack with one command: a [compose file](./compose.yaml) defining the app, database, and cache services with health checks and healthy-gated startup order, an [app Dockerfile](./app/Dockerfile) plus a minimal [app server](./app/app.py) so the stack works immediately after copying, and an [env template](./.env.example) for the credentials and ports the stack reads. The layout is the whole artifact — copy the directory, fill in values, build, and start.

## When to use

Use this scaffold when starting a project that needs an app container talking to a database and a cache on a local machine or a single shared host. It fits development environments, integration-test backends, and demos that must show service dependencies honestly. It is not a swarm or Kubernetes deployment pattern — for orchestrated rollouts with replicas and rolling updates, use the swarm and production stack examples under `Docker/manifests/` instead.

## Prerequisites

- Docker Engine with the Compose plugin available (`docker compose version` answers).
- Port 8000 free on the host (or overridden via `APP_PORT` in `.env`); the database and cache are reachable only inside the Compose networks and publish no host ports.
- No registry access required — only the app image is built locally; database and cache images pull from their default registry on first start.

## Steps

1. Copy the scaffold into a new project directory:

   ```bash
   cp -r multi-service-compose-with-healthchecks/ my-stack/
   cd my-stack
   ```

2. Create the environment file from the template and set a real password:

   ```bash
   cp .env.example .env
   ```

3. Build the app image and start the stack in the background:

   ```bash
   docker compose up --build -d
   ```

4. Watch containers become healthy (the app waits for the database and cache checks to pass before its own check can succeed):

   ```bash
   docker compose ps
   ```

5. Hit the app health endpoint through the published port:

   ```bash
   curl http://localhost:8000/health
   ```

6. Stop the stack when done; add `-v` only to also drop the named data volumes:

   ```bash
   docker compose down
   ```

## Verify

- Run `docker compose ps` — all three services report `healthy`, not just `running`.
- Run `curl http://localhost:8000/health` — the response body is `{"status": "ok"}`.
- Run `docker compose logs db | head` — the database log shows it accepted connections before the app's first request.
- Run `docker compose config` — the rendered file resolves every `${VAR:-default}` without warnings about missing variables.

## Rollback

- If the app reports `unhealthy`: inspect `docker compose logs app`, fix the failure, then `docker compose up --build -d app` to rebuild only that service.
- If credentials were changed mid-life: update `.env`, then `docker compose up -d` to recreate the affected containers. Changing `POSTGRES_PASSWORD` after the data volume already exists does not re-seed the database user — for a clean reset run `docker compose down -v` (destroys stored data) and start again.
- If a bad image override was set via `POSTGRES_IMAGE`/`REDIS_IMAGE`: revert the variable in `.env` and re-run `docker compose up -d` to return to the previous images.

## Common errors

- **App stuck in `starting` while db/cache are healthy**: the app health probe calls `http://localhost:8000/health` inside its own container — confirm the server binds `0.0.0.0` (it does in the scaffold) and that `APP_PORT` matches the published port mapping.
- **`FATAL: password authentication failed` in db logs**: `.env` was edited after the first start. Either restore the original password or reset with `docker compose down -v` and start fresh.
- **`port is already allocated`**: another process holds the published app port. Set `APP_PORT` in `.env` to a free port or stop the conflicting process.
- **Compose warns about `required: false` on `env_file`**: that flag keeps the stack bootable straight from the copy without a `.env` present (defaults apply); the warning form varies by plugin release and is safe to ignore here.

## References

- [compose file](./compose.yaml) — service definitions, health checks, networks, and volumes.
- [app Dockerfile](./app/Dockerfile) — non-root runtime image for the scaffold app.

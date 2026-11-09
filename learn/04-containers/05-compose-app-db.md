---
last_verified: 2026-11-08
tool_version: "n/a"
sources: []
---
# Run the app and Postgres with Docker Compose

In [Smaller, faster images with multi-stage builds](04-docker-multistage.md), you built an image for the sample app. Real apps usually need other services too, such as a database. In this lesson, you will describe the app and Postgres in a Docker Compose file, add healthchecks, start the stack, and confirm both services report healthy.

## What you'll learn

- Describe the app and database in a compose file with healthchecks
- Start the stack and confirm both services report healthy

## Before you start

- [Smaller, faster images with multi-stage builds](04-docker-multistage.md) — the sample app image (or build context) your Compose file will run.
- [Read and write YAML that validates](../01-orientation/05-yaml-basics.md) — how to read mappings, lists, and indentation in YAML.
- Docker Engine with the Docker Compose plugin (`docker compose version`). Docker Compose reads a YAML file and runs the services it describes as containers.
- Optional reference (linking, not required reading now): [docker run vs docker compose up](../../Docker/docs/docker-run-vs-compose.md), [Docker health check patterns](../../Docker/docs/docker-health-check-patterns.md), and the companion file [app-postgres-healthchecks.compose.yaml](../../Docker/manifests/app-postgres-healthchecks.compose.yaml).

## Walkthrough

1. Create a Compose file that describes the app and a Postgres database. Save it as `compose.yaml` in your sample app directory (or copy and adapt [app-postgres-healthchecks.compose.yaml](../../Docker/manifests/app-postgres-healthchecks.compose.yaml)):

   ```yaml
   services:
     app:
       build: .
       ports:
         - "8080:8000"
       environment:
         DB_HOST: db
         DB_PORT: "5432"
         DB_NAME: appdb
         DB_USER: appuser
         DB_PASSWORD: apppass
       depends_on:
         db:
           condition: service_healthy
       healthcheck:
         test: ["CMD-SHELL", "python -c \"import urllib.request; urllib.request.urlopen('http://localhost:8000/health')\" || exit 1"]
         interval: 10s
         timeout: 5s
         retries: 5
         start_period: 15s
       restart: unless-stopped

     db:
       image: postgres:16-alpine
       environment:
         POSTGRES_DB: appdb
         POSTGRES_USER: appuser
         POSTGRES_PASSWORD: apppass
       ports:
         - "5432:5432"
       volumes:
         - postgres-data:/var/lib/postgresql/data
       healthcheck:
         test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
         interval: 10s
         timeout: 5s
         retries: 5
         start_period: 10s
       restart: unless-stopped

   volumes:
     postgres-data:
   ```

   You should see: two services under `services:`. The app connects to `db` by service name. `depends_on` with `condition: service_healthy` tells Compose to wait until Postgres passes its healthcheck before starting the app. Each `healthcheck` runs a command inside the container: the app checks its `/health` endpoint, and Postgres uses `pg_isready` to confirm the database accepts connections.

2. Start the stack in the background.

   ```bash
   docker compose up -d
   ```

   You should see: Compose creating the network and volume (if needed), pulling or building images, and starting `db` and `app`. The `-d` flag runs containers in detached mode so your terminal stays free.

3. Confirm both services report healthy.

   ```bash
   docker compose ps
   ```

   You should see: both `app` and `db` listed with `STATUS` showing `Up` and `(healthy)`. If a service shows `(health: starting)`, wait a few seconds and run the command again until the healthcheck passes or fails.

4. Check the app from your host (optional, if the app exposes `/health`).

   ```bash
   curl -s http://localhost:8080/health
   ```

   You should see: the app's healthy response.

5. Stop the stack when you are done.

   ```bash
   docker compose down
   ```

   You should see: Compose stopping and removing the containers and network. The named volume `postgres-data` remains so database data survives a restart; add `--volumes` only if you intentionally want to delete it.

## Exercise

Create your own `compose.yaml` that runs the sample app and Postgres together:

1. Define an `app` service and a `db` service. Use the image you built in the previous lesson for `app` (or `build: .`), and use `postgres:16-alpine` for `db`.
2. Set database environment variables for both services so the app can reach Postgres at host `db`.
3. Add a `healthcheck` to `db` using `pg_isready`, and add a `healthcheck` to `app` that checks the app's health endpoint or a command that exits `0` when ready.
4. Make `app` wait for a healthy database with `depends_on` and `condition: service_healthy`.
5. Start the stack with `docker compose up -d`, then confirm both services report healthy.

## Check your work

```bash
docker compose ps --format 'table {{.Name}}\t{{.Service}}\t{{.Status}}'
```

You should see: a row for each service with `Status` containing `healthy` (for example, `Up 30 seconds (healthy)`).

When you finish checking, clean up:

```bash
docker compose down
```

## Common mistakes

- Expecting `depends_on` alone to wait for Postgres to be ready. Without `condition: service_healthy`, Compose only waits for the container to start, not for the database to accept connections.
- Forgetting `start_period` on a slow-starting service. Healthcheck failures during the start period do not count against retries, which avoids marking a healthy-but-slow service as unhealthy.
- Using the wrong healthcheck command for Postgres (for example, a user or database name that does not match `POSTGRES_USER`/`POSTGRES_DB`). `pg_isready -U appuser -d appdb` must match the values you configured.
- Publishing Postgres on the host with `ports:` in environments where it is not needed. For app-to-database traffic inside the Compose network, the app can reach `db:5432` without a host port mapping.

## Next

[Trivy — quick primer](../../Trivy/notes/0000-primer-trivy.md)
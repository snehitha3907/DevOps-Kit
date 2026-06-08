# Docker Compose quickstart notes

Following the official Docker Compose quickstart guide. Here's what tripped me up.

## Steps

1. Created a simple app with a web service and redis service
2. Wrote the `docker-compose.yml` file
3. Ran `docker compose up` to start services

## What tripped me up

- The command changed from `docker-compose` to `docker compose` (v2). My muscle memory kept typing the old hyphenated version.
- Port mapping syntax in compose is `ports: - "8000:8000"` — the quotes caught me off guard, but they're required when mapping same ports.
- The `depends_on` key only waits for container startup, not for the app inside to be ready. I expected redis to be fully ready before my web service tried to connect.
- Environment variables use `environment:` with `KEY=VALUE` syntax or `env_file:` for external files. I mixed up the two approaches initially.
- Scale with `docker compose up --scale web=3` works, but I forgot to set `hostname` for individual service identification.

## What I'd try next

Add a healthcheck to the redis service and explore compose profiles for dev vs prod configurations.
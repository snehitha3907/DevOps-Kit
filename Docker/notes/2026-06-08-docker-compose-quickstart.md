# Docker Compose Quickstart Notes

Following the official Docker Compose quickstart to run a simple web app.

## Steps

1. Installed Docker Compose (comes with Docker Desktop, or manually on Linux)
2. Created a new directory for the example
3. Wrote a `docker-compose.yml` file defining a simple web app
4. Ran `docker compose up` to start services

The first thing I noticed — the command changed from `docker-compose` to `docker compose` (space, not hyphen). Old tutorials still use the hyphen format.

I created the compose file:

```yaml
services:
  web:
    image: nginx
    ports:
      - "8080:80"
```

Then ran:

```bash
docker compose up
```

It pulled the nginx image and started the container. Opening localhost:8080 showed the nginx welcome page.

## Got stuck on

- **Port already in use** — I tried port 8080 but something else was using it. Changed to 8888.
- **Command syntax** — I kept typing `docker-compose up` and getting "command not found" until I realized the space syntax is new.
- **Detached mode** — I hit Ctrl+C to stop it and realized I should have used `-d` to run it detached.

## What I'd try next

I want to add another service like a Redis container and see how they communicate via the default network. I'll also try the WordPress + MySQL example from the docs.
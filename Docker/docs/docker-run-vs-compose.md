# docker run vs docker compose up — when to use which

I've been using both `docker run` and `docker compose up` and learned when each makes sense. Here's my take.

## When I reach for docker run

I use `docker run` when I need:

- **Single-container applications** — running one service like a standalone database or cache. Just fire it up, test something, done.
- **Quick testing** — spinning up a container temporarily to try something out. No need to write a YAML file.
- **Learning and experimentation** — getting familiar with a specific image's options and behavior without setup overhead.
- **One-off commands** — executing a task in an isolated environment without long-running services.

Example for running a single MySQL container:

```bash
docker run -d --name mysql-db -e MYSQL_ROOT_PASSWORD=secret -p 3306:3306 mysql:8.0
```

## When I reach for docker compose up

I use `docker compose up` when I'm dealing with:

- **Multi-container applications** — apps that need multiple services running together (web + database + cache).
- **Development environments** — when I need to recreate the same setup across multiple machines or share with teammates.
- **Configuration that changes** — instead of remembering long `docker run` commands, I put them in a compose file.
- **Complex networking** — when containers need to talk to each other, compose handles the network setup.

Example `docker-compose.yml` for a web app with a database:

```yaml
services:
  web:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

## How they compared in my testing

I tested both approaches and noticed these differences:

| Aspect | docker run | docker compose up |
|--------|-----------|-------------------|
| Startup | Single command, single container | Multi-service orchestration |
| Configuration | CLI flags | YAML file |
| Networking | Manual port mapping | Automatic service discovery |
| Persistence | Manual volume flags | Declared volumes |
| Scale | One container per command | Built-in scaling with `--scale` |

## What I ran to verify

After spinning up containers, I used these commands to check they were running:

```bash
# For docker run — verify single container
docker ps --filter name=my-container

# For docker compose — verify all services
docker compose ps
```

## What tripped me up

- Mixing `docker run` and compose for related services — containers ended up on different networks and couldn't talk to each other by service name.
- Forgetting `-d` with `docker run` — container ran in foreground and blocked my terminal. Had to open a new window.
- Not creating the network first when running multiple manual containers — compose handles this automatically, but manual runs require explicit `--network` flags.
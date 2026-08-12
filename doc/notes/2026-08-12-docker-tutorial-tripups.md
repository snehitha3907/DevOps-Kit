---
last_verified: 2026-08-12
tool_version: n/a
---

# Docker Get Started tutorial — what tripped me up

I worked through the official "Get started" tutorial that walks through containerizing an app and running it with Docker Compose. I've poked at Docker before, but this was the first time I went end to end with an actual app instead of random commands. Here's what happened and where I got stuck.

## The setup

The tutorial starts by cloning a small guestbook-style app and building it:

```bash
git clone <sample-app-repo> getting-started
cd getting-started
docker build -t getting-started .
docker run -dp 127.0.0.1:3000:3000 getting-started
```

The `-d` flag runs the container in the background, and `-p 127.0.0.1:3000:3000` maps my port 3000 to the container's port 3000. I only bound to `127.0.0.1` so nothing outside my machine can reach it.

## What actually tripped me up

- **`docker build -t getting-started .` — that trailing dot matters.** I forgot the `.` once and got `"docker build" requires exactly 1 argument`. The dot is the build context — it tells Docker which directory to bundle and send to the daemon. Without it, the Dockerfile `COPY . .` has nothing to copy from.
- **The name/port typo loop.** I ran `docker run -dp 127.0.0.1:3000:3001` once (swapped ports) and the app "worked" but on the wrong port, which took me a while to notice. Double-checking the port mapping before running would have saved that.
- **`Dockerfile` vs `dockerfile` casing.** On my Linux filesystem the lowercase `dockerfile` was fine because Docker accepts both, but I renamed it to `Dockerfile` for consistency when I shared the repo — renaming mid-tutorial added nothing but confusion.
- **Changes not showing up.** I edited the app source and rebuilt, but the old behavior stuck around. I'd forgotten I was running the *previous* container on port 3000. The fix was `docker ps`, then `docker rm -f <name>` to stop and remove it, then rebuild and run again. The tutorial's "update the app" page spells this out — I learned the hard way that running a second `docker run` on the same port just errors with "port is already allocated".
- **`docker compose up -d` vs `docker run`.** The tutorial swaps to a `compose.yaml` with two services (app + MySQL). `docker compose up -d` reads the file as a whole; I kept trying to run individual containers with `docker run` against the compose network and the app couldn't reach MySQL until I let Compose create and manage the network for me.
- **Named vs anonymous images.** `docker build -t name .` tags the image; untagged images pile up as `<none>` entries in `docker images` and confuse every later `docker run`. Tagging explicitly from the start keeps `docker ps` and cleanup straightforward.

## What I'd try next

I want to take the same app and write a small script that builds, runs, and cleans down the container and image so I stop leaving stale containers behind — and then move the whole thing under a proper image registry workflow.
# Docker — quick primer

> First-day notes for someone who's never used Docker. Personal voice, plain language.

## What is it?

Docker bundles an app plus its dependencies into a single package. Kinda like a VM but way lighter — containers share the host's OS kernel instead of running a full OS.

## What does it do?

I write a `Dockerfile` to define my app's base image and deps, then `docker build` creates an image, and `docker run` starts a container from it. Images get tagged and stored in registries like Docker Hub.

## Why does it exist?

Before Docker I kept hitting "works on my machine" bugs — wrong lib versions, missing system packages. VMs fixed it but were too slow and heavy. Docker starts containers in seconds.

## Key terminology

- **Image** — Read-only snapshot. `docker pull nginx` downloads one.
- **Container** — A running image. `docker run nginx` starts it.
- **Dockerfile** — Build recipe. `FROM python:3.11` picks the base.
- **Layer** — Cached build step. Only rebuilds what changed.
- **Registry** — Image storage. Docker Hub is the default.
- **Volume** — Persists data after a container stops.
- **Port mapping** — Host-to-container port bridge (`-p 8080:80`).

## A tiny example

```bash
docker pull hello-world
docker run hello-world
```

Pulls a tiny test image and prints a hello message.

## What I'll cover next

Install Docker, run a real container, mess with `docker ps`, and write a simple Dockerfile.

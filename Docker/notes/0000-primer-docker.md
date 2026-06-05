# Docker — quick primer

> First-day notes for someone who's never used Docker. Personal voice, plain language.

## What is it?

Docker wraps an app and its dependencies into a single bundle. Think of it like a shipping container for code — instead of "works on my machine" excuses, you ship the whole environment and it runs anywhere. It's like a virtual machine but lighter, since containers share the host OS kernel.

## What does it do?

You write a `Dockerfile` listing your app's base image, dependencies, and startup command. Then `docker build` creates an image, and `docker run` spins up a container. Images get tagged and pulled from registries like Docker Hub.

## Why does it exist?

Before Docker, I wasted hours fighting environment mismatches — wrong library versions, missing system packages. VMs worked but started slow and ate RAM. Containers boot in seconds and share the host kernel, so I can run multiple ones without bloat.

## Key terminology

- **Image** — Read-only snapshot. `docker pull nginx` downloads one.
- **Container** — A running image. `docker run nginx` starts it.
- **Dockerfile** — Instructions to build an image. `FROM python:3.11` picks the base.
- **Layer** — A cached build step. `RUN pip install -r requirements.txt` becomes one.
- **Registry** — Storage for images. `docker push myuser/app` uploads yours.
- **Volume** — Persistent storage. `docker volume create mydata` keeps data safe.
- **Port mapping** — Host-to-container ports. `docker run -p 8080:80 nginx`.

## A tiny example

```bash
docker pull hello-world
docker run hello-world
```

This pulls a tiny test image and runs it — you'll see a hello message.

## What I'll cover next

I'll install Docker and run my first real container, then explore `docker ps` and write a Dockerfile for a simple app.

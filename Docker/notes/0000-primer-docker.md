# Docker — quick primer

> First-day notes for someone who's never used Docker. Personal voice, plain language.

## What is it?

Docker is a containerization platform that packages applications with everything they need to run. Think of it like shipping containers for software — instead of "works on my machine" problems, you build a container with your app, its dependencies, and configs, then run that same container anywhere. It sits in the same problem space as virtual machines but is lighter and faster because containers share the host OS kernel.

Docker started in 2013 as an internal project at dotCloud (a PaaS company), then open-sourced. It made containers accessible to developers without deep Linux kernel knowledge.

## What does it do?

Docker lets you build images (snapshots of your app + environment) and run them as containers (live, isolated processes). You write a `Dockerfile` that defines how to assemble your image, then `docker build` creates an image you can `docker run` as a container. It pulls base images from registries like Docker Hub, layers your changes on top, and everything is versioned with tags. The magic is that the same image runs identically on any machine with Docker installed.

## Why does it exist?

Before Docker, getting software to run in different environments was a mess. You'd develop on macOS, deploy to CentOS, and spend hours figuring out why the database connection string was wrong or a library was missing. Virtual machines solved this but were heavy. Docker gave us lightweight containers that start in seconds. People use it daily for local development, CI/CD pipelines, and production deployments.

## Key terminology

- **Image** — A read-only template with instructions to create a container. Example: `docker pull nginx` downloads the nginx image.
- **Container** — A running instance of an image. Example: `docker run nginx` starts an nginx container.
- **Dockerfile** — A text file with commands to build an image. Example: `FROM python:3.11` sets the base image.
- **Layer** — Each step in a Dockerfile creates a layer cached for faster rebuilds. Example: `RUN pip install -r requirements.txt` becomes a layer.
- **Registry** — A storage service for images (Docker Hub is the default). Example: `docker push myuser/myapp` uploads to Docker Hub.
- **Volume** — Persistent storage for containers, separate from the container's writable layer. Example: `docker volume create mydata`.
- **Port mapping** — Connecting host ports to container ports. Example: `docker run -p 8080:80 nginx` maps host 8080 to container 80.
- **Compose** — A tool to run multi-container apps. Example: `docker-compose.yml` defines app + database together.

## A tiny example

```bash
# Pull a lightweight web server image
docker pull nginx:alpine

# Run it, mapping host port 8080 to container port 80
docker run -d -p 8080:80 --name my-server nginx:alpine

# Check it's running
docker ps
```

This pulls a small nginx image, runs it in the background, and makes it accessible at `http://localhost:8080`.

## What I'll cover next

After this primer, I want to install Docker on my machine and run my first container. Once that works, I'll explore images and containers more deeply — pulling different images, understanding what `docker ps` shows, and pushing my own image to Docker Hub.
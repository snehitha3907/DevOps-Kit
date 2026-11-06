---
last_verified: 2026-11-06
tool_version: "n/a"
---

# Package the sample app as an image

This lesson takes the sample app you put under version control and packages it into a Docker image. You will write a Dockerfile, build the image, run a container from it, and reach the app's `/health` endpoint on a published port.

## What you'll learn

- Write a Dockerfile for the sample app and build it
- Run the container and reach /health on a published port

## Before you start

- [Docker — quick primer](../../Docker/notes/0000-primer-docker.md) — what an image, container, and Dockerfile are.
- [Containerization concepts](../../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md) — why we containerize and how images layer.
- [Put the sample app under version control](../03-version-control/03-git-sample-app-repo.md) — the sample app you will package.
- [Diagnose "I can't reach it" — IPs, ports and DNS](../02-networking/02-ip-ports-dns.md) — port publishing and reaching a service.
- Docker installed. Confirm with `docker --version`.

## Walkthrough

1. Create a Dockerfile in the sample app directory.

   ```bash
   cd ~/sample-app
   cat > Dockerfile <<'EOF'
   FROM python:3.12-slim
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install --no-cache-dir -r requirements.txt
   COPY . .
   EXPOSE 8000
   CMD ["python", "app.py"]
   EOF
   ```

   You should see: a `Dockerfile` created in the project root. Each instruction becomes a layer in the image.

2. Build the image and tag it.

   ```bash
   docker build -t sample-app:1.0 .
   ```

   You should see: `Successfully tagged sample-app:1.0` and a list of build steps, each marked `DONE`.

3. Run a container from the image, publishing port 8000.

   ```bash
   docker run -d -p 8000:8000 --name sample-app sample-app:1.0
   ```

   You should see: a long container ID printed. The `-d` flag detaches it so your terminal stays free.

4. Reach the health endpoint.

   ```bash
   curl -s http://localhost:8000/health
   ```

   You should see: `{"status":"ok"}` (or the equivalent healthy response your app returns).

## Exercise

Write your own Dockerfile for the sample app from scratch (do not copy the one above), build it as `sample-app:exercise`, run it on port 8080, and confirm `/health` returns a healthy response.

## Check your work

```bash
docker ps --filter name=sample-app-exercise --format '{{.Names}} {{.Ports}}'
curl -s http://localhost:8080/health
```

The container should be running with `0.0.0.0:8080->8000/tcp` published, and the curl should return the app's healthy response.

## Common mistakes

- Forgetting to `COPY` the app source after installing dependencies — the container starts but the app code is missing.
- Publishing the wrong port mapping (e.g. `-p 8000:8080` instead of `-p 8080:8000`) — curl then fails to connect.
- Running `docker build` from outside the directory containing the Dockerfile.

## Next

[Smaller, faster images with multi-stage builds](04-docker-multistage.md)
---
last_verified: 2026-11-06
tool_version: "29.9.3"
sources:
  - https://docs.docker.com/build/building/multi-stage/
  - https://docs.docker.com/build/cache/optimize/
  - https://docs.docker.com/reference/dockerfile/
  - https://docs.docker.com/engine/release-notes/29/
---

# Smaller, faster images with multi-stage builds

In [Package the sample app as an image](03-docker-first-image.md), you built one image that installs dependencies and runs the app. That works, but the image can carry build tools and extra files you do not need at runtime. In this lesson, you will split a Dockerfile into build and runtime stages and order instructions so Docker can reuse cached work.

## What you'll learn

- Split build and runtime stages and compare image sizes
- Order instructions so the build cache is reused

## Before you start

- [Package the sample app as an image](03-docker-first-image.md) — the single-stage image you will improve.
- Docker Engine with a BuildKit-capable builder (`docker --version` and `docker buildx version`). Docker is the container runtime you use to build and run images.
- For deeper reference (linking, not required reading now): [Docker build cache and multi-stage layering](../../Docker/docs/docker-build-cache-and-multi-stage-layering.md), [BuildKit cache mounts and secrets](../../Docker/docs/docker-buildkit-cache-mounts-secrets.md), and the example [multi-stage Go Dockerfile](../../Docker/dockerfiles/multi-stage-go-http-server.Dockerfile).

## Walkthrough

1. Start from a Dockerfile that separates the build environment from the runtime environment. Create `Dockerfile.multistage` in your sample app directory:

   ```dockerfile
   # Build stage: has the tools needed to install dependencies
   FROM python:3.12-slim AS builder
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

   # Runtime stage: keeps only what the app needs to run
   FROM python:3.12-slim
   WORKDIR /app
   COPY --from=builder /install /usr/local
   COPY . .
   EXPOSE 8000
   CMD ["python", "app.py"]
   ```

   You should see: two `FROM` instructions. `AS builder` names the first stage. `COPY --from=builder ...` copies only the installed packages into the final stage, so compilers and intermediate build files stay out of the runtime image.

2. Build the multi-stage image and tag it.

   ```bash
   docker build -f Dockerfile.multistage -t sample-app:multistage .
   ```

   You should see: build output for each stage and `Successfully tagged sample-app:multistage`. With a BuildKit builder, Docker builds the stages the final image depends on.

3. Compare image sizes with the image you built earlier.

   ```bash
   docker image ls sample-app
   ```

   You should see: a table with `REPOSITORY`, `TAG`, `IMAGE ID`, and `SIZE` for `sample-app:1.0` and `sample-app:multistage`. A multi-stage Dockerfile helps you keep runtime artifacts small by copying only what you need into the final stage (for example, a built binary or installed app dependencies).

4. Order instructions so the build cache can be reused. Docker reuses a cached layer when the instruction and the files it depends on have not changed. If a layer changes, later layers rebuild. Keep slow, stable steps early and frequently changing source late:

   ```dockerfile
   FROM python:3.12-slim AS builder
   WORKDIR /app

   # Changes rarely: copy manifests first, install deps
   COPY requirements.txt .
   RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

   # Changes often: copy source last
   COPY . .
   ```

   You should see (on a rebuild after changing app code only): the dependency install step reused from cache, while the final `COPY . .` and later steps rebuild. Run with plain progress to inspect cache behavior:

   ```bash
   docker build --progress=plain -f Dockerfile.multistage -t sample-app:multistage .
   ```

   You should see: lines marked `CACHED` for unchanged steps. A `.dockerignore` file keeps unrelated files (such as `.git` or local caches) out of the build context so they do not invalidate `COPY . .`.

## Exercise

Take the sample app from the previous lesson and create a multi-stage Dockerfile:

1. Use a named build stage that installs or prepares everything the app needs.
2. Use a separate runtime stage that copies only the required runtime artifacts with `COPY --from=<stage>`.
3. Copy dependency manifests before `COPY . .`, and install dependencies before copying the rest of the source.
4. Build the image as `sample-app:exercise-ms`, run it on port 8081, and confirm `/health` responds.

## Check your work

```bash
docker image ls sample-app --format '{{.Repository}}:{{.Tag}} {{.Size}}'
docker run -d -p 8081:8000 --name sample-app-exercise-ms sample-app:exercise-ms
curl -s http://localhost:8081/health
```

You should see: `sample-app:exercise-ms` listed with a size, the container running, and a healthy response from `/health`.

## Common mistakes

- Copying all source before installing dependencies (`COPY . .` then install) makes Docker rebuild the expensive install step on every code change.
- Using a numeric stage index (`COPY --from=0`) is fragile; name stages with `AS` so reordering does not break the build.
- Expecting files from a build stage to exist automatically in the runtime stage. Only files you copy with `COPY --from=...` are present.
- Leaving large files in the build context without a `.dockerignore`, which slows builds and can invalidate cache unexpectedly.

## Next

[Run the app and Postgres with Docker Compose](../../00_index/learning-path.md)
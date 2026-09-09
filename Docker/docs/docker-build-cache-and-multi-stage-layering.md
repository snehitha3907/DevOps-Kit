---
last_verified: 2026-09-09
tool_version: "29.8.0"
sources:
  - https://docs.docker.com/engine/release-notes/29/
  - https://docs.docker.com/build/cache/optimize
  - https://docs.docker.com/build/buildkit
  - https://www.docker.com/blog/advanced-dockerfiles-faster-builds-and-smaller-images-using-buildkit-and-multistage-builds
  - https://oneuptime.com/blog/post/2026-08-03-why-multi-stage-docker-cache-vanishes-ci-buildkit-mode-max/view
  - https://www.freecodecamp.org/news/how-to-optimize-your-docker-build-cache
---

# Docker build cache and multi-stage layering

Reference patterns for writing Dockerfiles that rebuild fast in CI and produce lean final images.

## Purpose

Every Dockerfile instruction creates a layer. When a layer's inputs change, that layer and every layer below it must rebuild. In CI, where each job starts with an empty local cache, poor layer ordering or missing cache configuration can turn a 2-minute build into a 15-minute one. This doc covers the mechanics of Docker's layer cache, how multi-stage builds isolate expensive build steps, and how to wire BuildKit's remote cache backends into CI pipelines so intermediate stages survive across runs.

## When to use

| Scenario | Approach |
|----------|----------|
| Single developer machine, small project | Layer ordering + `.dockerignore` is usually enough |
| CI pipeline with ephemeral runners | BuildKit registry cache with `mode=max` |
| Large monorepo with many services | Multi-stage builds + per-service cache namespaces |
| Dependencies change infrequently | `COPY` manifest files first, then `RUN install` |
| Dependencies change often | BuildKit `--mount=type=cache` for package manager caches |

## Prerequisites

- Docker Engine 23.0+ (BuildKit is the default builder since 23.0; Engine 29.8.0 ships BuildKit v0.33.0)
- For remote cache: a container registry (Docker Hub, ECR, GCR, GHCR) accessible from CI runners
- For cache mounts: BuildKit-enabled builder (`docker buildx` or `DOCKER_BUILDKIT=1`)

## How Docker layer cache works

Each instruction in a Dockerfile produces a layer. Docker caches each layer by hashing the instruction text plus the files it depends on. On a subsequent build, if the hash matches, the cached layer is reused without re-execution.

The critical rule: **when a layer is invalidated, all downstream layers rebuild too** — even if their inputs haven't changed. This makes layer ordering the single most impactful optimization.

```
FROM node:20-alpine          # Layer 1 — rarely changes
COPY package.json .          # Layer 2 — changes when deps change
RUN npm ci                   # Layer 3 — rebuilds only when Layer 2 changes
COPY . .                     # Layer 4 — changes on every commit
RUN npm run build            # Layer 5 — rebuilds when source changes
```

In this layout, a source-code change invalidates Layer 4 and 5, but Layers 1–3 (the expensive `npm ci`) stay cached. Reverse the order of `COPY . .` and `RUN npm ci`, and every commit forces a full dependency install.

### Layer ordering rules

1. **System dependencies first** — `apt-get install`, `apk add`, `yum install` — these change least often.
2. **Package manifest next** — `package.json`, `go.mod`, `requirements.txt`, `Gemfile` — change when you add/remove dependencies.
3. **Dependency install** — `npm ci`, `go mod download`, `pip install` — expensive, cache as aggressively as possible.
4. **Application source last** — `COPY . .` — changes on every commit, so put it at the bottom.

### `.dockerignore`

A `.dockerignore` file reduces the build context sent to the daemon, which speeds up context transfer and prevents irrelevant files from invalidating cache layers:

```
.git
node_modules
dist
*.md
*.log
.env*
docker-compose*.yml
Dockerfile*
.github
tests
coverage
__pycache__
```

Without `.dockerignore`, a change to a log file or `.git/` directory can invalidate the `COPY . .` layer even though the application code hasn't changed.

## Multi-stage build patterns

Multi-stage builds separate the build environment from the runtime environment. A full SDK image (compilers, build tools, dev dependencies) compiles or bundles the application, then copies only the output artifacts into a minimal runtime image. This produces smaller images and isolates build-time dependencies from the cache graph.

### Pattern 1: Compile in a builder, run in a slim image

```dockerfile
# syntax=docker/dockerfile:1
FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server .

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
```

The builder stage has the full Go toolchain. The runtime stage is Alpine with only the binary and CA certificates. BuildKit can skip unused stages and build independent stages in parallel.

### Pattern 2: Shared base stage for parallel builds

When multiple services share common system dependencies, a shared base stage avoids duplicating setup:

```dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:24.04 AS base
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates && rm -rf /var/lib/apt/lists/*

FROM base AS service-a
RUN apt-get update && apt-get install -y --no-install-recommends python3
COPY service-a/ /app/
RUN python3 -m py_compile /app/main.py

FROM base AS service-b
RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm
COPY service-b/ /app/
RUN npm --prefix /app ci
```

BuildKit builds `service-a` and `service-b` concurrently. The shared `base` stage is built once.

### Pattern 3: Build-only and runtime-only separation

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

FROM deps AS build
COPY . .
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

The `deps` stage caches `node_modules`. The `build` stage compiles TypeScript. The `runtime` stage copies only `dist/` and `node_modules/` — no source code, no dev dependencies, no build tools.

## BuildKit remote cache for CI

CI runners are ephemeral: each job starts with a fresh Docker daemon and no local cache. Without remote cache configuration, every CI build is a cold build.

BuildKit supports exporting and importing cache to a container registry, making cache available across runs and across runners.

### Registry cache setup

```bash
docker buildx build \
  --cache-from type=registry,ref=registry.example.com/myapp:buildcache \
  --cache-to type=registry,ref=registry.example.com/myapp:buildcache,mode=max \
  --tag registry.example.com/myapp:latest \
  --push .
```

- `--cache-from` imports cache records at the start of the build.
- `--cache-to` exports cache records after the build.
- `mode=max` exports cache for **all** build steps including intermediate stages. The default `mode=min` only caches layers in the final stage — intermediate build stages are excluded.

The `mode=max` distinction is critical: without it, multi-stage builds in CI re-run every dependency install and compilation step because the intermediate layers aren't in the exported cache.

### Preventing branch cache collisions

When multiple branches build on the same registry, their caches can overwrite each other. Namespace the cache reference by branch:

```bash
# In CI, use the branch name as a cache namespace
CACHE_REF="registry.example.com/myapp:buildcache-${CI_COMMIT_BRANCH}"

docker buildx build \
  --cache-from type=registry,ref=registry.example.com/myapp:buildcache-main \
  --cache-from type=registry,ref="${CACHE_REF}" \
  --cache-to type=registry,ref="${CACHE_REF},mode=max" \
  --tag "${IMAGE_TAG}" \
  --push .
```

This way, each branch gets its own cache, and feature branches can also inherit cache from `main`.

### GitHub Actions example

```yaml
- name: Build and push
  uses: docker/build-push-action@v6
  with:
    push: true
    tags: registry.example.com/myapp:${{ github.sha }}
    cache-from: type=registry,ref=registry.example.com/myapp:buildcache-${{ github.ref_name }}
    cache-to: type=registry,ref=registry.example.com/myapp:buildcache-${{ github.ref_name }},mode=max
```

## BuildKit cache mounts

Cache mounts persist package manager caches across builds without adding them to image layers. The cache survives even when the layer using it is invalidated.

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine
WORKDIR /app

COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

COPY . .
RUN npm run build
```

When `package.json` changes, the `npm ci` layer rebuilds — but the npm cache mount means only new or changed packages are downloaded. Already-cached packages are reused from `/root/.npm`.

### Cache mount targets for common package managers

| Package manager | Cache target |
|----------------|-------------|
| npm | `/root/.npm` |
| pip | `/root/.cache/pip` |
| Go modules | `/go/pkg/mod` |
| Go build cache | `/root/.cache/go-build` |
| apt | `/var/cache/apt` |
| yum/dnf | `/var/cache/dnf` |

### Combining cache mounts with multi-stage builds

```dockerfile
# syntax=docker/dockerfile:1
FROM golang:1.22 AS builder
WORKDIR /app

# Download dependencies with cached module directory
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=bind,source=go.mod,target=go.mod \
    --mount=type=bind,source=go.sum,target=go.sum \
    go mod download

# Build with cached module directory and build cache
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build -o /app/server .

FROM alpine:3.19
COPY --from=builder /app/server /server
CMD ["/server"]
```

The bind mounts give the builder access to `go.mod` and `go.sum` without COPYing them into the layer. The cache mounts persist the Go module directory and build cache across builds.

## Verifying cache behavior

### Check which layers are cached

```bash
# Build with progress output to see cache hits
docker buildx build --progress=plain --target builder -t test-cache .

# Look for CACHED [stage ...] lines in output
# CACHED [dependencies 2/3] means the layer was reused
# RUN ... means the layer was rebuilt
```

### Inspect cache disk usage

```bash
# Show BuildKit cache disk usage
docker buildx du

# Prune unused cache
docker buildx prune -f
```

### Measure build time improvement

```bash
# Cold build (no cache)
time docker buildx build --no-cache -t app-cold .

# Warm build (with cache)
time docker buildx build -t app-warm .

# Compare — warm build should be significantly faster
```

### Validate remote cache is working

```bash
# First build: creates the cache
docker buildx build \
  --cache-to type=registry,ref=myregistry.io/app:buildcache,mode=max \
  --tag myregistry.io/app:v1 --push .

# Second build (different runner or after prune): imports cache
docker buildx build \
  --cache-from type=registry,ref=myregistry.io/app:buildcache \
  --tag myregistry.io/app:v2 --push .

# Check progress output for CACHED lines on intermediate stages
```

## Common errors

- **"cache From target ... not found"** — the cache reference doesn't exist yet. BuildKit continues with a cold build and creates the cache on success. This is expected on the first run.
- **Intermediate stages rebuild despite cache-from** — you're using `mode=min` (the default). Switch to `mode=max` on the `--cache-to` flag to include intermediate stages.
- **Cache grows unbounded** — registry caches accumulate untagged images. Configure registry lifecycle policies to prune old cache images, or use `docker buildx prune` periodically.
- **Cache mounts not persisting** — cache mounts are local to the builder instance. On CI with ephemeral runners, you need remote cache (`type=registry`) to persist across runs. Cache mounts help within a single build but don't survive daemon restarts.
- **Bind mount shows "no such file or directory"** — the `source` path in `--mount=type=bind` is relative to the build context. Ensure the path exists and matches the expected location in the container.
- **Stale cache causes build failures** — if a base image is updated (e.g., `node:20-alpine` gets a new patch), the old cached layers may reference an outdated base. Use `--no-cache` or clear the registry cache to force a fresh base pull.

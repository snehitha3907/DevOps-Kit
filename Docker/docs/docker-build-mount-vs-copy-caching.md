# Docker build --mount vs COPY for dependency caching in multi-stage builds

> Comparing two approaches to handle dependency caching in multi-stage Docker builds. BuildKit's `--mount` is newer and supposedly faster for repeated builds; COPY is the traditional approach that works everywhere. I wanted to see how they actually compare in practice.

## Purpose

Multi-stage builds often install dependencies (Go modules, npm packages, pip requirements) in an early stage and copy the installed result into a lean final stage. The problem is that the dependency-install step runs from scratch every time the dependency files change — and even when they don't, if you COPY the full source, Docker invalidates the layer.

I've been using the COPY approach for a while and wanted to see whether switching to BuildKit cache mounts would speed things up. Here's what I found.

Two patterns solve this differently:

1. **COPY dependency files first** — copy only the manifest files (`go.mod`, `package.json`, `requirements.txt`), install, then copy the rest of the source. Layer caching works as long as the manifest files haven't changed.

2. **BuildKit cache mounts** — use `RUN --mount=type=cache` to persist the package manager's own cache directory across builds, and `RUN --mount=type=bind` (with `from=`) to access dependency files without COPY.

## When to use which

From what I've seen, this is how the two approaches compare:

| Situation | Approach |
|-----------|----------|
| BuildKit is enabled (Docker >= 18.09 with `DOCKER_BUILDKIT=1`) | `--mount` — faster rebuilds, less layer bloat |
| Classic builder only (CI runners without BuildKit, older Docker) | COPY — works on every builder |
| Package manager cache is large (Go modules, apt, pip) | `--mount=type=cache` — avoids re-downloading |
| Want maximum layer sharing between builds | COPY — layers are cached independently and reusable |
| Need to support docker buildx | Both work, but `--mount` is more natural with BuildKit |

## Step-by-step: the COPY approach

The traditional multi-stage pattern. Copy only the manifest files first, install, then copy everything else. This is the approach I've been using most:

```dockerfile
# Stage 1: build
FROM golang:1.22 AS builder
WORKDIR /app

# Copy only dependency files first — this layer is cached
# as long as go.mod and go.sum don't change.
COPY go.mod go.sum ./
RUN go mod download

# Now copy everything and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server .

# Stage 2: minimal runtime
FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
```

One thing I noticed: the `RUN go mod download` layer is cached until `go.mod` or `go.sum` changes. When those files change, the entire download runs again — even if only one dependency was updated. That's where the cache mount approach can help.

## Step-by-step: the BuildKit cache mount approach

This replaces `COPY` + `RUN` with a single `RUN --mount`. BuildKit keeps the Go module cache on the host and reuses it. The docs say this should be faster:

```dockerfile
# syntax=docker/dockerfile:1
FROM golang:1.22 AS builder
WORKDIR /app

# Bind-mount go.mod/go.sum from the build context, no COPY needed.
# Cache the Go module download directory across builds.
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=bind,target=. \
    go mod download -x

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=bind,target=. \
    CGO_ENABLED=0 GOOS=linux go build -o /app/server .

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/server /server
EXPOSE 8080
CMD ["/server"]
```

The cache mount means `go mod download` only fetches modules that aren't already in `/go/pkg/mod`. Even when `go.mod` changes, already-downloaded modules are reused. The bind mount gives the builder stage access to the current source without copying it into the image layer.

One trade-off I found: the `--mount=type=bind,target=.` exposes the entire build context, which may include files you'd rather not mount. A `.dockerignore` helps here, though I'm still figuring out the best pattern for that.

## Verify

Run each build twice and compare the timing:

```bash
# Build with COPY approach
docker build --no-cache -t app-copy -f Dockerfile.copy .

# Build with mount approach (BuildKit)
DOCKER_BUILDKIT=1 docker build --no-cache -t app-mount -f Dockerfile.mount .

# Second build (reuses cache or cache mount)
time DOCKER_BUILDKIT=1 docker build -t app-mount -f Dockerfile.mount .
time docker build -t app-copy -f Dockerfile.copy .

# Inspect cache mount usage
docker buildx du
```

The mount approach showed noticeably faster second builds in my tests, especially when the dependency set was large. The `--no-cache` first run downloads everything fresh in both approaches.

## Common errors

- **"Cache mount target is not a directory"** — the cache mount path must exist in the container as expected by the package manager. For Go, `/go/pkg/mod` is the default; for npm, `/root/.npm`; for pip, `/root/.cache/pip`. I hit this one when I tried a custom path that didn't match what Go expected.
- **"Cannot use --mount with classic builder"** — without `DOCKER_BUILDKIT=1`, cache mounts fall back silently or error depending on the version. Always set the environment variable or use `docker buildx`. Caught me on the first try.
- **"Bind mount shows no such file or directory"** — the bind mount path in the container must match the expected location. For `--mount=type=bind,target=.` the build context is the current directory. I had to adjust the `target` when my build expected files in a subdirectory.
- **Cache invalidation is too aggressive** — the cache mount key is based on the mount target path. Different Dockerfiles that share the same cache mount path on the same builder share the cache, which can cause stale caches. Something to be aware of if you're running multiple projects on the same builder.

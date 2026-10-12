---
last_verified: 2026-10-12
tool_version: n/a
---

# Docker BuildKit advanced features: cache mounts and secrets

## Purpose

This guide covers two BuildKit build-time mount features that solve recurring
pain points in image builds: `RUN --mount=type=cache` for persisting package
manager caches across builds, and `RUN --mount=type=secret` (plus the related
`type=ssh` mount) for giving a single build step access to credentials without
baking them into any image layer. It focuses on the mount syntax, cache scoping
rules, secret hygiene, and how to confirm nothing sensitive leaked into the
finished image.

## When to use

Use cache mounts when a build step re-downloads the same third-party content on
every invocation: language package installs, operating-system package installs,
or any step whose input changes slightly but whose backing store is large.
Cache mounts keep the package manager's own cache directory on the builder and
reuse it, so only missing entries are fetched.

Use secret mounts when a build step needs a credential at build time: pulling a
private package feed, cloning a private repository during the build, or
authenticating to an internal artifact mirror. A secret mount exposes the value
only for the duration of that one `RUN` step and never creates a layer
containing it, which is the property that `COPY`-ing a credential file or
passing it via a build argument cannot provide.

Prefer plain `COPY` layer caching alone when the builder does not support
BuildKit mounts, or when the dependency set is small enough that re-downloading
is cheaper than managing mount state. Prefer multi-stage builds in combination
with both mount types so that caches and credentials live only in build stages
and the final stage carries just the built artifact.

## Prerequisites

- A container engine build that uses BuildKit (the `docker buildx` builder or a
  BuildKit-enabled `docker build`).
- A build context with a dependency manifest (package manifest, lockfile, or
  equivalent) so cache behaviour can be observed across repeated builds.
- The credential material available on the build host (a file path for secret
  mounts, an agent socket for SSH mounts), never checked into the context.

## Steps

### 1. Confirm the builder supports mounts

Run a trivial build that uses a cache mount and confirm it succeeds before
converting a real Dockerfile. If the builder rejects the `--mount` flag, the
build is running on the classic builder and the rest of this guide does not
apply until the build is routed to a BuildKit builder.

```dockerfile
# syntax=docker/dockerfile
FROM alpine AS probe
RUN --mount=type=cache,target=/var/cache/apk apk update
```

```bash
docker buildx build -t mount-probe .
```

### 2. Add a cache mount for the package manager cache

Point the cache mount at the directory the package manager actually uses, and
keep the mount target stable across Dockerfiles that should share cache. The
following example caches a Python package install:

```dockerfile
# syntax=docker/dockerfile
FROM python AS builder
WORKDIR /app
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt
COPY . .
```

The first build populates the builder-side cache. Rebuilds after an
application-code change reuse the cached wheels and only fetch what the
manifest now requires. Combining the cache mount with the
manifest-first `COPY` pattern keeps layer invalidation narrow while the mount
keeps downloads incremental.

### 3. Scope shared caches explicitly

By default, mounts with the same target path on the same builder share one
cache, which means unrelated projects can pollute each other or read stale
entries. Give each logical cache an explicit identity so sharing is a choice:

```dockerfile
# syntax=docker/dockerfile
FROM python AS builder
WORKDIR /app
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip,id=pip-cache-myservice \
    pip install -r requirements.txt
```

Use one `id` per service or per package manager. Builds that should share a
cache use the same `id`; builds that must stay isolated use distinct values.
Treat a cache that starts serving stale content as disposable: change the `id`
to start from an empty cache rather than debugging entries inside the shared
volume.

### 4. Pass build-time credentials with a secret mount

Expose the credential only inside the `RUN` step that needs it, reading it
from the mounted path. The secret never appears in a `COPY` layer, a build
argument, or image history:

```dockerfile
# syntax=docker/dockerfile
FROM python AS builder
WORKDIR /app
COPY requirements.txt .
RUN --mount=type=secret,id=pip-index-url \
    PIP_INDEX_URL=$(cat /run/secrets/pip-index-url) \
    pip install -r requirements.txt
```

Build with the secret supplied from a host file:

```bash
docker buildx build --secret id=pip-index-url,src=$HOME/.secrets/pip-index-url -t myservice .
```

Rules that keep this safe: one secret per mount (`id` names the credential,
`src` is the host file), never `echo` the value or pass it with `--build-arg`,
and never `COPY` the secret into the context. The mounted file exists only for
that step; subsequent layers cannot read it.

### 5. Use an SSH mount for repository access during the build

When the build step clones a private repository or fetches a private module,
forward the SSH agent instead of copying a private key into the image:

```dockerfile
# syntax=docker/dockerfile
FROM golang AS builder
WORKDIR /app
RUN --mount=type=ssh go mod download
```

```bash
docker buildx build --ssh default -t myservice .
```

The agent socket is available only during that `RUN` step. No key material is
written to any layer, and the finished image carries no trace of the agent.

### 6. Keep mounts out of the final stage

Use a multi-stage build so that mount usage stays in build stages and the
shipped stage contains only the artifact:

```dockerfile
# syntax=docker/dockerfile
FROM python AS builder
WORKDIR /app
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip,id=pip-cache-myservice \
    pip install -r requirements.txt
COPY . .
RUN python -m compileall src

FROM python AS runtime
WORKDIR /app
COPY --from=builder /app/src ./src
CMD ["python", "-m", "src"]
```

Even if a build step mishandles a credential, the final stage only receives
the explicitly copied artifact directory, which bounds the blast radius.

## Verify

1. Rebuild twice without changing the manifest and confirm the second build
   reuses the cache mount instead of re-downloading:

   ```bash
   docker buildx build -t myservice .
   docker buildx build -t myservice .
   docker buildx du
   ```

   The builder cache report should show cache usage, and the second build log
   should show the install step completing without fetching every package.

2. Confirm no secret leaked into the image by checking build history and the
   filesystem of the finished image:

   ```bash
   docker buildx build --secret id=pip-index-url,src=$HOME/.secrets/pip-index-url -t myservice .
   docker history myservice
   docker run --rm myservice sh -c 'ls /run/secrets 2>/dev/null; echo "secrets-dir-check-done"'
   ```

   History must not contain the credential value or a layer that copies a
   credential file, and the runtime container must not contain the secret path.

3. Confirm cache isolation by building two services with distinct cache `id`
   values and checking that changing one manifest does not invalidate the
   other's cached step.

## Rollback

Mounts are build-time only, so rollback means returning to a Dockerfile that
does not use them:

1. Restore the previous Dockerfile revision (manifest-first `COPY` plus plain
   `RUN` install steps, credentials handled outside the build).
2. Rebuild and re-run the Verify steps above to confirm the image still builds
   and behaves identically.
3. Optionally evict builder cache created by the mounts so later builds start
   clean:

   ```bash
   docker buildx prune --force
   ```

   Use targeted pruning on shared builders; a full prune evicts every
   project's cache, not just this service's.

## Common errors

- **Mount flag rejected by the builder** — the build ran on the classic
  builder. Route the build through a BuildKit builder (`docker buildx build`)
  instead of retrying the same command.
- **Cache mount appears to do nothing** — the mount target does not match the
  directory the package manager actually writes to. Check the tool's default
  cache location and mount exactly that path.
- **Two projects share a stale cache** — both Dockerfiles use the same mount
  target without an explicit `id`. Assign a distinct `id` per service and
  rebuild.
- **Secret file not found in the step** — the `--secret id=...` name on the
  command line does not match the `id=` in the Dockerfile mount, or the `src`
  path is wrong. The names must match exactly.
- **Credential visible in image history** — the value was passed via build
  argument or `COPY`-ied into a layer instead of using a secret mount. Remove
  that instruction, rebuild without cache for the affected stages, and confirm
  with `docker history` before shipping.
- **SSH mount fails with no agent** — the build was invoked without the
  matching `--ssh` flag, or the agent holds no key. Start the agent, add the
  key, and pass the same socket name the Dockerfile expects.

## References

- BuildKit built-in mount documentation (cache, secret, and SSH mount types)
- Buildx build command reference (secret and SSH forwarding flags)
- Builder cache management documentation (inspecting and pruning build cache)

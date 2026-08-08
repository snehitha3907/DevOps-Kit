---
last_verified: 2026-08-08
tool_version: n/a
sources:
  - https://thecodeforge.io/devops/docker-kubernetes-ci-cd/
  - https://codingprotocols.com/blog/github-actions-kubernetes-cicd
---

# Smaller images through base-image selection, layer caching, and minimal runtimes

> L2 concept notes — what I learned when I combined three image-optimization tricks to shrink a Python Flask image from over a gigabyte to under 100 MB.

## What I set out to do

I kept shipping images that were way bigger than they needed to be. A simple Flask app ballooned to over a gigabyte because I started from `python:3.12` (the full Debian-based image) and ran `pip install` in the same Dockerfile layer as my application code. I wanted to try three things together:

1. **Pick a smaller base image** — swap the full Debian-based `python:3.12` for `python:3.12-slim` and then strip down to a distroless runtime in the final stage.
2. **Cache layers properly** — install dependencies before copying application code so that editing a source file doesn't invalidate the expensive dependency layer.
3. **Use a minimal final stage** — a multi-stage build that carries over only the installed packages and app code, nothing from the builder.

## What worked

I rewrote the Dockerfile as a two-stage build:

```dockerfile
# --- Builder stage ---
FROM python:3.12-slim AS builder
WORKDIR /install
COPY requirements.txt .
# Install deps BEFORE app code so source edits reuse this cached layer
RUN pip install --user --no-cache-dir -r requirements.txt

# --- Final stage: minimal runtime, no build tools ---
FROM gcr.io/distroless/python3
COPY --from=builder /root/.local /root/.local
COPY . /app
WORKDIR /app
ENV PYTHONPATH=/root/.local/lib/python*/site-packages
CMD ["app.py"]
```

Three decisions cut the size:

- **Base image — `python:3.12-slim`** is about 150 MB instead of the 900 MB full image, because it drops docs, man pages, and other non-essential packages.
- **Layer ordering** — `COPY requirements.txt` and `pip install` run before `COPY .`, so when I edit `app.py` Docker reuses the cached dependency layer and only rebuilds the last two lines.
- **Minimal runtime — distroless** — the final stage has no shell, no package manager, no utilities. Just Python and what the app needs. The final image was 85 MB.

I verified with:

```bash
docker build -t my-app:slim .
docker images my-app:slim
```

And checked the breakdown with `docker history` — the dependency layer was ~30 MB, the distroless base ~25 MB, and the app code ~5 MB.

## Got stuck on

- **`--no-cache-dir` is essential.** Without it pip leaves a cache directory inside the layer, adding roughly 200 MB. I almost missed this because the first build "worked", it was just bloated.
- **`PYTHONPATH` needed a glob.** The distroless image puts packages in a version-specific path (`/root/.local/lib/python3.12/site-packages`), so I used a wildcard in `ENV PYTHONPATH` to match it.
- **Debugging a distroless image is painful.** There is no shell, so when the app failed to start I couldn't `docker run -it` to poke around. I added a temporary `debug` stage that copies in a shell so I could troubleshoot before cutting it out for the final version.

## What I'd try next

I want to experiment with `scratch` for Go binaries — a truly empty base image where only the compiled binary exists. For Python, I'd try `python:3.12-alpine` and check whether my dependencies are compatible with musl libc. I should also add a `.dockerignore` file to keep the build context small: a fat context slows down every build even when the final image is tiny.

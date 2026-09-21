# last_verified: 2026-09-20 · Docker n/a
#
# Purpose: Multi-stage production Dockerfile for a small Python web service.
#   Builds dependencies in an isolated builder stage, then ships only the
#   runtime and installed packages in a slim final image that runs as a
#   non-root user with a container healthcheck.
# When to use: When a Python HTTP service needs a small, repeatable image
#   for compose, Swarm, or Kubernetes deployment with limited runtime surface.
# Prerequisites:
#   - Docker engine with build support
#   - Application source with requirements.txt and an app module exposing
#     a health endpoint at /health on port 8000
# Build: docker build -f production-python-web-service.Dockerfile -t myapp/api:test .
# Run: docker run --rm -p 8000:8000 myapp/api:test
# Verify: curl -f http://localhost:8000/health ; docker inspect --format '{{.State.Health.Status}}' <container>
# Rollback: retag and redeploy the previous image tag; no in-image state to migrate.
# Common errors: health endpoint path mismatch (container reports unhealthy);
#   files owned by root when a host volume is mounted over /app (recreate
#   without the mount or adjust ownership at run time).

# --- Builder stage: resolve and install dependencies in isolation ---
FROM python:3.11-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# --- Runtime stage: minimal image, non-root user, healthcheck ---
FROM python:3.11-slim AS runtime
WORKDIR /app

# Create a dedicated non-root user and group first so later layers use it.
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Bring in only the installed packages from the builder stage.
COPY --from=builder /install /usr/local
COPY app.py gunicorn.conf.py ./

# Drop privileges before the service starts.
USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

CMD ["gunicorn", "-c", "gunicorn.conf.py", "app:app"]

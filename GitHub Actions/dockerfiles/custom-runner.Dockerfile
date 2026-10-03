# syntax=docker/dockerfile:1
# last_verified: 2026-10-03 · GitHub Actions n/a
#
# Purpose: Minimal custom GitHub Actions runner image. The runner is
#   downloaded into a builder stage at build time; registration happens
#   at container start from environment variables, so the same image
#   serves any repository or organization without a rebuild.
# When to use: When you want a small runner image you control — own
#   base, own package set, own runner release pin — instead of the
#   prebuilt runner images. For jobs that must build container images
#   themselves, start from the Docker-in-Docker variant in
#   GitHub/dockerfiles/self-hosted-runner.Dockerfile instead.
# Prerequisites: Docker with BuildKit (docker buildx), and a runner
#   registration token from the target repository or organization
#   (Settings > Actions > Runners).
# Build: docker buildx build --build-arg RUNNER_VERSION=<release tag> \
#          -t gh-actions-custom-runner .
# Run:   docker run --rm \
#          -e RUNNER_URL=https://github.com/owner/repo \
#          -e RUNNER_TOKEN=<registration token> \
#          -e RUNNER_LABELS=self-hosted,custom \
#          gh-actions-custom-runner
# Verify: The runner shows as Online under Settings > Actions > Runners,
#   and a workflow dispatched with its label completes; docker logs
#   shows config.sh output followed by the listener starting up.
# Notes: RUNNER_VERSION deliberately has no default — pin the exact
#   actions-runner release at build time instead of inheriting a
#   floating version (runner releases ship on their own cadence).

ARG RUNNER_ARCH=x64

FROM ubuntu:24.04 AS builder

ARG RUNNER_VERSION
ARG RUNNER_ARCH

# Fail fast: the caller must pin the runner release explicitly.
RUN test -n "${RUNNER_VERSION}" || { \
      echo "ERROR: pass --build-arg RUNNER_VERSION=<actions-runner release tag>"; \
      exit 1; \
    }

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" \
      -o /tmp/actions-runner.tar.gz \
    && mkdir -p /actions-runner \
    && tar xzf /tmp/actions-runner.tar.gz -C /actions-runner \
    && rm /tmp/actions-runner.tar.gz

FROM ubuntu:24.04

ARG RUNNER_VERSION

LABEL org.opencontainers.image.title="gh-actions-custom-runner" \
      org.opencontainers.image.description="Minimal custom GitHub Actions runner" \
      org.opencontainers.image.version="${RUNNER_VERSION}"

# Runner runtime libraries (libcurl, ICU, libunwind, OpenSSL) plus git
# for workflow checkouts and jq for job-side JSON handling.
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      jq \
      libcurl4 \
      libicu74 \
      libunwind8 \
      libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Dedicated non-root account instead of running the listener as root.
RUN groupadd --system runner \
    && useradd --system --gid runner --create-home --shell /bin/bash runner

COPY --from=builder /actions-runner /home/runner/actions-runner

RUN mkdir -p /home/runner/_work \
    && chown -R runner:runner /home/runner

USER runner
WORKDIR /home/runner/actions-runner
ENV RUNNER_WORKDIR=/home/runner/_work

# Entrypoint: register on start (ephemeral-friendly), then hand off to
# the listener. Registration tokens are short-lived, so they are passed
# at run time, never baked into the image.
RUN <<'EOF'
cat > /usr/local/bin/start-runner <<'SCRIPT'
#!/bin/bash
set -euo pipefail

: "${RUNNER_URL:?RUNNER_URL is not set (format: https://github.com/owner/repo)}"
: "${RUNNER_TOKEN:?RUNNER_TOKEN is not set (registration token from Settings > Actions > Runners)}"

/home/runner/actions-runner/config.sh \
  --url "${RUNNER_URL}" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME:-$(hostname)}" \
  --labels "${RUNNER_LABELS:-self-hosted,custom}" \
  --work "${RUNNER_WORKDIR:-/home/runner/_work}" \
  --unattended \
  --replace \
  ${RUNNER_EPHEMERAL:+--ephemeral}

exec /home/runner/actions-runner/run.sh
SCRIPT
chmod 0755 /usr/local/bin/start-runner
EOF

ENTRYPOINT ["/usr/local/bin/start-runner"]

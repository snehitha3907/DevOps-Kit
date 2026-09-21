# last_verified: 2026-09-21 · GitHub self-hosted runner image

# Purpose: Self-hosted GitHub Actions runner container with Docker-in-Docker and
# pre-installed actions dependencies. Runners register against a GitHub Enterprise
# server or github.com, pick up jobs from the designated organization/repo, and
# execute workflows inside isolated containers.
# When to use: When workflow jobs require Docker privileges (e.g. building and
# pushing container images) alongside runner-native actions that need tools
# pre-installed on the host rather than installed per-job.
# Prerequisites: A GitHub Personal Access Token or GitHub App token with
# `run:write` scope; the Docker socket or DinD sidecar available at `/var/run/docker.sock`;
# the runner group URL and labels configured in the GitHub UI or via env vars.

# Build stage: compile the runner binary and fetch action dependencies.
FROM ubuntu:24.04 AS builder

ARG RUNNER_VERSION=2.327.1
ARG NODE_VERSION=22

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    jq \
    libcurl4 \
    libicu74 \
    libunwind8 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" \
    -o /tmp/actions-runner.tar.gz \
    && mkdir -p /actions-runner \
    && tar xzf /tmp/actions-runner.tar.gz -C /actions-runner \
    && rm /tmp/actions-runner.tar.gz

RUN curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Runtime stage: minimal image with runner, DinD, and dependencies.
FROM ubuntu:24.04

LABEL org.opencontainers.image.title="gh-self-hosted-runner" \
      org.opencontainers.image.description="GitHub Actions self-hosted runner with Docker-in-Docker" \
      org.opencontainers.image.version="2.327.1"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    jq \
    libcurl4 \
    libicu74 \
    libunwind8 \
    libssl3 \
    docker.io \
    git \
    ssh \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 runner \
    && useradd --uid 1000 --gid runner --create-home --shell /bin/bash runner

COPY --from=builder /actions-runner /actions-runner
COPY --from=builder /usr/local/bin/node /usr/local/bin/
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules/
COPY --from=builder /usr/local/include/node /usr/local/include/node/

RUN chown -R runner:runner /actions-runner \
    && mkdir -p /home/runner/_work /home/runner/.docker \
    && chown -R runner:runner /home/runner

USER runner
WORKDIR /home/runner

ENV RUNNER_ALLOW_RUNASROOT=1 \
    DOCKER_CONFIG=/home/runner/.docker

# Healthcheck: verify the runner process is listening and accepting work.
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -fsS http://localhost:8080/_status || exit 1

# Steps: configure and start the runner with DinD sidecar.
# 1. Configure runner via `config.sh` with the URL, token, and labels.
# 2. Start Docker-in-Docker in the background for workflow jobs needing `docker` requests.
# 3. Run the runner with `run.sh`, which blocks and processes jobs.
# Verify: docker ps lists running containers; the runner dashboard shows the
# instance as online; workflow jobs that use `docker build` and `docker push`
# complete without "Cannot connect to the Docker daemon" errors.

EXPOSE 8080

CMD ["/home/runner/actions-runner/run.sh"]

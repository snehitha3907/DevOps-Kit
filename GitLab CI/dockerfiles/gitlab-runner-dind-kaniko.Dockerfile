# last_verified: 2026-10-22 · GitLab Runner self-hosted image

# Purpose: Self-hosted GitLab Runner container with Docker-in-Docker, kaniko/buildah
# for in-job image builds, and kubectl + helm for deploy jobs. Registers against a
# GitLab instance (gitlab.com or self-managed) and executes CI/CD jobs that require
# privileged Docker operations and Kubernetes deployments.
# When to use: When pipeline jobs need to build and push container images (via
# kaniko or buildah), interact with Docker daemon (via DinD sidecar), or deploy to
# Kubernetes clusters using kubectl/helm — all from a single runner image.
# Prerequisites: A GitLab Runner registration token with `runner:write` scope; the
# Docker socket or DinD sidecar available at `/var/run/docker.sock`; kubectl/helm
# configured against target clusters; kaniko executor or buildah available in
# job containers.

# Build stage: fetch gitlab-runner binary and install dependencies.
FROM ubuntu:24.04 AS builder

ARG GITLAB_RUNNER_VERSION=17.4.0
ARG KUBECTL_VERSION=v1.31.0
ARG HELM_VERSION=v3.15.4
ARG KANIKO_VERSION=v1.23.2
ARG BUILDAH_VERSION=1.35.0

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://gitlab-runner-downloads.s3.amazonaws.com/v${GITLAB_RUNNER_VERSION}/binaries/gitlab-runner-linux-amd64" \
    -o /usr/local/bin/gitlab-runner \
    && chmod +x /usr/local/bin/gitlab-runner

RUN curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
    -o /tmp/helm.tar.gz \
    && tar xzf /tmp/helm.tar.gz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && rm -rf /tmp/helm.tar.gz /tmp/linux-amd64

RUN curl -fsSL "https://github.com/GoogleContainerTools/kaniko/releases/download/${KANIKO_VERSION}/kaniko-${KANIKO_VERSION}.tar.gz" \
    -o /tmp/kaniko.tar.gz \
    && tar xzf /tmp/kaniko.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/kaniko \
    && rm /tmp/kaniko.tar.gz

RUN curl -fsSL "https://github.com/containers/buildah/releases/download/v${BUILDAH_VERSION}/buildah-${BUILDAH_VERSION}.linux.amd64.tar.gz" \
    -o /tmp/buildah.tar.gz \
    && tar xzf /tmp/buildah.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/buildah \
    && rm /tmp/buildah.tar.gz

# Runtime stage: minimal image with runner, DinD, and deployment tools.
FROM ubuntu:24.04

LABEL org.opencontainers.image.title="gitlab-runner-dind-kaniko" \
      org.opencontainers.image.description="GitLab Runner with Docker-in-Docker, kaniko, buildah, kubectl, and helm" \
      org.opencontainers.image.version="17.4.0"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    docker.io \
    git \
    ssh \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 gitlab-runner \
    && useradd --uid 1000 --gid gitlab-runner --create-home --shell /bin/bash gitlab-runner

COPY --from=builder /usr/local/bin/gitlab-runner /usr/local/bin/gitlab-runner
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/kaniko /usr/local/bin/kaniko
COPY --from=builder /usr/local/bin/buildah /usr/local/bin/buildah

RUN chown -R gitlab-runner:gitlab-runner /home/gitlab-runner \
    && mkdir -p /home/gitlab-runner/.docker /home/gitlab-runner/.kube \
    && chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/.docker /home/gitlab-runner/.kube \
    && usermod -aG docker gitlab-runner

USER gitlab-runner
WORKDIR /home/gitlab-runner

ENV DOCKER_CONFIG=/home/gitlab-runner/.docker \
    KUBECONFIG=/home/gitlab-runner/.kube/config \
    HELM_CACHE_HOME=/home/gitlab-runner/.cache/helm \
    HELM_CONFIG_HOME=/home/gitlab-runner/.config/helm \
    HELM_DATA_HOME=/home/gitlab-runner/.local/share/helm

# Healthcheck: verify the runner process is registered and responsive.
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD gitlab-runner verify || exit 1

# Steps: register and start the runner with DinD sidecar.
# 1. Register runner via `gitlab-runner register` with URL, token, and executor (docker).
# 2. Start Docker-in-Docker in the background for workflow jobs needing `docker` requests.
# 3. Run the runner with `gitlab-runner run`, which blocks and processes jobs.
# Verify: `gitlab-runner verify` succeeds; the GitLab UI shows the runner as online;
# jobs using `kaniko`, `buildah`, `docker build`, `kubectl`, or `helm` complete
# without "Cannot connect to the Docker daemon" or "kubectl: command not found" errors.

EXPOSE 8080

CMD ["gitlab-runner", "run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
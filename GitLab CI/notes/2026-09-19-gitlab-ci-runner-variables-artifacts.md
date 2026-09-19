---
last_verified: 2026-09-19
tool_version: n/a
sources:
  - https://docs.gitlab.com/ee/ci/quick_start/
  - https://docs.gitlab.com/ee/ci/runners/
---

# GitLab CI/CD quickstart — runner setup, variables, and artifacts trip-ups

> L2 follow-up to the basic quickstart. I already had a pipeline running (see 2026-06-24-following-gitlab-ci-quickstart.md). This covers the next layer: making it usable for real work.

## What I was trying to do

Get a self-hosted runner registered, pass secrets via CI/CD variables, cache dependencies between runs, and share build artifacts between stages. The quickstart glosses over all of these.

## Steps

### 1. Register a self-hosted runner

```bash
# On the runner machine (Ubuntu 22.04)
curl -L --output /usr/local/bin/gitlab-runner \
  https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
chmod +x /usr/local/bin/gitlab-runner

# Register against GitLab.com (replace with your URL/token)
gitlab-runner register \
  --url https://gitlab.com \
  --registration-token <PROJECT_RUNNER_TOKEN> \
  --executor docker \
  --docker-image docker:24 \
  --description "local-docker-runner" \
  --tag-list "docker,local" \
  --run-untagged="false" \
  --locked="false"
```

Started it as a service:
```bash
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
gitlab-runner start
```

### 2. Add CI/CD variables for secrets

Project > Settings > CI/CD > Variables:
- `DOCKER_HUB_TOKEN` — protected, masked
- `KUBE_CONFIG` — protected, file type
- `SONAR_TOKEN` — protected, masked

Referenced in `.gitlab-ci.yml`:
```yaml
variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""

build:
  variables:
    DOCKER_HUB_TOKEN: $DOCKER_HUB_TOKEN  # explicit pass-through
  script:
    - echo "$DOCKER_HUB_TOKEN" | docker login -u myuser --password-stdin
```

### 3. Cache dependencies

```yaml
cache:
  key: "$CI_COMMIT_REF_SLUG"
  paths:
    - .cache/pip/
    - node_modules/
  policy: pull-push

install-deps:
  stage: prepare
  image: python:3.11
  script:
    - pip install --cache-dir .cache/pip -r requirements.txt
  cache:
    key: "$CI_COMMIT_REF_SLUG"
    paths:
      - .cache/pip/
    policy: push
```

### 4. Artifacts between stages

```yaml
build:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
    when: always

test:
  stage: test
  needs: [build]
  script:
    - pytest dist/
```

## Got stuck on

- **Runner registration token vs project token**: The quickstart says "registration token" but there are three types (instance, group, project). Used project token from Settings > CI/CD > Runners > New project runner. Instance/group tokens need admin access.
- **Docker-in-Docker executor**: The `docker:24` image needs `privileged = true` in `config.toml` for `docker build`. Added `[runners.docker] privileged = true` — security trade-off documented.
- **Cache key collision**: Used `$CI_COMMIT_REF_SLUG` but feature branches and main shared the same slug after rebase. Switched to `$CI_COMMIT_SHA` for unique keys, then manual cleanup.
- **Artifacts not passing**: `needs:` downloads artifacts automatically, but only if the upstream job has `artifacts:` defined. Missed `when: always` on the build job — artifacts disappeared on failure.
- **Protected variables on fork pipelines**: Fork MR pipelines don't get protected variables by default. Needed "Run pipelines in forked projects" setting + unprotect for specific variables (security review required).

## What worked

- Runner registration via CLI is clean — token rotates, config in `/etc/gitlab-runner/config.toml`.
- CI/CD variables UI is straightforward once you know protected/masked/file types.
- `needs:` keyword for DAG pipelines is a game-changer over sequential stages.
- Cache policy `pull-push` on prepare stage, `pull` on consumers works reliably.

## What I'd try next

- GitLab CI/CD catalog for reusable components (`.gitlab/ci/` templates).
- `rules:` instead of `only/except` for complex trigger logic.
- Parent-child pipelines for monorepo splits.
- Auto DevOps as a baseline comparison.
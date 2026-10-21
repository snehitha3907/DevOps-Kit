# Modular GitLab CI/CD Pipeline Template

A production-ready, modular GitLab CI/CD pipeline scaffold using `include:local` for composable job templates, shared library with YAML anchors and `!reference` tags, and a Kind-based runner bootstrap for local testing.

## Overview

This template provides a complete GitLab CI/CD pipeline structure organized as:

```
.
├── .gitlab-ci.yml              # Root pipeline configuration (includes local templates)
├── .gitlab/
│   └── ci/
│       ├── lib.yml             # Shared anchors, references, hidden job templates, helpers
│       ├── build.yml           # Build stage job templates
│       ├── test.yml            # Test stage job templates
│       ├── deploy.yml          # Deploy stage job templates
│       └── helpers.sh          # Bash helper functions for CI jobs
├── scripts/
│   └── kind-runner-bootstrap.sh # Kind cluster + GitLab Runner bootstrap
└── README.md                   # This file
```

## Features

- **Modular Architecture**: Separate files per stage (build, test, deploy) included via `include:local`
- **DRY with YAML Anchors**: Reusable configurations using `&anchor` and `<<: *alias`
- **!reference Tags**: Modern GitLab CI/CD feature for referencing job fields across files
- **Hidden Job Templates**: Base templates (`.job_base`, `.docker_build_template`, etc.) extended by concrete jobs
- **Multi-Stage Pipeline**: validate → build → test → deploy
- **Security-First**: Integrated SAST, dependency scanning, container scanning, secret detection, IaC scanning
- **Multi-Platform Builds**: Docker Buildx for linux/amd64,linux/arm64
- **Deployment Strategies**: Rolling, Canary, Blue-Green, GitOps (ArgoCD)
- **Review Environments**: Automatic per-MR environments with auto-stop
- **Kind Runner Bootstrap**: Local Kubernetes runner for pipeline testing
- **Helm & Kustomize Support**: Native deployment templates for both

## Quick Start

### 1. Copy Template to Your Project

```bash
# Clone or download this template
cp -r /path/to/modular-pipeline-repo/* your-project/
cd your-project
```

### 2. Configure Variables

Edit `.gitlab-ci.yml` or set in GitLab UI (Settings → CI/CD → Variables):

| Variable | Description | Required |
|----------|-------------|----------|
| `CI_REGISTRY` | Container registry URL | Yes |
| `CI_REGISTRY_USER` | Registry username | Yes |
| `CI_REGISTRY_PASSWORD` | Registry password/token | Yes |
| `KUBE_CONFIG` | Base64-encoded kubeconfig | For deploy jobs |
| `BASE_DOMAIN` | Base domain for review/staging/prod URLs | Yes |
| `ARGOCD_TOKEN` | ArgoCD auth token (if using GitOps) | Optional |
| `FOSSA_API_KEY` | FOSSA license scanning key | Optional |

### 3. Push to GitLab

```bash
git init
git add .
git commit -m "feat: add modular GitLab CI/CD pipeline"
git remote add origin https://gitlab.com/your-group/your-project.git
git push -u origin main
```

### 4. Local Testing with Kind Runner

```bash
# Get runner token from GitLab: Admin Area > Runners > Register instance runner
export RUNNER_TOKEN="your-runner-token"

# Bootstrap Kind cluster with GitLab Runner
./scripts/kind-runner-bootstrap.sh -r "$RUNNER_TOKEN"

# Set kubeconfig for local kubectl
export KUBECONFIG=~/.kube/kind-gitlab-runner
```

## Pipeline Structure

### Stages

| Stage | Purpose | Key Jobs |
|-------|---------|----------|
| `validate` | Lint, syntax check, policy validation | `test:helm-lint`, `test:kubeval`, `test:lint` |
| `build` | Compile, package, build images | `build:docker`, `build:docker:multiarch`, `build:helm`, `build:artifact` |
| `test` | Unit, integration, security, performance | `test:unit`, `test:integration`, `test:sast`, `test:container-scan` |
| `deploy` | Deploy to environments | `deploy:review`, `deploy:staging`, `deploy:production`, `deploy:canary` |

### Extending Jobs

All concrete jobs extend hidden templates from `lib.yml`:

```yaml
# In your .gitlab-ci.yml or stage file
my-custom-build:
  extends: .docker_build_template
  variables:
    DOCKERFILE: "custom/Dockerfile"
    BUILD_ARGS: "--build-arg CUSTOM_ARG=value"
  rules:
    - if: $CI_COMMIT_BRANCH == "feature/*"
```

### Using !reference

Reference fields from other jobs (GitLab 16.1+):

```yaml
deploy:custom:
  stage: deploy
  script:
    - !reference [.deploy_k8s_template, script]
    - echo "Custom post-deploy step"
  variables:
    DEPLOY_ENVIRONMENT: "custom"
```

## Job Templates Reference

### Build Templates (`.gitlab/ci/build.yml`)

| Template | Extends | Description |
|----------|---------|-------------|
| `build:docker` | `.docker_build_template` | Single-platform Docker build |
| `build:docker:multiarch` | `.docker_buildx_template` | Multi-platform (amd64/arm64) build |
| `build:kaniko` | `.job_base` | Kaniko build (no Docker daemon) |
| `build:helm` | `.helm_lint_template` | Helm chart packaging & publishing |
| `build:docs` | `.job_base` | Documentation site build |
| `build:artifact` | `.job_base` | Language-specific artifact compilation |

### Test Templates (`.gitlab/ci/test.yml`)

| Template | Extends | Description |
|----------|---------|-------------|
| `test:unit` | `.unit_test_template` | Unit tests (multi-language auto-detect) |
| `test:integration` | `.integration_test_template` | Integration tests with service containers |
| `test:e2e` | `.job_base` | Cypress/Playwright E2E tests |
| `test:sast` | `.sast_template` | Static Application Security Testing |
| `test:dependency-scan` | `.dependency_scan_template` | Dependency vulnerability scanning |
| `test:container-scan` | `.container_scan_template` | Container image vulnerability scanning |
| `test:secret-detection` | `.job_base` | Secret detection in code |
| `test:iac-scan` | `.job_base` | Checkov IaC scanning (TF, K8s, Helm) |
| `test:license-scan` | `.job_base` | FOSSA license compliance |
| `test:performance` | `.job_base` | k6 load testing |
| `test:lint` | `.job_base` | Code quality/linting (multi-language) |

### Deploy Templates (`.gitlab/ci/deploy.yml`)

| Template | Extends | Description |
|----------|---------|-------------|
| `deploy:review` | `.deploy_k8s_template` | Per-MR review environment (auto-stop) |
| `stop:review` | `.kubectl_environment` | Manual review environment cleanup |
| `deploy:staging` | `.deploy_k8s_template` | Staging deployment (auto on main) |
| `deploy:production` | `.deploy_production_template` | Production (manual, tags only) |
| `deploy:canary` | `.kubectl_environment` | Canary deployment (10% traffic) |
| `deploy:promote-canary` | `.kubectl_environment` | Promote canary to 100% |
| `deploy:rollback` | `.kubectl_environment` | Helm/kubectl rollback |
| `deploy:argocd` | `.kubectl_environment` | ArgoCD GitOps sync |
| `deploy:helm-registry` | `.helm_environment` | Publish Helm charts to OCI registry |
| `deploy:terraform` | `.job_base` | Terraform plan/apply |
| `deploy:blue-green` | `.kubectl_environment` | Blue-green deployment |

## Shared Library (`.gitlab/ci/lib.yml`)

### Anchors Available

| Anchor | Purpose |
|--------|---------|
| `.docker_environment` | Docker-in-Docker setup |
| `.helm_environment` | Helm + kubectl setup |
| `.kubectl_environment` | kubectl setup |
| `.cache_default` / `.cache_pull` / `.cache_push` | Cache configuration |
| `.only_default_branch` / `.only_merge_requests` / `.only_tags` / `.only_schedules` | Common rule sets |
| `.resource_limits_small` / `.medium` / `.large` | Kubernetes resource limits |
| `.retry_on_failure` | Auto-retry on runner failures |
| `.timeout_short` / `.medium` / `.long` | Job timeouts |

### Hidden Job Templates

| Template | Stage | Purpose |
|----------|-------|---------|
| `.job_base` | — | Base configuration for all jobs |
| `.docker_build_template` | build | Docker build with registry push |
| `.docker_buildx_template` | build | Multi-arch Docker Buildx build |
| `.unit_test_template` | test | Multi-language unit test runner |
| `.integration_test_template` | test | Integration tests with DB/cache |
| `.sast_template` | test | GitLab SAST scanner |
| `.dependency_scan_template` | test | GitLab dependency scanning |
| `.container_scan_template` | test | GitLab container scanning |
| `.helm_lint_template` | validate | Helm chart linting |
| `.kubeval_template` | validate | Kubernetes manifest validation |
| `.deploy_k8s_template` | deploy | Standard K8s/Helm deployment |
| `.deploy_production_template` | deploy | Production deployment (manual) |

### Helper Functions (`.gitlab/ci/helpers.sh`)

Source in `before_script`: `source .gitlab/ci/helpers.sh`

| Function | Description |
|----------|-------------|
| `log_info/warn/error/success` | Colored logging |
| `retry <attempts> <delay> <cmd>` | Exponential backoff retry |
| `wait_for_rollout <resource> [ns] [timeout]` | Wait for K8s rollout |
| `generate_version` | Semantic version from git tags |
| `get_image_digest <image>` | Extract Docker image digest |
| `registry_login` | Docker registry authentication |
| `setup_kubectl` | Configure kubectl from KUBE_CONFIG |
| `setup_helm` | Configure Helm registry auth |
| `export_pipeline_vars` | Export vars to build.env artifact |
| `is_merge_request/default_branch/tag` | Pipeline context checks |
| `get_deploy_environment` | Determine target environment |
| `validate_env VAR1 VAR2...` | Validate required env vars |

## Kind Runner Bootstrap

The `scripts/kind-runner-bootstrap.sh` script provisions:

1. **Kind Cluster**: 1 control-plane + 2 workers with containerd registry mirrors
2. **NGINX Ingress**: For review/staging/production ingress
3. **Cert-Manager**: TLS certificate management
4. **GitLab Runner**: Kubernetes executor with:
   - Privileged mode for Docker-in-Docker
   - Host-path volume for Docker socket
   - S3 cache (MinIO compatible)
   - Prometheus metrics annotations
   - Configurable tags and resource limits

### Usage

```bash
# Basic usage
./scripts/kind-runner-bootstrap.sh -r "$RUNNER_TOKEN"

# Custom configuration
./scripts/kind-runner-bootstrap.sh \
  -n my-cluster \
  -v v1.28.5 \
  -r "$RUNNER_TOKEN" \
  -u https://gitlab.mycompany.com \
  -t "k8s,helm,terraform,prod"
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `KIND_CLUSTER_NAME` | `gitlab-runner` | Cluster name |
| `K8S_VERSION` | `v1.29.2` | Kubernetes version (Kind node image tag) |
| `RUNNER_TOKEN` | (required) | GitLab Runner registration token |
| `GITLAB_URL` | `https://gitlab.com` | GitLab instance URL |
| `RUNNER_TAGS` | `kubernetes,docker,build,test,deploy` | Runner tags |
| `RUNNER_NAME` | `kind-runner-<timestamp>` | Runner name |

## Customization Guide

### Adding a New Stage

1. Create `.gitlab/ci/newstage.yml` with job templates
2. Add `include: - local: '.gitlab/ci/newstage.yml'` to `.gitlab-ci.yml`
3. Add stage to `stages:` list in `.gitlab-ci.yml`

### Adding a New Job Template

1. Define hidden template in `lib.yml` (e.g., `.my_template`)
2. Create concrete job in appropriate stage file extending the template
3. Use anchors for shared configuration

### Overriding Variables

Set in GitLab UI or `.gitlab-ci.yml`:

```yaml
variables:
  REGISTRY_IMAGE: "$CI_REGISTRY_IMAGE/my-custom-name"
  KUBERNETES_VERSION: "1.28"
  HELM_VERSION: "3.14"
```

### Disabling Jobs

Use `rules:` to disable specific jobs:

```yaml
test:sast:
  rules:
    - if: $SAST_ENABLED == "false"
      when: never
    - *only_default_branch
    - *only_merge_requests
```

## Requirements

- **GitLab**: 16.0+ (for `!reference` support)
- **Runner**: Docker executor or Kubernetes executor
- **Docker**: 24.0+ (for Buildx multi-platform)
- **Kubernetes**: 1.27+ (for deploy templates)
- **Helm**: 3.12+ (for Helm deployments)
- **Kind**: 0.22+ (for local runner bootstrap)

## Version Compatibility

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| GitLab | 16.0 | 17.4 |
| GitLab Runner | 16.0 | 17.4 |
| Kubernetes | 1.27 | 1.29 |
| Helm | 3.12 | 3.15 |
| Docker | 24.0 | 27.0 |
| Kind | 0.22 | 0.26 |

## Security Considerations

- Runner registration token stored as Kubernetes secret
- Registry credentials via CI/CD variables (masked/protected)
- Kubeconfig base64-encoded in CI/CD variable
- Privileged mode required for Docker-in-Docker (review for production)
- S3 cache encryption recommended for production
- Network policies recommended for runner namespace

## Troubleshooting

### Runner Not Registering

```bash
# Check runner pods
kubectl get pods -n gitlab-runner -l app=gitlab-runner

# Check logs
kubectl logs -n gitlab-runner -l app=gitlab-runner --tail=100

# Verify secret exists
kubectl get secret gitlab-runner-secret -n gitlab-runner
```

### Pipeline Stuck in Pending

- Verify runner tags match job tags
- Check runner capacity (`kubectl top nodes`)
- Verify runner is not paused in GitLab UI

### Docker Build Fails

- Ensure runner has `--privileged` or Docker socket mounted
- Check `DOCKER_HOST` and `DOCKER_TLS_CERTDIR` variables
- Verify registry credentials

### Kind Cluster Creation Fails

- Ensure Docker daemon is running
- Check port conflicts (80, 443, 6443)
- Verify Kind version compatibility with K8s version

## Contributing

This template is part of the DevOps-Kit. See the main repository for contribution guidelines.

## License

MIT License — see LICENSE file for details.
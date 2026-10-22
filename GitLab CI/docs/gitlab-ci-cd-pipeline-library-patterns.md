---
last_verified: 2026-10-22
tool_version: n/a
sources: []
---

# GitLab CI/CD pipeline library patterns

> Shipping one maintained pipeline to many repositories using `include:project`, `extends`, `!reference`, `rules`, and `spec:inputs`

## Purpose

This document describes how to structure a GitLab CI/CD pipeline as a reusable library that multiple downstream repositories can consume. The pattern separates pipeline definition from project-specific configuration, allowing a platform team to maintain a single source of truth for build, test, and deploy logic while each application repository provides only its own parameters.

The modular scaffold at `GitLab CI/templates/modular-pipeline-repo/` demonstrates file-level composition with `include:local`. This document extends that pattern to cross-project reuse with `include:project`, typed inputs via `spec:inputs`, and composable rule sets.

## When to use

Use this pattern when:

- A platform or DevOps team owns the CI/CD logic and application teams own the code
- Multiple repositories need identical or near-identical pipeline behaviour
- Pipeline changes must roll out to all consumers without editing each repository
- Application teams should not need to understand pipeline internals

Do not use this pattern when:

- Each repository has genuinely unique pipeline requirements
- The consumer count is small (under 3) and divergence is likely
- The organisation prefers copy-paste ownership over shared maintenance

## Prerequisites

- A GitLab instance (self-managed or SaaS) with CI/CD enabled
- A dedicated project to host the pipeline library (e.g., `platform/ci-library`)
- Maintainer or Owner access on the library project to protect the default branch
- Downstream projects with Developer access or higher on the library project
- GitLab 15.11+ for `spec:inputs` support (GA in 16.0)

## Key concepts

### `include:project`

Pulls a pipeline file from another project. The included file is fetched at pipeline creation time and merged into the downstream configuration.

```yaml
include:
  - project: 'platform/ci-library'
    file: '/pipelines/base.yml'
    ref: 'main'          # optional; pins to a branch, tag, or commit SHA
```

The `ref` parameter is critical for stability. Without it, a force-push to the library's default branch immediately affects all downstream pipelines. Pin to a tag (e.g., `v2.3.0`) for production consumers; use a branch for staging.

### `spec:inputs`

Defines typed, validated inputs that a pipeline or job accepts. Inputs are declared in the included file and provided by the consumer.

```yaml
# In platform/ci-library/pipelines/base.yml
spec:
  inputs:
    image_tag:
      type: string
      default: 'latest'
      description: 'Container image tag to deploy'
    environment:
      type: string
      enum: [staging, production]
      required: true
    replica_count:
      type: number
      default: 3
      minimum: 1
      maximum: 20
```

Consumed in jobs via `$[[ inputs.image_tag ]]` (double-bracket syntax distinguishes inputs from predefined variables).

### `extends`

Inherits a complete job definition from a hidden job (name starting with `.`). Multiple parents are merged in order; later parents override earlier ones.

```yaml
.deploy_template:
  image: registry.example.com/deploy-tool:1.0
  script:
    - deploy.sh
  rules:
    - if: $CI_COMMIT_TAG

deploy:production:
  extends: .deploy_template
  variables:
    ENVIRONMENT: production
```

Only one parent may define `rules`; a second `rules` replaces the first entirely. Keep rule sets in separate hidden jobs and extend them explicitly.

### `!reference` tags

Copies a single key from another job. Unlike `extends`, which merges entire job definitions, `!reference` pulls one field (e.g., `script`, `before_script`, `variables`, `rules`).

```yaml
.job_base:
  before_script:
    - apk add --no-cache curl jq

deploy:staging:
  extends: .deploy_template
  before_script:
    - !reference [.job_base, before_script]
    - echo "Staging-specific setup"
```

A plain YAML parser rejects `!reference`; the GitLab CI/CD parser resolves it during configuration assembly. The pipeline editor's Validate button shows the merged result.

### `rules` composition

Rule sets can be extracted into hidden jobs and reused via `extends` or `!reference`. This avoids duplicating `if:`/`when:` logic across jobs.

```yaml
.rules_default_branch:
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

.rules_merge_request:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

build:
  extends: [.build_template, .rules_default_branch, .rules_merge_request]
```

The order matters: the last `rules` in the merge wins. A job extending multiple rule-set parents must not define its own `rules` unless it intends to replace them entirely.

## Steps

### 1. Create the library project

Create a dedicated project (e.g., `platform/ci-library`) with a protected default branch. Require merge request approvals for changes to pipeline files.

### 2. Structure the library

Organise pipelines by concern:

```
ci-library/
├── pipelines/
│   ├── base.yml              # Entry point; declares spec:inputs, includes stages
│   ├── build.yml             # Build stage jobs
│   ├── test.yml              # Test stage jobs
│   ├── deploy.yml            # Deploy stage jobs
│   └── lib/
│       ├── templates.yml     # Hidden job templates (extends targets)
│       ├── rules.yml         # Reusable rule sets
│       └── references.yml    # !reference targets (script blocks, variable sets)
├── scripts/
│   └── helpers.sh            # Shared shell functions
└── README.md                 # Usage documentation for consumers
```

### 3. Define the entry point with `spec:inputs`

In `pipelines/base.yml`, declare all configurable parameters:

```yaml
spec:
  inputs:
    project_name:
      type: string
      required: true
    docker_image:
      type: string
      default: '$CI_REGISTRY_IMAGE/$CI_PROJECT_NAME'
    kubernetes_namespace:
      type: string
      default: 'default'
    deploy_on_tag_only:
      type: boolean
      default: true

include:
  - local: 'pipelines/build.yml'
  - local: 'pipelines/test.yml'
  - local: 'pipelines/deploy.yml'
```

### 4. Build reusable templates with `extends`

In `pipelines/lib/templates.yml`, define hidden jobs that capture common patterns:

```yaml
.docker_build:
  image: docker:24-cli
  services:
    - docker:24-dind
  variables:
    DOCKER_TLS_CERTDIR: "/certs"
  script:
    - docker build -t "$[[ inputs.docker_image ]]:$CI_COMMIT_SHA" .
    - docker push "$[[ inputs.docker_image ]]:$CI_COMMIT_SHA"

.helm_deploy:
  image: alpine/helm:3.14
  script:
    - helm upgrade --install "$[[ inputs.project_name ]]" ./chart
      --namespace "$[[ inputs.kubernetes_namespace ]]"
      --set image.tag="$CI_COMMIT_SHA"
```

Jobs in `build.yml` and `deploy.yml` extend these templates and override only what differs.

### 5. Extract rule sets for reuse

In `pipelines/lib/rules.yml`:

```yaml
.rules_main_branch:
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

.rules_tags_only:
  rules:
    - if: $CI_COMMIT_TAG

.rules_manual:
  rules:
    - when: manual
      allow_failure: false
```

Jobs combine rule sets via `extends`:

```yaml
deploy:production:
  extends: [.helm_deploy, .rules_tags_only, .rules_manual]
```

### 6. Share script fragments with `!reference`

In `pipelines/lib/references.yml`:

```yaml
.setup_kubectl:
  before_script:
    - apk add --no-cache kubectl
    - echo "$KUBE_CONFIG" | base64 -d > /tmp/kubeconfig
    - export KUBECONFIG=/tmp/kubeconfig
```

Deploy jobs pull the kubectl setup without inheriting the entire job:

```yaml
deploy:staging:
  extends: .helm_deploy
  before_script:
    - !reference [.setup_kubectl, before_script]
```

### 7. Consume the library in downstream projects

In each application repository's `.gitlab-ci.yml`:

```yaml
include:
  - project: 'platform/ci-library'
    file: '/pipelines/base.yml'
    ref: 'v2.3.0'

spec:
  inputs:
    project_name: 'my-service'
    environment: 'production'
    replica_count: 5
```

The downstream file only provides inputs. All pipeline logic lives in the library.

### 8. Version the library

Tag releases in the library project using semantic versioning:

```bash
git tag -a v2.3.0 -m "Add ARM64 build support; fix helm timeout"
git push origin v2.3.0
```

Downstream projects update the `ref:` pin when ready. A Renovate or Dependabot configuration can automate this.

## Verify

1. **Pipeline editor validation.** In a downstream project, open CI/CD > Editor and click Validate. The merged configuration must show all jobs with resolved inputs and no syntax errors.
2. **Input substitution.** Run a pipeline and inspect the job variables. Each `$[[ inputs.* ]]` reference must resolve to the value provided in the downstream `spec:inputs` block.
3. **Rule evaluation.** Confirm jobs appear only under the expected conditions (main branch, tags, merge requests). A missing job usually means a rule did not match, not a load failure.
4. **Cross-project fetch.** Simulate a library outage by temporarily revoking downstream access. Pipeline creation should fail with a clear "project not found or access denied" message rather than a cryptic YAML error.
5. **Version pinning.** Change the `ref:` to an old tag and confirm the pipeline uses the old logic. This proves consumers control when they adopt changes.

## Common errors

| Symptom | Cause | Resolution |
|---|---|---|
| "Job `build` has no `rules`" | Multiple parents define `rules`; last one wins and may be empty | Keep rule sets in separate hidden jobs; extend exactly one rule-set parent per job |
| `!reference` unresolved | Source job or key name misspelled | Check spelling in the library file; validate in the pipeline editor |
| Input not substituted | Used `$INPUT_NAME` instead of `$[[ inputs.name ]]` | Use double-bracket syntax for `spec:inputs` |
| Pipeline creates but jobs missing | `include:project` file path incorrect | Verify the file path in the library project; path is relative to repository root |
| Downstream pipeline uses stale logic | `ref:` omitted or points to moving branch | Pin `ref:` to a tag; update via automated MR when ready |
| "Variable `KUBE_CONFIG` is not defined" | Secret not passed to downstream | Ensure the library job declares the variable as required or provides a clear error message |

## What this pattern does not cover

- **Secret distribution.** The library can declare required variables but cannot inject secrets. Each downstream project must configure its own CI/CD variables or integrate with a vault.
- **Runner selection.** The library defines job `tags`; downstream projects must register runners with matching tags.
- **Multi-cluster deployments.** The `kubernetes_namespace` input handles single-cluster multi-environment; multi-cluster requires additional inputs and context switching logic.
- **Policy enforcement.** GitLab's pipeline validation (e.g., `spec:inputs` schema) runs at pipeline creation. It does not prevent a malicious maintainer from pushing a breaking change to a pinned tag — tag protection and signed commits are separate controls.
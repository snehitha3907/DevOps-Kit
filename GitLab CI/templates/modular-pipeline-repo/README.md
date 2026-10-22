---
last_verified: 2026-10-22
tool_version: n/a
sources: []
---

# Modular GitLab CI/CD pipeline repository

A starting point for a pipeline that is split across several files instead of
living in one long `.gitlab-ci.yml`. The root file pulls the stage files in,
the stage files hold the jobs, and one shared file holds the templates the
jobs extend. It is a scaffold rather than a finished pipeline: the jobs adapt
to what the repository actually contains, and the parts that cannot be
guessed — the cluster credentials, the runner tags, the image tags — are left
for the team that owns the project.

## Purpose

The point of splitting the pipeline is that a change to one stage stops
touching the others. A team that only maintains the deploy jobs can read one
file. The cost is that GitLab has to be told where the pieces are, and that
the pieces are merged before the pipeline runs, which is where most of the
surprises in a modular pipeline come from.

This scaffold is arranged around three GitLab features:

- `include:` with `local:` pulls the stage files into the pipeline.
- `extends:` lets a job take its whole shape from a hidden job.
- `!reference` copies a single key out of another job, which is how a job
  reuses one part of a template and replaces the rest.

## What is inside

```
.
├── .gitlab-ci.yml              # root: include, stages, workflow, variables
├── .gitlab/
│   └── ci/
│       ├── lib.yml             # hidden job templates, rule sets, anchors
│       ├── build.yml           # build stage jobs
│       ├── test.yml            # test stage jobs
│       ├── deploy.yml          # deploy stage jobs
│       └── helpers.sh          # shell helpers sourced by the jobs
├── scripts/
│   └── kind-runner-bootstrap.sh # local cluster and runner for trying it out
└── README.md
```

Copy the directory into a project — the root file is already named
`.gitlab-ci.yml` — and the pipeline has a shape. Nothing here is
pinned to a version: the images the jobs run are named by variables in the
root file, and the values are unversioned floating tags chosen as a starting
point. A tag that quietly stops resolving fails at image pull, long before
any pipeline logic runs, and the symptom reads like a broken pipeline rather
than a stale tag.

## How the pieces fit together

### The root file

`.gitlab-ci.yml` lists the four stage files, the four stages, the workflow
rules and the shared variables. The workflow rules end with `- when: never`,
which is what stops a feature-branch push from creating a pipeline at all
rather than creating an empty one.

### The shared file

`.gitlab/ci/lib.yml` holds the templates. It is worth knowing one thing
about it before reading further: GitLab parses every included file on its
own, so a YAML anchor written in `lib.yml` is **not** visible from
`build.yml`, `test.yml` or `deploy.yml`. An alias that crosses a file
boundary fails to resolve, and the failure looks like a syntax error rather
than a scoping problem.

There are two ways around it, and this scaffold uses both:

- **Anchors inside one file.** The cache, retry, timeout and resource
  blocks are anchors in `lib.yml` and are merged into the templates in the
  same file. A mapping may carry only one merge key, so a template that
  needs two blocks uses the list form, `<<: [*first, *second]`, and the
  earlier mapping wins — so a template that changes a value that the base
  template also sets puts its own block first. A merge key also replaces a
  whole key rather than merging it key by key, which is why the shared
  variables live in the root file instead.
- **Templates and references across files.** A job in `build.yml` reaches a
  template in `lib.yml` with `extends:`, and reaches a single key of another
  job with `!reference [template, key]`.

### What `extends` and `!reference` are each for

`extends` takes the whole job. A job that extends a template inherits the
image, the services, the script and the artifacts, and overrides only what
it names:

```yaml
build:docker:
  extends: [.docker_build_template, .rules_default_branch_and_mr]
  tags:
    - docker
```

The second parent in that list is a rule set. Only one parent may set
`rules`, otherwise the second one replaces the first, which is why the rule
sets are kept apart from the job templates.

`!reference` takes one key. It is what a job uses when it wants to keep one
part of a template and replace the rest, because `extends` replaces a whole
key rather than appending to it. The deploy template uses it twice, to pull
in the base setup and the kubeconfig block:

```yaml
.deploy_k8s_template:
  before_script:
    - !reference [.job_base, before_script]
    - apk add --no-cache kubectl
    - !reference [.kubeconfig_setup, script]
```

The first line keeps the setup every job starts with; the last one keeps the
kubeconfig block that the deploy jobs share. Writing either of them out
again instead would be the same code in two places, and the two copies
drift.

A plain YAML parser rejects the `!reference` tag, because the tag is
GitLab's own and not part of YAML. A parser that knows the tag reads the
file; one that does not stops on the first tag it has not seen.

## The jobs

| Job | Stage | What it does |
|---|---|---|
| `build:docker` | build | Builds the image from the `Dockerfile` and pushes it under the commit SHA |
| `build:docker:multiarch` | build | The same build for several platforms, on tags |
| `build:artifact` | build | Runs the project's own build and keeps the output |
| `test:unit` | test | Runs the test command that matches the project layout |
| `test:integration` | test | Runs the integration tests with a database and a cache attached |
| `test:lint` | validate | Runs the linter that matches the project layout and keeps the report |
| `test:helm-lint` | validate | Lints and renders the charts |
| `test:scan` | test | Scans the working tree and the built image, and keeps the report |
| `deploy:review` | deploy | A per-merge-request environment, by hand |
| `stop:review` | deploy | Removes that environment again |
| `deploy:staging` | deploy | The default branch, on its own |
| `deploy:production` | deploy | A tag, by hand |
| `deploy:rollback` | deploy | Puts the previous release back |

The templates the jobs extend are in `.gitlab/ci/lib.yml`:

| Template | Stage | What it carries |
|---|---|---|
| `.job_base` | — | The package install and the helper file every job starts with |
| `.docker_build_template` | build | Build, tag and push, and the dotenv report with the image tag |
| `.docker_buildx_template` | build | The same, for several platforms |
| `.build_artifact_template` | build | The project's own build command |
| `.unit_test_template` | test | The unit test command |
| `.integration_test_template` | test | The integration test command and the service containers |
| `.lint_template` | validate | The linter that matches the project layout |
| `.trivy_scan_template` | test | The scanner and its report |
| `.helm_lint_template` | validate | Lints and renders the charts |
| `.deploy_k8s_template` | deploy | The Helm or Kustomize rollout, with the environment |
| `.kubectl_job_template` | — | The kubectl setup and the kubeconfig |
| `.kubeconfig_setup` | — | The kubeconfig block, reused with `!reference` |

### The image tag travels as a dotenv variable

The build job writes `build.env` and declares it as a dotenv report, so the
test and deploy stages work on the image that was pushed instead of building
a second one:

```yaml
  artifacts:
    reports:
      dotenv: build.env
```

The job that consumes it asks for the artifact explicitly, and marks the
dependency optional, because a pipeline that does not run the build job would
otherwise refuse to be created:

```yaml
  needs:
    - job: "build:docker"
      artifacts: true
      optional: true
```

A dotenv variable cannot override a predefined `CI_` variable, so the file
carries the image tag and the version and nothing else.

### What the jobs publish

Only one kind of report is declared here, and it is a file the job actually
writes: the dotenv report above. The lint and scan jobs publish their
output as plain artifacts. The linters and scanners write JSON that is not
the format GitLab expects for a merge request widget, so publishing it under
`reports:codequality` would make a job that found nothing look like a job
that reported a clean bill of health. The reports are kept as artifacts
instead, where they can be read.

The scan job reports findings without failing the pipeline. Turning findings
into a gate is a decision for the team that owns the pipeline, and a gate
that fails on any finding tends to get switched off.

## Adopting it

1. Copy the directory into the project. The root file is already named
   `.gitlab-ci.yml`.
2. Point the image variables in the root file at tags you have checked, and
   confirm each one resolves:

   ```bash
   docker manifest inspect "$KUBECTL_IMAGE"
   ```

   A non-zero exit means the tag does not exist.
3. Register a runner with the tags the jobs ask for: `docker`, `build`,
   `test` and `deploy`.
4. Store the kubeconfig as a masked CI/CD variable named `KUBE_CONFIG`, with
   the kubeconfig base64 encoded. The deploy jobs fail with a clear message
   when it is missing rather than writing an empty file. It is deliberately
   not in the variables block of the root file: it holds a cluster
   credential, and anything written to a file in the repository is committed.
5. Adjust the job rules. The rule sets in `lib.yml` are a reasonable
   default and are meant to be edited.
6. Point the remote of the project at your GitLab instance and push.

### Trying it locally

`scripts/kind-runner-bootstrap.sh` creates a Kind cluster and installs a
GitLab Runner with the Kubernetes executor, which is a quicker loop than
the hosted runner while a pipeline is still changing:

```bash
./scripts/kind-runner-bootstrap.sh \
  --version <node-image-tag> \
  --runner-token "$RUNNER_TOKEN" \
  --gitlab-url <your-gitlab-instance> \
  --chart-repo <repository-holding-the-runner-chart>
```

The node image tag has to match the Kind release that is installed, and the
chart repository has to be the one that holds the GitLab Runner chart. The
ingress controller and the certificate manager are optional: the script skips
them when their manifests are not given.

### The helper file

`.gitlab/ci/helpers.sh` is sourced by every job and holds the small
functions that would otherwise be repeated: logging, a retry with
backoff, writing the kubeconfig, and writing the dotenv file. It is POSIX
sh, because the runner picks the shell from the image and the images used
here do not ship bash.

## Verify

1. **The merged configuration is the one that matters.** Open the pipeline
   editor for the project and use Validate. It checks the configuration as
   GitLab assembles it, after the `include:` files are merged, which is the
   only way to see the result of the split.
2. **The images resolve.** For each image variable:

   ```bash
   docker manifest inspect "$KUBECTL_IMAGE"
   ```

   A non-zero exit means the tag does not exist.
3. **The job list matches the table above.** Push a branch, open a merge
   request, and read the pipeline page. A job that is missing is usually a
   job whose rules did not match, not a job that failed to load.
4. **The helper file loaded.** The log of any job starts with the
   `[INFO]` lines from `helpers.sh`. A shell error about `set` or about an
   unknown command means the file was not parsed by the shell the runner
   picked.
5. **The image tag arrived.** Open the artifacts of the build job and read
   `build.env`. The deploy job prints the tag it is about to roll out, and
   the same value is in the variables of the deploy job.

## What this scaffold does not cover

- **Deployment strategies.** Rolling, canary, blue-green and GitOps rollouts
  are all variations on the deploy template, and each one is a decision about
  the cluster rather than about the pipeline. The review and production
  environments here are the two that most projects need first.
- **Static analysis.** The scan job looks for vulnerabilities in the working
  tree and in the image. A linter that understands the language and a static
  analyser are left to the project, because the right one depends on the
  language and on what the project already runs.
- **Runner sizing.** The `resources` blocks in the templates are a starting
  point, and a runner that is too small for the build fails in a way that
  looks like a build error.

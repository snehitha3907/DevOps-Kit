# Glossary

## Git
- **Commit** — A snapshot of the repository at a point in time.

## Docker

- **Health check** — A Docker Compose directive that tests container readiness (e.g., via HTTP endpoint) before dependent services are started.
- **HEALTHCHECK** — A Dockerfile instruction that defines how Docker probes whether a running container is still healthy (`starting`, `healthy`, or `unhealthy`); `HEALTHCHECK NONE` disables an inherited check from the base image.
- **`--start-period`** — A HEALTHCHECK grace period after container start during which failures do not count against retries, giving slow-starting apps time to become ready before the container is marked unhealthy.
- **HTTP probe** — A HEALTHCHECK style using `curl -f` (or similar) against an HTTP endpoint; only 2xx/3xx responses count as healthy.
- **TCP probe** — A HEALTHCHECK style using `nc -z host port` (or a bash `/dev/tcp` test) to confirm a port accepts connections; it validates socket readiness, not application-level logic.
- **Image** — A read-only snapshot of a filesystem used as a template for creating containers.
- **Container** — A running instance of an image; encapsulates an app and its dependencies in an isolated environment.
- **Dockerfile** — A text file containing instructions to build a Docker image.
- **Layer** — A cached build step in a Docker image that enables incremental builds.
- **Registry** — A storage and distribution system for Docker images (e.g., Docker Hub).
- **Volume** — Persistent storage that survives container restarts.
- **Port mapping** — A Docker networking feature mapping a host port to a container port.
- **Compose** — A tool for defining and running multi-container applications using a YAML file.
- **Build context** — The directory path passed to `docker build` that the Docker daemon uses as the source for copying files during image creation.
- **BuildKit** — Docker's modern build backend that enables faster, more efficient image builds with features like cache mounts and parallel execution.
- **--mount** — A BuildKit-specific `RUN` instruction modifier that mounts cache, secret, or SSH resources into a Docker build step.
- **docker buildx** — Docker's CLI plugin for extended build capabilities, including BuildKit, multi-platform images, and advanced caching strategies.
- **Swarm** — Docker's native multi-node orchestrator; services deploy with `docker stack deploy` from a Compose-format file, where the `deploy:` block (replicas, update config, placement) only takes effect on a Swarm.
- **Stack (Compose vs Swarm)** — The same Compose file runs as a single-host stack under `docker compose up` and as a multi-node stack under `docker stack deploy`; replica control and rolling updates only exist in the Swarm form.
- **Swarm secret** — A sensitive value (password, cert, key) created with `docker secret create` and mounted into a service's containers at runtime, so the stack file itself never carries plaintext credentials.
- **`update_config`** — The Swarm service block (`parallelism`, `delay`, `failure_action`, `order`) controlling how `docker stack deploy` rolls a new image across replicas without taking the whole service down at once.
- **Immutable tag** — An image tag that points at exactly one build (a commit SHA or CI build number) and is never re-pushed. Deploy the immutable tag instead of a moving one, so a rollout is unambiguous about which build is live and a rollback is just a pointer move back to a known-good image.
- **Moving tag** — A re-pushed tag like `stable` or `latest` whose contents change over time. Convenient for humans, ambiguous for deploys: nodes with a cached copy keep running the old build, so redeploying it says nothing about what is actually live.
- **Classic builder** — Docker's original single-threaded build engine. Still selectable with `DOCKER_BUILDKIT=0`, useful for isolating a failure to the old path, but it lacks cache mounts, build secrets, and parallel step execution.
- **Multi-platform build** — One build producing images for several CPU architectures (`linux/amd64,linux/arm64`) under the same tag via a manifest list. Needs `binfmt_misc`/QEMU emulation registered on the host when the target architecture is not the build machine's.
- **Registry cache** — A BuildKit or Buildx cache exported into a container registry and pulled by the next build (`--cache-from type=registry`), so ephemeral CI runners don't rebuild every layer from scratch.
- **`depends_on` with `condition: service_healthy`** — A Compose startup gate that holds a dependent service until the named services report `healthy`, not merely started. Without the condition, an app container begins serving before its database is accepting connections.
- **`env_file`** — A Compose key that loads a file of `KEY=value` lines into a container's environment at start. Keep a committed `.env.example` beside it so the required keys are discoverable without committing real values.

## GCP

- **Google Cloud SDK** — Google's set of command-line tools for managing GCP resources, bundling `gcloud`, `gsutil`, and `bq`.
- **gcloud** — The primary CLI for creating, inspecting, and managing Google Cloud resources such as VMs, networks, and IAM policies.
- **gsutil** — A command-line tool for interacting with Cloud Storage buckets and objects.
- **Project** — The top-level container in GCP that groups resources, billing, permissions, and APIs for a given workload.
- **Compute Engine** — GCP's infrastructure-as-a-service offering for running virtual machine instances.
- **Cloud Storage (GCS)** — GCP's object storage service, organised into buckets that hold files and blobs.
- **`bq`** — CLI tool for BigQuery.
- **Zone / Region** — Where resources live. Zones are sub-divisions of regions.
- **`gcloud config`** — Persistent settings for the CLI (project, region, zone, account).
- **Service account** — A non-human identity for automation. Used instead of a user account in pipelines.
- **Application Default Credentials (ADC)** — A strategy that `gcloud` and GCP client libraries use to find credentials automatically.
- **startup-script** — A Compute Engine metadata key whose value is a shell script that runs automatically on the first boot of an instance (e.g. `apt-get update && apt-get install -y nginx`); a quick way to install software or bootstrap a machine without a config-management tool.
- **`--format`** — Controls output: `json`, `yaml`, `table`, `text`, `csv`, `list`.
- **`--filter`** — Server-side filtering of results.
- **IAM policy binding** — Grants a member (user, group, or service account) a role on a specific resource, e.g. `gcloud storage buckets add-iam-policy-binding` to let a service account read one bucket. Scoped bindings are preferable to project-wide roles.
- **Named configuration** — A saved `gcloud` profile (`gcloud config configurations list|activate`) holding its own account, project, region, and zone, so learning setups stay separate from the default instead of editing it in place.
- **Instance template** — A Compute Engine recipe (machine type, image, tags, metadata, service account) that managed instance groups copy when creating VMs; the startup script lives under `metadata.items` with the key `startup-script`.
- **Cloud Run** — A serverless container platform: push an image, give it a service definition, and Google runs and scales revisions behind an HTTPS endpoint. The unit you deploy is a container image plus a port, not a server.
- **Artifact Registry** — Google's container image registry, the usual home for images destined for Cloud Run. Image names are fully qualified (`REGION-docker.pkg.dev/PROJECT/REPO/IMAGE:TAG`) rather than Docker Hub's `user/image` shorthand.
- **`google_cloud_run_v2_service`** — The Terraform resource that declares a Cloud Run service, its container image, resource limits, and the ingress setting. The generated service URL is exported as the module output and is also the value you attach to DNS or pass to a load balancer.

## Helm

- **Chart** — A packaged collection of Kubernetes templates and metadata, analogous to an `apt` or `brew` package.
- **Release** — A running instance of a chart. Multiple releases of the same chart can coexist (e.g., `myapp-staging` and `myapp-prod`).
- **values.yaml** — The default configuration file for a chart, containing key-value pairs that templates consume.
- **Repository** — A hosted collection of charts, such as the Bitnami repository or an OCI registry.
- **Template** — A Kubernetes manifest written with Go templating placeholders that Helm renders at install or upgrade time.
- **Release revision** — An incrementing number tracking each change to a Helm release; viewable with `helm history`.
- **`helm uninstall`** — The command that removes a release and its resources from the cluster.
- **`helm repo update`** — The command that refreshes the local chart index from remote repositories so `helm search` and `helm upgrade` see newer chart versions.
- **replicaCount** — The chart value that sets how many pod replicas the Deployment should run; `replicaCount: 2` provides redundancy during rolling updates, while `5` gives headroom for node maintenance.
- **image.repository / tag / pullPolicy** — Chart values that pin the container image and its pull behaviour; pinning `tag` instead of `latest` makes `helm rollback` deterministic.
- **serviceAccount** — Chart values that control creation and mounting of the Kubernetes ServiceAccount used by the release's pods.
- **podSecurityContext / containerSecurityContext** — Chart values that harden the pod and container: `runAsNonRoot`, `readOnlyRootFilesystem`, `allowPrivilegeEscalation: false`, `capabilities.drop: [ALL]`, and `seccompProfile.type`.
- **resources.requests / limits** — Chart values that declare CPU/memory guarantees and ceilings; without `requests` the scheduler and HPA have nothing to schedule against.
- **`--set` flag** — An inline `helm install/upgrade --set key=value` override for one-off tweaks or CI-injected values (e.g. an image tag); visible later in `helm history` but hard to review when chained, so it suits single computed values rather than whole environments.
- **Per-environment values file** — A `-f values-<env>.yaml` file holding only the keys that differ from chart defaults; selecting the file per environment keeps each environment's differences reviewable instead of retyping flags on every upgrade.
- **Named template** — A reusable snippet in a chart's `templates/_helpers.tpl`, included with `include`/`template`; used to share labels, names, and repeated blocks across manifests instead of duplicating them per file.
- **Subchart** — A chart nested inside another chart's `charts/` directory and deployed as part of the parent release; a vendored subchart (e.g. a PostgreSQL one checked into the parent) keeps local installs working without an external chart repository, and `database.enabled=false`-style switches turn it off when a managed service takes over.
- **values.schema.json** — A JSON Schema file Helm validates every supplied values file against on `lint`, `template`, `install`, and `upgrade`; a mistyped key fails there instead of rendering into a manifest the cluster refuses.
- **Hook** — A Helm manifest annotated with `helm.sh/hook` (e.g. `pre-install`, `pre-upgrade`) that runs once around the release lifecycle rather than living with it; the usual shape is a migration Job that must succeed before the new Deployment rolls out.
- **chart-testing (`ct`)** — A tool that detects which charts changed on a branch (`ct list-changed`) and runs lint plus install over just those charts (`ct lint`, `ct install`), so a repo with many charts does not re-verify everything on every change.
- **Shared base values with per-cluster overlays** — A layering pattern for one release deployed to several clusters: a single base file holds every setting identical everywhere, and each cluster adds a small overlay file supplying `clusterName` and its own deltas. Later `-f` files win, so the base is always passed first.

## Git

- **Repository (repo)** — A directory Git watches, containing all tracked files and their full change history.
- **Commit** — A snapshot of files at a point in time, identified by a unique hash.
- **Stage (index)** — An intermediate area where changes are prepared before committing.
- **Branch** — A separate line of development; the default branch is named `main`.
- **git bisect** — A git builtin that binary-searches commit history to find the exact commit that introduced a regression; answered manually with good/bad markers or automated with `git bisect run <test-script>`, which marks each checked-out revision good (exit 0) or bad (non-zero exit).
- **Clone** — Copying a remote repository to the local machine.
- **Push** — Sending local commits to a remote repository.
- **Pull** — Fetching and integrating changes from a remote repository.
- **Merge** — Combining changes from one branch into another.
- **Merge commit** — A commit created by a merge that ties together the histories of two branches, preserving full branch context.
- **Diff** — A view showing what changed between two commits or between working files and the last commit.
- **Remote** — A URL pointing to another copy of the repository, typically hosted remotely.
- **HEAD** — A pointer to the commit currently checked out.
- **Rebase** — Rewriting commit history by applying commits from one branch onto another.
- **Cherry-pick** — Applying the changes introduced by a specific commit to the current branch without merging the full branch history.
- **Git worktree** — A mechanism that allows multiple working directories to be associated with a single repository, enabling parallel work on different branches without stashing or switching.
- **Detached HEAD** — The state where `HEAD` points directly at a commit instead of a branch, which happens after `git checkout <commit-hash>`; commits made in this state belong to no branch and can be lost until a branch is pointed at them.
- **Hook** — A script Git executes before or after a specific event (e.g., pre-commit, commit-msg, post-checkout, post-commit, pre-push, pre-rebase).
- **Pre-commit hook** — A Git hook that runs before a commit is finalised, used to check for issues like trailing whitespace, conflict markers, or debug statements.
- **Commit-msg hook** — A Git hook that validates the format of a commit message, often enforcing conventional commit standards.
- **Post-checkout hook** — A Git hook that runs after a branch switch, used to maintain hooks, suggest cleanup, or display context.
- **Post-commit hook** — A Git hook that runs after a commit is created, often used to log commit metadata, notify a team channel, or suggest follow-up actions like pushing.
- **Pre-push hook** — A Git hook that runs before a push is sent to the remote, used to run final checks such as tests, lint, or secret scanning.
- **Pre-rebase hook** — A Git hook that runs before a rebase begins, commonly used to block history rewrites on protected branches.
- **Conventional commit** — A commit message format that follows a structured prefix (`feat:`, `fix:`, `chore:`, etc.) enabling automated changelog generation and semantic versioning.
- **Reflog** — Git's private log of where HEAD has pointed at every step (`git reflog`); the safety net for "lost" commits after a bad rebase or reset, since any entry can be recovered by checking out its hash and branching from it.
- **Pull Request** — A review request to merge one branch into another, with a diff and discussion.
- **.gitignore** — A file that tells Git which files or directories to skip. Example: ignoring `.terraform/` and `*.tfvars` so secrets and generated files aren't committed.
- **pre-commit framework** — A language-agnostic Git hook manager that lets you define a `.pre-commit-config.yaml` listing hooks (formatters, linters, custom checks) which run automatically before each `git commit`. Hooks are isolated environments installed per-project, so contributors don't need to install tools globally.
- **gitattributes** — Git's path-pattern configuration file that controls line-ending normalization, custom diff drivers, and merge strategies per file type (`.ipynb`, lockfiles, binaries).
- **Clean/smudge filter** — A gitattributes filter that transforms file contents on checkin (clean) and checkout (smudge), e.g. normalizing line endings or converting file formats so the repo stores a canonical form.
- **Merge driver** — A gitattributes configuration that tells Git how to resolve conflicts in specific file types (e.g. lockfiles, generated files) instead of falling back to the default 3-way merge.

## GitHub

- **Deploy key** — An SSH public key registered on a single GitHub repository, granting read-only or read-write access for unattended operations like CI cloning.
- **Fine-grained PAT** — A personal access token scoped to specific repositories and granular permissions, used for HTTPS-based authentication and API access in CI/CD pipelines.
- **Machine user** — A GitHub account used exclusively for automation tasks, not tied to an individual team member, ensuring CI tokens remain valid regardless of personnel changes.
- **Repository** — A project container with code, issues, pull requests, and wiki.
- **Pull Request (PR)** — A proposed change that can be reviewed and merged.
- **Issue** — A discussion thread for bugs, features, or tasks.
- **Fork** — A personal copy of a repository for contributing changes.
- **Wiki** — A built-in documentation space for a repository.
- **Projects** — A kanban-style project management board for tracking work.
- **Insights** — Analytics and metrics for a repository, including traffic, contributors, and dependency graph.
- **GitHub flow** — A lightweight branching workflow where feature branches are created from `main`, changes are committed, a pull request is opened, and the branch is merged and deleted after review.
- **Issue form** — A structured YAML template for GitHub issues that provides input fields, dropdowns, checkboxes, and validations, defined under `.github/ISSUE_TEMPLATE/` or `.github/issue-forms/`.
- **Blank issues** — A repository setting that controls whether users can open issues without selecting a template; disabling it enforces template use.
- **Contact link** — A link shown in the new-issue interface that directs users to external resources such as community discussions or security policies.
- **Stale workflow** — A scheduled automation (often `.github/stale.yml` or an Actions workflow) that labels and closes issues and PRs after a period of inactivity.
- **release-please** — A GitHub tool that automates versioning, changelog generation, and release creation from conventional commits; commonly wired in via a `.github/workflows/release-please.yml` file.
- **workflow run** — An instantiation of a workflow that has been triggered; each run has an ID, a status (`queued`, `in_progress`, `completed`), and a conclusion (`success`, `failure`), queryable via the Actions API's `GET /repos/{owner}/{repo}/actions/workflows/{workflow}/runs`.
- **CODEOWNERS** — A file that assigns review responsibility by path, so PRs touching a directory automatically request the owning team.
- **Dependabot** — GitHub's automated dependency updater; configured in `dependabot.yml`, it opens grouped PRs (e.g. Actions, base images, providers) on a schedule.
- **Branch protection** — Rules on a branch (commonly `main`) requiring passing status checks, a number of approving reviews, and conversation resolution before merge; optionally enforced for admins, with force pushes and deletions blocked.
- **Tag** — A named pointer to a specific commit, usually a version like `v1.2.0`; pushing a tag is the starting signal for a release flow.
- **Milestone** — A GitHub grouping of issues and PRs targeted at the same release, giving the changelog something concrete to summarise when the tag is cut.
- **Release** — A versioned, downloadable package attached to a tag: notes plus binary assets, published with `gh release create` so one command ships notes and files together.
- **GitHub App** — A registered integration that is an actor in its own right; it is installed on repositories or organizations, acts under its own identity with per-category permissions, runs without a user present, and can subscribe to webhook events.
- **OAuth App** — A registered integration that proxies for a user; it asks a user to authorize it, receives a token representing that user, and can do what the user can do — no more. Fits user-facing tooling where work should happen under the user's own identity.
- **Auto-merge** — Letting GitHub merge a pull request as soon as its required checks pass, instead of merging by hand. For Dependabot fleets the safe shape is a script that lists open Dependabot PRs, reads each head commit's check-runs, and squash-merges only the green ones, leaving failed or pending PRs open.
- **SECURITY.md** — A repository-level vulnerability disclosure policy file, placed at the repo root and surfaced by GitHub's Security tab. It states which versions receive security updates and gives reporters a private channel (the GitHub vulnerability report form or a direct email) instead of opening a public issue.
- **Dependabot security config** — The `security` block inside `dependabot.yml` that asks Dependabot to open security-update pull requests for vulnerable dependencies and assigns a reviewer (often a security team) to each. Distinct from the ordinary `updates` schedule, which only handles version bumps.
- **COMPLIANCE.md** — A checklist-style document that records which security and compliance controls a repository enforces and where each lives, so auditors and contributors can verify coverage without hunting through `.github/`. It is a human-readable manifest of the declarative controls, not a substitute for a full compliance audit.

## GitHub Actions

- **Workflow** — An automated process defined in YAML that runs one or more jobs when triggered.
- **Job** — A set of steps executed on the same runner.
- **Step** — An individual task within a job, such as running a script or using an action.
- **Action** — A reusable unit of automation that can be shared across workflows.
- **Composite action** — An action built by combining multiple workflow steps into one callable unit (`runs.using: composite`); the caller keeps control of the surrounding job (triggers, environment, matrix) while the shared steps stay in one place.
- **Reusable workflow** — A whole workflow file designed to be called from other workflows via `uses: owner/repo/.github/workflows/file.yml@ref` with `on: workflow_call`; the owning repository controls the jobs, environment gates, and approvals centrally.
- **Runner** — A server that listens for workflow jobs and executes them.
- **Caller workflow** — The top-level workflow in a caller-plus-reusable pair: it builds the artifact once, then calls the reusable workflow once per environment in promotion order, so staging only runs after dev succeeds.
- **Custom runner image** — A self-built runner image (own base, own package set, pinned runner release) where registration happens at container start from `RUNNER_URL`/`RUNNER_TOKEN`, so one image serves any repository without a rebuild.
- **workflow_dispatch** — An event that lets you trigger a workflow run manually, either from the GitHub web UI or via the REST API (`POST /repos/{owner}/{repo}/actions/workflows/{workflow}/dispatches`); useful for on-demand or scheduled-on-request runs from a script.
- **Repository Actions secret** — An encrypted credential scoped to a single repository and readable only by workflows running in it. The API never hands the value back: reads return the name, the public-key fingerprint, and the last-updated timestamp, which is why a rotation has to be verified by writing rather than by fetching.
- **Sealed box** — The libsodium sealed-box encryption the API expects for a secret value. Each repository publishes its own public key; the value is sealed against that key locally and only the sealed blob is uploaded, so the plaintext never crosses the wire.
- **Public key vs write permission** — Two separate permissions on the same token. A token that can write secrets but cannot read a repository's public key fails at the very first request against every repository, which reads as a credentials problem rather than a scope one.
- **Secret fleet** — The explicit list of repositories a bulk command targets, given inline (`repo1,repo2`), as a one-per-line file, or as a CSV with a `repository` column. Naming the fleet on the command line is what makes a mis-typed repository name visible in the plan before anything is sent.
- **`--dry-run`** — Prints every repository, every secret, and every intended write, then stops. On a bulk write the plan is the only place a wrong repository name or a wrong secret name can still be caught cheaply.
- **`GITHUB_API_VERSION`** — Pins the REST API version header on each request. Left unset, the header is omitted and the server's current default applies, which means a script written against one API shape can change behaviour when GitHub moves the default.
- **OIDC (workload identity federation)** — Exchanging a short-lived identity token the workflow mints for itself (`id-token: write` permission) for cloud credentials, instead of storing a long-lived access key as a secret. AWS verifies the token against a trust policy and STS hands back session credentials with a bounded lifetime.
- **Trust policy** — The IAM role condition that constrains which tokens may assume it: the identity provider, the repository, and the ref or environment in the token's subject claim. A tight subject (one repo, one environment) is what stops any other workflow from exchanging for the same role.

## GitLab CI/CD

- **Pipeline** — A collection of jobs split into stages (e.g., build → test → deploy) defined in `.gitlab-ci.yml`.
- **Job** — A single unit of work in a pipeline, with a script, image, and optional rules.
- **Stage** — A group of jobs that run in parallel within the same pipeline stage.
- **Runner** — A process that executes GitLab CI jobs; can be shared (GitLab-provided) or self-hosted.
- **`.gitlab-ci.yml`** — The YAML file at the root of a repository that defines the pipeline configuration.
- **Artifact** — Files produced by a job (e.g., binary, test report) passed to later stages or downloadable from the UI.
- **CI/CD variable** — A key-value pair used for secrets, API tokens, and configuration in GitLab CI/CD.
- **Cache** — Paths (e.g. a pip cache directory, `node_modules/`) persisted between runs under a key such as the branch slug, so dependency installs don't redo clean-room downloads every pipeline.
- **`needs`** — A DAG keyword letting a job start as soon as the listed jobs finish, pulling in their artifacts without waiting for the whole stage; the alternative to strictly sequential stages.
- **Pipeline trigger (API)** — Starting a pipeline for a branch with `POST /projects/:id/pipeline?ref=<branch>` and a `PRIVATE-TOKEN` header, then polling `/pipelines/:id/jobs` until no job reports `running`, `pending`, or `created`.
- **Workflow rules** — A `workflow: rules` block in GitLab CI that gates whether an entire pipeline runs based on the source branch, pipeline source, or CI/CD variables.
- **Multi-project pipeline** — A GitLab CI pattern that connects pipelines across multiple repositories using a bridge job, so a change in one project can trigger a build in another.
- **Downstream pipeline** — A pipeline triggered by another pipeline, used in multi-project and child-pipeline setups to fan out work across repositories or stages.
- **Bridge job** — The `trigger: project:` job that starts a pipeline in another repository; a pipeline triggered this way waits for the downstream result and reports its status as part of the parent.
- **Child pipeline** — A pipeline whose configuration is itself a pipeline job, included with `trigger: include:`. Unlike a downstream pipeline it runs in the same project as its parent, sharing that project's runners, variables, and permissions.
- **Dynamic child pipeline** — A child pipeline whose config file does not exist in Git: an earlier job generates it, publishes it as an artifact, and the trigger job points at the same path inside that artifact. The pattern for job sets only knowable at run time — one job per discovered service, per tenant, per matrix leg.
- **`when: manual`** — A job-level keyword that parks a job until someone plays it in the UI or triggers it through the API; the usual shape for a production deploy gate a merge request must not cross on its own.
- **Protected environment** — A GitLab environment that requires an approval before a job targeting it runs, and whose secrets are exposed only to that job; the platform-side counterpart to a `when: manual` gate.

## Infrastructure as Code Concepts

- **Declarative** — Describing the desired end state without listing the steps to get there. Example: "I want three nginx servers running" instead of "install nginx, start service, wait for port 80."
- **Imperative** — Listing explicit commands to execute in order. Example: a bash script that runs `apt install`, `systemctl start`, and `ufw allow` one after another.
- **State file** — A record of what infrastructure currently exists and its configuration. Example: `terraform.tfstate` tracks every AWS instance, security group, and S3 bucket Terraform has created.
- **Provider** — A plugin that understands how to create and manage resources in a specific platform. Example: the `aws` provider in Terraform knows how to create EC2 instances, S3 buckets, and RDS databases.
- **Resource** — A single piece of infrastructure defined in code. Example: an `aws_instance` resource or an `ansible.builtin.apt` task.
- **Module** — A reusable, self-contained bundle of IaC code that can be shared and composed. Example: a Terraform module for S3 buckets with versioning and encryption that I can drop into multiple projects.
- **Workspace** — An isolated instance of state for the same configuration. Example: Terraform workspaces `dev`, `staging`, and `prod` let me run identical code against separate state files.
- **Drift detection** — Comparing actual infrastructure against the declared state to find unmanaged changes. Example: noticing that someone manually resized an EC2 instance outside of Terraform.
- **Plan** — A preview of what changes IaC will make before applying them. Example: `terraform plan` shows "1 to add, 0 to change, 0 to destroy" so I can verify the impact.
- **Apply** — Executing the planned changes to make real infrastructure match the code. Example: `terraform apply` creates the resources the plan described.

## Kubernetes

- **Pod** — The smallest deployable unit in Kubernetes; one or more containers sharing storage and network.
- **Deployment** — A controller that manages a set of identical pods, handling scaling and rolling updates.
- **Service** — A stable network endpoint for accessing a set of pods.
- **Manifest** — A YAML or JSON file defining a Kubernetes resource.
- **kubectl** — The Kubernetes CLI tool for interacting with clusters.
- **kind** — A tool for running local Kubernetes clusters using Docker containers as nodes.
- **Minikube** — A tool that runs a single-node Kubernetes cluster locally for development and testing.
- **NodePort** — A Kubernetes Service type that exposes the service on a static port on each node's IP address.
- **ReplicaSet** — A Kubernetes controller that ensures a specified number of pod replicas are running at any given time.
- **Rolling update** — A deployment strategy that gradually replaces old pod instances with new ones, minimizing downtime.
- **ConfigMap** — A Kubernetes resource for storing non-sensitive configuration data as key-value pairs that can be consumed by pods.
- **Secret** — A Kubernetes resource for storing sensitive data such as passwords or API keys, encoded as base64.
- **Ingress** — A Kubernetes API object that manages external access to services, typically via HTTP/HTTPS routing rules based on hostnames and paths.
- **Ingress Controller** — A pod (e.g., nginx-ingress, Traefik) that implements the Ingress rules and handles actual traffic routing into the cluster.
- **ClusterIP** — The default Kubernetes Service type that exposes the service on an internal cluster IP, making it reachable only from within the cluster.
- **NetworkPolicy** — A Kubernetes resource that controls traffic flow between pods and namespaces; when no policy exists, all pods can communicate freely.
- **CNI plugin** — A Container Network Interface plugin (e.g., kindnet, Calico) that implements pod-to-pod networking and routing in a Kubernetes cluster.
- **Liveness probe** — A periodic container check (HTTP GET, TCP, or command) that determines whether the container is still alive; if it fails, kubelet kills and restarts the container.
- **Readiness probe** — A periodic container check that determines whether the container is ready to serve traffic; if it fails, the pod is removed from Service endpoints until it passes again.
- **Startup probe** — A container check that gates whether the liveness and readiness probes begin running; useful for slow-starting applications so kubelet does not kill them during boot.
- **Context** — A cluster+user+namespace tuple stored in the kubeconfig; `kubectl` uses the current context to decide which cluster to send requests to.
- **Kubeconfig** — The YAML file holding cluster endpoints, credentials, contexts, and the active context. A CI job gets one as a masked file-type CI/CD variable rather than as inline YAML, because an empty or truncated kubeconfig fails at `kubectl apply` with a message that does not name the real cause.
- **KUBECONFIG** — The env var that points `kubectl` at a specific kubeconfig path; the simplest way to hand a job its own credential without touching the runner's `~/.kube/config`.
- **ImagePullBackOff** — A pod image-pull error state where Kubernetes cannot download the container image, usually due to a wrong image name or missing registry credentials.
- **ContainerCreating** — A pod phase indicating the container runtime is pulling the image or setting up the filesystem; distinct from `ImagePullBackOff`, which means the pull itself failed.
- **HorizontalPodAutoscaler (HPA)** — An autoscaling/v2 resource that adjusts a Deployment's replica count between `minReplicas` and `maxReplicas` based on metrics such as CPU utilisation; pairs with resource requests because the utilisation target is computed against them.
- **Resource request** — The CPU/memory a container is guaranteed (`resources.requests`); the scheduler uses it to place pods, and HPA utilisation percentages are measured against it.
- **Resource limit** — The CPU/memory ceiling a container may not exceed (`resources.limits`); exceeding a CPU limit throttles the container, exceeding a memory limit gets it OOM-killed.
- **ServiceAccount** — An identity for processes running in a pod, used to authenticate to the Kubernetes API and other services.
- **ClusterRole** — A set of permissions that defines what resources a user or service account can access across the entire cluster.
- **ClusterRoleBinding** — A rule that grants the permissions in a ClusterRole to a specific user or service account.
- **RBAC** — Role-Based Access Control, the Kubernetes authorization model that grants permissions through Roles and ClusterRoles bound to users or ServiceAccounts; Prometheus needs `get`, `list`, and `watch` on pods, services, endpoints, and nodes.
- **Pod Disruption Budget** — A policy that limits the number of pods that can be voluntarily evicted from a Deployment or StatefulSet at once, protecting availability during node maintenance.
- **imagePullSecrets** — A Pod-spec field naming the Secret that holds private-registry pull credentials, so the kubelet can fetch the image. The Secret must live in the same namespace as the workload; one Secret per namespace can be shared by every Deployment in it.
- **GatewayClass** — A cluster-scoped resource naming a Gateway API implementation (the controller that will program the data plane). The platform team installs one per implementation; every Gateway binds to one, so the edge has a single advertised entry point per controller.
- **Gateway (Gateway API)** — The platform-owned resource holding listeners: which hostnames, ports, and protocols accept traffic and where TLS terminates. Replaces the Ingress class plus listener surface, without saying anything about which Service a host or path reaches.
- **HTTPRoute** — The app-owned Gateway API resource binding hostnames and path matches to backend Services, with filters for header matching and request rewriting. Scoped by RBAC separately from the Gateway, so app teams change routing without touching infrastructure-owned fields.
- **Custom resource** — An API object defined by a CustomResourceDefinition (CRD) rather than built into Kubernetes; the extension point operators use to model app-specific desired state (replicas, image, config) as native YAML.
- **Reconciliation** — The controller loop that converges observed state toward the desired state declared in a custom resource: read both, apply the diff idempotently, and stop applying once they match. Terminal validation failures return without requeueing; only conflicts and transient errors back off and retry.
- **Finalizer** — A string key on an object that blocks its deletion until the controller removes it. The controller sets it before creating external state, then honours it on delete by tearing that state down first — without it, deleting the custom resource orphans whatever it provisioned.

## OpenTofu

- **Provider** — A plugin that lets OpenTofu manage a specific infrastructure platform (e.g., AWS, local).
- **State** — A snapshot of real-world infrastructure stored in `terraform.tfstate` that OpenTofu uses to track what it manages.
- **Plan** — A dry-run diff showing what resources will be created, changed, or destroyed.
- **Apply** — The command that executes the planned infrastructure changes.
- **Module** — A self-contained package of `.tf` configurations that manages a group of related resources.
- **Variable** — An input value that keeps configurations flexible across environments.
- **Output** — A value exposed by a module or root configuration after apply.
- **Backend** — The configuration that defines where state is stored (local by default, or remote for teams).
- **`tofu`** — The OpenTofu CLI binary, the drop-in replacement for `terraform`.
- **`tofu state list`** — Prints every resource address currently tracked in state; the first command to run before any state surgery. Think of it as `ls` for managed infrastructure.
- **`tofu state mv`** — Rewires a state address to match a renamed resource block in code (e.g. `aws_instance.app` → `aws_instance.web`) so plan doesn't destroy and recreate the real resource.
- **`tofu state pull`** — Dumps the full state to stdout; redirect it to a backup file before any state operation so a botched change is recoverable.
- **Workspace (OpenTofu)** — A named, separate copy of state under the same configuration (`workspace new`, `workspace select`). Check `workspace show` before any stateful command so you don't operate on the wrong environment's state.
- **Backend migration** — Moving state between backends by editing the `backend` block and re-running `init`; the CLI offers to copy existing state to the new location. There is no `tofu migrate` command.
- **Plaintext secrets in state** — Values marked sensitive in code still land as plain JSON in the state file, so backend storage and read access deserve the same care as credentials.
- **S3 backend** — A remote-state backend that stores the state file as an object in an S3 bucket (`bucket` + `key` + `region`), so every machine running `apply` reads and writes the same state instead of drifting with local files.
- **DynamoDB lock table** — The `dynamodb_table` referenced by an S3 backend; OpenTofu takes a lock row on every state write so concurrent applies queue instead of clobbering each other.
- **Workspace isolation** — Using one workspace per environment (`dev`, `prod`) against the same configuration and backend, so each environment gets its own state pointer (`key` prefix per workspace) while the code stays identical.
- **Root module** — The top-level configuration a caller writes: provider blocks plus one or more `module` calls with concrete inputs. Shared modules stay provider-free so the same code serves every environment through different root modules.
- **`versions.tf`** — The file in a shared module that declares `required_providers` (and the OpenTofu version floor) without any `provider` blocks, so version constraints travel with the module while credentials stay in the caller's root module.
- **Count-gated resource** — A resource block with `count = var.enable_x ? 1 : 0` so an input flag decides whether the resource exists at all (e.g. skipping NAT gateways in isolated environments); guarded by a `validation` block so incompatible flag combinations fail at plan time.
- **Custom provider** — A provider built for an API that has no official coverage, written in Go against the Terraform Plugin Framework. The scaffold generates the provider server plus resource and data-source templates; the author fills in the schema, CRUD against the target API, and acceptance tests before installing it for real configurations.
- **Provider schema** — The typed declaration of what a provider accepts (endpoint, credentials) and what each resource and data source exposes (required/optional/computed attributes). Schema mistakes surface as plan-time errors, which is why the testing guide pins contracts before any apply.
- **Acceptance test** — A Go test that builds the provider, applies a real configuration against a sandbox API, and asserts on the resulting state. Slower than unit tests but the only layer that proves the provider's CRUD matches the API's behaviour.

## Terraform

- **Backend** — A configuration that defines how Terraform stores and loads state (e.g., local, S3, AzureRM).
- **Provider** — A plugin that lets Terraform manage a specific infrastructure platform (e.g., AWS, local).
- **State** — A file that maps real-world resources to your Terraform configuration.
- **Plan** — A dry-run that shows what changes Terraform will make.
- **Apply** — The command that executes the changes shown in a plan.
- **Resource** — A declarative description of an infrastructure component (e.g., `local_file`).
- **Module** — A self-contained package of Terraform configurations that manages a group of related resources.
- **Output** — A value exposed by a Terraform module or root configuration after apply.
- **State locking** — A mechanism (often using DynamoDB) that prevents concurrent Terraform operations from modifying the same state file simultaneously.
- **Workspace** — A separate state instance within a single Terraform configuration, typically used to manage multiple environments like dev, staging, and prod.
- **for_each** — A meta-argument that creates multiple resource instances from a map or set of strings; preferred over `count` when resources are non-identical.
- **count** — A meta-argument that creates a given number of identical resource instances; uses `count.index` to differentiate each instance.
- **Validation block** — A Terraform `validation` block on a variable that checks the supplied value at plan time (e.g. via `can(regex(...))` or `alltrue(...)`) and fails the plan with a custom `error_message` if the check does not pass. It catches bad input up front instead of half-way through apply.
- **Provisioner** — A Terraform block attached to a resource that runs a command or script at a point in the resource lifecycle (create, update, or destroy). Prefer a managed resource or provider when one exists; provisioners are a last resort for actions no resource type supports.
- **local-exec provisioner** — A Terraform provisioner that runs a command on the local machine where `terraform apply` executes (not on the target resource). Commonly used to invoke a configuration-management tool like Ansible after a resource is created.
- **Tainted** — A Terraform resource state flag marking a previously-created resource for destruction and recreation on the next apply, set automatically after a partial failure or via `terraform taint`, so Terraform replaces it cleanly instead of attempting in-place changes.
- **Child module** — A Terraform module invoked from a parent module, exposing computed values through `output` blocks so the parent can consume them without hard-coding resource attributes.
- **Parent module** — A Terraform module that calls one or more child modules and wires their outputs into its own resources or further child modules.
- **`required_version`** — The version constraint in a `terraform` block declaring which CLI releases a configuration supports (e.g. `>= 1.5, < 1.9`). Widen or move the bound only after the migration is verified, so a narrow bound rejects the new binary instead of letting a mixed-version estate plan against the same state.
- **tflint** — A static linter that parses Terraform configurations the way Terraform does and applies a rule set on top: deprecated syntax, provider-specific misuse, missing version constraints, and team naming conventions. Runs per pull request; initialise plugins once per repository with `tflint --init`.
- **Terratest** — A Go library for integration-testing infrastructure: it runs `terraform apply` against an ephemeral environment, asserts on outputs and real resource behaviour, then destroys everything. Catches defects that plan cleanly but misbehave once deployed.
- **Native test framework (`.tftest.hcl`)** — Terraform's built-in contract tests: `run` blocks apply a module with given inputs and assert on outputs, so variable-validation and wiring mistakes fail before any real apply.
- **Provider schema** — The structured description of every resource type and data source a provider exposes, including required and optional arguments and attribute types; emitted as JSON by `terraform providers schema -json`, it is the authoritative source of what a provider accepts.
- **Schema contract** — A hand-written JSON file declaring the arguments and attributes a module requires from a provider, checked against the live schema export before CI merges, so a provider-version drift that silently drops a required field fails the build instead of surfacing at apply time.
- **Module Registry** — The public (or private) catalog where versioned Terraform modules are published for others to consume; a module published with a version tag becomes selectable by `terraform init` and `source = "terraform-aws-modules/vpc/aws"`.

## Trivy

- **Vulnerability scanner** — A tool that identifies security vulnerabilities in software dependencies and container images.
- **Image scanning** — The process of inspecting a container image for known vulnerabilities in the base OS packages and application dependencies.
- **SARIF** — Static Analysis Results Interchange Format, a standard JSON-based format for sharing analysis results.
- **CVSS** — Common Vulnerability Scoring System, a framework for rating the severity of security vulnerabilities.
- **Severity filtering** — The ability to filter scan results by severity level (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN).
- **SBOM** — Software Bill of Materials, a list of all components and dependencies in a piece of software.
- **`--exit-code`** — A Trivy flag that makes a scan return a non-zero exit code when vulnerabilities are found (e.g. `--exit-code 1`); needed to turn a scan into a failing CI gate, since Trivy exits 0 by default even with issues.
- **`trivy fs`** — Scans a local filesystem/directory for vulnerabilities in lockfiles and dependency manifests; returns "No vulnerable packages found" when there is nothing to resolve (e.g. no lockfiles present).
- **`trivy repo`** — Scans a Git repository's dependencies for known vulnerabilities by cloning it before analysis.
- **`--severity`** — A Trivy flag that narrows a scan to given levels (e.g. `--severity CRITICAL`), so exit codes and reports can be scoped to the findings you actually care about.
- **`VulnerabilityID`** — The CVE identifier Trivy assigns to each finding in its JSON report; paired with `PkgName`, `InstalledVersion`, and `FixedVersion` it tells you exactly which package needs upgrading to clear a finding.
- **Scan policy** — A misconfiguration policy bundle Trivy consults during `misconfig` scanning, referenced in config by a `bundle`/`name` pair (e.g. `bundle: default`); it defines which checks run so a scan fails on the rules you actually care about instead of the whole built-in set.
- **Policy as code (OPA/Rego)** — Writing custom checks as Rego rules, bundling them into a policy package, and pointing Trivy at the bundle with `-f` so a scan fails on your own rules rather than only the built-in misconfig set. The bundle is a directory of `.rego` files; `trivy image --policy ./policies --severity CRITICAL` runs them and reports `PolicyName`/`Severity`/`Message` per failing rule.
- **`trivy image`** — Scans a container image for OS and language vulnerabilities; requires the Docker daemon and downloads a vulnerability DB on first run (cached at `~/.cache/trivy/db`).
- **DB caching** — Trivy's vulnerability database is fetched once and cached locally; subsequent `trivy image` runs are immediate and re-pulling the image is needed after a Dockerfile base-tag change.
- **`trivy k8s`** — Scans a Kubernetes cluster for vulnerabilities and misconfigurations across its workloads and node components; the cluster must be reachable from the machine running the scan.
- **`trivy sbom`** — Generates a Software Bill of Materials for a container image or filesystem, listing every detected package and dependency in CycloneDX or SPDX format.

## Prometheus

- **Metric** — A named measurement with labels, collected over time from a target endpoint. Example: `http_requests_total{method="GET",status="200"}`.
- **Label** — A key-value dimension attached to a metric that lets Prometheus filter and aggregate results. Example: `job="nginx"`, `instance="localhost:9090"`.
- **Scrape** — The pull-based operation where Prometheus fetches metrics from a configured target at a regular interval.
- **Target** — An HTTP endpoint that exposes a /metrics page and is listed in a `scrape_configs` block. Example: `localhost:9090/metrics`.
- **PromQL** — Prometheus's query language for selecting, aggregating, and computing on time-series data. Example: `rate(http_requests_total[5m])`.
- **Alertmanager** — A component that receives alerts from Prometheus, deduplicates them, groups by labels, and routes them to email, Slack, or pager integrations.
- **Recording rule** — A rule that precomputes an expression into a new named time series on a schedule, so a dashboard or another rule reuses one stored result instead of re-running a heavy query on every panel refresh. Naming follows `level:metric:operations`, e.g. `job:http_error_ratio:1m`.
- **Alerting rule** — A rule that evaluates a condition (`recorded_series > 0.05`), optionally holds it for a `for` duration, and fires when it stays true. The `for` clause is what stops a blip from paging anyone.
- **Route tree** — Alertmanager's ordered receiver definitions: alerts are matched by label and handed to the first matching route, so grouping and routing decisions live in one place rather than in each alert's labels.
- **Inhibition rule** — A rule that mutes an alert when another matching alert is already firing. A `Critical` firing suppresses every `Warning` for the same instance, which is what keeps a bad deploy from paging the whole rotation twice.
- **On-call rotation** — A schedule in PagerDuty that assigns the incident to whoever is on shift, so an alert reaches a person rather than a distribution list. Rotations pair with escalation policies: if the first responder does not acknowledge within a window, the incident walks up the policy.
- **Exporter** — A small server that translates third-party metrics into the Prometheus format. Example: Node Exporter turns Linux kernel and hardware metrics into /metrics output.
- **ServiceMonitor** — A Kubernetes Custom Resource Definition (CRD) used by the Prometheus Operator to declaratively select which pods to scrape.
- **PodMonitor** — A Kubernetes CRD used by the Prometheus Operator to select pods for scraping based on label selectors, similar to ServiceMonitor but targeting pods directly.
- **PrometheusRule** — A Kubernetes CRD used by the Prometheus Operator to define alerting and recording rules as native cluster resources.
- **`kubernetes_sd_configs`** — A Prometheus scrape configuration block that discovers scrape targets from the Kubernetes API; the `role` field (pod, service, endpoints, node) controls which objects become targets.
- **`relabel_configs`** — A Prometheus relabeling configuration applied to discovered targets before scraping; used to filter, rename labels, or drop unwanted targets so only relevant endpoints are scraped.

## Monitoring & Observability

- **Metric** — A numeric measurement collected over time, like `http_requests_total` or `process_cpu_seconds`. Metrics are cheap to store and fast to query, which makes them perfect for dashboards and alerts.
- **Log** — A timestamped text record of an event, usually structured as JSON with fields like `level`, `service`, and `message`. Logs tell the story of what happened in detail.
- **Trace** — A record of a single request's path through multiple services, showing each hop's duration and metadata. Distributed tracing lets me see where time was lost across service boundaries.
- **Dashboard** — A visual panel that graphs metrics and logs for at-a-glance system health. A good dashboard answers "is everything okay?" in under ten seconds.
- **Alert** — A notification triggered when a metric crosses a threshold or a condition is met. Good alerts are actionable and low-noise; bad alerts train on-call engineers to ignore them.
- **Service Level Indicator (SLI)** — A specific measurable attribute of a service, such as request latency or availability percentage. SLIs are the raw numbers behind service level agreements.
- **Service Level Objective (SLO)** — A target value for an SLI, like "99.9% of requests return in under 200ms". SLOs give teams a shared language for reliability instead of vague "make it faster" goals.
- **DORA metrics** — Four delivery-health numbers: deployment frequency, mean lead time for changes, mean time to recover, and change failure rate. Tracked from commit and deploy timestamps, they score the factory, not just the app.
- **Deployment marker** — An annotation on a metrics timeline recording when a deploy landed, so an error-rate move can be tied back to the change that caused it.
- **Health gate** — A checkpoint that probes targets (DNS resolution timing plus TCP/HTTP reachability), correlates the results under one id, and returns a proceed-or-hold verdict per target before a rollout continues.

## CI/CD Concepts

- **Continuous Integration (CI)** — The practice of automatically building and testing every code change.
- **Continuous Deployment (CD)** — The practice of automatically deploying every change that passes CI.
- **Continuous Delivery** — An extension of CI where every change is deployable but may require manual approval to deploy.
- **Trigger** — An event that starts a pipeline run, such as pushing to a branch, opening a PR, or a scheduled time.
- **Environment** — A named deployment target like `staging` or `production` that pipelines promote artifacts through, often with approval gates.
- **Secret** — A sensitive value (API key, password, token) the pipeline needs but must never print to logs; stored in the CI/CD platform's secrets manager.
- **Matrix build** — Running the same job with multiple configurations (OS, language versions) in parallel to test all combinations.
- **Artifact promotion** — The practice of passing a build artifact through successive environments (e.g., dev → staging → prod) after it passes validation at each stage.
- **Preview environment** — A short-lived deployment of a single pull request's artifact, spun up automatically with its own hostname and seed data so reviewers can click through the change; torn down when the request closes. Serves as the first promotion gate before staging.
- **Deployment gate** — A manual or automated checkpoint in a pipeline that must be passed before an artifact can proceed to the next environment.
- **Rollback trigger** — An automated or manual action that reverts a deployment to a previous known-good state when a health check, alert, or error threshold is breached.

## Linux & System Administration

- **systemd** — A system and service manager for Linux that provides a standardised way to manage services, timers, and system state.
- **systemd timer** — A unit file that schedules recurring jobs, serving as a cron replacement with better logging and dependency management.
- **systemd service** — A unit file that defines a long-running or one-shot process managed by systemd, with options for restart policies and resource control.
- **journald** — The systemd logging daemon that collects and stores log data from the kernel, services, and system processes.
- **journal-remote** — A systemd-journald remote collection daemon that receives and stores journal entries from remote hosts over HTTP.
- **journal-upload** — A systemd-journald client that uploads journal entries to a remote server running journal-remote.
- **StandardOutput=journal** — A systemd service directive that routes the service's stdout directly to the journald log stream.
- **StandardError=journal** — A systemd service directive that routes the service's stderr directly to the journald log stream.
- **Oneshot** — A systemd service Type that runs a short-lived task to completion and then exits, as opposed to a long-running daemon.
- **Wants=** — A systemd unit directive that expresses a loose dependency, starting the target unit when this unit starts but not failing if it cannot.
- **After=** — A systemd unit directive that orders startup, ensuring the specified unit is fully started before this unit begins.

## Version Control Concepts

- **Repository** — A folder tracked by version control that contains the project and its full history.
- **Commit** — A snapshot of changes at a point in time, with a message explaining why the change was made.
- **Branch** — A parallel line of development that lets me work on changes without disturbing the main line.
- **Merge** — Combining changes from one branch into another.
- **Pull Request** — A review request to merge one branch into another, with a diff and discussion.
- **Clone** — Copying a remote repository to my local machine so I can work on it.
- **Remote** — A version of the repository hosted on a server (like GitHub) that I can push to and pull from.
- **.gitignore** — A file that tells Git which files or directories to skip.
- **Conflict** — When two branches change the same line of code and Git can't auto-merge them.
- **HEAD** — A pointer to the current commit I'm looking at, usually the tip of the current branch.
- **Branch protection** — Rules applied to a Git branch (commonly `main`) that enforce requirements such as passing CI checks, required reviews, or preventing force pushes before merging.
- **Merge strategy** — The method Git uses to combine branches: merge commit (preserves full history), rebase (rewrites commits onto a new base), or squash (collapses all commits into one); the choice affects history readability and bisectability.
- **Release automation** — The practice of turning a Git tag into a deployable artifact through an automated pipeline — typically parsing conventional commits to generate a changelog, bump the version, and publish a release without manual steps.
- **Divergence (ahead/behind)** — How many commits each of two branches has that the other lacks, shown by `git rev-list --left-right --count A...B` as two numbers (e.g. `2 5` means the left side is 2 ahead, 5 behind). Counts alone don't name the commits; list the unique ones on each side to see what would merge.
- **Trunk-based development** — A branching strategy where all work lands on one shared branch (`main`/`trunk`) via short-lived feature branches, instead of long-lived release or feature branches that merge painfully.
- **Short-lived branch** — A feature branch that lives hours to a day or two and merges via PR as soon as CI passes; the unit of work in trunk-based delivery.
- **Merge queue** — A CI mechanism that serializes PR merges, re-testing each one against the latest `main` before landing so concurrent merges can't break each other.
- **Ruleset** — GitHub's successor to classic branch protection: a programmable set of merge gates (required checks, workflows, bypass lists) applied to branches or tags.
- **Stale branch** — A branch with no commits or PR activity for N days; the cleanup target of branch-hygiene automation.

## HashiCorp Vault

- **Seal / unseal** — A locked Vault refuses requests until it is unsealed with key shares (`vault operator unseal <key-share>`); a dev server starts unsealed.
- **Dev server** — A throwaway in-memory Vault (`vault server -dev`) for learning; nothing is saved to disk.
- **Secrets engine (KV)** — The key-value store where simple secrets live (`vault kv put secret/app password=x`).
- **Policy** — A written rule saying which paths a token may read or write, e.g. read-only on `secret/app`.
- **Token** — The credential presented instead of a password (`vault login <token>`); dev mode prints a root token.
- **VAULT_ADDR** — The env var telling the CLI where the server lives (e.g. `export VAULT_ADDR='http://127.0.0.1:8200'`).
- **`vault secrets enable`** — Mounts a secrets engine at a chosen path (`vault secrets enable -path=my-secrets kv-v2`); mounting your own path instead of relying on the dev server's default keeps the learning explicit about which engine serves which secret.
- **KV v2 versioning** — Every `kv put` to a versioned path creates a new version instead of overwriting; old values stay readable until destroyed. `kv get` shows the value nested under `data` beside version metadata — use `-field=data` or `-format=json` when scripting against it.
- **Read-only policy** — A policy granting only `read` on one data path (plus `read` on its `metadata` path for KV v2, so versions can be listed), bound to an identity group so tokens minted for that group can see exactly one secret and nothing else.
- **Identity group** — A named set of Vault entities (`vault write identity/group name="readers" policies="read-only-hello"`) that carries policies to every member token. Attaching the policy to the group instead of to individual tokens is what keeps least-privilege issuance to one place.

## Pulumi

- **Program** — The code file where I declare what I want, in Python, TypeScript, Go, or C#, instead of a YAML or DSL template.
- **Stack** — A named instance of a program, usually one per environment (`dev`, `prod`), keeping each environment's state and config apart without duplicating code.
- **Provider** — A plugin that teaches Pulumi to talk to one cloud; it turns resource objects in code into real API calls.
- **Preview** — A dry look at what would change before anything happens; run preview, see "1 to create", then decide to deploy.
- **State** — Pulumi's memory of what it already built and which outputs came back, so the next run only changes the diff.
- **Output** — A value the cloud hands back after deploy (e.g. a bucket's real name) that can be wired into an app's config.
- **Config** — Per-stack settings so one program behaves differently per environment.
- **Stack config file** — The `Pulumi.<stack>.yaml` file (e.g. `Pulumi.dev.yaml`) holding one stack's settings under dotted `config:` keys, read back with `pulumi config get <key>`; the project file (`Pulumi.yaml`) is not where per-environment values go.
- **Encrypted secret** — A config value Pulumi stores sealed in its backend instead of plaintext, set with `pulumi config set --secret <key> <value>` and read back as an `Output` that only decrypts at runtime. Worth it for anything that would otherwise sit in a YAML file in version control.
- **Component resource** — A Pulumi component that bundles several child resources under one type and exports a typed interface (`export("vpc-id", ...)`), so callers never reach into the wiring. A reusable Network wrapping a VPC, subnets, and a gateway is the shape.
- **StackReference** — A cross-stack handle (`StackReference.get("dev", "vpc-id")`) that lets one stack read another stack's exported outputs without sharing state files. The usual way stacks talk to each other instead of each one re-creating what it needs.
- **Multi-stack project** — One `Pulumi.yaml` with several stacks (`dev`, `staging`, `prod`) pointing at separate program directories under `stacks/`, so each environment is its own code path while the shared components stay in one place.

## Grafana

- **Grafana** — An open-source dashboarding layer for observability: it borrows numbers from a data source and turns query results into graphs, gauges, and tables. It stores no metrics itself.
- **Data source** — Where Grafana reads numbers from, e.g. a Prometheus server on `localhost:9090`.
- **Panel** — A single chart or readout on a dashboard, e.g. a graph of request rate over the last hour.
- **Dashboard** — A saved set of panels with layout and time range, shareable as a link instead of screenshots.
- **Variable** — A dropdown that re-runs every panel with a new value, so one dashboard can flip between services.
- **Alert rule** — A threshold check pinned to a query, e.g. warn if the error share stays above five percent for ten minutes.
- **Snapshot** — A frozen, shareable copy of a dashboard whose graphs survive after the underlying data ages out.
- **Provisioning** — Declaring data sources, dashboards, and alert rules from files under `/etc/grafana/provisioning/` (or from `GF_*` environment variables) at start-up instead of clicking them into the UI. Provisioned objects are owned by the config: they appear in the UI but are read-only there, and edits must go back into the file.
- **`GF_DATASOURCES`** — An environment variable holding inline JSON that provisions data sources on boot. Convenient for a throwaway container, awkward to review in version control; a YAML file under the provisioning directory is the better home once the definition grows.
- **`uid`** — The stable string identifier a dashboard (or folder) needs to be addressable by API and URL. Exported JSON carrying only a numeric `id` will import but never show up in the list, because the numeric ID is instance-local.
- **Unified Alerting** — The current Grafana alerting system, reachable at `/alerting/list`. A bookmarked link to the legacy `/alerting` page still resolves to the old UI, which does not show rules created under Unified Alerting.

## Grafana Cloud

- **Grafana agent** — The OpenTelemetry Collector distribution bundled as `grafana-agent` / `grafana-agent-ctl`: the same scrape-and-forward shape as a raw collector, wired to a Grafana Cloud stack by a stack ID and an API token rather than by an endpoint you assemble yourself.
- **Prometheus scrape job** — The agent stanza that names what to scrape, how often, and where the samples go: `prometheus.scrape "node" { targets = ..., forward_to = [...], scrape_interval = "15s" }`.
- **`prometheus.exporter.unix`** — An exporter stanza that runs node-level collectors (CPU, memory, filesystem, load) and publishes their target list, so a scrape job can point at `prometheus.exporter.unix.default.targets` instead of a hardcoded `host:port`.
- **relay / pass-through relabel** — A `prometheus.relabel` rule that receives samples and forwards them on. An empty rule is a no-op, which makes it a convenient placeholder: give the scrape job one target today and a second one tomorrow without touching the scrape stanza.
- **Remote write** — The push-side counterpart to scraping: the agent sends samples to the Cloud stack's `/api/prom/push` endpoint instead of waiting to be polled. Without it the samples are collected and then discarded, which is the usual reason a first agent config looks like it is working but nothing appears in the UI.
- **API token** — The credential the agent presents to the Grafana Cloud API. It carries a specific set of instance permissions, so scoping it to just the one stack is worth the extra step — a token that can read every stack is a token you do not want in a repo.
- **`uid`** — The stable string identifier a dashboard or folder needs to be addressable by API and URL. Without one, an imported or POSTed dashboard exists but is not listed anywhere, which is the usual reason a scripted "create a dashboard" call appears to do nothing.

## OpenTelemetry

- **OpenTelemetry (OTel)** — A vendor-neutral observability framework: one set of APIs and SDKs to emit traces, metrics, and logs from code, then point the data at any backend without re-instrumenting.
- **Trace** — The full journey of one request across services, e.g. one checkout click traced from the web app through payments.
- **Span** — A single timed step inside a trace, e.g. a span named `charge-card` covering just the payment call.
- **Context propagation** — Passing trace IDs along with each hop (e.g. an ID header) so spans from different services land in the same trace.
- **W3C tracecontext** — The W3C standard propagation format carried in the `traceparent` header (`00-<trace-id>-<span-id>-<flags>`). The default choice for new services, and the format most SDKs inject and extract out of the box.
- **B3 (Zipkin-style propagation)** — The older single-header or paired-header format Zipkin popularised (`b3: <trace-id>-<span-id>-<sampled>`). Still met in legacy services and in some SDK default configurations.
- **Propagation mismatch** — What happens when one service injects `traceparent` and the downstream only understands `b3`, or when a gateway injects a header the consumer ignores: the trace stops at the boundary and the downstream spans arrive as orphaned roots. The fix is to align the propagator on both sides of the boundary.
- **Exporter** — The plug that ships signals somewhere: a local collector while learning, a real backend later.
- **Collector** — A middleman that receives, batches, and forwards signals, e.g. one collector on a laptop feeding whatever viewer is being tried. `otel/opentelemetry-collector-contrib` is the distribution that bundles the common receivers, processors, and exporters into one binary.
- **OTLP** — OpenTelemetry Protocol, the wire format the SDKs use to hand signals to a collector. The gRPC flavour listens on port 4317 and is the default target of the Python OTLP exporter; the HTTP/protobuf flavour uses 4318.
- **Receiver / Processor / Exporter** — The three stages a collector runs every signal through: a receiver accepts it off the wire, a processor batches, filters, or enriches it, and an exporter forwards it onward. A collector with no exporter configured simply logs what it receives, which is the quickest way to confirm a span actually arrived.
- **Tracer provider** — The SDK object that owns span creation and export for a process. One provider is set once at start-up via `trace.set_tracer_provider(...)`; asking for a tracer after that returns tracers bound to it.
- **Tracer** — The handle a tracer provider hands out, namespaced by the instrumentation library that requested it (`trace.get_tracer("first-span")` becomes `"first-span"` in the backend). Separating tracers per library is what keeps one team's spans from being indistinguishable from another's.
- **Span processor** — The hook a span provider registers to decide what happens when a span ends. `SimpleSpanProcessor` sends each span the moment it closes — right for learning and for a collector you are watching — while a batching processor trades a little latency for far fewer network calls under load.
- **Span attribute** — A key/value pair attached to a span (`span.set_attribute("http.method", "GET")`) recording a fact about that step. Attributes are indexed, so they are what you filter and group by in a trace backend; free-form log lines are not.
- **OTLP endpoint** — The address a client exporter is pointed at, e.g. `localhost:4317` for a collector running on the same machine. It is the one setting most often wrong when a span silently goes nowhere: check the port matches the receiver the collector actually has enabled.
- **Pipeline** — The named entry under `service.pipelines` that wires receivers, processors, and exporters together for one signal type. The order in that line reads receivers, then processors, then exporters, and the collector refuses to start if the stages are listed any other way.

## Jenkins

- **Jenkins** — An open-source automation server that provides hundreds of plugins to support building, deploying, and automating any project.
- **Pipeline** — A suite of plugins that supports implementing and integrating continuous delivery pipelines into Jenkins. Defined in a `Jenkinsfile` using either Declarative or Scripted syntax.
- **Declarative Pipeline** — A simplified, opinionated syntax for writing Jenkins Pipelines with a predefined structure (`pipeline { agent any; stages { ... } }`).
- **Scripted Pipeline** — The original Groovy-based syntax for Jenkins Pipelines, offering full programming flexibility but more verbose.
- **Agent** — The machine or container where Pipeline stages execute. Can be `any`, a labeled node, a Docker container, or a Kubernetes pod.
- **Stage** — A logical grouping of tasks within a Pipeline (e.g., `Build`, `Test`, `Deploy`).
- **Step** — A single task within a stage, such as `sh`, `git`, `archiveArtifacts`, or a plugin-provided step.
- **Jenkinsfile** — The text file checked into source control that defines the Pipeline. The standard contract between developers and the automation system.
- **Blue Ocean** — A modern UI for Jenkins that visualizes Pipelines, shows stage-level logs, and surfaces failures more clearly than the classic UI.
- **Shared Library** — A versioned collection of reusable Pipeline code (steps, functions, global variables) loaded from a Git repo or Jenkins internal storage, enabling DRY across many Jenkinsfiles.
- **Credentials Binding** — The mechanism that injects secrets (username/password, SSH key, secret text) into a Pipeline as environment variables without writing them to the console log.
- **Pipeline Agent** — Where the Pipeline runs. `agent any` picks any available executor; `agent { docker { image '...' } }` runs inside a container; `agent { kubernetes { yaml '...' } }` runs on a cluster pod.
- **Post Section** — A block in a Declarative Pipeline that runs after the main stages (`always`, `success`, `failure`, `unstable`, `changed`, `fixed`) — useful for cleanup, notifications, or artifact archival.

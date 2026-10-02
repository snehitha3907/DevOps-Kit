---
last_verified: 2026-10-02
tool_version: n/a
---

# GitLab CI/CD with Kubernetes — end-to-end walkthrough

## Purpose

This records the full path a commit takes from a GitLab push to a running
Kubernetes Deployment: a runner that can reach a cluster, a cluster credential
the pipeline is allowed to hold, and a `.gitlab-ci.yml` that builds one image,
publishes it under the commit SHA, and rolls that exact digest onto a Deployment.
It is the wiring document. The pipeline itself is already written and commented
in [`../configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml`](../configs/minimal-gitlab-ci-docker-build-deploy-kubernetes.yaml);
what was missing was the setup *around* that file — the runner choice, the
variable that hands the job a kubeconfig, and the approval gate that stops a
merge request from touching the cluster.

## When to use

Use this when the deploy target is a plain Kubernetes cluster and the image is
built from the same repository that carries the pipeline definition. It does not
cover a GitOps controller reconciling manifests — if Argo CD or Flux CD owns the
Deployment, a pipeline that mutates it directly will simply be reverted, and
that is a different wiring problem.

## Prerequisites

- A reachable cluster and a kubeconfig whose current context is the deploy target.
- A workload already present, so `kubectl set image` has something to act on. This
  walkthrough uses [`../../Kubernetes/manifests/deployment-service-with-probes-limits.yaml`](../../Kubernetes/manifests/deployment-service-with-probes-limits.yaml),
  which defines a Deployment and Service both named around `web-app`.
- A runner that can either run containers or schedule pods. The build and push
  jobs need the `docker` tag; the deploy job needs nothing in particular, and
  will happily sit on any runner carrying that tag.

## Steps

### 1. Confirm the target workload exists

```bash
# Path below is relative to the repository root.
kubectl apply -f Kubernetes/manifests/deployment-service-with-probes-limits.yaml
kubectl rollout status deployment/web-app --timeout=120s
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}'
```

Record that last value. It is the only statement of what was running before the
pipeline first touched the cluster, and it is what the config's rollback branch
depends on. Doing this outside the pipeline is deliberate: a pipeline that has
never seen the workload before cannot tell a missing Deployment from a failed
rollout, and reports both as "kubectl exited non-zero".

### 2. Decide where the deploy job runs

Two runners are workable. A **shared runner** with the `docker` tag already
carrying Docker-in-Docker serves all three jobs; the deploy job runs in a
container, which is why it writes its kubeconfig to `$CI_PROJECT_DIR` rather than
relying on an ambient `~/.kube/config` that a container job does not have.

The alternative is registering a runner with the **Kubernetes executor**, so each
job runs as its own pod and inherits the namespace's service account. That is
tidier for isolation, and it moves the image-pull problem rather than solving
it: a pod scheduled into the cluster pulls from the GitLab registry as an
anonymous client unless the namespace carries a matching `imagePullSecret`.
The config does not create that secret, so a runner pod will sit in
`ErrImagePull` while the same pipeline succeeds from a shared runner. Whichever
route is chosen, the secret still has to exist before a private image can roll
out — see Common errors.

### 3. Store the cluster credential as a masked variable

`KUBE_CONFIG` holds a cluster credential and must not appear in a committed file.
Project > Settings > CI/CD > Variables, then add it as a **File** variable,
**masked**, and **protected** — protected so merge-request pipelines from forks
do not receive it. The config reads it defensively and exits with a plain message
when it is absent, rather than letting kubectl fail on an empty kubeconfig.

### 4. Point the pipeline at `web-app`

The config keeps cluster coordinates in `variables:` so a staging and a
production pipeline differ by values rather than by a fork of the file. Set them
to match the manifest applied in step 1:

```yaml
K8S_NAMESPACE: "default"
K8S_DEPLOYMENT: "web-app"
K8S_CONTAINER: "web-app"
```

`K8S_CONTAINER` must match the container `name:` inside the Deployment template,
not the Deployment's own name — they happen to be identical here, which makes the
mistake easy to make somewhere else later.

### 5. Confirm the approval gate blocks

The deploy job is gated by `when: manual` **inside a `rules:` entry** with
`allow_failure: false`. A job-level `when: manual` defaults to
`allow_failure: true`, and the failure mode is quiet: the pipeline goes green,
nobody deploys, and the only evidence is that the Deployment's image never
changed. After the first merge to the default branch, click the deploy job and
confirm the pipeline sits in a blocked state rather than reporting success.

## Verify

```bash
kubectl get deployment web-app -o jsonpath='{.spec.template.spec.containers[0].image}'
```

The image should be the digest published by the push job, not the SHA tag.
Confirm the rollout history lines up with the commit:

```bash
kubectl rollout history deployment/web-app
kubectl rollout undo deployment/web-app --to-revision=1   # only if it did not
```

## Common errors

- **"no runner has the `docker` tag" / job stuck pending.** The build and push
  jobs carry `tags: [docker]`; a runner without that tag is invisible to them.
- **Build fails at `docker build` on a shared runner.** The Docker-in-Docker
  service needs a privileged runner. The symptom is a build error, not a
  runner-configuration message, which is why the config's header calls it out.
- **Rollout succeeds locally, pods then fail `ErrImagePull`.** The image is
  private to the registry and the namespace has no matching `imagePullSecret`.
  The rollout itself will report success because the Deployment accepted the
  image reference; the failure only shows in pod status afterwards.
- **Pipeline green, cluster unchanged.** Almost always the manual-gate
  `allow_failure` issue in step 5.

## What I'd try next

Splitting staging from production with a second `rules:` keyed on the commit
branch, so both pipelines share one file, and moving from `kubectl set image` to
a `kubectl apply` of a Kustomize overlay once there is more than one container
to keep in step.
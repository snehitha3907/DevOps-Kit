---
last_verified: 2026-10-02
tool_version: 3.5.0
sources:
  - https://argo-cd.readthedocs.io/en/stable/getting_started/
  - https://argo-cd.readthedocs.io/en/stable/user-guide/
  - https://argo-cd.readthedocs.io/en/stable/faq/
  - https://github.com/argoproj/argo-cd/releases/tag/v3.5.0
---

# How I wired ArgoCD with GitHub for GitOps deployment

## Purpose

This doc records the working setup: an ArgoCD control plane on a Kubernetes
cluster reading manifests from a private GitHub repo, with commits to the repo
driving deployments automatically. It is the wiring guide — what commands I ran,
what configuration I had to set on both sides, and where the integration broke.

## When to use this

Use this as the reference when you need ArgoCD to deploy from GitHub rather than
from a public repo or a local path. It assumes the cluster already has ArgoCD
installed and the operator can reach the GitHub API from the cluster.

## Prerequisites

- ArgoCD installed and reachable (`argocd` CLI authenticated, or the web UI).
- A GitHub repo holding Kubernetes manifests in a known path.
- A deploy key or credential ArgoCD uses to read the repo.

## Steps

### 1. Add the GitHub repo as an ArgoCD remote

Register the repo so ArgoCD can read it:

```bash
argocd repo add https://github.com/myorg/my-gitops \
  --username myorg \
  --password "${GITHUB_TOKEN}" \
  --type git
```

The password is a fine-grained personal access token with read-only `Contents`
permission. ArgoCD stores it encrypted in the `argocd-secret` secret; verify with
`argocd repo list` that the connection status is not error.

### 2. Create the ArgoCD project

Scope the app to a project so RBAC and resource limits apply:

```bash
argocd proj default \
  --description "Production GitHub-backed apps" \
  --dest https://kubernetes.default.svc \
  --dest-namespace '*' \
  --src '*'
```

### 3. Create the Application

Point ArgoCD at the GitHub repo path:

```bash
argocd app create guestbook \
  --project default \
  --repo https://github.com/myorg/my-gitops \
  --path manifests/guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace guestbook \
  --sync-policy automated
```

Or apply the equivalent manifest:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/myorg/my-gitops
    targetRevision: main
    path: manifests/guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: guestbook
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### 4. Verify the sync cycle

```bash
argocd app sync guestbook --async
argocd app wait guestbook --health --timeout 180
argocd app get guestbook -o wide
```

A healthy sync shows `SYNCED` status and `Healthy` health. Committing a change
to `manifests/guestbook/deployment.yaml` triggers the next sync automatically.

## Verify

- `argocd app get <name>` reports `Synced` and `Healthy`.
- `kubectl get deployments -n <namespace>` shows the manifest's replica count.
- Reverting a commit in GitHub shows the app return to `OutOfSync` until the next
  sync, then back to `Synced` with the old image.

## Common errors

- **Repo connection fails.** Check the token's scopes and that the deploy key is
  added to the repo. `argocd repo list` shows the error message.
- **App never syncs.** Confirm `targetRevision` resolves — a branch name needs
  the branch to exist; a commit SHA needs the commit to be reachable.
- **`prune` deleted something I needed.** Review what the Git path contains before
  enabling `prune: true`; ArgoCD deletes anything in the destination namespace
  that is not in the repo.

## References

- ArgoCD getting started: https://argo-cd.readthedocs.io/en/stable/getting_started/
- ArgoCD user guide (repos, projects, apps): https://argo-cd.readthedocs.io/en/stable/user-guide/
- ArgoCD FAQ: https://argo-cd.readthedocs.io/en/stable/faq/
- ArgoCD v3.5.0 release: https://github.com/argoproj/argo-cd/releases/tag/v3.5.0
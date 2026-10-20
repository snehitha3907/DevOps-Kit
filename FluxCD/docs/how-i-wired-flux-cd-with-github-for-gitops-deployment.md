---
last_verified: 2026-10-20
tool_version: n/a
sources: []
---

# Wiring Flux CD with GitHub for GitOps Deployment

## Purpose

This document describes how to connect Flux CD to a GitHub repository so that cluster state automatically synchronizes with the Git source of truth. The pattern uses Flux's GitRepository and Kustomization resources to watch a GitHub repo and apply manifests to a Kubernetes cluster.

## When to Use

- You have a Kubernetes cluster and want GitOps-driven deployments
- Your deployment manifests live in a GitHub repository
- You prefer a pull-based model where the cluster reconciles from Git
- You want to manage both infrastructure and application deployments through Flux

## Prerequisites

- A running Kubernetes cluster (v1.27+ recommended)
- `flux` CLI installed locally
- A GitHub repository with Kubernetes manifests (Kustomize or plain YAML)
- A GitHub personal access token (classic) or fine-grained token with `repo` scope
- `kubectl` configured for the target cluster

## Steps

### 1. Bootstrap Flux on the Cluster

Run the bootstrap command pointing at your GitHub repository. This installs Flux controllers and creates the initial GitRepository and Kustomization resources.

```bash
flux bootstrap github \
  --owner=<GITHUB_USERNAME_OR_ORG> \
  --repository=<REPO_NAME> \
  --branch=main \
  --path=clusters/<CLUSTER_NAME> \
  --personal \
  --token-auth
```

The `--token-auth` flag prompts for a GitHub token. The `--path` argument tells Flux where in the repo to find manifests for this cluster.

### 2. Verify the Bootstrap

Check that Flux controllers are running and the initial reconciliation succeeded.

```bash
flux check --pre
kubectl -n flux-system get all
flux get sources git
flux get kustomizations
```

The GitRepository source should show `Ready=True` and the Kustomization should show `Ready=True` with the latest commit SHA.

### 3. Structure the Repository

Organize manifests so each environment or cluster has its own path:

```
clusters/
  production/
    flux-system/          # Flux's own manifests (managed by bootstrap)
    infrastructure/       # CRDs, namespaces, operators
    apps/                 # Application Kustomizations
  staging/
    ...
```

Each `apps/` entry is a Kustomization resource that Flux applies. Use `kustomization.yaml` files to compose bases and overlays.

### 4. Add Application Kustomizations

For each application, create a Kustomization resource in the cluster's path:

```yaml
# clusters/production/apps/podinfo-kustomization.yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: podinfo
  namespace: flux-system
spec:
  interval: 10m0s
  path: ./apps/podinfo
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
  healthChecks:
    - apiVersion: apps/v1
      kind: Deployment
      name: podinfo
      namespace: default
```

Commit and push. Flux detects the new Kustomization and applies it on the next reconciliation interval.

### 5. Configure Automated Image Updates (Optional)

To enable automated container image updates, add an ImageRepository and ImagePolicy:

```yaml
# clusters/production/apps/podinfo-image-repo.yaml
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImageRepository
metadata:
  name: podinfo
  namespace: flux-system
spec:
  image: ghcr.io/stefanprodan/podinfo
  interval: 5m0s
---
apiVersion: image.toolkit.fluxcd.io/v1beta2
kind: ImagePolicy
metadata:
  name: podinfo
  namespace: flux-system
spec:
  imageRepositoryRef:
    name: podinfo
  policy:
    semver:
      range: '>=1.0.0'
```

Then reference the image in the deployment using a Kustomize patch or the `flux update image` command.

## Verify

1. **GitRepository sync**: `flux get sources git` — confirm `Ready=True` and the latest commit matches `main`.
2. **Kustomization status**: `flux get kustomizations` — all should show `Ready=True`.
3. **Workload health**: `kubectl get deployments -A` — application pods should be running.
4. **Drift test**: Manually change a replica count in the cluster (`kubectl scale deployment podinfo --replicas=5 -n default`). Wait for the reconciliation interval (default 10m) and verify Flux reverts to the Git state.

## Common Errors

| Symptom | Cause | Resolution |
|---------|-------|------------|
| GitRepository `Ready=False` | Invalid token or repo path | Verify token has `repo` scope; check `--path` exists in repo |
| Kustomization stuck `Progressing` | Resource apply timeout or conflict | Check `flux logs kustomization <name>`; resolve conflicting fields |
| ImagePolicy not updating | Semver range excludes latest tag | Adjust `policy.semver.range` or use `policy.alphabetical.order` |
| `flux bootstrap` fails | Cluster API version mismatch | Ensure Kubernetes version >= 1.27; check CRD compatibility |

## Rollback

If a bad commit breaks the cluster:

1. Revert the commit in GitHub: `git revert <bad-sha> && git push`
2. Flux reconciles the revert on the next interval (or trigger manually: `flux reconcile source git flux-system`)
3. For immediate rollback without waiting: `flux suspend kustomization <name> && flux resume kustomization <name>`

## References

- Flux CD documentation: https://fluxcd.io/flux/
- GitRepository API: https://fluxcd.io/flux/components/source/gitrepositories/
- Kustomization API: https://fluxcd.io/flux/components/kustomize/kustomizations/
- Bootstrap guide: https://fluxcd.io/flux/installation/bootstrap/github/
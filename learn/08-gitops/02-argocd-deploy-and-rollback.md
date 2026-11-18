---
last_verified: 2026-11-18
tool_version: n/a
sources: []
---
# Deploy from Git with ArgoCD and roll back

In the previous lesson you packaged the sample app as a Helm chart with values per environment. Now you will connect that app to a Git repo and let ArgoCD keep the cluster matching it — so an image tag change in Git flows automatically to the cluster, and a bad change can be undone by reverting the commit. This is the core GitOps loop: Git is the single source of truth, and ArgoCD is the controller that converges the cluster to it.

## What you'll learn

- Point an ArgoCD Application at the app's manifests in a Git repo.
- Change the image tag in Git, commit and push, and watch ArgoCD sync the new image to the cluster.
- Roll back by reverting the image-tag commit in Git, so ArgoCD resyncs the previous image.

## Before you start

- [ArgoCD — quick primer](../../ArgoCD/notes/0000-primer-argocd.md) — what an Application, sync, and health status are, and that ArgoCD watches a Git repo and converges the cluster to it. The Application manifest you write below follows the same shape as the first-application reference [`2026-07-23-first-application-manifest.yaml`](../../ArgoCD/configs/2026-07-23-first-application-manifest.yaml).
- [Package the sample app as a Helm chart](../07-kubernetes/06-helm-package-app.md) — the sample app packaged as a chart with values per environment; you will point ArgoCD at a copy of this app running in Git.
- [Undo mistakes and recover lost work](../03-version-control/05-git-recover-reflog.md) — how `git revert` creates a new commit that undoes an earlier one without rewriting shared history; that revert is the rollback mechanism this lesson uses.
- ArgoCD installed and reachable: the `argocd` CLI (`argocd version`) and the ArgoCD API server running on your cluster, carried over from the previous lesson. A local cluster (kind or minikube) with kubectl configured.
- Git installed; confirm with `git --version`.

## Walkthrough

### 1. Create a Git repo with the sample app manifests

Create a local repo holding a Deployment for the sample app (the same guestbook-style app from the previous lesson):

```bash
cd /tmp
rm -rf gitops-demo && mkdir gitops-demo && cd gitops-demo
git init -b main
mkdir -p manifests
cat > manifests/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-demo
  labels:
    app: web-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web-demo
    template:
      metadata:
        labels:
          app: web-demo
      spec:
        containers:
        - name: web
          image: ghcr.io/argoproj/argocd-example-apps/guestbook:v1
          ports:
          - containerPort: 3000
EOF
git add manifests/deployment.yaml && git commit -m "add web-demo deployment"
git log --oneline
```

You should see: one commit on `main` (`add web-demo deployment`).

Now create a GitHub repository (or any remote ArgoCD can reach), add it as `origin`, and push:

```bash
git remote add origin https://github.com/<you>/gitops-demo.git
git branch -M main
git push -u origin main
```

Replace `<you>` with your GitHub user or org.

### 2. Point an ArgoCD Application at the app in Git

Write an Application manifest that tells ArgoCD where the app lives in Git:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: web-demo
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/<you>/gitops-demo.git
    targetRevision: main
    path: manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Replace `<you>` with your GitHub user or org, then apply it:

```bash
kubectl apply -f web-demo-application.yaml
argocd app wait web-demo --health --timeout 120
argocd app get web-demo
```

You should see: `application.argoproj.io/web-demo created`, then ArgoCD reports `Sync status: Synced` and `Health: Healthy`, and `argocd app get` shows the Deployment running the `v1` image.

### 3. Change the image tag in Git and watch the cluster follow

Bump the image tag in `manifests/deployment.yaml` from `v1` to `v2`, then commit and push:

```bash
git commit -am "bump image to v2"
git push
argocd app get web-demo
kubectl get deployment web-demo -o jsonpath='{.spec.template.spec.containers[0].image}'
```

You should see: ArgoCD briefly reports `OutOfSync`, then `Synced`; `kubectl` prints the container image ending in `guestbook:v2`. The cluster now matches the new image you pushed to Git.

### 4. Roll back by reverting the commit

A bad image was deployed, so roll back by reverting the commit that bumped it — the same revert pattern from the Git recovery lesson. This adds a new commit rather than rewriting history, which is safe for a shared repo:

```bash
git revert HEAD --no-edit
git push
argocd app wait web-demo --health --timeout 120
kubectl get deployment web-demo -o jsonpath='{.spec.template.spec.containers[0].image}'
argocd app history web-demo
```

You should see: a new `Revert "bump image to v2"` commit; ArgoCD syncs back to the previous image; `kubectl` prints the image ending in `guestbook:v1` again; and `argocd app history` lists the deployments ArgoCD has run.

## Exercise

Do the full flow on your own against a fresh repo:

1. Create a Git repo with the web-demo Deployment (and a Service if you like), push it, and create an ArgoCD Application pointing at it; wait for Healthy.
2. Change the image tag to a new version, commit and push; confirm ArgoCD syncs the new image (check `argocd app get` and `kubectl`).
3. Revert the image-tag commit (`git revert HEAD --no-edit`), push, and confirm the cluster is back to the previous image.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
argocd app get web-demo
kubectl get deployment web-demo -o jsonpath='{.spec.template.spec.containers[0].image}'
git log --oneline -3
```

You should see: Sync status `Synced` and Health `Healthy`; the container image shows the version you reverted back to (`...guestbook:v1`, not the bumped `v2`); and `git log` shows three commits — the original, the bump, and the revert — proving the rollback happened in Git.

## Common mistakes

- Editing the image live with `kubectl set image` instead of in Git — ArgoCD self-heals back to Git on the next sync, so your change disappears. Always change Git first.
- Committing without pushing — ArgoCD only sees pushed commits, so the cluster stays on the old image until you push.
- Reverting the wrong commit — run `git log --oneline` first so you revert the image-bump commit, not the original deployment.

## Next

[Monitoring and observability concepts](../../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md)

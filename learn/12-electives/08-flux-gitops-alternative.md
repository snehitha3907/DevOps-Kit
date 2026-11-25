---
last_verified: 2026-11-25
tool_version: n/a
sources: []
---

# The GitOps setup again, with Flux

In the previous electives lesson you built a VPC with Pulumi's `awsx` component — infrastructure described in code and applied to a cloud account. This lesson re-creates that same "desired state in Git" idea with Flux CD: you declare the sample app you want running (a Kustomization or HelmRelease) in a Git repo, install Flux on a local cluster, and let Flux pull from Git and converge the cluster to it. You will then contrast that pull-based flow with ArgoCD's sync model from the earlier ArgoCD lesson.

## What you'll learn
- Install the Flux CLI and bootstrap Flux on a local cluster so it watches a Git repo.
- Commit a Kustomization describing the sample app to Git and watch Flux sync it to the cluster.
- Compare Flux's pull-based reconciliation with ArgoCD's application controller, and name when each is the better fit.

## Before you start
- [Deploy from Git with ArgoCD and roll back](../08-gitops/02-argocd-deploy-and-rollback.md) — how a GitOps controller watches manifests in Git and converges the cluster to them; you will use the same mental model with Flux in place of ArgoCD.
- Flux CLI installed; confirm with `flux version`.
- A local cluster (kind or minikube) with `kubectl` configured; confirm with `kubectl cluster-info`.
- Git installed; confirm with `git --version`.
- Companion references you can adapt instead of writing from scratch: `FluxCD/scripts/bootstrap-flux-on-kind.sh` (Flux bootstrap on kind) and `FluxCD/configs/2026-09-30-minimal-gitrepository-and-kustomization.yaml` (a minimal GitRepository plus Kustomization).

## Walkthrough

1. Bootstrap Flux on the local cluster.

   Run the bootstrap helper against your cluster:

   ```bash
   flux bootstrap github --owner=<you> --repository=flux-get-started --branch=main --path=clusters/my-cluster --personal
   ```

   Replace `<you>` with your GitHub user or org. Flux commits its own manifests to the repo under `clusters/my-cluster/` and installs the source, kustomize, helm, and notification controllers.

   You should see: `flux bootstrap` reports success and `kubectl get pods -n flux-system` lists `source-controller`, `kustomize-controller`, `helm-controller`, and `notification-controller` all `Running`.

2. Create a Git repo holding the sample app's desired state.

   Make a local repo with a simple Deployment, then push it to GitHub so Flux can read it:

   ```bash
   cd /tmp
   rm -rf flux-demo && mkdir flux-demo && cd flux-demo
   git init -b main
   mkdir -p apps/web-demo
   cat > apps/web-demo/deployment.yaml <<'EOF'
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
           image: nginx:1.25
           ports:
           - containerPort: 80
   EOF
   git add apps/web-demo/deployment.yaml && git commit -m "add web-demo deployment"
   git remote add origin https://github.com/<you>/flux-demo.git
   git branch -M main
   git push -u origin main
   ```

   You should see: one commit on `main` and a successful push to GitHub.

3. Tell Flux to watch the repo and sync the app.

   Add a GitRepository source and a Kustomization that points at the app folder:

   ```bash
   flux create source git flux-demo \
     --url=https://github.com/<you>/flux-demo.git \
     --branch=main \
     --interval=1m

   flux create kustomization web-demo \
     --source=flux-demo \
     --path=apps/web-demo \
     --prune=true \
     --health-check="Deployment/web-demo.flux-demo" \
     --interval=1m
   ```

   Replace `<you>` with your GitHub user or org.

   You should see: both resources created (`GitRepository.source.toolkit.fluxcd.io/flux-demo created`, `Kustomization.kustomize.toolkit.fluxcd.io/web-demo created`).

4. Confirm Flux converged the cluster.

   ```bash
   flux get kustomization web-demo
   kubectl get deployment web-demo
   ```

   You should see: the Kustomization reports `Ready` and `AppliedRevision` set, and `kubectl` shows the `web-demo` Deployment running `nginx:1.25` with one available replica.

## Exercise

Do the full flow on your own against a fresh cluster and repo:

1. Bootstrap Flux on your cluster (`flux bootstrap` or the `FluxCD/scripts/bootstrap-flux-on-kind.sh` reference).
2. Create a Git repo with the sample app's Deployment (and a Service if you like), push it, and point Flux at it with a GitRepository source and a Kustomization.
3. Confirm the Deployment is running and matches what you committed.
4. Change the image tag in Git, commit and push; wait for Flux to reconcile and confirm the cluster rolled out the new image.
5. Write a short comparison (3–4 sentences) of Flux's pull-based reconciliation versus ArgoCD's sync-from-Git model: what each does automatically, what you trigger manually, and when you would pick one over the other.

Record each result yourself — no solution is provided.

## Check your work

```bash
flux get sources git flux-demo                                  # GitRepository source present
flux get kustomization web-demo                                 # Ready, AppliedRevision set
kubectl get deployment web-demo -o jsonpath='{.spec.template.spec.containers[0].image}'  # image you committed
kubectl rollout status deployment/web-demo                      # rollout complete
```

You should see: the GitRepository source lists your repo URL, the Kustomization is `Ready`, `kubectl` prints the image you pushed, and `rollout status` reports `successfully rolled out`.

## Common mistakes

- Forgetting to push to GitHub — Flux only sees pushed commits, so the cluster stays on the old state until you push.
- Pointing the Kustomization `--path` at the repo root instead of the app folder — Flux tries to apply every manifest it finds and reports errors for unrelated files.
- Assuming Flux pushes like ArgoCD — Flux pulls from Git on its own interval; changes appear after the next reconciliation, not instantly on `git push`.

## Next

[Ship metrics to Grafana Cloud](09-grafana-cloud-shipping.md)

---
last_verified: 2026-11-18
tool_version: n/a
sources: []
---
# Package the sample app as a Helm chart

In the previous lesson you ran the sample app on Kubernetes as a Deployment with health probes, resource requests and limits, and an autoscaler. Applying those raw manifests one by one is tedious and hard to reproduce across environments. This lesson shows you how to package the same app as a Helm chart — templates plus a values file — then install it into staging and production with different values, upgrade a release, and roll it back when something goes wrong.

## What you'll learn

- Turn the app's manifests into a Helm chart with values per environment.
- Upgrade a running release and roll it back to a previous revision.

## Before you start

- [Helm — quick primer](../../Helm/notes/0000-primer-helm.md) — what a chart, release, and values.yaml are, and that `helm install` creates a tracked release.
- [Probes, resource limits and autoscaling](04-k8s-probes-limits-hpa.md) — the sample app Deployment (nginx on port 80 with health probes and resource requests/limits) running on a local cluster.
- Helm installed; confirm with `helm version`. A local cluster (kind or minikube) with kubectl configured, carried over from the previous lesson.

## Walkthrough

1. Scaffold the chart.

   Create a new chart called `web-demo`:

   ```bash
   helm create web-demo
   ```

   You should see: `helm create` prints the new chart directory and its files (Chart.yaml, values.yaml, and a templates/ folder).

   Open `web-demo/Chart.yaml` and set the name and description:

   ```yaml
   apiVersion: v2
   name: web-demo
   description: The sample app packaged as a Helm chart
   type: application
   version: 0.1.0
   appVersion: "1.0.0"
   ```

   Replace `web-demo/templates/deployment.yaml` with the sample app Deployment, using Helm templates for the replica count, image, and resources:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: {{ .Release.Name }}-demo
     labels:
       app: web-demo
       release: {{ .Release.Name }}
   spec:
     replicas: {{ .Values.replicaCount }}
     selector:
       matchLabels:
         app: web-demo
         release: {{ .Release.Name }}
     template:
       metadata:
         labels:
           app: web-demo
           release: {{ .Release.Name }}
       spec:
         containers:
         - name: demo
           image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
           imagePullPolicy: {{ .Values.image.pullPolicy }}
           ports:
           - containerPort: 80
             name: http
           livenessProbe:
             httpGet:
               path: /health
               port: http
             initialDelaySeconds: 15
             periodSeconds: 20
           readinessProbe:
             httpGet:
               path: /health
               port: http
             initialDelaySeconds: 5
             periodSeconds: 10
           resources:
             {{- toYaml .Values.resources | nindent 12 }}
   ```

   Replace `web-demo/templates/service.yaml` with a ClusterIP Service:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: {{ .Release.Name }}-demo
     labels:
       app: web-demo
       release: {{ .Release.Name }}
   spec:
     type: {{ .Values.service.type }}
     ports:
     - port: {{ .Values.service.port }}
       targetPort: http
       protocol: TCP
       name: http
     selector:
       app: web-demo
       release: {{ .Release.Name }}
   ```

   Edit `web-demo/values.yaml` to carry the defaults:

   ```yaml
   replicaCount: 1
   image:
     repository: nginx
     pullPolicy: IfNotPresent
   service:
     type: ClusterIP
     port: 80
   resources:
     limits:
       cpu: 250m
       memory: 256Mi
     requests:
       cpu: 100m
       memory: 128Mi
   ```

   Note: I left the image tag off the default so environments supply their own; environments override keys through their own values files.

2. Validate and preview the rendered manifests.

   ```bash
   helm lint web-demo
   helm template web-demo ./web-demo
   ```

   You should see: `helm lint` reports no issues, and `helm template` prints the rendered Deployment and Service YAML with your values substituted (for example, `replicas: 1` and `image: "nginx"`).

   Reference: the existing chart `../../Helm/manifests/demo-chart/` shows the same template pattern with staging and production values overlays — read it to compare how environment-specific keys are layered.

3. Add per-environment values files.

   Create `web-demo/values-staging.yaml`:

   ```yaml
   replicaCount: 2
   image:
     tag: staging
   ```

   Create `web-demo/values-production.yaml`:

   ```yaml
   replicaCount: 3
   image:
     tag: production
   resources:
     requests:
       cpu: 200m
       memory: 256Mi
     limits:
       cpu: 500m
       memory: 512Mi
   ```

   Each environment file carries only the keys that differ from `values.yaml`; later `-f` files win, so staging and production stay small deltas over the defaults.

4. Install the chart into two environments.

   ```bash
   helm install web-demo-staging ./web-demo -f web-demo/values-staging.yaml
   helm install web-demo-prod ./web-demo -f web-demo/values-production.yaml
   ```

   You should see: both releases installed, each named `web-demo-staging` and `web-demo-prod`, with the chart rendered into the cluster. Confirm with:

   ```bash
   helm list
   kubectl get deployment -l app=web-demo
   ```

   You should see: two Deployments, `web-demo-staging-demo` with 2 replicas and `web-demo-prod-demo` with 3 replicas, matching their values files.

5. Upgrade a release.

   Change staging to run 3 replicas by editing `web-demo/values-staging.yaml` (`replicaCount: 3`), then upgrade:

   ```bash
   helm upgrade web-demo-staging ./web-demo -f web-demo/values-staging.yaml
   ```

   You should see: Helm reports the release was updated, and `kubectl get deployment web-demo-staging-demo` now shows 3 desired replicas. Helm keeps every release as a revision you can inspect later.

6. Roll back a release.

   Suppose the upgrade introduced a bad image tag. Roll staging back to its previous revision:

   ```bash
   helm rollback web-demo-staging 1
   ```

   You should see: Helm rolled the release back to revision 1, and `kubectl get deployment web-demo-staging-demo` is back to 2 replicas. Check the history with `helm history web-demo-staging` to see each revision and when it was deployed.

## Exercise

Do the full flow on your own against a fresh cluster, using a different release name:

1. Scaffold a chart named `my-app` with `helm create`.
2. Edit `Chart.yaml`, `templates/deployment.yaml`, `templates/service.yaml`, and `values.yaml` so the chart deploys the sample app (nginx on port 80, with liveness and readiness probes on /health and CPU/memory requests and limits).
3. Add `values-staging.yaml` (2 replicas) and `values-production.yaml` (3 replicas).
4. Install the chart twice as `my-app-staging` and `my-app-prod`, each with its own values file.
5. Upgrade `my-app-staging` to 3 replicas and confirm the Deployment reflects the change.
6. Roll `my-app-staging` back to revision 1 and confirm the replica count returns to 2.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
helm list
helm history my-app-staging
kubectl get deployment -l app=web-demo
kubectl get deployment my-app-staging-demo
kubectl get deployment my-app-prod-demo
```

You should see: two releases in `helm list`; `helm history` listing at least two revisions for `my-app-staging`; the staging Deployment back at 2 replicas after the rollback; and the production Deployment at 3 replicas.

## Common mistakes

- Installing the same chart twice with the same release name fails because the release already exists — use a distinct release name per environment, or `helm upgrade` instead of a second `helm install`.
- Forgetting `-f values-staging.yaml` on install or upgrade makes Helm fall back to `values.yaml`, so your environment-specific replica count and image tag are silently ignored.
- A typo in a template (for example wrong indentation under `resources:`) makes `helm lint` fail and `helm template` emit invalid YAML; fix the template before installing.
- `helm rollback` takes the release name first, then the revision number — swapping them targets the wrong release.

## Next

[ArgoCD — quick primer](../../ArgoCD/notes/0000-primer-argocd.md)

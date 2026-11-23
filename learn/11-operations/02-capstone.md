---
last_verified: 2026-11-23
tool_version: 1.37.2
sources:
  - https://dl.k8s.io/release/stable.txt
  - https://github.com/hashicorp/terraform/releases/tag/v1.17.2
  - https://github.com/aquasecurity/trivy/releases/tag/v0.76.2
  - https://github.com/argoproj/argo-cd/releases/tag/v3.6.2
  - https://github.com/prometheus/prometheus/releases/tag/v3.16.0
  - https://github.com/grafana/grafana/releases/tag/v13.3.1
  - https://github.com/grafana/k6/releases/tag/v2.4.0
  - https://developer.hashicorp.com/terraform/cli/commands/destroy
---

# Capstone: ship the sample app end to end

In [Run an incident drill with a runbook](01-incident-drill.md) you practiced turning an alert into a rollback. Every other lesson in this path built one piece of the delivery pipeline — Terraform state, container images, GitOps, observability, supply-chain scanning. This capstone runs them as one flow: a Git commit provisions the infrastructure, builds and scans the image, deploys the app, and a load test proves it meets its SLO; a second commit tears it all down. Nothing is done from a cloud console.

## What you'll learn

- Provision infrastructure, build, scan and deploy the app through Git only
- Meet the SLO under a load test and pass the acceptance checks
- Tear everything down

## Before you start

- [Run an incident drill with a runbook](01-incident-drill.md) — the runbook and rollback steps you reuse if a deploy fails.
- [Plan and apply Terraform from CI with OIDC](../06-iac-and-cloud/08-terraform-in-ci.md) — OIDC auth, plan on PR, apply on merge.
- [SBOMs and image policy in the pipeline](../10-security/01-supply-chain-in-ci.md) — CycloneDX SBOM and the digest scan gate.
- [Trace one request with OpenTelemetry](../09-observability/06-otel-trace-request.md) — tracing one request from the app into the database.
- [Define an SLO and alert on its burn rate](../09-observability/05-slo-and-burn-rate.md) — the burn-rate alerts this capstone must keep green.
- Kubernetes 1.37.2: `kubectl version --client`; a local cluster via kind 0.33.0 (`kind version`) or minikube 1.39.0 (`minikube version`).
- Docker Engine 29.10.0: `docker --version`; Terraform 1.17.2: `terraform version`; Helm 4.3.2: `helm version`; Trivy 0.76.2: `trivy version`; k6 2.4.0: `k6 version`.
- The sample app repo, Helm chart, Terraform module, and GitHub Actions workflows carried over from the earlier lessons; a container registry you can push to.
- Reference manifests: [`Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml`](../../Kubernetes/manifests/production-deployment-hpa-pdb-networkpolicies.yaml), [`Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/`](../../Kubernetes/templates/k8s-deployment-helm-chart-kustomize-overlay/), and [`Kubernetes/scripts/rollout-status-and-pod-readiness.sh`](../../Kubernetes/scripts/rollout-status-and-pod-readiness.sh).

## Walkthrough

### 1. Write down the acceptance checks first

Before changing anything, list what "done" means so every later step has a target.

- Trivy exits 0 on the image digest (no HIGH/CRITICAL unfixed findings).
- The ArgoCD Application reports `Synced` and `Healthy`.
- `GET /health` returns 200.
- Prometheus reports `up{job="sample-app"} == 1`.
- The burn-rate alert does not fire during the k6 run.
- After teardown, `terraform plan` reports no changes and `kubectl get all` is empty.

If any of these is false at the end, the capstone is not done.

### 2. Provision the infrastructure from a pull request

Use the Terraform module and the OIDC workflow from the Terraform lesson. Open a pull request that changes `infra/`:

```bash
cd infra
terraform fmt -check
terraform init
terraform plan -out=tfplan
```

You should see: Terraform initialises, plans the resources, and writes `tfplan` with no errors. In CI the plan is posted on the PR; merging to `main` runs `terraform apply -input=false -auto-approve tfplan` with the OIDC-assumed role.

Verify the cluster and cloud resources exist before moving on:

```bash
terraform output
kubectl get nodes
```

You should see: Terraform outputs (registry URL, cluster name, role ARN) and nodes in `Ready`. The image registry and IAM role now exist, and no long-lived cloud keys were stored in GitHub.

### 3. Build, scan, and publish the image from Git

A push to `main` (or a release tag) triggers the build job. It builds the image tagged with the commit SHA, scans by digest, generates an SBOM, and pushes only if the gate passes:

```bash
docker build -t "$REGISTRY/sample-app:$GITHUB_SHA" .
docker push "$REGISTRY/sample-app:$GITHUB_SHA"
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' "$REGISTRY/sample-app:$GITHUB_SHA" | cut -d@ -f2)
trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 \
  "$REGISTRY/sample-app@sha256:$DIGEST"
trivy image --format cyclonedx --output sbom.cdx.json --scanners vuln \
  "$REGISTRY/sample-app:$GITHUB_SHA"
```

You should see: the digest scan exits 0 on a clean image, `sbom.cdx.json` is written and parses as JSON, and the image is in the registry under both the SHA tag and its digest. If the scan exits non-zero, the workflow stops and ArgoCD never sees a new tag.

### 4. Deploy the chart with ArgoCD

Install ArgoCD 3.6.2 into the cluster:

```bash
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.6.2/manifests/install.yaml
```

You should see: the ArgoCD pods become Ready. Then create an Application pointing at the Helm chart in Git:

```bash
kubectl apply -f sample-app-application.yaml
argocd app wait sample-app --health --timeout 300
argocd app get sample-app
```

where `sample-app-application.yaml` is:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sample-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/OWNER/REPO.git
    targetRevision: main
    path: charts/sample-app
  destination:
    server: https://kubernetes.default.svc
    namespace: sample-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

You should see: `Sync status: Synced` and `Health: Healthy`, and the Deployment running the image tagged with the commit SHA from step 3. ArgoCD now converges the cluster to whatever image tag sits in Git.

### 5. Confirm the app is observed

Prometheus scrapes the app and the burn-rate rules are loaded. Check the target and the SLO:

```bash
# Prometheus target is up
curl -s http://localhost:9090/api/v1/query?query=up%7Bjob%3D%22sample-app%22%7D

# Health endpoint
kubectl port-forward -n sample-app svc/sample-app 8080:80 &
PF_PID=$!
sleep 2
curl -sf http://localhost:8080/health
kill $PF_PID
```

You should see: the Prometheus query returns `1` for the sample-app target, and `/health` returns 200. The Grafana dashboard from the dashboard lesson plots request rate, error rate, and latency; the OpenTelemetry collector from the tracing lesson shows the app-to-database span with one shared trace ID.

### 6. Run the load test with k6

Save a small k6 script (thresholds on latency and error rate) and run it against the app:

```bash
k6 run --vus 20 --duration 2m k6/capstone.js
```

You should see: k6 reports the `http_req_duration` and error-rate thresholds as `✓` (passed) and exits 0. While it runs, watch the burn-rate alert in Prometheus/Alertmanager: it must stay inactive. If a threshold fails, raise the HPA max replicas or the container CPU limit, commit the change, let ArgoCD sync, and rerun.

A minimal `k6/capstone.js`:

```js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 20,
  duration: '2m',
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  const res = http.get('http://localhost:8080/');
  check(res, { 'status is 200': (r) => r.status === 200 });
  sleep(0.1);
}
```

### 7. Tear everything down

Delete the ArgoCD Application first (prunes the cluster resources), then destroy the cloud infrastructure:

```bash
argocd app delete sample-app --cascade
terraform -chdir=infra destroy -auto-approve
```

Then delete the local cluster:

```bash
kind delete cluster --name lesson-cluster
# or: minikube delete
```

Verify nothing is left:

```bash
terraform -chdir=infra plan
kubectl get all -A
docker ps
```

You should see: `terraform plan` reports "No changes", `kubectl get all -A` shows only kube-system, and `docker ps` shows no kind/minikube containers. The capstone is complete.

## Exercise

Run the full flow on your own against a fresh cluster and repo:

1. Open a PR that changes `infra/`; merge it and confirm `terraform apply` creates the registry, IAM role, and cluster.
2. Push a commit that changes the app; confirm the build, digest scan, and SBOM step pass and the image lands in the registry.
3. Bump the image tag in the Helm chart values, commit and push; confirm ArgoCD syncs and reports `Synced`/`Healthy`.
4. Run the k6 load test and confirm both thresholds pass and the burn-rate alert stays inactive.
5. Break something on purpose (bad image tag) and use the incident runbook to roll back; confirm recovery.
6. Tear down with `argocd app delete`, `terraform destroy`, and cluster deletion; confirm the acceptance checks from step 1 of the Walkthrough.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
# Image scanned clean
trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 \
  "REGISTRY/sample-app@sha256:<digest>"
echo $?

# ArgoCD healthy
argocd app get sample-app

# Health and Prometheus target
kubectl port-forward -n sample-app svc/sample-app 8080:80 &
PF_PID=$!
sleep 2
curl -sf http://localhost:8080/health
kill $PF_PID

# Load test thresholds pass
k6 run --vus 20 --duration 2m k6/capstone.js

# Teardown verified
terraform -chdir=infra plan
kubectl get all -A
```

You should see: Trivy exits 0; ArgoCD reports `Synced` and `Healthy`; `/health` returns 200; k6 exits 0 with both thresholds marked `✓`; after teardown, `terraform plan` reports no changes and `kubectl get all -A` shows only kube-system.

## Common mistakes

- Skipping the digest scan and scanning a mutable tag — the image can change between scan and deploy; always scan `name@sha256:...`.
- Applying Terraform locally instead of from CI — defeats the "through Git only" goal and leaves no audit trail; keep `terraform apply` in the workflow.
- Editing the image with `kubectl set image` — ArgoCD self-heals back to Git; change the tag in Git first.
- Forgetting to delete the ArgoCD Application before `terraform destroy` — orphaned cluster resources survive the destroy; prune first.
- Leaving the local cluster running — `kind delete cluster` / `minikube delete` is the last teardown step; confirm with `docker ps`.
- Declaring success while the burn-rate alert is firing — the SLO is the acceptance check, not just a green rollout.

## Next

[Azure — quick primer](../../Azure/notes/0000-primer-azure.md)

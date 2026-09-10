---
last_verified: 2026-08-29
tool_version: n/a
sources: []
---

# Integrating Kubernetes with Prometheus for production monitoring

## Purpose

Kubernetes clusters are dynamic: pods are created and destroyed, IPs change, and services scale up and down. Prometheus discovers and scrapes these moving targets through Kubernetes service-discovery mechanisms rather than static configuration. This document describes how to wire Prometheus into a Kubernetes cluster so that it automatically tracks workloads and collects metrics without manual target management.

## When to use

- Production clusters where workloads change frequently (deployments, statefulsets, jobs)
- Multi-tenant environments where each team owns a set of services
- GitOps workflows where manifests are applied continuously and monitoring must follow
- Any setup where hard-coding static targets would require constant updates

## Prerequisites

- A running Kubernetes cluster
- Prometheus server deployed inside or outside the cluster with network access to the API server
- kubectl configured for the target cluster
- RBAC permissions to read pods, services, endpoints, and nodes (or a ServiceAccount with those rights)

## Steps

### 1. Grant Prometheus read access to the Kubernetes API

Prometheus queries the Kubernetes API to discover pods, services, and nodes. Create a ClusterRole and ClusterRoleBinding that allows read access to the resources Prometheus needs:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources: ["nodes", "pods", "services", "endpoints"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["extensions", "networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: monitoring
```

### 2. Configure Prometheus scrape configs for Kubernetes service discovery

In `prometheus.yml`, add a `kubernetes_sd_configs` block that tells Prometheus where to look for targets. The `role` field controls which Kubernetes objects become scrape targets:

```yaml
scrape_configs:
- job_name: 'kubernetes-pods'
  kubernetes_sd_configs:
  - role: pod
  relabel_configs:
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
  - source_labels: [__address__]
    action: replace
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
    target_label: __address__
```

Common roles include `pod`, `service`, `endpoints`, `node`, and `ingress`.

### 3. Annotate workloads for automatic scraping

Instead of hard-coding targets in Prometheus, annotate pods or services with Prometheus-specific annotations. Prometheus uses these annotations to decide whether to scrape a target and where to find the metrics endpoint:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
        prometheus.io/path: "/metrics"
    spec:
      containers:
      - name: my-app
        image: my-app:latest
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
```

### 4. Add recording and alerting rules

Prometheus alerting rules can be stored as Kubernetes custom resources when using the Prometheus Operator, or as plain YAML files mounted into Prometheus. The Operator exposes `PrometheusRule` objects:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: high-error-rate
  namespace: monitoring
  labels:
    prometheus: k8s
    role: alert-rules
spec:
  groups:
  - name: general
    rules:
    - alert: HighErrorRate
      expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
      for: 2m
      labels:
        severity: critical
      annotations:
        summary: "High error rate detected"
        description: "{{ $labels.pod }} has a 5xx rate of {{ $value }}"
```

## Verify

After applying manifests and restarting Prometheus, open the Prometheus UI and navigate to **Status > Targets**. Every annotated pod or service should appear with a state of `UP`. Filter by the job name you configured to isolate Kubernetes-discovered targets.

```bash
# Port-forward Prometheus for local access
kubectl port-forward -n monitoring svc/prometheus 9090:9090
```

In the UI, run a PromQL query against one of your Kubernetes-discovered targets:

```
up{job="kubernetes-pods"}
```

A non-empty result set confirms that Prometheus is successfully scraping pods.

## Common errors

- **RBAC is too permissive or too restrictive** — Prometheus needs `get`, `list`, and `watch` on pods, services, endpoints, and nodes. A ClusterRole that omits `watch` causes the target list to appear empty because Prometheus cannot track changes.
- **NetworkPolicy blocks API server access** — if the cluster uses NetworkPolicy, ensure the Prometheus pod can reach the Kubernetes API server endpoint (usually `kubernetes.default.svc`).
- **Selector mismatch in ServiceMonitor or PodMonitor** — when using the Prometheus Operator, the `selector` in a `ServiceMonitor` must match the labels on the actual Service. A mismatch causes the target to be silently ignored.
- **Port and path annotations missing** — without `prometheus.io/scrape: "true"`, Prometheus ignores the pod entirely. Without `prometheus.io/port`, it defaults to port 9090, which is often wrong.
- **Metrics path collision** — some applications expose metrics on a different path than `/metrics`. If the `prometheus.io/path` annotation is missing or wrong, Prometheus returns 404 for every scrape attempt.

## References

- Prometheus Kubernetes service discovery documentation
- Prometheus Operator custom resource definitions
- Kubernetes RBAC authorization documentation

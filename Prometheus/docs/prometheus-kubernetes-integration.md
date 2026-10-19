---
last_verified: 2026-10-19
tool_version: n/a
sources: []
---

# Prometheus integration with Kubernetes: service discovery, pod annotations, kube-state-metrics, and managed Prometheus differences

## Purpose

This document describes how Prometheus discovers and scrapes targets in a Kubernetes cluster. It covers the built-in service discovery mechanisms, the role of pod annotations for scrape configuration, the kube-state-metrics add-on for cluster-level metrics, and the key differences when using a managed Prometheus service (Amazon Managed Service for Prometheus, Google Cloud Managed Service for Prometheus, Azure Managed Prometheus) versus a self-hosted deployment.

## When to use

- Configuring Prometheus to monitor workloads running in Kubernetes
- Understanding what metrics are available from the Kubernetes API without custom instrumentation
- Evaluating managed Prometheus offerings against a self-hosted stack
- Troubleshooting missing targets or unexpected scrape behavior in a cluster

## Prerequisites

- A Kubernetes cluster (current stable version recommended for current API versions)
- Prometheus (current stable version, self-hosted) or access to a managed Prometheus endpoint
- `kubectl` access with permissions to read pods, services, endpoints, nodes, and custom resources
- Basic familiarity with Prometheus scrape configuration and relabeling

## Steps

### 1. Kubernetes service discovery roles

Prometheus uses the `kubernetes_sd_config` block with one of five roles. Each role queries a different API endpoint and produces a distinct label set.

| Role | API resource | Typical use case | Key labels produced |
|------|--------------|------------------|---------------------|
| `node` | `Node` | Node-exporter, kubelet, cAdvisor metrics | `__meta_kubernetes_node_name`, `__meta_kubernetes_node_label_<name>` |
| `pod` | `Pod` | Application pods exposing `/metrics` | `__meta_kubernetes_pod_name`, `__meta_kubernetes_pod_namespace`, `__meta_kubernetes_pod_label_<name>`, `__meta_kubernetes_pod_annotation_<name>` |
| `service` | `Service` | Stable endpoints for headless or ClusterIP services | `__meta_kubernetes_service_name`, `__meta_kubernetes_service_namespace`, `__meta_kubernetes_service_label_<name>`, `__meta_kubernetes_service_annotation_<name>` |
| `endpoints` | `Endpoints` / `EndpointSlice` | Per-pod IPs behind a Service (more granular than `service`) | `__meta_kubernetes_endpoints_*`, `__meta_kubernetes_endpoint_*` |
| `ingress` | `Ingress` | TLS certificate expiry, path-based scrape targets | `__meta_kubernetes_ingress_name`, `__meta_kubernetes_ingress_namespace`, `__meta_kubernetes_ingress_label_<name>` |

A minimal scrape config using the `pod` role:

```yaml
scrape_configs:
  - job_name: kubernetes-pods
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
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        action: replace
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_pod_name]
        action: replace
        target_label: kubernetes_pod_name
```

### 2. Pod annotations for scrape control

The standard annotation convention (used by the relabel config above) lets pod authors opt in without cluster-admin involvement.

| Annotation | Purpose | Example |
|------------|---------|---------|
| `prometheus.io/scrape` | Set to `true` to enable scraping | `"true"` |
| `prometheus.io/port` | Port name or number where `/metrics` is exposed | `"9090"` or `"http-metrics"` |
| `prometheus.io/path` | Metrics path if not `/metrics` | `"/metrics/custom"` |
| `prometheus.io/scheme` | `http` or `https` (default: `http`) | `"https"` |
| `prometheus.io/param_<name>` | Query parameters to append | `prometheus.io/param_timeout: "10s"` |

For HTTPS scrape targets, the pod must also present a certificate trusted by Prometheus (either a public CA or a CA configured in the scrape config's `tls_config`).

### 3. kube-state-metrics: cluster-object metrics

kube-state-metrics (KSM) watches Kubernetes API objects and exposes their state as Prometheus metrics. It does not collect resource usage (CPU, memory) — that comes from cAdvisor or the kubelet summary API.

Key metric families (abridged):

| Metric family | Type | Description |
|---------------|------|-------------|
| `kube_pod_info` | Gauge | Pod metadata: name, namespace, uid, node, labels, annotations |
| `kube_pod_status_phase` | Gauge | Pod phase (Pending, Running, Succeeded, Failed, Unknown) |
| `kube_pod_container_status_running` | Gauge | Container running state (1 = running) |
| `kube_pod_container_status_restarts_total` | Counter | Container restart count |
| `kube_deployment_status_replicas` | Gauge | Desired, available, ready, updated replicas |
| `kube_daemonset_status_number_ready` | Gauge | DaemonSet ready pod count |
| `kube_statefulset_status_replicas` | Gauge | StatefulSet replica counts |
| `kube_node_status_condition` | Gauge | Node conditions (Ready, MemoryPressure, DiskPressure, PIDPressure) |
| `kube_node_spec_taint` | Gauge | Node taints with key/effect labels |
| `kube_persistentvolume_info` | Gauge | PV metadata: capacity, storage class, reclaim policy |
| `kube_persistentvolumeclaim_info` | Gauge | PVC metadata: namespace, storage class, volume name |

Deploy KSM in the cluster (typically via Helm or the provided manifests) and add a scrape config for its Service:

```yaml
scrape_configs:
  - job_name: kube-state-metrics
    kubernetes_sd_configs:
      - role: service
        namespaces:
          names: [monitoring]
    relabel_configs:
      - source_labels: [__meta_kubernetes_service_name]
        action: keep
        regex: kube-state-metrics
```

KSM (current stable) requires a recent Kubernetes version. The metrics endpoint is `/metrics` on port 8080 by default.

### 4. Managed Prometheus: what changes

Managed Prometheus services remove the operational burden of running the Prometheus server (storage, compaction, HA, upgrades) but impose constraints on service discovery and ingestion.

| Aspect | Self-hosted Prometheus | Amazon Managed Service for Prometheus (AMP) | Google Cloud Managed Service for Prometheus | Azure Managed Prometheus |
|--------|------------------------|---------------------------------------------|---------------------------------------------|--------------------------|
| **Service discovery** | Full `kubernetes_sd_config` support | Supported via Prometheus Agent / OpenTelemetry Collector | Supported via OTEL Collector (GMP operator) | Supported via Azure Monitor metrics addon / OTEL Collector |
| **Remote write** | Optional | Required (only ingestion path) | Required (only ingestion path) | Required (only ingestion path) |
| **Remote read** | Native | Supported (query via AMP workspace) | Supported (query via PromQL API) | Supported (query via Azure Monitor) |
| **Retention** | Configurable locally | 150 days default, up to 3 years | 30 days default, up to 13 months | 30 days default, configurable |
| **HA / replication** | Manual (Thanos, Cortex, Mimir) | Built-in (multi-AZ) | Built-in (regional) | Built-in (zone-redundant) |
| **Alertmanager** | Co-located or separate | External (bring your own) | External (bring your own) | Integrated (Azure Monitor alerts) or external |
| **Rule evaluation** | Local | Local (in agent/collector) or remote | Remote (in managed control plane) | Remote (in managed control plane) |
| **Cost model** | Infrastructure + ops | Per metric sample ingested + stored | Per metric sample ingested + stored | Per metric sample ingested + stored |

#### 4.1 Ingestion via remote write

All three managed services accept Prometheus remote-write protocol. The typical pattern deploys a Prometheus Agent (or OpenTelemetry Collector) in-cluster that scrapes using standard `kubernetes_sd_config` and forwards via remote write:

```yaml
# Prometheus Agent config (AMP / GMP / Azure)
scrape_configs:
  - job_name: kubernetes-pods
    kubernetes_sd_configs:
      - role: pod
    # ... same relabel_configs as self-hosted ...

remote_write:
  - url: https://aps-workspace.<region>.amazonaws.com/api/v1/remote_write
    sigv4:
      region: <region>
    queue_config:
      max_samples_per_send: 1000
      max_shards: 200
      capacity: 2500
```

For GMP, the `url` points to `https://<region>-prometheus.googleapis.com/api/v1/projects/<project-id>/locations/<region>/workspaces/<workspace-id>/remoteWrite`. For Azure, the endpoint is `https://<workspace-name>.monitoring.azure.com/api/v1/remote-write`.

#### 4.2 Service discovery limitations

- **AMP**: The managed scraper (AWS-distributed OpenTelemetry Collector) supports `pod`, `service`, `endpoints`, `node` roles. Custom relabel configs are passed via a ConfigMap. The `ingress` role is not supported by the managed collector.
- **GMP**: The Google Cloud Managed Prometheus Operator translates `PodMonitoring` and `ServiceMonitoring` CRDs into OTEL Collector config. Arbitrary `kubernetes_sd_config` blocks are not directly supported; use the CRDs instead.
- **Azure**: The Azure Monitor metrics addon uses a DaemonSet collector with fixed discovery rules. Custom scrape targets require the OpenTelemetry Collector addon with a custom config.

#### 4.3 Rule evaluation and alerting

- **AMP**: Rules are evaluated in the agent/collector (local evaluation). Alertmanager runs separately (self-hosted or via a partner integration).
- **GMP**: Rules can be evaluated in the managed control plane (via `PrometheusRule` CRDs synced to the backend) or locally in the collector.
- **Azure**: Rules are evaluated in the Azure Monitor backend. Alerting uses Azure Monitor action groups (email, webhook, ITSM, Logic Apps).

#### 4.4 Cost control

Managed services charge per active time series (ingested samples) and per GB-month stored. Strategies:

- Use `metric_relabel_configs` in the agent/collector to drop high-cardinality labels (e.g., `pod`, `container_id`) before remote write.
- Aggregate at scrape time with recording rules rather than storing raw high-cardinality series.
- Enable `drop` actions for debug-only metrics (`__name__` matching `go_*`, `process_*` unless needed).
- Monitor the `prometheus_remote_write_*` metrics on the agent to track ingestion volume.

## Verify

1. **Target discovery**: In the Prometheus UI (or managed equivalent), navigate to Status → Targets. Confirm the `kubernetes-pods` job shows expected pods with `prometheus.io/scrape: true`. Targets should be `UP` with labels `kubernetes_namespace`, `kubernetes_pod_name`, and pod labels mapped via `labelmap`.

2. **kube-state-metrics**: Query `kube_pod_info` and `kube_deployment_status_replicas`. Verify the metric labels include namespace, pod, deployment, and that values match `kubectl get` output.

3. **Managed ingestion**: For AMP/GMP/Azure, check the agent/collector logs for `remote_write` success (HTTP 2xx). In the managed console, verify the active series count and ingestion rate match expectations. Run a PromQL query against the managed endpoint (e.g., `up{job="kubernetes-pods"}`) and confirm data returns.

4. **Annotation changes**: Add `prometheus.io/scrape: "true"` to a test pod. Within the `scrape_interval` (default 30s), the target should appear in the Targets page without a Prometheus restart.

## Common errors

| Symptom | Likely cause | Resolution |
|---------|--------------|------------|
| Targets show `UNKNOWN` or `DOWN` | Pod port annotation missing or wrong | Set `prometheus.io/port` to the container port name or number |
| Targets missing entirely | `prometheus.io/scrape` not `true` or relabel `keep` regex mismatch | Ensure annotation is exactly `"true"` (string); check relabel regex |
| `kube-state-metrics` metrics absent | KSM not deployed or Service not in monitored namespace | Deploy KSM; ensure scrape config `namespaces` includes its namespace |
| High ingestion bill (managed) | No metric relabeling; pod/container labels create unbounded series | Add `metric_relabel_configs` with `action: labeldrop` for `pod`, `container_id`, `uuid` |
| Rule evaluation lag (managed) | Rules evaluated remotely with default interval | For GMP, reduce `evaluationInterval` in `PrometheusRule`; for AMP, evaluate locally in agent |
| TLS scrape failures | Pod serves HTTPS but CA not trusted by Prometheus | Configure `tls_config.ca_file` in scrape config or use a public CA |
| Managed collector ignores custom relabel | Using CRD-based discovery (GMP) or fixed DaemonSet (Azure) | Migrate to `PodMonitoring`/`ServiceMonitoring` CRDs (GMP) or deploy OTEL Collector with custom config (Azure) |

## References

- Prometheus documentation: Kubernetes service discovery
- Prometheus documentation: Remote write tuning
- kube-state-metrics: Metric list
- AWS AMP: Remote write setup
- Google Cloud Managed Prometheus: Configuration
- Azure Monitor: Managed Prometheus overview
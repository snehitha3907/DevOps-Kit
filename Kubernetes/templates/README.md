# Kubernetes Multi-Cluster Management Scaffold

> Production-ready template for managing multiple Kubernetes clusters with Cluster API, fleet management, and GitOps bootstrap.

## Overview

This scaffold provides a complete foundation for multi-cluster Kubernetes operations using:

- **Cluster API (CAPI)** — declarative cluster lifecycle management across providers
- **ClusterClass & ClusterResourceSet** — fleet-wide configuration and policy enforcement
- **Flux CD** — GitOps continuous delivery for both management and workload clusters
- **Multi-provider support** — AWS (CAPA), Azure (CAPZ), GCP (CAPG), Docker (CAPD)

## Architecture

```
management-cluster/
├── capi-system/              # Cluster API core controllers
├── capa-system/              # AWS infrastructure provider
├── capz-system/              # Azure infrastructure provider
├── capg-system/              # GCP infrastructure provider
├── capd-system/              # Docker infrastructure provider (dev)
├── flux-system/              # Flux CD controllers
├── fleet-management/         # ClusterClass, ClusterResourceSet, policies
└── gitops-bootstrap/         # Flux GitRepository, Kustomization for workload clusters

workload-clusters/
├── clusterclass/             # Reusable cluster definitions (control plane, workers, CNI, CSI)
├── clusters/                 # Individual cluster manifests (one per cluster)
└── cluster-resource-sets/    # Fleet-wide resources (CNI, CSI, monitoring, security)

gitops-bootstrap/
├── flux/                     # Flux CD bootstrap manifests
└── applications/             # Application definitions per environment

examples/
├── aws/                      # AWS EKS-style clusters with CAPA
├── azure/                    # Azure AKS-style clusters with CAPZ
├── gcp/                      # GCP GKE-style clusters with CAPG
└── docker/                   # Local development with CAPD
```

## Prerequisites

- `kubectl` ≥ 1.28
- `clusterctl` ≥ 1.7 (matches CAPI v1.7)
- `flux` CLI ≥ 2.5
- `helm` ≥ 3.13
- Access to target cloud provider (AWS/Azure/GCP) or Docker for local development
- A Git repository for GitOps source of truth

## Quick Start

### 1. Bootstrap Management Cluster

```bash
# Create kind management cluster
kind create cluster --name mgmt --config examples/docker/kind-config.yaml

# Initialize Cluster API providers
clusterctl init --core cluster-api:v1.7.0 \
  --bootstrap kubeadm:v1.7.0 \
  --control-plane kubeadm:v1.7.0 \
  --infrastructure docker:v1.7.0 \
  --infrastructure aws:v1.7.0 \
  --infrastructure azure:v1.7.0 \
  --infrastructure gcp:v1.7.0

# Install Flux CD
flux install --components-extra=image-reflector-controller,image-automation-controller

# Apply fleet management and GitOps bootstrap
kubectl apply -k management-cluster/fleet-management/
kubectl apply -k management-cluster/gitops-bootstrap/
```

### 2. Create a Workload Cluster (AWS Example)

```bash
# Set required environment variables
export AWS_REGION=us-east-1
export AWS_CONTROL_PLANE_MACHINE_TYPE=m6i.large
export AWS_NODE_MACHINE_TYPE=m6i.large
export KUBERNETES_VERSION=1.29.4

# Generate cluster from ClusterClass
clusterctl generate cluster aws-prod \
  --from clusterclass/aws-managed-cluster \
  --kubernetes-version ${KUBERNETES_VERSION} \
  --control-plane-machine-count=3 \
  --worker-machine-count=3 \
  > examples/aws/aws-prod-cluster.yaml

# Review and apply
kubectl apply -f examples/aws/aws-prod-cluster.yaml
```

### 3. Verify GitOps Bootstrap

```bash
# Check Flux synchronization
flux get kustomizations --all-namespaces

# Verify workload cluster registration
kubectl get clusters --all-namespaces
```

## Directory Structure Details

### `management-cluster/`

Core management cluster components:

| Component | Purpose |
|-----------|---------|
| `capi-system/` | Cluster API core controllers (cluster, machine, bootstrap) |
| `capa-system/` | AWS infrastructure provider (EC2, ELB, VPC) |
| `capz-system/` | Azure infrastructure provider (VMSS, Load Balancer, VNet) |
| `capg-system/` | GCP infrastructure provider (GCE, Cloud Load Balancing, VPC) |
| `capd-system/` | Docker infrastructure provider (local development) |
| `flux-system/` | Flux CD controllers (source, kustomize, helm, notification) |
| `fleet-management/` | ClusterClass, ClusterResourceSet, admission policies |
| `gitops-bootstrap/` | Flux GitRepository/Kustomization for workload clusters |

### `workload-clusters/clusterclass/`

Reusable cluster definitions using ClusterClass (CAPI v1.7+):

```
clusterclass/
├── aws-managed-cluster.yaml      # EKS-like: managed control plane, EC2 workers
├── azure-managed-cluster.yaml    # AKS-like: managed control plane, VMSS workers
├── gcp-managed-cluster.yaml      # GKE-like: managed control plane, GCE workers
├── self-managed-cluster.yaml     # Full self-managed (kubeadm) for any provider
└── variables/                    # ClusterClass variable definitions
    ├── aws-variables.yaml
    ├── azure-variables.yaml
    ├── gcp-variables.yaml
    └── common-variables.yaml
```

### `workload-clusters/clusters/`

Individual cluster instances (one file per cluster):

```
clusters/
├── aws-prod.yaml
├── aws-staging.yaml
├── azure-prod.yaml
├── gcp-prod.yaml
└── docker-dev.yaml
```

### `workload-clusters/cluster-resource-sets/`

Fleet-wide resources applied via ClusterResourceSet:

```
cluster-resource-sets/
├── cni-calico.yaml           # Calico CNI for all clusters
├── cni-cilium.yaml           # Cilium CNI alternative
├── csi-aws-ebs.yaml          # AWS EBS CSI driver
├── csi-azure-disk.yaml       # Azure Disk CSI driver
├── csi-gcp-pd.yaml           # GCP Persistent Disk CSI driver
├── monitoring-prometheus.yaml # Prometheus Operator + ServiceMonitors
├── logging-loki.yaml         # Grafana Loki logging stack
├── security-falco.yaml       # Falco runtime security
├── security-kyverno.yaml     # Kyverno policy engine
└── ingress-nginx.yaml        # NGINX Ingress Controller
```

### `gitops-bootstrap/flux/`

Flux CD bootstrap for workload clusters:

```
flux/
├── gitrepository.yaml        # Git source (SSH/HTTPS/OCI)
├── kustomization-mgmt.yaml   # Management cluster self-sync
├── kustomization-fleet.yaml  # Fleet-wide ClusterResourceSet sync
└── kustomization-apps.yaml   # Per-cluster application sync
```

## ClusterClass Variables

Each ClusterClass exposes variables for customization:

| Variable | Description | Default |
|----------|-------------|---------|
| `kubernetesVersion` | Kubernetes version for control plane & workers | `1.29.4` |
| `controlPlaneReplicas` | Number of control plane replicas | `3` |
| `workerReplicas` | Number of worker nodes | `3` |
| `controlPlaneMachineType` | Instance type for control plane | Provider-specific |
| `workerMachineType` | Instance type for workers | Provider-specific |
| `cni` | CNI plugin (calico, cilium) | `calico` |
| `csi` | CSI driver (aws-ebs, azure-disk, gcp-pd) | Provider-specific |
| `enableMonitoring` | Deploy Prometheus stack | `true` |
| `enableLogging` | Deploy Loki stack | `true` |
| `enableSecurity` | Deploy Falco + Kyverno | `true` |

## Provider-Specific Configuration

### AWS (CAPA)

Required IAM permissions for management cluster:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": ["ec2:*", "elasticloadbalancing:*", "iam:CreateServiceLinkedRole"], "Resource": "*" }
  ]
}
```

Set credentials via:
```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...  # if using temporary credentials
```

### Azure (CAPZ)

Required Azure subscription and service principal:

```bash
export AZURE_SUBSCRIPTION_ID=...
export AZURE_TENANT_ID=...
export AZURE_CLIENT_ID=...
export AZURE_CLIENT_SECRET=...
```

### GCP (CAPG)

Required GCP project and service account:

```bash
export GCP_PROJECT=...
export GCP_SERVICE_ACCOUNT_KEY_JSON=...
```

### Docker (CAPD) — Development Only

No cloud credentials required. Uses local Docker daemon.

## Fleet Management Operations

### Apply ClusterResourceSet to All Clusters

```bash
# Label clusters for targeted resource sets
kubectl label cluster aws-prod environment=production
kubectl label cluster aws-staging environment=staging

# ClusterResourceSet uses label selectors for targeting
# See workload-clusters/cluster-resource-sets/ for examples
```

### Rolling Updates Across Fleet

```bash
# Update Kubernetes version in ClusterClass variable
# All clusters using that ClusterClass will roll out
kubectl patch clusterclass aws-managed-cluster \
  --type merge -p '{"spec":{"variables":[{"name":"kubernetesVersion","value":"1.30.0"}]}}'
```

### Drift Detection

```bash
# Flux continuously reconciles; drift appears as OutOfSync
flux get kustomizations --all-namespaces --watch
```

## GitOps Repository Structure

Expected Git repository layout for Flux:

```
gitops-repo/
├── clusters/
│   ├── management/
│   │   ├── flux-system/
│   │   └── fleet-management/
│   ├── aws-prod/
│   │   ├── flux-system/
│   │   ├── infrastructure/
│   │   └── applications/
│   └── azure-prod/
│       ├── flux-system/
│       ├── infrastructure/
│       └── applications/
├── apps/
│   ├── monitoring/
│   ├── logging/
│   └── security/
└── infrastructure/
    ├── cni/
    ├── csi/
    └── ingress/
```

## Verification Checklist

After deployment, verify:

- [ ] Management cluster: `kubectl get pods -n capi-system` — all Running
- [ ] Providers: `kubectl get pods -n capa-system,capz-system,capg-system,capd-system` — all Running
- [ ] Flux: `flux check` — all checks pass
- [ ] Workload cluster: `kubectl get cluster <name> -n <namespace>` — Phase: Provisioned
- [ ] Workload nodes: `kubectl --kubeconfig <workload-kubeconfig> get nodes` — all Ready
- [ ] GitOps sync: `flux get kustomizations --all-namespaces` — all True/Applied

## Rollback Procedures

| Scenario | Procedure |
|----------|-----------|
| Workload cluster failed provisioning | `kubectl delete cluster <name> -n <namespace>` — cleans up all CAPI resources |
| ClusterClass update caused issues | Revert ClusterClass spec; CAPI rolls back machines |
| Flux sync stuck | `flux suspend kustomization <name> -n <ns>` → fix Git → `flux resume` |
| Provider controller crash | Check logs: `kubectl logs -n capa-system -l cluster.x-k8s.io/provider=infrastructure-aws` |

## Common Errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `MachineDeployment` stuck `Pending` | Cloud quota exceeded | Request quota increase or reduce replica count |
| `Cluster` stuck `Provisioning` | CNI/CSI not ready | Verify ClusterResourceSet applied; check CNI pods |
| Flux `GitRepository` not ready | SSH key / HTTPS auth failure | Verify secret in `flux-system` namespace |
| `ClusterResourceSet` not applying | Label selector mismatch | Ensure cluster labels match `spec.clusterSelector` |
| CAPD clusters fail on CI | Docker-in-Docker not configured | Use `--privileged` or sysbox runtime |

## References

- Cluster API Book: https://cluster-api.sigs.k8s.io/
- ClusterClass Documentation: https://cluster-api.sigs.k8s.io/tasks/experimental/clusterclass
- ClusterResourceSet: https://cluster-api.sigs.k8s.io/developer/architecture/controllers/cluster-resource-set
- Flux CD Documentation: https://fluxcd.io/
- CAPA Provider: https://github.com/kubernetes-sigs/cluster-api-provider-aws
- CAPZ Provider: https://github.com/kubernetes-sigs/cluster-api-provider-azure
- CAPG Provider: https://github.com/kubernetes-sigs/cluster-api-provider-gcp
- CAPD Provider: https://github.com/kubernetes-sigs/cluster-api-provider-docker

## Version Compatibility

| Component | Version |
|-----------|---------|
| Kubernetes | 1.28, 1.29, 1.30 |
| Cluster API | v1.7.x |
| clusterctl | v1.7.x |
| Flux CD | v2.5.x |
| CAPA (AWS) | v1.7.x |
| CAPZ (Azure) | v1.7.x |
| CAPG (GCP) | v1.7.x |
| CAPD (Docker) | v1.7.x |

---

*Generated for DevOps-Kit. Last verified: 2026-10-25*
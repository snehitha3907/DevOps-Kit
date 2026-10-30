# Multi-Cluster Operations Guide

> Day-to-day operations for managing the multi-cluster fleet

## Cluster Lifecycle

### Create a New Workload Cluster

```bash
# 1. Choose provider and environment
export PROVIDER=aws        # aws, azure, gcp, docker
export ENVIRONMENT=prod    # prod, staging, dev
export CLUSTER_NAME=${PROVIDER}-${ENVIRONMENT}

# 2. Set provider-specific variables (see examples/<provider>/clusters.yaml)
# 3. Generate cluster manifest
clusterctl generate cluster ${CLUSTER_NAME} \
  --from clusterclass/${PROVIDER}-managed-cluster \
  --kubernetes-version v1.29.4 \
  --namespace capi-workloads \
  > examples/${PROVIDER}/${CLUSTER_NAME}.yaml

# 4. Review and apply
kubectl apply -f examples/${PROVIDER}/${CLUSTER_NAME}.yaml

# 5. Watch provisioning
kubectl get cluster ${CLUSTER_NAME} -n capi-workloads -w
```

### Scale a Cluster

```bash
# Scale worker nodes
kubectl patch machinedeployment ${CLUSTER_NAME}-workers \
  -n capi-workloads \
  --type merge \
  -p '{"spec":{"replicas":5}}'

# Scale control plane (must be odd number)
kubectl patch kubeadmcontrolplane ${CLUSTER_NAME}-control-plane \
  -n capi-workloads \
  --type merge \
  -p '{"spec":{"replicas":5}}'
```

### Upgrade Kubernetes Version

```bash
# Update ClusterClass variable (affects all clusters using it)
kubectl patch clusterclass ${PROVIDER}-managed-cluster \
  -n capi-system \
  --type merge \
  -p '{"spec":{"variables":[{"name":"kubernetesVersion","value":"v1.30.0"}]}}'

# Or upgrade single cluster
kubectl patch cluster ${CLUSTER_NAME} \
  -n capi-workloads \
  --type merge \
  -p '{"spec":{"topology":{"version":"v1.30.0"}}}'
```

### Delete a Cluster

```bash
# Graceful deletion (drains nodes, cleans up cloud resources)
kubectl delete cluster ${CLUSTER_NAME} -n capi-workloads

# Force deletion (if stuck)
kubectl patch cluster ${CLUSTER_NAME} -n capi-workloads \
  --type merge -p '{"metadata":{"finalizers":[]}}'
kubectl delete cluster ${CLUSTER_NAME} -n capi-workloads --force --grace-period=0
```

## Fleet Management

### Apply ClusterResourceSet to Subset of Clusters

```bash
# Label clusters for targeting
kubectl label cluster aws-prod environment=production tier=critical
kubectl label cluster aws-staging environment=staging tier=standard

# ClusterResourceSet uses label selectors automatically
# No additional action needed - controller reconciles on label change
```

### View Fleet Status

```bash
# All clusters across namespaces
kubectl get clusters --all-namespaces -o wide

# Cluster conditions
kubectl get clusters --all-namespaces -o custom-columns=\
NAME:.metadata.name,NAMESPACE:.metadata.namespace,PHASE:.status.phase,\
CONTROL-PLANE:.status.controlPlaneReady,WORKERS:.status.workerNodesReady

# Machine health
kubectl get machines --all-namespaces -o wide
```

## GitOps Operations

### Sync Flux Manually

```bash
# Sync all Flux resources
flux reconcile source git flux-system -n flux-system
flux reconcile kustomization flux-system -n flux-system
flux reconcile kustomization fleet-management -n flux-system
flux reconcile kustomization apps -n flux-system

# Sync specific workload cluster
flux reconcile kustomization apps -n <cluster-namespace>
```

### Suspend/Resume Automation

```bash
# Suspend (for maintenance)
flux suspend kustomization apps -n <cluster-namespace>

# Resume after maintenance
flux resume kustomization apps -n <cluster-namespace>
```

### Debug Sync Failures

```bash
# Check Flux logs
flux logs --all-namespaces --kind=Kustomization --name=apps

# Check Kustomization status
kubectl get kustomization apps -n <cluster-namespace> -o yaml

# Check GitRepository status
kubectl get gitrepository flux-system -n flux-system -o yaml
```

## Troubleshooting

### Cluster Stuck in Provisioning

```bash
# Check cluster conditions
kubectl describe cluster ${CLUSTER_NAME} -n capi-workloads

# Check machines
kubectl get machines -n capi-workloads -l cluster.x-k8s.io/cluster-name=${CLUSTER_NAME}

# Check machine health
kubectl describe machine ${MACHINE_NAME} -n capi-workloads

# Common causes:
# - Cloud provider credentials expired
# - Quota exceeded
# - Subnet/security group misconfiguration
# - CNI/CSI not ready (check ClusterResourceSet)
```

### Machine Not Joining Cluster

```bash
# Check bootstrap status
kubectl get kubeadmconfig -n capi-workloads -l cluster.x-k8s.io/cluster-name=${CLUSTER_NAME}

# Check node bootstrap logs (on the node itself)
journalctl -u kubelet -f

# Common causes:
# - API server endpoint unreachable
# - Certificate signing request not approved
# - CNI not installed (check ClusterResourceSet cni label)
```

### Flux Sync Stuck

```bash
# Check all Flux resources
flux get all -n flux-system

# Common causes:
# - GitRepository not ready (SSH key, URL, branch)
# - Kustomization path doesn't exist in repo
# - HelmRelease chart not found
# - Webhook admission failure (cert rotation)
```

### ClusterResourceSet Not Applying

```bash
# Check ClusterResourceSet status
kubectl get clusterresourceset -n capi-system

# Check if cluster matches selector
kubectl get cluster ${CLUSTER_NAME} -n capi-workloads --show-labels

# Common causes:
# - Cluster labels don't match clusterSelector
# - Resources already exist (conflict)
# - Namespace doesn't exist for namespaced resources
```

## Monitoring and Alerting

### Key Metrics to Watch

| Metric | Alert Threshold | Description |
|--------|----------------|-------------|
| `cluster_status_phase` | != Provisioned | Cluster not healthy |
| `machine_status_phase` | != Running | Machine not ready |
| `flux_kustomization_ready` | == 0 | GitOps sync failing |
| `prometheus_remote_storage_succeeded` | == 0 | Metrics not shipping |

### Useful PromQL Queries

```promql
# Clusters not provisioned
count(cluster_status_phase{phase!="Provisioned"}) by (cluster, namespace)

# Machines not running
count(machine_status_phase{phase!="Running"}) by (cluster, namespace)

# Flux sync lag
time() - flux_kustomization_last_applied_timestamp_seconds

# Control plane readiness
kube_node_status_condition{condition="Ready",node_role="control-plane"} == 0
```

## Backup and Disaster Recovery

### etcd Backup (Control Plane)

```bash
# On each control plane node
ETCDCTL_API=3 etcdctl snapshot save /backup/etcd-$(date +%F).db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```

### Flux Git Repository Backup

```bash
# Git repo is the source of truth - ensure Git remote has proper backup
# No additional backup needed if Git is properly backed up
```

### Cluster API Resources Backup

```bash
# Backup all CAPI resources
kubectl get clusters,machines,machinedeployments,kubeadmcontrolplanes \
  --all-namespaces -o yaml > capi-backup-$(date +%F).yaml
```

## Security Operations

### Rotate Certificates

```bash
# CAPI manages control plane certs automatically
# For manual rotation:
kubectl delete secret -n capi-workloads ${CLUSTER_NAME}-ca
# CAPI will regenerate
```

### Update SSH Keys

```bash
# Update AWSMachineTemplate with new key
kubectl patch awsmachinetemplate aws-control-plane -n capi-system \
  --type merge -p '{"spec":{"template":{"spec":{"sshKeyName":"new-key-name"}}}}'

# Update worker template
kubectl patch awsmachinetemplate aws-worker -n capi-system \
  --type merge -p '{"spec":{"template":{"spec":{"sshKeyName":"new-key-name"}}}}'

# Rolling restart required
kubectl rollout restart machinedeployment/${CLUSTER_NAME}-workers -n capi-workloads
```

### Audit Kyverno Policies

```bash
# Check policy violations
kubectl get policyreport --all-namespaces

# Check cluster policies
kubectl get clusterpolicy

# View policy details
kubectl describe clusterpolicy disallow-privileged-containers
```

---

*Generated for DevOps-Kit. Last verified: 2026-10-25*
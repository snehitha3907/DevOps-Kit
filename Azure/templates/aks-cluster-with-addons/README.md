---
last_verified: 2026-10-07
tool_version: "0.26.x"
sources: []
---

# aks-cluster-with-addons

A Bicep module template that deploys a production-grade Azure Kubernetes Service (AKS) cluster with a configurable set of managed addons. The template uses a modular architecture where the core cluster and each addon are separate Bicep modules, composed through a single entry point (`main.bicep`).

## What is in the box

- `main.bicep` — entry point that wires the cluster module and all optional addons together
- `modules/aks-cluster.bicep` — core AKS cluster module (private cluster, Azure CNI, user-assigned kubelet identity, system pool with autoscaling)
- `modules/addons/monitoring.bicep` — Azure Monitor Container Insights (Log Analytics + OMS agent)
- `modules/addons/policy.bicep` — Azure Policy for Kubernetes (Gatekeeper v3, audit mode by default)
- `modules/addons/keyvault-provider.bicep` — Azure Key Vault Secrets Provider (CSI driver for secret mounting)
- `modules/addons/http-routing.bicep` — HTTP application routing (NGINX ingress + public DNS zone integration)
- `modules/addons/gitops.bicep` — GitOps (Flux v2) for Git-based cluster configuration
- `modules/addons/network-policy.bicep` — Azure Network Policy Manager (Calico for pod-to-pod policies)
- `examples/deploy.sh` — example CLI commands for deploying the template with common parameter sets
- `README.md` — this file

## Purpose

This template provides a single, repeatable way to stand up a private AKS cluster with the addons most production workloads need:

- **Observability** — Container Insights gives you logs, metrics, and live container views without running your own Prometheus/Grafana stack.
- **Governance** — Azure Policy (Gatekeeper) enforces org standards (allowed images, required labels, no privileged pods) at admission time.
- **Secrets** — Key Vault CSI driver lets pods mount secrets from Key Vault as volumes, no application code changes.
- **Ingress** — HTTP application routing provisions a public DNS zone and NGINX controller automatically.
- **GitOps** — Flux v2 syncs cluster state from a Git repository (Kustomize, Helm, or plain manifests).
- **Network policy** — Calico enforces pod-to-pod traffic rules via Kubernetes NetworkPolicy resources.

Each addon is opt-in via a boolean parameter, so you pay for and operate only what you need. The template deliberately separates addons into independent modules rather than cramming everything into one monolithic file — this makes it easier to enable/disable, version, and test individual pieces.

## When to use

Reach for this template when:

- You need a production-ready AKS baseline that includes observability, governance, secrets, and GitOps out of the box.
- You want a private cluster (no public API endpoint) with Azure CNI networking so pods get real VNet IPs.
- You prefer managing addons as configurable modules rather than enabling them one-off in the portal or via `az aks enable-addons`.
- You are building a landing zone or platform foundation that other teams will consume.

Do not use this template if:

- You need a simple dev/test cluster — the addon set adds cost and operational surface area.
- You require a public API endpoint — this template hardens the cluster as private-only.
- You use a different CNI (Cilium, Antrea) — the template assumes Azure CNI with VNet subnet delegation.
- You manage addons exclusively through a separate GitOps pipeline — the template's addon modules would conflict.

## Prerequisites

- Azure CLI ≥ 2.55.0 with the `aks-preview` extension (`az extension add --name aks-preview`).
- Bicep CLI ≥ 0.26.x (`az bicep install`).
- An existing resource group in the target subscription.
- A pre-created VNet and subnet in the same resource group (Azure CNI requires the subnet to exist before cluster creation).
- The subnet must be delegated to `Microsoft.ContainerService/managedClusters` (or the deployment will do it).
- A role definition ID for the kubelet identity (typically `Network Contributor` or a custom role with `Microsoft.Network/virtualNetworks/subnets/join/action`).
- If enabling HTTP routing: a pre-created public DNS zone delegated to Azure DNS.
- If enabling GitOps with a private repo: a user-assigned identity with read access to the repo (deploy key or PAT).
- The deploying principal needs `Microsoft.ContainerService/managedClusters/write`, `Microsoft.ManagedIdentity/userAssignedIdentities/write`, `Microsoft.Authorization/roleAssignments/write`, and the addon-specific permissions (Log Analytics workspace write for monitoring, DNS zone read/write for HTTP routing, etc.).

## Steps

### 1. Create the VNet and subnet (if not already present)

```bash
az network vnet create \
  --resource-group <rg> \
  --name <vnet-name> \
  --address-prefixes 10.0.0.0/16 \
  --subnet-name <subnet-name> \
  --subnet-prefixes 10.0.1.0/24

# Delegate the subnet to AKS
az network vnet subnet update \
  --resource-group <rg> \
  --vnet-name <vnet-name> \
  --name <subnet-name> \
  --delegations Microsoft.ContainerService/managedClusters
```

### 2. Get the role definition ID for the kubelet identity

Use `Network Contributor` (built-in) or a custom role with subnet join permission:

```bash
ROLE_ID=$(az role definition list --name "Network Contributor" --query "[0].id" -o tsv)
```

### 3. Deploy the template (minimal: cluster only)

```bash
az deployment group create \
  --resource-group <rg> \
  --template-file main.bicep \
  --parameters clusterName=<cluster-name> \
    vnetName=<vnet-name> \
    subnetName=<subnet-name> \
    roleDefinitionId=$ROLE_ID
```

### 4. Deploy with all addons enabled

```bash
# Create Log Analytics workspace first (or let the template create one)
LAW_ID=$(az monitor log-analytics workspace create \
  --resource-group <rg> \
  --workspace-name <law-name> \
  --query id -o tsv)

# Create public DNS zone for HTTP routing (if enabling)
az network dns zone create \
  --resource-group <rg> \
  --name <zone-name>

# Create user-assigned identity for GitOps (if enabling with private repo)
az identity create \
  --resource-group <rg> \
  --name <gitops-identity-name>

az deployment group create \
  --resource-group <rg> \
  --template-file main.bicep \
  --parameters clusterName=<cluster-name> \
    vnetName=<vnet-name> \
    subnetName=<subnet-name> \
    roleDefinitionId=$ROLE_ID \
    enableMonitoring=true \
    logAnalyticsWorkspaceId=$LAW_ID \
    enablePolicy=true \
    enableKeyVaultProvider=true \
    enableHttpRouting=true \
    httpRoutingZoneName=<zone-name> \
    enableGitOps=true \
    gitOpsRepoUrl=github.example.com/<org>/<repo>.git \
    gitOpsBranch=main \
    gitOpsConfigPath=clusters/production \
    enableNetworkPolicy=true
```

### 5. Pull credentials (from a machine with line-of-sight to the private API)

```bash
az aks get-credentials \
  --resource-group <rg> \
  --name <cluster-name> \
  --admin
```

`examples/deploy.sh` contains the full sequence as runnable commands with parameter defaults.

## Verify

- `az aks show --resource-group <rg> --name <cluster-name> --query "{private:apiServerAccessProfile.enablePrivateCluster, cni:networkProfile.networkPlugin, monitoring:addonProfiles.azuremonitorcontainers.enabled, policy:addonProfiles.azurepolicy.enabled, keyvault:addonProfiles.azureKeyvaultSecretsProvider.enabled, httpRouting:addonProfiles.httpApplicationRouting.enabled, gitops:addonProfiles.gitops.enabled, networkPolicy:addonProfiles.azureNetworkPolicy.enabled}"` — all enabled addons should show `true`.
- `kubectl get pods -n kube-system` — shows OMS agent, Gatekeeper, CSI driver, NGINX ingress, Flux controllers, and Calico pods as expected.
- `kubectl get networkpolicies -A` — returns resources when network policy addon is enabled.
- `az monitor log-analytics workspace show --resource-group <rg> --workspace-name <law-name>` — shows the workspace receiving cluster logs.
- `flux check --kubeconfig <kubeconfig>` — validates GitOps controllers are healthy (if enabled).

## Rollback

AKS addons are managed as part of the cluster resource. To remove an addon, set its `enable*` parameter to `false` and re-deploy — the addon is removed in place. To roll back a bad cluster change, re-deploy with the previous parameter values. To tear down entirely, delete the resource group or run `az aks delete --resource-group <rg> --name <cluster-name> --yes`. The VNet, subnet, Log Analytics workspace, DNS zone, and managed identities are separate resources and must be deleted separately if no longer needed.

## Common errors

- `SubnetNotDelegated` — the subnet lacks the `Microsoft.ContainerService/managedClusters` delegation. Run the delegation command in Step 1 before deploying.
- `SubnetOverlap` — the `serviceCidr` or `dnsServiceIP` overlaps the VNet address space. Choose a non-overlapping service CIDR (e.g., `10.2.0.0/24` for a `10.0.0.0/16` VNet).
- `PrivateClusterRequiresPrivateLink` — the cluster is private but the deploying machine has no network path to the private endpoint. Deploy from a VM in the same VNet, a peered VNet, or a VPN/ExpressRoute connection.
- `RoleAssignmentLimitExceeded` — too many role assignments on the subnet. Consolidate by using a single kubelet identity per cluster (this template does that).
- `DnsZoneNotFound` — HTTP routing enabled but the DNS zone resource ID is invalid. Ensure the zone exists in the same subscription and the deploying principal has read access.
- `GitOpsSyncFailed` — Flux cannot reach the Git repo. For private repos, ensure the user-assigned identity has a valid deploy key or PAT with read access; for public repos, check the URL and branch name.
- `LogAnalyticsWorkspaceNotFound` — monitoring enabled but the workspace ID is wrong. Use the full resource ID (`/subscriptions/.../resourceGroups/.../providers/Microsoft.OperationalInsights/workspaces/...`).

## References

- `main.bicep` — the composition root.
- `modules/aks-cluster.bicep` — core cluster module.
- `modules/addons/*.bicep` — individual addon modules.
- `examples/deploy.sh` — runnable deployment examples.
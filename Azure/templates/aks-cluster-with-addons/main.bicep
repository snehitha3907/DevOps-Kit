// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// Azure Bicep module template for AKS cluster with common production addons.
// Deploys a private AKS cluster with Azure CNI, user-assigned kubelet identity,
// and a configurable set of managed addons (Monitor, Policy, Key Vault, HTTP routing, GitOps).

targetScope = 'resourceGroup'

@description('Name of the AKS cluster. Must be globally unique within the region.')
@minLength(1)
@maxLength(63)
param clusterName string

@description('Azure region for the cluster and all resources.')
param location string = resourceGroup().location

@description('DNS prefix for the cluster control plane.')
@minLength(1)
param dnsPrefix string = clusterName

@description('Name of the existing VNet holding the node subnet (same resource group).')
param vnetName string

@description('Name of the existing subnet for nodes and pods (Azure CNI requires it pre-created).')
param subnetName string

@description('Full resource id of the role to grant the kubelet identity on the subnet.')
@minLength(1)
param roleDefinitionId string

@description('VM size for the system node pool.')
param vmSize string = 'Standard_DS2_v2'

@description('Node count when autoscaling is off; initial count when it is on.')
@minValue(1)
param nodeCount int = 3

@description('Autoscale the system pool between minCount and maxCount.')
param enableAutoScaling bool = true

@description('Minimum nodes with autoscaling on.')
@minValue(1)
param minCount int = 2

@description('Maximum nodes with autoscaling on.')
@minValue(1)
param maxCount int = 6

@description('Service CIDR for cluster services (must not overlap the VNet).')
param serviceCidr string = '10.2.0.0/24'

@description('Cluster DNS service IP (must sit inside serviceCidr).')
param dnsServiceIP string = '10.2.0.10'

@description('Name of the user-assigned identity used by kubelets.')
param identityName string = '${clusterName}-kubelet'

@description('Enable Azure Monitor Container Insights addon.')
param enableMonitoring bool = true

@description('Log Analytics workspace resource ID for Container Insights. Created if not provided.')
param logAnalyticsWorkspaceId string = ''

@description('Enable Azure Policy for Kubernetes addon (Gatekeeper v3).')
param enablePolicy bool = true

@description('Enable Azure Key Vault Secrets Provider addon (CSI driver).')
param enableKeyVaultProvider bool = true

@description('Enable HTTP application routing addon (public DNS zone + ingress controller).')
param enableHttpRouting bool = false

@description('DNS zone name for HTTP application routing (required if enableHttpRouting=true).')
param httpRoutingZoneName string = ''

@description('Enable GitOps (Flux) addon for GitOps-based cluster configuration.')
param enableGitOps bool = false

@description('Git repository URL for GitOps (required if enableGitOps=true).')
param gitOpsRepoUrl string = ''

@description('GitOps branch to sync (required if enableGitOps=true).')
param gitOpsBranch string = 'main'

@description('GitOps configuration path in the repository (required if enableGitOps=true).')
param gitOpsConfigPath string = 'clusters/production'

@description('User-assigned identity resource ID for GitOps (created if not provided).')
param gitOpsIdentityId string = ''

@description('Enable Azure Network Policy Manager (Calico) addon.')
param enableNetworkPolicy bool = false

@description('Tags to apply to all resources.')
param tags object = {}

@allowed([
  'SystemAssigned'
  'UserAssigned'
])
@description('Identity type for the cluster control plane.')
param clusterIdentityType string = 'SystemAssigned'

// Existing network: CNI allocates pod IPs from here, so it must exist first.
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: vnet
  name: subnetName
}

// User-assigned identity for the kubelets (image pull + subnet join).
resource kubeletIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
  tags: tags
}

// Optional: Log Analytics workspace for monitoring
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = if (!empty(logAnalyticsWorkspaceId)) {
  name: last(split(logAnalyticsWorkspaceId, '/'))
  scope: resourceGroup(subscriptionId(logAnalyticsWorkspaceId), split(logAnalyticsWorkspaceId, '/')[4])
}

// Optional: User-assigned identity for GitOps
resource gitOpsIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(gitOpsIdentityId)) {
  name: last(split(gitOpsIdentityId, '/'))
  scope: resourceGroup(subscriptionId(gitOpsIdentityId), split(gitOpsIdentityId, '/')[4])
}

// Core AKS cluster module
module aksCluster 'modules/aks-cluster.bicep' = {
  name: 'aks-cluster-${clusterName}'
  params: {
    clusterName: clusterName
    location: location
    dnsPrefix: dnsPrefix
    vnetName: vnetName
    subnetName: subnetName
    roleDefinitionId: roleDefinitionId
    vmSize: vmSize
    nodeCount: nodeCount
    enableAutoScaling: enableAutoScaling
    minCount: minCount
    maxCount: maxCount
    serviceCidr: serviceCidr
    dnsServiceIP: dnsServiceIP
    identityName: identityName
    kubeletIdentityId: kubeletIdentity.id
    clusterIdentityType: clusterIdentityType
    tags: tags
  }
}

// Azure Monitor Container Insights addon
module monitoringAddon 'modules/addons/monitoring.bicep' = if (enableMonitoring) {
  name: 'addon-monitoring-${clusterName}'
  params: {
    clusterName: clusterName
    clusterResourceId: aksCluster.outputs.clusterId
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    tags: tags
  }
}

// Azure Policy for Kubernetes addon
module policyAddon 'modules/addons/policy.bicep' = if (enablePolicy) {
  name: 'addon-policy-${clusterName}'
  params: {
    clusterName: clusterName
    clusterResourceId: aksCluster.outputs.clusterId
    location: location
    tags: tags
  }
}

// Azure Key Vault Secrets Provider addon
module keyVaultAddon 'modules/addons/keyvault-provider.bicep' = if (enableKeyVaultProvider) {
  name: 'addon-keyvault-${clusterName}'
  params: {
    clusterName: clusterName
    clusterResourceId: aksCluster.outputs.clusterId
    location: location
    tags: tags
  }
}

// HTTP application routing addon
module httpRoutingAddon 'modules/addons/http-routing.bicep' = if (enableHttpRouting) {
  name: 'addon-httprouting-${clusterName}'
  params: {
    clusterName: clusterName
    clusterResourceId: aksCluster.outputs.clusterId
    location: location
    dnsZoneName: httpRoutingZoneName
    tags: tags
  }
}

// GitOps (Flux) addon
module gitOpsAddon 'modules/addons/gitops.bicep' = if (enableGitOps) {
  name: 'addon-gitops-${clusterName}'
  params: {
    clusterName: clusterName
    clusterResourceId: aksCluster.outputs.clusterId
    location: location
    repoUrl: gitOpsRepoUrl
    branch: gitOpsBranch
    configPath: gitOpsConfigPath
    identityId: gitOpsIdentityId
    tags: tags
  }
}

// Azure Network Policy Manager addon
module networkPolicyAddon 'modules/addons/network-policy.bicep' = if (enableNetworkPolicy) {
  name: 'addon-networkpolicy-${clusterName}'
  params: {
    clusterName: clusterName
    clusterResourceId: aksCluster.outputs.clusterId
    location: location
    tags: tags
  }
}

// Least-privilege wiring: kubelet identity may join nodes to this subnet only.
resource subnetRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aksCluster.outputs.clusterId, kubeletIdentity.id, roleDefinitionId)
  scope: subnet
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: kubeletIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('Private FQDN of the cluster API server.')
output controlPlanePrivateFqdn string = aksCluster.outputs.controlPlanePrivateFqdn

@description('Object id of the kubelet managed identity.')
output kubeletIdentityObjectId string = kubeletIdentity.properties.principalId

@description('Resource ID of the AKS cluster.')
output clusterId string = aksCluster.outputs.clusterId

@description('Cluster identity principal ID (SystemAssigned or UserAssigned).')
output clusterIdentityPrincipalId string = aksCluster.outputs.clusterIdentityPrincipalId
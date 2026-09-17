// last_verified: 2026-09-17 · Azure Bicep (n/a)
//
// Purpose: production AKS cluster with a private API server, user-assigned
// managed identities, and Azure CNI networking. The cluster drops into a
// pre-existing subnet so pods get real VNet addresses, and the kubelet
// identity gets a role assignment scoped to that subnet. One way to do it;
// the docs also show a SystemAssigned-only setup, which is simpler but gives
// you less control over the kubelet identity lifecycle.
//
// Steps:
//   1. Create the VNet and subnet first (Azure CNI needs the subnet to exist).
//   2. Deploy into your resource group, passing the subnet and role ids:
//      az deployment group create --resource-group <rg> \
//        --template-file production-aks-cluster.bicep \
//        --parameters clusterName=<name> vnetName=<vnet> subnetName=<subnet> \
//          roleDefinitionId=<role-resource-id>
//   3. Pull credentials from a machine with line-of-sight to the private API.
//
// Verify:
//   az aks show --resource-group <rg> --name <name> \
//     --query "{private:apiServerAccessProfile.enablePrivateCluster, cni:networkProfile.networkPlugin}"

targetScope = 'resourceGroup'

@description('Name of the AKS cluster.')
@minLength(1)
param clusterName string

@description('Azure region for the cluster and the managed identity.')
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
}

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    enableRBAC: true
    // Private cluster: no public API endpoint, nodes reach it over private link.
    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: kubeletIdentity.id
        clientId: kubeletIdentity.properties.clientId
        objectId: kubeletIdentity.properties.principalId
      }
    }
    agentPoolProfiles: [
      {
        name: 'systempool'
        mode: 'System'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        count: nodeCount
        vmSize: vmSize
        vnetSubnetID: subnet.id
        enableAutoScaling: enableAutoScaling
        minCount: enableAutoScaling ? minCount : null
        maxCount: enableAutoScaling ? maxCount : null
      }
    ]
    // Azure CNI: every pod gets a VNet-routable address from the subnet.
    networkProfile: {
      networkPlugin: 'azure'
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
    }
  }
}

// Least-privilege wiring: kubelet identity may join nodes to this subnet only.
resource subnetRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aks.id, kubeletIdentity.id, roleDefinitionId)
  scope: subnet
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: kubeletIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('Private FQDN of the cluster API server.')
output controlPlanePrivateFqdn string = aks.properties.privateFQDN

@description('Object id of the kubelet managed identity.')
output kubeletIdentityObjectId string = kubeletIdentity.properties.principalId

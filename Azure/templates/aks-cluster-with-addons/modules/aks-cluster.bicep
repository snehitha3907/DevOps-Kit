// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// Core AKS cluster module. Creates a private AKS cluster with Azure CNI,
// user-assigned kubelet identity, and system node pool with autoscaling.

targetScope = 'resourceGroup'

@description('Name of the AKS cluster.')
@minLength(1)
@maxLength(63)
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

@description('Resource ID of the pre-created kubelet user-assigned identity.')
param kubeletIdentityId string

@allowed([
  'SystemAssigned'
  'UserAssigned'
])
@description('Identity type for the cluster control plane.')
param clusterIdentityType string = 'SystemAssigned'

@description('Tags to apply to all resources.')
param tags object = {}

@description('Kubernetes version (leave empty for AKS default).')
param kubernetesVersion string = ''

resource aks 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  name: clusterName
  location: location
  tags: tags
  identity: clusterIdentityType == 'SystemAssigned' ? {
    type: 'SystemAssigned'
  } : {
    type: 'UserAssigned'
    userAssignedIdentities: {
      // If UserAssigned, caller must pass the identity resource ID via a separate param or convention
    }
  }
  properties: {
    dnsPrefix: dnsPrefix
    enableRBAC: true
    // Private cluster: no public API endpoint, nodes reach it over private link.
    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDNSZone: 'system' // 'system' = Azure-managed private DNS zone, 'none' = bring your own
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: kubeletIdentityId
      }
    }
    agentPoolProfiles: [
      {
        name: 'systempool'
        mode: 'System'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        count: enableAutoScaling ? null : nodeCount
        vmSize: vmSize
        vnetSubnetID: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
        enableAutoScaling: enableAutoScaling
        minCount: enableAutoScaling ? minCount : null
        maxCount: enableAutoScaling ? maxCount : null
        osDiskSizeGB: 128
        osDiskType: 'Ephemeral'
        nodeLabels: {
          'node-type': 'system'
        }
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        upgradeSettings: {
          maxSurge: '33%'
        }
      }
    ]
    // Azure CNI: every pod gets a VNet-routable address from the subnet.
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'cilium' // or 'calico' when network policy addon is enabled
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      loadBalancerSku: 'Standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
        outboundIPs: []
      }
    }
    // Security profile with Azure AD integration and workload identity
    securityProfile: {
      defenseInDepth: 'enabled'
      workloadIdentity: 'enabled'
      azureKeyVaultKms: 'disabled' // Enable if using Azure Key Vault for encryption
      imageCleaner: {
        enabled: true
        intervalHours: 24
      }
    }
    // Disable local accounts, require Azure AD
    disableLocalAccounts: true
    apiServerAccessProfile: {
      enablePrivateCluster: true
      enablePrivateClusterPublicFQDN: false
      privateDNSZone: 'system'
      authorizedIPRanges: [] // Empty = no authorized IP ranges (private cluster)
    }
    kubernetesVersion: kubernetesVersion
    autoUpgradeProfile: {
      upgradeChannel: 'stable'
      nodeOsUpgradeChannel: 'NodeImage'
    }
    addonProfiles: {} // Addons are deployed as separate modules for granularity
  }
}

@description('Private FQDN of the cluster API server.')
output controlPlanePrivateFqdn string = aks.properties.privateFQDN

@description('Resource ID of the AKS cluster.')
output clusterId string = aks.id

@description('Cluster identity principal ID (SystemAssigned or UserAssigned).')
output clusterIdentityPrincipalId string = clusterIdentityType == 'SystemAssigned' ? aks.identity.principalId : ''
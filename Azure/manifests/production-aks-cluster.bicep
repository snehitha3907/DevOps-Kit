# last_verified: 2026-09-17 · Azure n/a

// Production AKS cluster with managed identities, private clusters, and Azure CNI

param clusterName string = 'prod-aks'
param resourceGroupName string = 'rg-aks-prod'
param location string = resourceGroup().location
param kubernetesVersion string = '1.29'
param nodeCount int = 3
param nodeVmSize string = 'Standard_D4s_v5'

// Managed identity for the AKS cluster
resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${clusterName}-identity'
  location: location
  sku: {
    name: 'Standard'
  }
}

// Virtual network with Azure CNI
resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${clusterName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/20'
          delegations: []
        }
      }
    ]
  }
}

// Private DNS zone for AKS API
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.${environment().suffixes.containerService}'
  location: 'global'
}

resource privateDnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${clusterName}-dns-link'
  parent: privateDnsZone
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
    registrationEnabled: false
  }
}

// AKS cluster with private API server, managed identity, and Azure CNI
resource aks 'Microsoft.ContainerService/managedClusters@2024-02-02' = {
  name: clusterName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${aksIdentity.id}': {}
    }
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    enableRBAC: true
    linuxProfile: {
      adminUsername: 'azureadmin'
      ssh: {
        publicKeys: [
          {
            keyData: '<ssh-rsa-key-data>'
          }
        ]
      }
    }
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      podCidr: '10.244.0.0/16'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
      outboundType: 'loadBalancer'
    }
    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDnsZoneId: privateDnsZone.id
    }
    identityProfile: {
      kubeletidentity: {
        objectId: aksIdentity.properties.principalId
        clientId: aksIdentity.properties.clientId
      }
    }
    agentPoolProfiles: [
      {
        name: 'nodepool'
        count: nodeCount
        vmSize: nodeVmSize
        osType: 'Linux'
        mode: 'System'
        enableAutoScaling: true
        minCount: 1
        maxCount: 5
        nodeLabels: {}
      }
    ]
    diskEncryptionSetId: ''
    enablePodSecurityPolicy: false
  }
}

output kubeConfigUri string = 'https://${aks.properties.fqdn}/'
output identityClientId string = aksIdentity.properties.clientId
output nodeResourceGroup string = aks.properties.nodeResourceGroup

// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// Azure Network Policy Manager (Calico) addon module for AKS.
// Enables Calico network policies for pod-to-pod traffic control.

targetScope = 'resourceGroup'

@description('Name of the AKS cluster.')
param clusterName string

@description('Resource ID of the AKS cluster.')
param clusterResourceId string

@description('Azure region for the addon resources.')
param location string = resourceGroup().location

@description('Tags to apply to all resources.')
param tags object = {}

resource cluster 'Microsoft.ContainerService/managedClusters@2024-05-01' existing = {
  scope: resourceGroup()
  name: clusterName
}

// AKS addon profile for Azure Network Policy Manager (Calico)
resource networkPolicyAddon 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  scope: resourceGroup()
  name: clusterName
  properties: {
    addonProfiles: {
      azureNetworkPolicy: {
        enabled: true
        config: {
          // Calico version (managed by Azure)
          version: 'latest'
        }
      }
    }
  }
}

@description('Network policy addon enabled status.')
output networkPolicyEnabled bool = true

@description('Network policy provider (Calico).')
output networkPolicyProvider string = 'calico'
// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// Azure Key Vault Secrets Provider (CSI driver) addon module for AKS.
// Enables mounting Key Vault secrets as Kubernetes volumes via the CSI driver.

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

// AKS addon profile for Azure Key Vault Secrets Provider
resource keyVaultAddon 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  scope: resourceGroup()
  name: clusterName
  properties: {
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          // Rotation polling interval (default: 2m)
          rotationPollInterval: '2m'
          // Enable secret sync for user-assigned identities
          enableSecretRotation: true
        }
      }
    }
  }
}

@description('Key Vault Secrets Provider addon enabled status.')
output keyVaultProviderEnabled bool = true
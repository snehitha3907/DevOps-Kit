// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// Azure Policy for Kubernetes addon module for AKS.
// Deploys Gatekeeper v3 (OPA) for policy enforcement and Azure Policy integration.

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

// AKS addon profile for Azure Policy
resource policyAddon 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  scope: resourceGroup()
  name: clusterName
  properties: {
    addonProfiles: {
      azurepolicy: {
        enabled: true
        config: {
          // Audit-only mode (does not enforce, only reports violations)
          // Set to "enforce" for blocking non-compliant resources
          policyMode: 'audit'
          // Version of the policy addon
          version: 'v2'
        }
      }
    }
  }
}

@description('Policy addon enabled status.')
output policyEnabled bool = true

@description('Policy mode (audit or enforce).')
output policyMode string = 'audit'
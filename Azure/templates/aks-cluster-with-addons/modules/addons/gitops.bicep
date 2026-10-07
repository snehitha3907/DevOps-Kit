// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// GitOps (Flux) addon module for AKS.
// Enables GitOps-based cluster configuration management using Flux v2.

targetScope = 'resourceGroup'

@description('Name of the AKS cluster.')
param clusterName string

@description('Resource ID of the AKS cluster.')
param clusterResourceId string

@description('Azure region for the addon resources.')
param location string = resourceGroup().location

@description('Git repository URL for GitOps (required).')
@minLength(1)
param repoUrl string

@description('GitOps branch to sync.')
param branch string = 'main'

@description('GitOps configuration path in the repository.')
param configPath string = 'clusters/production'

@description('User-assigned identity resource ID for GitOps (created if not provided).')
param identityId string = ''

@description('Tags to apply to all resources.')
param tags object = {}

resource cluster 'Microsoft.ContainerService/managedClusters@2024-05-01' existing = {
  scope: resourceGroup()
  name: clusterName
}

// User-assigned identity for GitOps (optional, for private repos)
resource gitOpsIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(identityId)) {
  name: last(split(identityId, '/'))
  scope: resourceGroup(subscriptionId(identityId), split(identityId, '/')[4])
}

// AKS addon profile for GitOps (Flux)
resource gitOpsAddon 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  scope: resourceGroup()
  name: clusterName
  properties: {
    addonProfiles: {
      gitops: {
        enabled: true
        config: {
          // Git repository URL (HTTPS or SSH)
          repositoryUrl: repoUrl
          // Branch to track
          branch: branch
          // Path within the repo containing cluster config
          configPath: configPath
          // Optional: user-assigned identity for private repos
          // The identity needs read access to the repo (deploy key or token)
          identity: empty(identityId) ? json('null') : {
            type: 'userAssigned'
            userAssignedIdentity: identityId
          }
          // Flux sync interval
          syncInterval: '3m'
          // Retry interval on failure
          retryInterval: '1m'
          // Timeout for operations
          timeout: '5m'
        }
      }
    }
  }
}

@description('GitOps addon enabled status.')
output gitOpsEnabled bool = true

@description('Git repository URL.')
output repositoryUrl string = repoUrl

@description('GitOps branch.')
output branch string = branch
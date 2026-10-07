// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// Azure Monitor Container Insights addon module for AKS.
// Deploys the Container Insights (OMS) agent and configures log analytics workspace integration.

targetScope = 'resourceGroup'

@description('Name of the AKS cluster.')
param clusterName string

@description('Resource ID of the AKS cluster.')
param clusterResourceId string

@description('Azure region for the addon resources.')
param location string = resourceGroup().location

@description('Log Analytics workspace resource ID. If empty, a new workspace is created.')
param logAnalyticsWorkspaceId string = ''

@description('Tags to apply to all resources.')
param tags object = {}

resource cluster 'Microsoft.ContainerService/managedClusters@2024-05-01' existing = {
  scope: resourceGroup()
  name: clusterName
}

// Log Analytics workspace - created if not provided
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = if (empty(logAnalyticsWorkspaceId)) {
  name: '${clusterName}-logs'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: -1
    }
  }
}

// Container Insights solution
resource containerInsightsSolution 'Microsoft.OperationsManagement/solutions@2021-03-01-preview' = if (empty(logAnalyticsWorkspaceId)) {
  name: 'ContainerInsights(${logAnalyticsWorkspace.name})'
  location: location
  tags: tags
  plan: {
    name: 'ContainerInsights(${logAnalyticsWorkspace.name})'
    publisher: 'Microsoft'
    product: 'OMSGallery/ContainerInsights'
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
    containedResources: [
      '${logAnalyticsWorkspace.id}/views/ContainerInsights'
    ]
    referencedResources: []
  }
}

// AKS addon profile for Azure Monitor
resource monitoringAddon 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  scope: resourceGroup()
  name: clusterName
  // Only update the addonProfile section
  properties: {
    addonProfiles: {
      azuremonitorcontainers: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: empty(logAnalyticsWorkspaceId) ? logAnalyticsWorkspace.id : logAnalyticsWorkspaceId
          // Enable metrics collection
          metrics: {
            enabled: true
          }
        }
      }
    }
  }
}

@description('Log Analytics workspace ID used by Container Insights.')
output logAnalyticsWorkspaceId string = empty(logAnalyticsWorkspaceId) ? logAnalyticsWorkspace.id : logAnalyticsWorkspaceId

@description('Container Insights solution name (if created).')
output solutionName string = empty(logAnalyticsWorkspaceId) ? 'ContainerInsights(${logAnalyticsWorkspace.name})' : ''
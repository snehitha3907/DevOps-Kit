// last_verified: 2026-10-07 · Azure Bicep 0.26.x
// HTTP application routing addon module for AKS.
// Deploys an NGINX ingress controller with automatic public DNS zone integration.

targetScope = 'resourceGroup'

@description('Name of the AKS cluster.')
param clusterName string

@description('Resource ID of the AKS cluster.')
param clusterResourceId string

@description('Azure region for the addon resources.')
param location string = resourceGroup().location

@description('DNS zone name for HTTP application routing (required).')
@minLength(1)
param dnsZoneName string

@description('Tags to apply to all resources.')
param tags object = {}

resource cluster 'Microsoft.ContainerService/managedClusters@2024-05-01' existing = {
  scope: resourceGroup()
  name: clusterName
}

// Public DNS zone for HTTP routing (must exist or be created separately)
// This addon assumes the DNS zone is pre-created and delegated.
// The addon will create A records in this zone for ingress services.
resource dnsZone 'Microsoft.Network/dnszones@2018-05-01' existing = {
  name: dnsZoneName
}

// AKS addon profile for HTTP application routing
resource httpRoutingAddon 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  scope: resourceGroup()
  name: clusterName
  properties: {
    addonProfiles: {
      httpApplicationRouting: {
        enabled: true
        config: {
          // The DNS zone name where A records will be created
          dnsZoneResourceId: dnsZone.id
          // Ingress class name for the NGINX controller
          ingressClassName: 'nginx'
        }
      }
    }
  }
}

@description('HTTP application routing addon enabled status.')
output httpRoutingEnabled bool = true

@description('DNS zone resource ID used for HTTP routing.')
output dnsZoneResourceId string = dnsZone.id

@description('Ingress class name for the NGINX controller.')
output ingressClassName string = 'nginx'
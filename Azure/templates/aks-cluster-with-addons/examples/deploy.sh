#!/usr/bin/env bash
# last_verified: 2026-10-07 · Azure CLI 2.55+ · Bicep 0.26.x
# Example deployment script for the AKS cluster with addons template.
# Usage: ./deploy.sh [minimal|full] <resource-group> <cluster-name> <vnet-name> <subnet-name> [options]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_FILE="${SCRIPT_DIR}/../main.bicep"

MODE="${1:-minimal}"
RG="${2:-}"
CLUSTER_NAME="${3:-}"
VNET_NAME="${4:-}"
SUBNET_NAME="${5:-}"

if [[ -z "$RG" || -z "$CLUSTER_NAME" || -z "$VNET_NAME" || -z "$SUBNET_NAME" ]]; then
  echo "Usage: $0 [minimal|full] <resource-group> <cluster-name> <vnet-name> <subnet-name>"
  echo ""
  echo "Modes:"
  echo "  minimal  - Deploy cluster only (no addons)"
  echo "  full     - Deploy cluster with all addons enabled"
  echo ""
  echo "Environment variables for 'full' mode:"
  echo "  LAW_NAME              - Log Analytics workspace name (created if not exists)"
  echo "  DNS_ZONE_NAME         - Public DNS zone name for HTTP routing (must exist)"
  echo "  GITOPS_REPO_URL       - Git repository URL for GitOps (required if GitOps enabled)"
  echo "  GITOPS_BRANCH         - GitOps branch (default: main)"
  echo "  GITOPS_CONFIG_PATH    - GitOps config path (default: clusters/production)"
  echo "  GITOPS_IDENTITY_NAME  - User-assigned identity name for GitOps (created if not exists)"
  exit 1
fi

# Get Network Contributor role definition ID
ROLE_ID=$(az role definition list --name "Network Contributor" --query "[0].id" -o tsv)
if [[ -z "$ROLE_ID" ]]; then
  echo "ERROR: Could not find 'Network Contributor' role definition"
  exit 1
fi

echo "=== Deploying AKS cluster ($MODE mode) ==="
echo "Resource group: $RG"
echo "Cluster name: $CLUSTER_NAME"
echo "VNet: $VNET_NAME"
echo "Subnet: $SUBNET_NAME"
echo "Role definition: $ROLE_ID"

# Ensure VNet and subnet exist and subnet is delegated
echo "--- Ensuring VNet and subnet delegation ---"
az network vnet show --resource-group "$RG" --name "$VNET_NAME" >/dev/null 2>&1 || {
  echo "VNet $VNET_NAME not found in $RG. Creating..."
  az network vnet create --resource-group "$RG" --name "$VNET_NAME" --address-prefixes 10.0.0.0/16 --subnet-name "$SUBNET_NAME" --subnet-prefixes 10.0.1.0/24
}

az network vnet subnet show --resource-group "$RG" --vnet-name "$VNET_NAME" --name "$SUBNET_NAME" >/dev/null 2>&1 || {
  echo "Subnet $SUBNET_NAME not found. Creating..."
  az network vnet subnet create --resource-group "$RG" --vnet-name "$VNET_NAME" --name "$SUBNET_NAME" --address-prefixes 10.0.1.0/24
}

# Delegate subnet to AKS
az network vnet subnet update \
  --resource-group "$RG" \
  --vnet-name "$VNET_NAME" \
  --name "$SUBNET_NAME" \
  --delegations Microsoft.ContainerService/managedClusters

case "$MODE" in
  minimal)
    echo "--- Deploying minimal cluster (no addons) ---"
    az deployment group create \
      --resource-group "$RG" \
      --template-file "$TEMPLATE_FILE" \
      --parameters clusterName="$CLUSTER_NAME" \
        vnetName="$VNET_NAME" \
        subnetName="$SUBNET_NAME" \
        roleDefinitionId="$ROLE_ID" \
        enableMonitoring=false \
        enablePolicy=false \
        enableKeyVaultProvider=false \
        enableHttpRouting=false \
        enableGitOps=false \
        enableNetworkPolicy=false
    ;;

  full)
    echo "--- Deploying cluster with all addons ---"

    # Log Analytics workspace
    LAW_NAME="${LAW_NAME:-${CLUSTER_NAME}-logs}"
    echo "Log Analytics workspace: $LAW_NAME"
    LAW_ID=$(az monitor log-analytics workspace show --resource-group "$RG" --workspace-name "$LAW_NAME" --query id -o tsv 2>/dev/null || \
      az monitor log-analytics workspace create --resource-group "$RG" --workspace-name "$LAW_NAME" --query id -o tsv)

    # DNS zone for HTTP routing
    DNS_ZONE_NAME="${DNS_ZONE_NAME:-}"
    if [[ -z "$DNS_ZONE_NAME" ]]; then
      echo "ERROR: DNS_ZONE_NAME must be set for HTTP routing"
      exit 1
    fi
    echo "DNS zone: $DNS_ZONE_NAME"
    az network dns zone show --resource-group "$RG" --name "$DNS_ZONE_NAME" >/dev/null 2>&1 || {
      echo "DNS zone $DNS_ZONE_NAME not found. Creating..."
      az network dns zone create --resource-group "$RG" --name "$DNS_ZONE_NAME"
    }

    # GitOps identity
    GITOPS_IDENTITY_NAME="${GITOPS_IDENTITY_NAME:-${CLUSTER_NAME}-gitops}"
    GITOPS_REPO_URL="${GITOPS_REPO_URL:-}"
    if [[ -z "$GITOPS_REPO_URL" ]]; then
      echo "ERROR: GITOPS_REPO_URL must be set for GitOps"
      exit 1
    fi
    GITOPS_BRANCH="${GITOPS_BRANCH:-main}"
    GITOPS_CONFIG_PATH="${GITOPS_CONFIG_PATH:-clusters/production}"
    echo "GitOps identity: $GITOPS_IDENTITY_NAME"
    GITOPS_IDENTITY_ID=$(az identity show --resource-group "$RG" --name "$GITOPS_IDENTITY_NAME" --query id -o tsv 2>/dev/null || \
      az identity create --resource-group "$RG" --name "$GITOPS_IDENTITY_NAME" --query id -o tsv)

    echo "--- Deploying with all addons ---"
    az deployment group create \
      --resource-group "$RG" \
      --template-file "$TEMPLATE_FILE" \
      --parameters clusterName="$CLUSTER_NAME" \
        vnetName="$VNET_NAME" \
        subnetName="$SUBNET_NAME" \
        roleDefinitionId="$ROLE_ID" \
        enableMonitoring=true \
        logAnalyticsWorkspaceId="$LAW_ID" \
        enablePolicy=true \
        enableKeyVaultProvider=true \
        enableHttpRouting=true \
        httpRoutingZoneName="$DNS_ZONE_NAME" \
        enableGitOps=true \
        gitOpsRepoUrl="$GITOPS_REPO_URL" \
        gitOpsBranch="$GITOPS_BRANCH" \
        gitOpsConfigPath="$GITOPS_CONFIG_PATH" \
        gitOpsIdentityId="$GITOPS_IDENTITY_ID" \
        enableNetworkPolicy=true
    ;;

  *)
    echo "ERROR: Unknown mode '$MODE'. Use 'minimal' or 'full'."
    exit 1
    ;;
esac

echo "=== Deployment complete ==="
echo "Get credentials (from a machine with VNet access):"
echo "  az aks get-credentials --resource-group $RG --name $CLUSTER_NAME --admin"
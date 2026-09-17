#!/bin/bash
# last_verified: 2026-09-17 · Azure CLI

# Purpose: stand up an Azure VM scale set behind a load balancer with
# autoscaling rules. This is one way to do it; the Azure portal and ARM
# templates also cover the same ground.

RESOURCE_GROUP="rg-vmss-demo"
LOCATION="eastus"
VMSS_NAME="app-vmss"
LB_NAME="app-lb"
CUSTOM_IMAGE="Canonical:UbuntuServer:22_04-lts:latest"
SKU="Standard_B2ms"

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

# --- Steps ---

# 1. Create the resource group.
echo "Creating resource group $RESOURCE_GROUP..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" || fail "az group create failed"

# 2. Create a public IP for the load balancer.
echo "Creating public IP for load balancer..."
az network public-ip create \
  --resource-group "$RESOURCE_GROUP" \
  --name "${LB_NAME}-pip" \
  --allocation-method Static \
  --sku Standard || fail "az network public-ip create failed"

# 3. Create the load balancer and backend pool.
echo "Creating load balancer $LB_NAME..."
az network lb create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$LB_NAME" \
  --frontend-ip-name "${LB_NAME}-frontend" \
  --public-ip-id "$(az network public-ip show --resource-group "$RESOURCE_GROUP" --name "${LB_NAME}-pip" --query id -o tsv)" \
  --backend-pool-name "${LB_NAME}-backend" || fail "az network lb create failed"

# 4. Add a health probe and load-balancing rule.
echo "Adding health probe and load-balancing rule..."
az network lb probe create \
  --resource-group "$RESOURCE_GROUP" \
  --lb-name "$LB_NAME" \
  --name "${LB_NAME}-probe" \
  --protocol Tcp \
  --port 80 \
  --interval 5 \
  --number-of-probes 2 || fail "az network lb probe create failed"

az network lb rule create \
  --resource-group "$RESOURCE_GROUP" \
  --lb-name "$LB_NAME" \
  --name "${LB_NAME}-rule" \
  --frontend-ip-name "${LB_NAME}-frontend" \
  --backend-pool-name "${LB_NAME}-backend" \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --probe-name "${LB_NAME}-probe" || fail "az network lb rule create failed"

# 5. Create the VM scale set with a custom image and attach it to the LB.
echo "Creating VM scale set $VMSS_NAME..."
az vmss create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$VMSS_NAME" \
  --image "$CUSTOM_IMAGE" \
  --sku "$SKU" \
  --instance-count 2 \
  --lb "$LB_NAME" \
  --backend-pool-name "${LB_NAME}-backend" \
  --admin-username azureadmin \
  --generate-ssh-keys || fail "az vmss create failed"

# 6. Configure autoscaling: scale from 2 to 10 instances based on CPU.
echo "Configuring autoscaling rules..."
az monitor autoscale create \
  --resource-group "$RESOURCE_GROUP" \
  --resource "$VMSS_NAME" \
  --resource-type Microsoft.Compute/virtualMachineScaleSets \
  --name "${VMSS_NAME}-autoscale" \
  --min-count 2 \
  --max-count 10 \
  --count 2 || fail "az monitor autoscale create failed"

az monitor autoscale rule create \
  --resource-group "$RESOURCE_GROUP" \
  --autoscale-name "${VMSS_NAME}-autoscale" \
  --condition "Average CPU Percentage > 75" \
  --scale out 1 \
  --cooldown 5 || fail "az monitor autoscale rule create (scale out) failed"

az monitor autoscale rule create \
  --resource-group "$RESOURCE_GROUP" \
  --autoscale-name "${VMSS_NAME}-autoscale" \
  --condition "Average CPU Percentage < 25" \
  --scale in 1 \
  --cooldown 5 || fail "az monitor autoscale rule create (scale in) failed"

# --- Verify ---

echo "Verifying deployment..."
az vmss show --resource-group "$RESOURCE_GROUP" --name "$VMSS_NAME" --show-details \
  --query "{name:name, provisioningState:provisioningState, sku:sku.name, instances:virtualMachine.profile.instanceView.statuses}" --output table || fail "az vmss show failed"

az monitor autoscale show --resource-group "$RESOURCE_GROUP" --name "${VMSS_NAME}-autoscale" --output table || fail "az monitor autoscale show failed"

echo "VMSS, load balancer, and autoscaling are ready."

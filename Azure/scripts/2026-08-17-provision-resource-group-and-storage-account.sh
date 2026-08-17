#!/bin/bash
# last_verified: 2026-08-17 · Azure CLI

# Provision a resource group and a storage account with the Azure CLI.
# I ran this after `az login` and `az account set --subscription <sub>` so I was in the right sub.

RESOURCE_GROUP="rg-demo-eastus"
LOCATION="eastus"
STORAGE_ACCOUNT="demosa$(date +%s)"

# 1. Create the resource group. Location is set here and child resources do NOT
#    inherit it automatically — I learned that the hard way in the quickstart.
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# 2. Create the storage account. Names must be globally unique and lowercase-only,
#    so I appended a timestamp to a base name to avoid collisions.
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS

# 3. Verify both exist and show what I just created.
az group show --name "$RESOURCE_GROUP" --output table
az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP" --output table

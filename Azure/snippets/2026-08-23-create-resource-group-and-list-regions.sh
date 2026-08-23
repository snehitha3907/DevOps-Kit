#!/bin/bash
# last_verified: 2026-08-23 · Azure CLI
# I wanted to create a resource group and see what Azure regions are available.

# Create a resource group in East US.
az group create --name my-demo-rg --location eastus

# List all available Azure regions in a table.
az account list-locations --output table

# Pull out just the region names with a query.
az account list-locations --query "[].{Region:name}" --output table

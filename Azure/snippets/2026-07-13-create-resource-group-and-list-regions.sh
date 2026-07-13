#!/usr/bin/env bash
# last_verified: 2026-07-13 - Azure CLI n/a
# Quick snippet: create a resource group and list Azure regions

# Create a resource group in East US
az group create --name my-demo-rg --location eastus

# List all available Azure regions in a table
az account list-locations --output table

# List just the region names using JMESPath query
az account list-locations --query "[].{Region:name}" --output table

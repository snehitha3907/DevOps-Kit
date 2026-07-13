#!/usr/bin/env bash
# last_verified: 2026-07-13 - Azure CLI n/a
# Tried installing Azure CLI and logging in for the first time

# Install via the official Microsoft script
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Check the installed version
az --version

# Log in interactively — opens a browser
az login

# Show the active subscription
az account show --output table

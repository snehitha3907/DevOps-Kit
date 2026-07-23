#!/usr/bin/env bash
# last_verified: 2026-07-23 · Helm n/a
# I installed Helm and tried out the basic CLI commands

# Installing Helm via the official script
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Checking the version
helm version

# Adding the stable Bitnami repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# Searching for an nginx chart on Artifact Hub
helm search hub nginx

# Listing repos to confirm everything worked
helm repo list

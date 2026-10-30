#!/usr/bin/env bash
# last_verified: 2026-10-27 · terraform n/a
set -euo pipefail

ENV="${1:-dev}"
cd "$(dirname "$0")/../environments/$ENV"
terraform init -backend-config=backend.tf
terraform plan -var-file=terraform.tfvars

# last_verified: 2026-09-13 · Terraform · n/a
# Select the named workspace, init, and apply the environment.
#
# Usage: ./apply.sh <env>      e.g. ./apply.sh dev
#
# The script cds into environments/<env>/ so the per-environment backend.tf
# override takes effect. If the workspace does not exist yet it is created.

set -euo pipefail

ENV="${1:-}"
if [ -z "$ENV" ]; then
  echo "usage: $0 <env>" >&2
  exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$DIR/../environments/$ENV"
if [ ! -d "$TARGET" ]; then
  echo "unknown environment: $ENV" >&2
  exit 1
fi

cd "$TARGET"

terraform init -input=false

if ! terraform workspace select "$ENV" 2>/dev/null; then
  terraform workspace new "$ENV"
fi

terraform apply -auto-approve -var-file="terraform.tfvars"
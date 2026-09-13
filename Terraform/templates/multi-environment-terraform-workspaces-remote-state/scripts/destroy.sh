# last_verified: 2026-09-13 · Terraform · n/a
# Select the named workspace and destroy the environment's resources.
#
# Usage: ./destroy.sh <env>     e.g. ./destroy.sh prod
#
# WARNING: this is destructive. It removes the workspace's managed resources
# but keeps the state object in S3 so a re-apply can resume.

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
terraform workspace select "$ENV"
terraform destroy -auto-approve -var-file="terraform.tfvars"
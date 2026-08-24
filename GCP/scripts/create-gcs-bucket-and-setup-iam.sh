#!/usr/bin/env bash
# last_verified: 2026-08-24 · GCP SDK (gcloud CLI)

set -euo pipefail

PROJECT_ID="${1:-}"
BUCKET_NAME="${2:-}"
LOCATION="${3:-US}"
IAM_MEMBER="${4:-}"

if [[ -z "$PROJECT_ID" || -z "$BUCKET_NAME" || -z "$IAM_MEMBER" ]]; then
    cat <<EOF
Usage: $0 <project-id> <bucket-name> [location] <iam-member>

Creates a GCS bucket and grants an IAM role on it.

Arguments:
  project-id    GCP project ID
  bucket-name   Name for the new GCS bucket (globally unique)
  location      Bucket location (default: US)
  iam-member    IAM member to grant access, e.g.
                serviceAccount:ci@PROJECT_ID.iam.gserviceaccount.com

Example:
  $0 my-project my-app-bucket US serviceAccount:ci@my-project.iam.gserviceaccount.com
EOF
    exit 1
fi

if ! command -v gcloud &>/dev/null || ! command -v gsutil &>/dev/null; then
    echo "Error: gcloud SDK (gcloud, gsutil) must be installed and in PATH" >&2
    exit 1
fi

echo "Setting active project to ${PROJECT_ID}"
gcloud config set project "$PROJECT_ID" >/dev/null

echo "Creating bucket gs://${BUCKET_NAME} in ${LOCATION}"
gsutil mb -p "$PROJECT_ID" -l "$LOCATION" "gs://${BUCKET_NAME}"

echo "Granting roles/storage.objectAdmin to ${IAM_MEMBER}"
gsutil iam ch "member:${IAM_MEMBER}:roles/storage.objectAdmin" "gs://${BUCKET_NAME}"

echo "Verifying bucket and IAM policy..."
if gsutil ls -p "$PROJECT_ID" | grep -q "gs://${BUCKET_NAME}/"; then
    echo "Bucket confirmed."
else
    echo "Warning: bucket not visible in project listing" >&2
fi

policy=$(gsutil iam get "gs://${BUCKET_NAME}")
if echo "$policy" | grep -q "$IAM_MEMBER"; then
    echo "IAM member confirmed."
else
    echo "Warning: IAM member not present in policy" >&2
fi

echo "Done."

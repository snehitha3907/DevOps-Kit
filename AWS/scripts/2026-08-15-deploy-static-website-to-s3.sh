#!/usr/bin/env bash
# last_verified: 2026-08-15 · AWS CLI

# I wanted one script that takes a local folder and publishes it as a
# static website on S3. The AWS CLI is all I need — no SDK, no
# CloudFormation, just a few commands chained together.

BUCKET="${1:-my-static-site-$(date +%s)}"
SOURCE_DIR="${2:-./site}"
REGION="${3:-us-east-1}"

if ! aws --version >/dev/null 2>&1; then
  echo "AWS CLI not found in PATH" >&2
  exit 1
fi

# Create the bucket. The name must be globally unique, so I default to a
# timestamped name if the caller doesn't pass one.
aws s3 mb "s3://${BUCKET}" --region "${REGION}"

# Turn on static-website hosting. index.html is mandatory even if the
# site is a single page — the endpoint returns 200 only when it exists.
aws s3 website "s3://${BUCKET}" --index-document index.html

# Upload everything. public-read makes the objects reachable from the
# website endpoint without signed URLs. For a real site I'd put
# CloudFront in front, but this is the simplest proof-of-concept.
aws s3 sync "${SOURCE_DIR}" "s3://${BUCKET}/" --acl public-read

echo "http://${BUCKET}.s3-website-${REGION}.amazonaws.com"

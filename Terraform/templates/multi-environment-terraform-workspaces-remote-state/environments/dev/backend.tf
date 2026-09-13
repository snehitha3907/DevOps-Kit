# last_verified: 2026-09-13 · Terraform · n/a
# Dev environment backend override.
#
# This file sits in environments/dev/ and is loaded when the apply/destroy
# scripts cd into that folder. It re-declares the backend block with a
# workspace-specific key so dev state never shares an S3 object with prod.

terraform {
  backend "s3" {
    bucket         = "tf-state-<your-account-id>"
    region         = "us-east-1"
    key            = "multi-env/dev/terraform.tfstate"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
}
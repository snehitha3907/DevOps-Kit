# last_verified: 2026-09-13 · Terraform · n/a
# Prod environment backend override.
#
# Loaded when the apply/destroy scripts cd into environments/prod/. Uses a
# separate key prefix from dev so the two state files never collide, and the
# DynamoDB lock table is shared so the lock still serializes across envs.

terraform {
  backend "s3" {
    bucket         = "tf-state-<your-account-id>"
    region         = "us-east-1"
    key            = "multi-env/prod/terraform.tfstate"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
}
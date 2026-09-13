# last_verified: 2026-09-13 · Terraform · n/a
# Shared outputs. Values are namespaced by environment so callers can pick
# up the right one without hardcoding.

output "environment" {
  description = "The active Terraform workspace / environment name."
  value       = terraform.workspace
}

output "state_bucket_key" {
  description = "The S3 key where this environment's state lives."
  value       = "multi-env/${terraform.workspace}/terraform.tfstate"
}
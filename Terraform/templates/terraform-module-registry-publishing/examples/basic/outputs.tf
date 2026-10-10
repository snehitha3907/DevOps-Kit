output "bucket_name" {
  description = "S3 bucket name created by the module"
  value       = module.artifact_bucket.module_artifacts_bucket_name
}

output "bucket_arn" {
  description = "S3 bucket ARN created by the module"
  value       = module.artifact_bucket.module_artifacts_bucket_arn
}
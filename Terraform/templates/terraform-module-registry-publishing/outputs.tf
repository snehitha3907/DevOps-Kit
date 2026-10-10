output "module_artifacts_bucket_name" {
  description = "Name of the S3 bucket for module artifacts"
  value       = aws_s3_bucket.module_artifacts.id
}

output "module_artifacts_bucket_arn" {
  description = "ARN of the S3 bucket for module artifacts"
  value       = aws_s3_bucket.module_artifacts.arn
}

output "module_name" {
  description = "Name of the module"
  value       = var.module_name
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}
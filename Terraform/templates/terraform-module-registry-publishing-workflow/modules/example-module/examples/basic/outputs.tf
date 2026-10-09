# last_verified: 2026-10-09 · Terraform · n/a
# Example outputs.

output "bucket_id" {
  description = "The ID of the created bucket."
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "The ARN of the created bucket."
  value       = module.s3_bucket.bucket_arn
}
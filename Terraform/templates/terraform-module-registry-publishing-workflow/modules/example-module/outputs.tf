# last_verified: 2026-10-09 · Terraform · n/a
# Output values for the example module.

output "bucket_id" {
  description = "The ID (name) of the created S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the created S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The domain name of the bucket (for website hosting or direct access)."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the bucket."
  value       = aws_s3_bucket_versioning.this.versioning_configuration[0].status
}
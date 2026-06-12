output "bucket_name" {
  description = "Resolved bucket name."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN for IAM policies / event notifications."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Regional domain name."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "random_suffix" {
  description = "The suffix used for auto-generated names (useful for naming sidecars)."
  value       = random_id.suffix.hex
}
# last_verified: 2026-10-09 · Terraform · n/a
# Input variables for the example module. All variables must have descriptions.

variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket. Must be globally unique."
  type        = string
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3 and 63 characters."
  }
}

variable "prevent_destroy" {
  description = "When true, prevents the bucket from being destroyed. Recommended for production."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to all taggable resources."
  type        = map(string)
  default     = {}
}
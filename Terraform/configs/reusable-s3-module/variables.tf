variable "bucket_name" {
  description = "Explicit bucket name. Leave empty to auto-generate from bucket_prefix."
  type        = string
  default     = ""
}

variable "bucket_prefix" {
  description = "Prefix for auto-generated bucket name (keep short, S3 limit is ~63 chars)."
  type        = string
  default     = "tf-module-s3"
}

variable "environment" {
  description = "Env label for tags."
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Turn on versioning."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "tags" {
  description = "Extra tags merged onto the bucket."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
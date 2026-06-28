variable "bucket_name" {
  description = "Explicit bucket name. Leave empty to auto-generate from bucket_prefix."
  type        = string
  default     = ""
}

variable "bucket_prefix" {
  description = "Prefix for auto-generated bucket name."
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

variable "lifecycle_rules" {
  description = <<-EOT
    Lifecycle rules for the S3 bucket. Each rule supports expiration, storage class transitions,
    noncurrent version handling, and incomplete multipart upload cleanup.
    Set transition_storage_class to one of: STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, GLACIER, DEEP_ARCHIVE.
  EOT
  type = list(object({
    id                                         = string
    enabled                                    = bool
    prefix                                     = optional(string)
    tags                                       = optional(map(string))
    expiration_days                            = optional(number)
    transition_days                            = optional(number)
    transition_storage_class                   = optional(string)
    noncurrent_version_expiration_days         = optional(number)
    noncurrent_version_transition_days         = optional(number)
    noncurrent_version_transition_storage_class = optional(string)
    abort_incomplete_multipart_upload_days     = optional(number)
  }))
  default = []
  validation {
    condition = alltrue([
      for r in var.lifecycle_rules : (
        r.transition_days == null || r.transition_storage_class != null
      )
    ])
    error_message = "transition_storage_class is required when transition_days is set."
  }
  validation {
    condition = alltrue([
      for r in var.lifecycle_rules : (
        r.noncurrent_version_transition_days == null || r.noncurrent_version_transition_storage_class != null
      )
    ])
    error_message = "noncurrent_version_transition_storage_class is required when noncurrent_version_transition_days is set."
  }
}

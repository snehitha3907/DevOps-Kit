# last_verified: 2026-08-17 · Terraform
# A reusable module pattern: accept a map of inputs, validate them up front,
# and fan out one bucket per entry with for_each. Validation blocks catch bad
# input at plan time instead of half-way through apply.

variable "buckets" {
  description = "Map of bucket name -> tags."
  type = map(object({
    tags = map(string)
  }))

  validation {
    condition     = alltrue([for name, cfg in var.buckets : can(regex("^[a-z0-9][a-z0-9.-]+$", name))])
    error_message = "Each bucket name must be lowercase letters, digits, dots, or hyphens."
  }

  validation {
    condition     = alltrue([for name, cfg in var.buckets : contains(keys(cfg.tags), "Environment")])
    error_message = "Each bucket must carry an 'Environment' tag."
  }

  validation {
    condition     = length(var.buckets) > 0
    error_message = "Provide at least one bucket."
  }
}

resource "aws_s3_bucket" "this" {
  for_each = var.buckets

  bucket = each.key

  tags = each.value.tags
}

output "bucket_ids" {
  value = { for name, b in aws_s3_bucket.this : name => b.id }
}

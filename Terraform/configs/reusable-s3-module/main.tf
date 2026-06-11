terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

locals {
  # Build a deterministic bucket name; caller can override with explicit value.
  default_name = "${var.bucket_prefix}-${random_id.suffix.hex}"
  bucket_name  = var.bucket_name != "" ? var.bucket_name : local.default_name
}

# Suffix so "my-app" doesn’t collide with someone else’s module run.
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  tags   = merge(var.tags, { Name = local.bucket_name })
}

# Versioning — cheap insurance against accidental overwrite.
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# Encryption at rest with AWS-managed keys (SSE-S3).
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access — most buckets don’t need it.
# Keeping variables for each flag so reviewer can reason about them individually.
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
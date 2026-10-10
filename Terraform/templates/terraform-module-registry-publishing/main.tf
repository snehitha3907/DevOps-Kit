# Main module configuration
# Replace this with your module's actual resources

locals {
  common_tags = merge(
    {
      Module      = "terraform-aws-${var.module_name}"
      Environment = var.environment
      Owner       = var.owner
    },
    var.tags
  )
}

# Example: S3 bucket for module artifacts
resource "aws_s3_bucket" "module_artifacts" {
  bucket = "${var.module_name}-${var.environment}-${random_id.suffix.hex}"

  tags = local.common_tags
}

resource "aws_s3_bucket_versioning" "module_artifacts" {
  bucket = aws_s3_bucket.module_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "module_artifacts" {
  bucket = aws_s3_bucket.module_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
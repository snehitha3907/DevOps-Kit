terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "example_bucket" {
  source      = path.module
  environment = "dev"
  tags = {
    Test = "true"
  }

  lifecycle_rules = [
    {
      id            = "expire-logs"
      enabled       = true
      prefix        = "logs/"
      expiration_days = 90
      transition_days            = 30
      transition_storage_class   = "STANDARD_IA"
    },
    {
      id                                 = "cleanup-old-versions"
      enabled                            = true
      prefix                             = ""
      noncurrent_version_expiration_days = 30
    }
  ]
}

output "example_arn" {
  value = module.example_bucket.bucket_arn
}

output "lifecycle_rules" {
  value = module.example_bucket.lifecycle_rule_ids
}

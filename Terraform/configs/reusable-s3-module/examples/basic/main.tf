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
  source      = path.module   # Points to reusable-s3-module/ when placed in caller
  environment = "dev"
  tags = {
    Test = "true"
  }
}

output "example_arn" {
  value = module.example_bucket.bucket_arn
}
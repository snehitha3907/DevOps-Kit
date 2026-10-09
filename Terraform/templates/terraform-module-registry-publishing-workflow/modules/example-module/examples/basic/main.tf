# last_verified: 2026-10-09 · Terraform · n/a
# Basic example usage of the module.

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3_bucket" {
  source = "../../"

  bucket_name     = "example-bucket-${random_id.suffix.hex}"
  aws_region      = var.aws_region
  prevent_destroy = false

  tags = {
    Environment = "example"
    Owner       = "terraform-module-template"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

variable "aws_region" {
  description = "AWS region for the example."
  type        = string
  default     = "us-east-1"
}
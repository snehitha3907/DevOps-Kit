# last_verified: 2026-09-13 · Terraform · n/a
# Shared Terraform configuration for the multi-environment scaffold.
# The backend block is declared here but overridden per environment by
# environments/<env>/backend.tf.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
  }
  backend "s3" {
    bucket         = "tf-state-<your-account-id>"
    region         = "us-east-1"
    key            = "multi-env/terraform.tfstate"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
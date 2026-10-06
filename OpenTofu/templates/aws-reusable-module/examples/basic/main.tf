# last_verified: 2026-10-05 · OpenTofu n/a
# Example caller: a root module that consumes the shared VPC module.
# The root owns the provider block (region, credentials, version pins);
# the module only receives variables. Copy this directory, adjust the
# source address to wherever the module is published, and fill in values.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../.."

  project_name         = "demo"
  environment          = "dev"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway   = true

  tags = {
    Project = "demo"
    Owner   = "platform-team"
  }
}

variable "aws_region" {
  description = "AWS region for the example deployment."
  type        = string
  default     = "us-east-1"
}

output "vpc_id" {
  description = "VPC ID as returned by the shared module."
  value       = module.network.vpc_id
}

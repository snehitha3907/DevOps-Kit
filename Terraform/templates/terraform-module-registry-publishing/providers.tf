provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Module        = "terraform-aws-${var.module_name}"
      ManagedBy     = "Terraform"
      Environment   = var.environment
      Owner         = var.owner
    }
  }
}
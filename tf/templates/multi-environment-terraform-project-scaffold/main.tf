# last_verified: 2026-10-27 · terraform n/a

terraform {
  required_version = ">= 1.5"
}

locals {
  project = "example"
}

module "network" {
  source = "../modules/network"

  name        = "${local.project}-${var.environment}"
  cidr_block  = var.vpc_cidr
  tags        = var.tags
}

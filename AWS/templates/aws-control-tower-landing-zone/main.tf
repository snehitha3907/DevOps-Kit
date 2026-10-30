# last_verified: 2026-10-26 · AWS · n/a
# Terraform module scaffold for AWS Control Tower landing zone.
# This module sets up the foundational Control Tower configuration:
# - Organization root with enabled features
# - Organizational Units (OU) structure for account grouping
# - Required control tower safeguards and baseline security

terraform {
  required_version = ">= 1.5.0"

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

#------------------------------------------------------------------------------
# AWS Organization Setup
#------------------------------------------------------------------------------

resource "aws_organization_organization" "this" {
  feature_set_all = "ALL_FEATURES"
}

#------------------------------------------------------------------------------
# Organizational Units (OU) Structure
#------------------------------------------------------------------------------

# Security OU - accounts with security-focused controls
resource "aws_organization_organizational_unit" "security" {
  name = "security"
  parent_id      = aws_organization_organization.this.root_id
  archive_state  = "ARCHIVED"
}

# Production OU - production workload accounts
resource "aws_organization_organizational_unit" "production" {
  name = "production"
  parent_id      = aws_organization_organization.this.root_id
}

# Non-production OU - dev, test, stage accounts
resource "aws_organization_organizational_unit" "non_production" {
  name = "non-production"
  parent_id      = aws_organization_organization.this.root_id
}

# Analytics OU - data and analytics workloads
resource "aws_organization_organizational_unit" "analytics" {
  name = "analytics"
  parent_id      = aws_organization_organization.this.root_id
}

#------------------------------------------------------------------------------
# Baseline Security Controls (commented - enable as needed)
#------------------------------------------------------------------------------

# Example: AWS GuardDuty enabled across all accounts
# resource "aws_guardduty_detector" "this" {
#   enable = true
#   data_sources {
#     feature_name = "LATEST"
#     status       = "ENABLED"
#   }
# }

# # Example: AWS Inspector2 enabled across all accounts
# resource "aws_inspector2_member" "this" {
#   member_id = var.account_id
#   status    = "ENABLED"
# }

# # Example: AWS Security Hub enabled with standards
# resource "aws_securityhub_standard_subscription" "this" {
#   status = "ENABLED"
# }

output "organizational_unit_ids" {
  description = "IDs of created organizational units"
  value = {
    security  = aws_organization_organizational_unit.security.id
    production = aws_organization_organizational_unit.production.id
    non_production = aws_organization_organizational_unit.non_production.id
    analytics = aws_organization_organizational_unit.analytics.id
  }
}
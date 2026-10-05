# last_verified: 2026-10-05 · OpenTofu n/a
# Provider requirements for the shared module. The version upper bound lives
# in the consuming root module's versions.tf so every environment upgrades in
# lockstep; this block only names the providers the module calls.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

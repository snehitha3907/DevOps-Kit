# last_verified: 2026-10-25 · Vault n/a
# vlt-019: AppRole auth method, a least-privilege policy, and a token role.
# Applied with the HashiCorp Vault Terraform provider. No Vault version is pinned
# here because none appears in research.md — pin the provider version in the caller.

variable "vault_addr" {
  description = "Address of the Vault cluster"
  type        = string
  default     = "http://127.0.0.1:8200"
}

terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
  }
}

provider "vault" {
  address = var.vault_addr
}

# Enable the AppRole auth method at path "approle".
resource "vault_auth_backend" "approle" {
  type = "approle"
}

# Least-privilege policy: read and list only the app's own secrets.
resource "vault_policy" "app_readonly" {
  name = "app-readonly"
  policy = <<-EOF
path "secret/data/app/*" {
  capabilities = ["read", "list"]
}
EOF
}

# Token role issued under AppRole: tokens are bound to the policy above.
resource "vault_auth_backend_role" "app_token_role" {
  backend       = vault_auth_backend.approle.path
  role_name     = "app"
  token_policies = [vault_policy.app_readonly.name]
  token_ttl     = "20m"
  token_max_ttl = "1h"
}

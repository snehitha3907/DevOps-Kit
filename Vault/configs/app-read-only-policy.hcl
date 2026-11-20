# last_verified: 2026-11-20 · HashiCorp Vault 2.2.2
# Read-only policy for an application's own secret path (KV v2).
# Apply with: vault policy write myapp-read app-read-only-policy.hcl
# Then issue a scoped token: vault token create -policy=myapp-read

path "secret/data/myapp/*" {
  capabilities = ["read"]
}

# Deny direct access to the password rotation endpoint, even if a broader
# grant would otherwise allow it (deny overrides broader grants).
path "secret/data/myapp/rotated" {
  capabilities = ["deny"]
}

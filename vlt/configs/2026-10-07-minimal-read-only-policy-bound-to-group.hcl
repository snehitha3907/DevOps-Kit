# last_verified: 2026-10-07 · Vault policy HCL
# vlt-015 scratch: a least-privilege read-only policy, and the group it binds to.
# I have not applied this yet — it is the policy I plan to attach to a token
# in the next session, after the kv-v2 write/read/list script runs.
#
# Bind this policy to a group with the API, e.g.:
#   vault write identity/group \
#     name="readers" \
#     policies="read-only-hello" \
#     member_entity_ids=(...)
# Then issue tokens with `vault token create -policy=read-only-hello`.

# Only one path, only one capability. Nothing else is reachable.
path "secret/data/hello" {
  capabilities = ["read"]
}

# Also allow listing what versions exist at that path (kv-v2 metadata read).
path "secret/metadata/hello" {
  capabilities = ["read"]
}
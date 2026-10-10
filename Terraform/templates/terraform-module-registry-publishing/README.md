# Terraform Module Registry Publishing Workflow

## Purpose
Automated publishing workflow for Terraform modules to the public or private Terraform Registry. This template provides a complete module structure with CI/CD pipeline that validates, tests, and publishes modules on version tags.

## When to Use
- Publishing reusable Terraform modules to the public Terraform Registry
- Maintaining private module registry for organizational modules
- Enforcing consistent module structure and quality gates across teams

## Prerequisites
- Terraform >= 1.6.0
- GitHub repository with Actions enabled
- Terraform Registry account (public) or private registry endpoint
- GPG signing key for module verification (recommended)

## Repository Structure
```
.
├── .github/
│   └── workflows/
│       └── publish-module.yml      # Publishing workflow
├── examples/
│   └── basic/
│       ├── main.tf                 # Example usage
│       ├── variables.tf
│       └── outputs.tf
├── tests/
│   └── basic_test.go               # Terratest validation
├── main.tf                         # Module root configuration
├── variables.tf                    # Input variables
├── outputs.tf                      # Output values
├── versions.tf                     # Provider and Terraform version constraints
├── providers.tf                    # Provider configurations
├── README.md                       # Module documentation (auto-generated)
├── CHANGELOG.md                    # Version history
├── .terraform-docs.yml             # terraform-docs configuration
├── .tflint.hcl                     # TFLint configuration
└── LICENSE                         # Module license
```

## Publishing Workflow

### Trigger
Workflow runs on version tags matching `v*` (e.g., `v1.0.0`, `v2.3.1`).

### Steps
1. **Validate** — `fmt -check`, `init`, `validate`
2. **Lint** — TFLint with custom rules
3. **Test** — Terratest integration tests against real infrastructure
4. **Document** — Generate README with terraform-docs
5. **Sign** — GPG sign the module zip (if GPG key configured)
6. **Publish** — Upload to Terraform Registry via API
7. **Verify** — Confirm module appears in registry

### Required Secrets
| Secret | Description |
|--------|-------------|
| `TF_REGISTRY_TOKEN` | Terraform Registry API token |
| `GPG_PRIVATE_KEY` | GPG private key for signing (optional) |
| `GPG_PASSPHRASE` | GPG key passphrase (optional) |

## Usage
1. Copy this template to a new repository named `terraform-<provider>-<name>`
2. Update `versions.tf` with required providers
3. Implement module logic in `main.tf`
4. Add examples in `examples/basic/`
5. Write tests in `tests/`
6. Configure repository secrets
7. Push and tag: `git tag v1.0.0 && git push origin v1.0.0`

## Verify
After publishing, verify the module appears at:
- Public: `https://registry.terraform.io/modules/<namespace>/<name>/<provider>`
- Private: `<registry-host>/modules/<namespace>/<name>/<provider>`

Run `terraform init` in a test directory referencing the module to confirm download works.

## Rollback
If a published version has issues:
1. Do not delete from registry (breaks consumers)
2. Publish a patch version with fixes (e.g., `v1.0.1`)
3. Update CHANGELOG with migration notes
4. Deprecate bad version in registry UI if supported

## Common Errors
| Error | Cause | Resolution |
|-------|-------|------------|
| `module not found` | Registry propagation delay | Wait 5-10 minutes, retry |
| `signature verification failed` | GPG key mismatch | Verify GPG_PRIVATE_KEY matches public key on registry |
| `validation failed` | Syntax or provider errors | Run `terraform validate` locally first |
| `test timeout` | Infrastructure provisioning slow | Increase test timeout or use smaller instance types |

## References
- Terraform Module Registry Protocol: https://www.terraform.io/docs/registry/api-docs.html
- Publishing Modules: https://developer.hashicorp.com/terraform/registry/modules/publish
- Module Structure: https://developer.hashicorp.com/terraform/language/modules/develop/structure
- terraform-docs: https://terraform-docs.io/
- TFLint: https://github.com/terraform-linters/tflint
- Terratest: https://terratest.gruntwork.io/
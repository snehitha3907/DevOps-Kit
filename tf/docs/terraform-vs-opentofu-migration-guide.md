---
last_verified: 2026-10-25
tool_version: n/a
sources: []
---

# Terraform vs OpenTofu Migration Guide

## Purpose

This guide covers the practical considerations for migrating from Terraform to OpenTofu, including state compatibility, provider parity, and CI/CD pipeline updates. OpenTofu is a fork of Terraform 1.5.x that maintains backward compatibility while developing independently under the MPL-2.0 license.

## When to Use

- Teams evaluating OpenTofu as a drop-in replacement for Terraform
- Organizations requiring MPL-2.0 licensing for infrastructure tooling
- Projects needing features or bug fixes present in OpenTofu but not yet in Terraform
- CI/CD pipelines that can accommodate a binary swap with minimal configuration changes

## Prerequisites

- Existing Terraform configuration (version 1.5.x or later recommended)
- Terraform state stored in a supported backend (local, S3, Azure Blob, GCS, Consul, etcd, HTTP, Kubernetes, PG, remote)
- Provider versions compatible with the Terraform 1.5.x protocol
- Access to modify CI/CD pipeline definitions
- Backup of current state files before migration

## Migration Steps

### 1. Verify State Compatibility

OpenTofu reads and writes Terraform 1.5.x-compatible state files. No state migration is required for most backends.

```bash
# Test read compatibility with current state
tofu init -backend-config="bucket=my-tf-state" -backend-config="key=prod/terraform.tfstate"
tofu state list
```

If `tofu state list` returns resources without errors, the state is compatible. For remote backends, verify the backend configuration block uses arguments supported by both tools.

### 2. Validate Provider Parity

OpenTofu uses the same provider protocol as Terraform 1.5.x. Most providers work without changes.

```hcl
# Check required_providers block — no changes needed for most providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```

Providers that use custom plugin protocols or rely on Terraform Cloud/Enterprise-specific features may require updates. Check the provider changelog for OpenTofu compatibility notes.

### 3. Update CLI Commands

Replace `terraform` invocations with `tofu` in scripts, Makefiles, and documentation. The CLI surface is intentionally compatible.

```bash
# Common command mapping
terraform init     → tofu init
terraform plan     → tofu plan
terraform apply    → tofu apply
terraform destroy  → tofu destroy
terraform fmt      → tofu fmt
terraform validate → tofu validate
terraform state    → tofu state
terraform import   → tofu import
terraform output   → tofu output
terraform console  → tofu console
terraform providers → tofu providers
```

Aliases or wrapper scripts can ease transition:

```bash
# Optional: alias for muscle memory
alias tf=tofu
```

### 4. Update CI/CD Pipeline Definitions

#### GitHub Actions

```yaml
# Before
- uses: hashicorp/setup-terraform@v3
  with:
    terraform_version: 1.9.0

# After
- uses: opentofu/setup-opentofu@v1
  with:
    tofu_version: 1.8.0
    # or use the Terraform-compatible wrapper
- uses: hashicorp/setup-terraform@v3
  with:
    terraform_version: 1.9.0
    # setup-terraform also installs tofu when version format matches
```

The `hashicorp/setup-terraform` action supports OpenTofu versions when specified as `tofu/<version>`.

#### GitLab CI

```yaml
# Before
variables:
  TERRAFORM_VERSION: "1.9.0"

before_script:
  - curl -fsSL <terraform-release-url> -o terraform.zip
  - unzip terraform.zip && chmod +x terraform

# After
variables:
  OPENTOFU_VERSION: "1.8.0"

before_script:
  - curl -fsSL <opentofu-install-url> | bash -s -- -v ${OPENTOFU_VERSION}
  - export PATH=$PATH:/usr/local/bin
```

#### Jenkins Pipeline

```groovy
// Before
tools {
  terraform 'terraform-1.9.0'
}

// After
tools {
  // Requires OpenTofu tool installer plugin or custom wrapper
  // Many teams use a Docker image with tofu pre-installed
}
```

### 5. Handle Workspace and Backend Differences

OpenTofu supports the same workspace commands and backend types. The `terraform.workspace` variable and `terraform.workspace` interpolation work identically.

```bash
# Workspace operations are identical
tofu workspace list
tofu workspace new staging
tofu workspace select production
```

Backend configuration blocks require no syntax changes:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-tf-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf-lock-table"
  }
}
```

### 6. Address HCL and Language Differences

OpenTofu tracks Terraform 1.5.x HCL syntax. Features added in Terraform 1.6+ (e.g., `moved` blocks, `check` blocks, `ephemeral` resources, `provider` meta-argument enhancements) may not be present or may behave differently.

| Feature | Terraform | OpenTofu 1.x |
|---------|-----------|--------------|
| `moved` blocks | 1.1+ | Partial support |
| `check` blocks | 1.5+ | Supported |
| `ephemeral` resources | 1.8+ | Planned |
| `provider` functions | 1.7+ | Not yet |
| `import` blocks | 1.5+ | Supported |
| `removed` blocks | 1.7+ | Not yet |

Test configurations with `tofu validate` and `tofu plan` before applying.

### 7. Manage Lock Files

OpenTofu generates `tofu.lock.hcl` (equivalent to `.terraform.lock.hcl`). Commit this file to version control. The lock file format is compatible; OpenTofu can read Terraform lock files and vice versa in most cases.

```bash
# Regenerate lock file with OpenTofu
tofu init -upgrade
# Commits tofu.lock.hcl
```

### 8. Test in Staging Environment

Run a full plan/apply cycle in a non-production environment:

```bash
tofu init
tofu plan -out=tfplan
tofu apply tfplan
```

Verify all resources report "No changes" on a second plan run, indicating idempotency.

## Verify

1. **State integrity**: `tofu state list` matches `terraform state list` output exactly
2. **Plan parity**: `tofu plan` produces no unexpected changes against the same configuration
3. **Provider operations**: All resource create/read/update/delete operations succeed
4. **CI/CD execution**: Pipeline completes with `tofu` binary, artifacts upload correctly
5. **Team workflow**: Developers can run `tofu` locally with existing configurations

## Common Errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `Error: Required plugins not available` | Provider not in registry mirror or lock file mismatch | Run `tofu init -upgrade` to refresh lock file |
| `Error: Backend initialization failed` | Backend config uses Terraform Cloud/Enterprise-only features | Use standard backend (S3, Azure, GCS) or migrate to OpenTofu-compatible remote backend |
| `Error: Unsupported argument` | Configuration uses Terraform 1.6+ HCL features not in OpenTofu | Refactor to use 1.5.x-compatible syntax or wait for OpenTofu parity |
| `Error: Provider produced inconsistent result` | Provider version pinned to version requiring newer protocol | Update provider to version compatible with Terraform 1.5.x protocol |
| `Permission denied` on state backend | Credentials not passed to `tofu` process | Ensure AWS/GCP/Azure credentials available in CI environment |

## Rollback Procedure

If migration reveals blocking issues:

1. Revert CI/CD pipeline to use `terraform` binary
2. Restore `.terraform.lock.hcl` from git (discard `tofu.lock.hcl`)
3. Run `terraform init -reconfigure` to reinitialize with Terraform
4. Verify `terraform plan` shows no changes
5. Document specific incompatibilities for future retry

State files written by OpenTofu remain readable by Terraform 1.5.x+, so no state restoration is needed.

## References

- OpenTofu documentation (opentofu.org/docs)
- Terraform 1.5.x upgrade guide (developer.hashicorp.com/terraform/upgrade-guides/1-5)
- Provider compatibility matrix (opentofu.org/docs/intro/provider-compatibility/)
- Migration case studies (opentofu.org/docs/intro/migration-stories/)
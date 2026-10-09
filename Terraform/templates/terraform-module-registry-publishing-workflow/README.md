---
last_verified: 2026-10-09
tool_version: n/a
sources:
  - https://developer.hashicorp.com/terraform/registry/modules/publish
  - https://developer.hashicorp.com/terraform/cloud-docs/registry/publish-modules
  - https://github.com/benoitblais-hashicorp-demo/terraform-module-template/blob/main/.github/workflows/module_release.yml
---

# Terraform Module Registry Publishing Workflow — Project Scaffold

> A reusable scaffold for publishing Terraform modules to the public Terraform Registry or an HCP Terraform / Terraform Enterprise private registry using GitHub Actions. Supports both single-module and multi-module (monorepo) repositories with automated semantic versioning, release generation, and registry publishing.

## Layout

```
terraform-module-registry-publishing-workflow/
├── README.md
├── .github/
│   ├── workflows/
│   │   ├── release.yml              # GitHub Release creation on tag push
│   │   ├── publish-public.yml       # Publish to public Terraform Registry (webhook-driven)
│   │   ├── publish-private.yml      # Publish to HCP Terraform / TFE private registry via API
│   │   └── dependabot.yml           # Dependabot config for provider and action updates
├── modules/
│   └── example-module/              # Example standard module structure
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       ├── README.md
│       └── examples/
│           └── basic/
│               ├── main.tf
│               └── outputs.tf
├── scripts/
│   ├── tag-release.sh               # Helper to create and push semantic version tags
│   └── validate-module.sh           # Validate module structure before publish
└── docs/
    ├── publishing-guide.md          # Step-by-step publishing setup
    └── monorepo-guide.md            # Multi-module repository patterns
```

## Purpose

This scaffold provides a complete, production-ready workflow for publishing Terraform modules to the Terraform Registry. It handles:

- **Standard module structure** — conforms to HashiCorp's module requirements (root-level HCL, README, versions.tf, examples)
- **Automated releases** — GitHub Actions workflow creates releases on semantic version tag push (`v*.*.*`)
- **Public registry publishing** — leverages the Registry's GitHub webhook; pushing a valid tag triggers automatic import
- **Private registry publishing** — uses the HCP Terraform / TFE API to publish modules with full control over versioning, no-code enablement, and multi-module repositories
- **Multi-module (monorepo) support** — tag prefix pattern (`<module-name>/v*.*.*`) enables independent versioning per module
- **Dependency management** — Dependabot configuration for Terraform providers and GitHub Actions

## When to Use

- Publishing a new Terraform module to the public registry for community consumption
- Managing private modules in HCP Terraform or Terraform Enterprise with API-driven publishing
- Maintaining a monorepo with multiple independently versioned modules
- Teams needing a standardized, auditable release and publishing pipeline

## Prerequisites

- GitHub repository (public for public registry; public or private for private registry)
- For public registry: GitHub account linked to Terraform Registry, repository added via Registry UI
- For private registry: HCP Terraform or Terraform Enterprise organization, API token with `registry:write` scope
- Terraform >= 1.5 (for `moved` blocks and `optional()` syntax used in examples)
- `jq`, `git`, `sha256sum` available in CI runners (standard on `ubuntu-latest`)

## Module Structure Requirements

The Terraform Registry requires modules to follow the standard structure:

| File / Directory | Required | Purpose |
|------------------|----------|---------|
| `main.tf` | Yes | Primary entry point; resources, data sources, module calls |
| `variables.tf` | Yes | Input variable declarations with descriptions and types |
| `outputs.tf` | Yes | Output value declarations with descriptions |
| `versions.tf` | Yes | `terraform` block with `required_version` and `required_providers` |
| `README.md` | Yes | Module documentation (auto-rendered on Registry) |
| `examples/` | Recommended | Working usage examples (at least one) |
| `CHANGELOG.md` | Optional | Human-readable version history |
| `.github/workflows/` | This scaffold | CI/CD for validation, release, and publish |

## Quick Start (Single-Module Repository)

```bash
# 1. Copy this scaffold into a new repository
cp -r terraform-module-registry-publishing-workflow/* /path/to/new-module-repo/
cd /path/to/new-module-repo

# 2. Customize the example module
#    - Edit modules/example-module/ → rename to your module name
#    - Update variables.tf, outputs.tf, main.tf with your resources
#    - Update versions.tf with your provider requirements

# 3. Configure GitHub repository secrets
#    Public registry: no secrets needed (uses GITHUB_TOKEN)
#    Private registry: add TFE_TOKEN secret with HCP Terraform API token

# 4. For private registry: update .github/workflows/publish-private.yml
#    - Set TFC_ORGANIZATION to your organization name
#    - Adjust module_name, provider_name if needed

# 5. Create and push initial release tag
./scripts/tag-release.sh 1.0.0
git push origin v1.0.0

# 6. Verify: GitHub Release created, module appears in Registry
```

## Workflows

### `release.yml` — GitHub Release Creation

Triggers on tag push matching `v*.*.*` (single-module) or `*/v*.*.*` (multi-module). Creates a GitHub Release with auto-generated notes. For multi-module repos, extracts module name and version from the tag.

**Key features:**
- Minimal permissions (`contents: write`)
- Uses `ncipollo/release-action` for reliable release creation
- Supports `git-cliff` for customizable changelogs (opt-in via `enable-cliff: true`)

### `publish-public.yml` — Public Registry Publishing

**No separate workflow needed.** The public Terraform Registry uses a GitHub webhook configured when you add the module via the Registry UI. Pushing a valid semantic version tag (`v1.0.0` or `1.0.0`) automatically triggers the Registry to fetch and publish the module.

**Requirements:**
- Repository added to Registry via "Publish Module" UI
- Webhook registered (Registry does this automatically)
- Tags follow semantic versioning

### `publish-private.yml` — Private Registry Publishing (HCP Terraform / TFE)

Triggers on the same tag patterns as `release.yml`. Uses the Registry Modules API to:
1. Create or update the module version
2. Upload the module source as a tarball
3. Optionally enable no-code provisioning

**Configuration (via repository variables or workflow edits):**
- `TFC_ORGANIZATION` — HCP Terraform organization name
- `MODULE_NAME` — Module name (defaults to repository name)
- `PROVIDER_NAME` — Provider namespace (e.g., `aws`, `azurerm`, `google`)
- `TFE_TOKEN` secret — API token with registry write permissions

**Monorepo support:** Set `MODULE_SOURCE_DIR` to the module subdirectory path.

## Multi-Module (Monorepo) Pattern

For repositories containing multiple modules, use the tag prefix convention:

```
module-a/v1.0.0
module-b/v2.3.1
```

The `release.yml` workflow includes an `extract-module` job that parses the tag and passes module name and version to the reusable release workflow. The `publish-private.yml` workflow reads `MODULE_SOURCE_DIR` from the tag prefix.

Directory layout:

```
terraform-modules-repo/
├── .github/workflows/          # Shared workflows (this scaffold)
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── versions.tf
│   │   └── ...
│   ├── rds/
│   │   ├── main.tf
│   │   └── ...
│   └── eks/
│       └── ...
```

## Dependabot Configuration

The `dependabot.yml` workflow configures automated updates for:
- **Terraform providers** — weekly checks, grouped by provider
- **GitHub Actions** — weekly checks, grouped minor/patch updates
- **Terraform modules** — (if using module sources from Registry)

## Validation Script

`scripts/validate-module.sh` runs pre-publish checks:

```bash
./scripts/validate-module.sh modules/example-module
```

Checks:
- Required files exist (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md`)
- `versions.tf` declares `required_version` and `required_providers`
- `terraform fmt -check` passes
- `terraform validate` passes (requires initialized backend)
- No `.tfstate` files tracked

## Tagging Helper

`scripts/tag-release.sh` creates annotated semantic version tags:

```bash
# Patch release
./scripts/tag-release.sh patch
# Minor release
./scripts/tag-release.sh minor
# Major release
./scripts/tag-release.sh major
# Explicit version
./scripts/tag-release.sh 2.1.0
```

## Verify

After pushing a tag:

1. **GitHub Actions** — check the `release` workflow run (green = release created)
2. **Public Registry** — visit `https://registry.terraform.io/modules/<namespace>/<name>/<provider>/<version>` (appears within ~1 minute)
3. **Private Registry** — check the `publish-private` workflow run; verify module version in HCP Terraform UI under Registry → Modules
4. **Consume the module** — test with a temporary configuration:

```hcl
module "test" {
  source  = "<namespace>/<name>/<provider>"
  version = "1.0.0"
  # ... required variables
}
```

## Common Errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `module version already exists` | Tag pushed twice or version conflict | Delete the GitHub Release and tag locally/remote, fix version, re-tag |
| `webhook not triggered (public)` | Registry webhook missing or repo not public | Re-add module via Registry UI; ensure repo is public |
| `API 401 / 403 (private)` | Invalid or insufficient `TFE_TOKEN` | Generate new token with `registry:write` scope; update secret |
| `module source directory not found` | `MODULE_SOURCE_DIR` incorrect | Set to relative path from repo root (e.g., `modules/vpc`) |
| `terraform validate failed` | Missing provider backend or invalid HCL | Run `terraform init` in module dir; fix HCL syntax |
| `tag format not recognized` | Tag doesn't match `v*.*.*` or `*/v*.*.*` | Use semantic versioning: `v1.0.0` or `module-name/v1.0.0` |

## Rollback

To unpublish a module version:

- **Public Registry**: Not directly supported. Delete the GitHub Release and tag; Registry will not remove already-published versions. Contact HashiCorp support for exceptional cases.
- **Private Registry**: Use the HCP Terraform UI (Module → Manage Module → Delete Version) or API:
  ```bash
  curl -X DELETE \
    -H "Authorization: Bearer $TFE_TOKEN" \
    -H "Content-Type: application/vnd.api+json" \
    "https://app.terraform.io/api/v2/organizations/$ORG/registry-modules/private/$ORG/$MODULE/$PROVIDER/versions/$VERSION"
  ```

Then delete the GitHub Release and tag.

## References

- Terraform Registry module publishing: https://developer.hashicorp.com/terraform/registry/modules/publish
- HCP Terraform private registry: https://developer.hashicorp.com/terraform/cloud-docs/registry/publish-modules
- Standard module structure: https://developer.hashicorp.com/terraform/registry/modules/publish#requirements
- Registry Modules API: https://developer.hashicorp.com/terraform/cloud-docs/api-docs/registry-modules
- GitHub Actions for Terraform: https://github.com/hashicorp/terraform-github-actions
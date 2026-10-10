---
last_verified: 2026-10-10
tool_version: n/a
---

# OpenTofu Provider Development: Creating a Custom Provider

## Purpose

This document describes the process for developing a custom provider for OpenTofu. A custom provider extends OpenTofu's ability to manage infrastructure by implementing the provider protocol, allowing users to interact with APIs and services that lack official provider support.

## When to Use

- The target service or API has no official OpenTofu/Terraform provider
- Existing providers lack coverage for specific resources or data sources
- Internal tooling or proprietary platforms require infrastructure-as-code management
- Prototyping provider concepts before contributing upstream

## Prerequisites

- Go development environment (provider SDK is Go-based)
- Understanding of the Terraform Plugin Protocol (OpenTofu follows the same protocol)
- Access to the target service's API documentation and authentication mechanisms
- Familiarity with schema design for resources and data sources

## Steps

### 1. Initialize the Provider Scaffold

Use the provider scaffolding tool to generate the initial project structure:

```bash
go install github.com/hashicorp/terraform-plugin-framework/cmd/tfplugingen@latest
tfplugingen generate --provider-name=<provider-name>
```

The scaffold includes:
- Provider server implementation
- Resource and data source templates
- Schema definitions using the plugin framework
- Build and test configuration

### 2. Define the Provider Schema

Configure the provider block with authentication and endpoint settings:

```go
func New(version string) func() provider.Provider {
    return func() provider.Provider {
        return &myProvider{
            version: version,
        }
    }
}

type myProvider struct {
    version string
}

func (p *myProvider) Metadata(ctx context.Context, req provider.MetadataRequest, resp *provider.MetadataResponse) {
    resp.TypeName = "myprovider"
    resp.Version = p.version
}

func (p *myProvider) Schema(ctx context.Context, req provider.SchemaRequest, resp *provider.SchemaResponse) {
    resp.Schema = schema.Schema{
        Attributes: map[string]schema.Attribute{
            "endpoint": schema.StringAttribute{
                Optional:    true,
                Description: "API endpoint URL",
            },
            "api_key": schema.StringAttribute{
                Optional:    true,
                Sensitive:   true,
                Description: "Authentication token",
            },
        },
    }
}
```

### 3. Implement Resource Types

Each managed resource requires Create, Read, Update, and Delete (CRUD) operations:

```go
type myResource struct{}

func (r *myResource) Metadata(ctx context.Context, req resource.MetadataRequest, resp *resource.MetadataResponse) {
    resp.TypeName = "myprovider_myresource"
}

func (r *myResource) Schema(ctx context.Context, req resource.SchemaRequest, resp *resource.SchemaResponse) {
    resp.Schema = schema.Schema{
        Attributes: map[string]schema.Attribute{
            "id":          schema.StringAttribute{Computed: true},
            "name":        schema.StringAttribute{Required: true},
            "description": schema.StringAttribute{Optional: true},
        },
    }
}

func (r *myResource) Create(ctx context.Context, req resource.CreateRequest, resp *resource.CreateResponse) {
    var plan MyResourceModel
    resp.Diagnostics.Append(req.Plan.Get(ctx, &plan)...)
    if resp.Diagnostics.HasError() {
        return
    }

    // Call target API to create resource
    created, err := apiClient.Create(plan.Name.ValueString(), plan.Description.ValueString())
    if err != nil {
        resp.Diagnostics.AddError("Create failed", err.Error())
        return
    }

    plan.ID = types.StringValue(created.ID)
    resp.Diagnostics.Append(resp.State.Set(ctx, &plan)...)
}
```

Implement Read, Update, and Delete following the same pattern with appropriate API calls.

### 4. Implement Data Sources

Data sources enable reading existing infrastructure:

```go
type myDataSource struct{}

func (d *myDataSource) Schema(ctx context.Context, req datasource.SchemaRequest, resp *datasource.SchemaResponse) {
    resp.Schema = schema.Schema{
        Attributes: map[string]schema.Attribute{
            "id":   schema.StringAttribute{Required: true},
            "name": schema.StringAttribute{Computed: true},
        },
    }
}

func (d *myDataSource) Read(ctx context.Context, req datasource.ReadRequest, resp *datasource.ReadResponse) {
    var config MyDataSourceModel
    resp.Diagnostics.Append(req.Config.Get(ctx, &config)...)

    data, err := apiClient.Get(config.ID.ValueString())
    if err != nil {
        resp.Diagnostics.AddError("Read failed", err.Error())
        return
    }

    config.Name = types.StringValue(data.Name)
    resp.Diagnostics.Append(resp.State.Set(ctx, &config)...)
}
```

### 5. Build and Test

Compile the provider binary:

```bash
go build -o terraform-provider-myprovider_vX.Y.Z
```

Run acceptance tests against a live API:

```bash
TF_ACC=1 go test ./... -v
```

Unit tests for logic without API calls:

```bash
go test ./internal/... -v
```

### 6. Install and Use

Place the binary in the OpenTofu plugin directory or use a local mirror:

```hcl
terraform {
  required_providers {
    myprovider = {
      source  = "local/myprovider"
      version = "X.Y.Z"
    }
  }
}
```

Configure and use in OpenTofu configuration:

```hcl
provider "myprovider" {
  endpoint = "https://api.example.com"
  api_key  = var.api_key
}

resource "myprovider_myresource" "example" {
  name        = "example-resource"
  description = "Managed by OpenTofu"
}
```

## Verify

- Provider binary responds to `terraform-provider-myprovider --version`
- `tofu init` downloads and initializes the provider without errors
- `tofu plan` shows expected changes for resource create/update/delete
- `tofu apply` successfully provisions and manages the target resource
- Acceptance tests pass against the target API (requires credentials)
- Schema validation accepts valid configurations and rejects invalid ones

## Common Errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `provider binary not found` | Binary not in plugin cache or local mirror | Verify binary name matches `terraform-provider-<name>_v<version>` and location |
| `schema validation failed` | Attribute types or required/optional mismatch | Align Go schema with intended configuration; run `tofu validate` |
| `API authentication failed` | Invalid or missing credentials | Confirm endpoint and authentication values in provider block |
| `resource create timeout` | API call exceeds default timeout | Increase client timeout or implement async create with state polling |
| `state drift after update` | Read implementation returns stale data | Ensure Read fetches current state from API after each operation |

## Rollback

If a provider version introduces breaking changes:

1. Pin the previous provider version in the required_providers block
2. Run `tofu init -upgrade` to downgrade
3. Run `tofu plan` to verify no unexpected changes
4. Apply the downgraded provider

## References

- Terraform Plugin Framework documentation
- OpenTofu provider development guides
- Terraform Plugin Protocol specification
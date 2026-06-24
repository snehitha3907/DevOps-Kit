# Following the Terraform providers tutorial

I followed the official HashiCorp tutorial on providers — "Providers" from the Get Started series. The previous getting-started notes covered the Docker provider specifically, so this time I wanted to understand providers in general: how Terraform discovers them, how versioning works, and how to use multiple providers in one config.

## What I did

I started with a config that uses both the `local` and `random` providers:

```hcl
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

resource "random_pet" "name" {}

resource "local_file" "pet" {
  filename = "${path.module}/pet.txt"
  content  = "My pet is ${random_pet.name.id}"
}
```

Ran `terraform init` and saw both providers get downloaded. The output shows the registry source and version for each.

## What the tutorial covers

The tutorial walks through:

1. **Provider requirements** — declaring providers in `required_providers` with source and version.
2. **Version constraints** — `~> 2.4` means any 2.x version >= 2.4 but < 3.0. I'd been using `version = "latest"` in my head — nope, Terraform wants explicit constraints.
3. **Provider source** — `hashicorp/<name>` is the official namespace. Third-party providers use a different path like `kreuzwerker/docker`.
4. **Multiple providers** — one config can use several providers. Each gets its own `required_providers` entry.
5. **Provider configuration** — some providers need extra config (like `region` for AWS). The `local` and `random` providers work with no config block at all.

## Got stuck on

- **Provider install location.** After `terraform init`, the `.terraform/providers/` directory has a long hash-based path. I tried to find the binary and was confused by the nested structure. The tutorial doesn't explain it, but it's basically `<registry>/<namespace>/<type>/<version>/<os>/<arch>/terraform-provider-<type>_v<version>`. Makes sense once you know.
- **The `required_providers` syntax changes.** Older tutorials use the shorthand `provider "local" {}` without the `required_providers` block. The current recommended approach is to always use `required_providers`. The official tutorial uses the modern style, but Googling errors pulls up old patterns that don't work anymore.
- **`terraform init -upgrade`** — I didn't know `-upgrade` existed. The tutorial mentions it when you want to update to the latest acceptable version within constraints. I tried it and it re-downloaded providers without touching state.
- **Provider cache.** By default, Terraform downloads providers per-project. The tutorial mentions `plugin_cache_dir` in the CLI config. I didn't set it up, but I see why you'd want to for CI — otherwise each build re-downloads everything.

## What I'd try next

I want to try a provider that needs explicit configuration — maybe the AWS provider with a region setting and a real resource. The tutorial hints at it but uses `local` and `random` for simplicity. I also want to understand provider aliases (using the same provider with different configurations in one project).

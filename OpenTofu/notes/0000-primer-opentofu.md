---
last_verified: 2026-07-18
tool_version: n/a
---

# OpenTofu — quick primer

> First-day notes for someone who's never used OpenTofu. Personal voice, plain language.

## What is it?

OpenTofu is an infrastructure-as-code tool. If Docker is container-as-code and Kubernetes is orchestration-as-code, OpenTofu is infrastructure-as-code — you describe servers, networks, DNS, and cloud services in config files, and OpenTofu creates them. I'm used to clicking around cloud consoles or SSH-ing into a VPS; OpenTofu turns that into a repeatable, shareable plan. It's a fork of Terraform, so the commands and the `.tf` language feel almost identical to me — same `init`, `plan`, `apply`, `destroy` flow I already know.

## What does it do?

You write `.tf` files declaring what you want — "an instance, a security group, a bucket" — then run `tofu init`, `tofu plan`, and `tofu apply`. It figures out what exists vs what you declared and makes the API calls to match them. You can tear everything down with `tofu destroy`.

## Why does it exist?

Before tools like this, people either clicked cloud consoles (error-prone, not repeatable) or wrote scripts with cloud-specific CLIs (hard to share, no drift detection). OpenTofu gives a single declarative language across AWS, Azure, GCP, and on-prem things too. The plan/apply cycle catches drift — if someone manually adds a resource, `tofu plan` shows the diff. The fork came from wanting the tool to stay open-source and community-governed rather than controlled by a single vendor, so I reach for it when I want that guarantee.

## Key terminology

- **Provider** — A plugin for a platform. `provider "aws" { region = "us-east-1" }` sets it up.
- **Resource** — A thing to create. `resource "local_file" "hello" { content = "hi" }` declares one.
- **State** — A snapshot of real infrastructure. Stored in `terraform.tfstate`. If it gets lost, OpenTofu doesn't know what it manages.
- **Plan** — A diff. `tofu plan` shows what will be created, changed, or destroyed.
- **Apply** — Executes the plan. `tofu apply` makes the API calls.
- **Destroy** — Tears everything down. `tofu destroy` removes managed resources.
- **Module** — A reusable group of resources. `module "vpc" { source = "./vpc" }` pulls it in.
- **Variable** — Input values. `variable "region" { default = "us-east-1" }` keeps configs flexible.
- **Output** — Exposes values. `output "ip" { value = local_file.hello.id }` prints it.
- **Backend** — Where state is stored. Local by default; S3 or a remote backend for teams.

## A tiny example

```hcl
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

resource "local_file" "hello" {
  content  = "Hello, OpenTofu!"
  filename = "${path.module}/hello.txt"
}
```

Save as `main.tf`, run `tofu init && tofu apply`, and it writes a local file. No cloud account needed — this is exactly the same as my first Terraform project.

## What I'll cover next

I'll install OpenTofu and verify the binary, then run a minimal local-file project so I can compare the workflow side-by-side with Terraform. After that I want to try variables and outputs to see how input handling feels.

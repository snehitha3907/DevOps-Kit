---
last_verified: 2026-11-15
tool_version: n/a
---

# Reusable Terraform modules

The previous lesson moved your state to a remote backend so multiple people can apply without corrupting state. This lesson takes the network configuration you built there and turns it into a reusable module — a folder of `.tf` files with input variables and outputs — then calls that same module once for a dev environment and once for a prod environment, each with its own values and its own state.

## What you'll learn

- Turn a group of resources into a reusable module with `variables.tf` (inputs), `main.tf` (resources), and `outputs.tf` (outputs).
- Call the same module from multiple environments with different variable values, and read its outputs with `module.<name>.<output>`.

## Before you start

- [Keep Terraform state remote and locked](./06-terraform-remote-state.md) — the network configuration and remote backend set up there are the starting point for this lesson.
- Terraform installed; confirm with `terraform --version`.

## Walkthrough

1. Create the module folder. Under your project root, create `modules/network/` with three files.

   `modules/network/variables.tf` — the module's inputs:

   ```hcl
   variable "name_prefix" {
     description = "Prefix used for every resource name."
     type        = string
   }

   variable "environment" {
     description = "Environment label, e.g. dev or prod."
     type        = string
   }

   variable "base_path" {
     description = "Folder where the network files are written."
     type        = string
     default     = "."
   }
   ```

   `modules/network/main.tf` — the network, written as local files so you can run it without a cloud account (continuing the stand-in from the previous lesson):

   ```hcl
   resource "local_file" "vpc" {
     content  = "VPC ${var.name_prefix} running in ${var.environment}"
     filename = "${var.base_path}/${var.environment}-vpc.txt"
   }

   resource "local_file" "public_subnet" {
     content  = "Public subnet ${var.name_prefix}"
     filename = "${var.base_path}/${var.environment}-public-subnet.txt"
   }

   resource "local_file" "private_subnet" {
     content  = "Private subnet ${var.name_prefix}"
     filename = "${var.base_path}/${var.environment}-private-subnet.txt"
   }
   ```

   `modules/network/outputs.tf` — the module's outputs, so callers can find the files it created:

   ```hcl
   output "vpc_file" {
     description = "Path to the VPC file."
     value       = local_file.vpc.filename
   }

   output "public_subnet_file" {
     description = "Path to the public subnet file."
     value       = local_file.public_subnet.filename
   }

   output "private_subnet_file" {
     description = "Path to the private subnet file."
     value       = local_file.private_subnet.filename
   }
   ```

   A module is just a folder of `.tf` files: `variables.tf` declares inputs, `main.tf` declares resources, `outputs.tf` exposes values callers can read. You can compare this against the existing `Terraform/configs/reusable-s3-module/` module for a real-world example with variables and outputs.

   You should see: three `.tf` files under `modules/network/`.

2. Call the module from an environment. Create `environments/dev/main.tf`:

   ```hcl
   terraform {
     required_providers {
       local = {
         source = "hashicorp/local"
       }
     }
   }

   module "network" {
     source      = "../../modules/network"
     name_prefix = "dev-net"
     environment = "dev"
     base_path   = "."
   }

   output "dev_vpc_file" {
     value = module.network.vpc_file
   }
   ```

   `source` tells Terraform where to find the module. `name_prefix`, `environment`, and `base_path` are the inputs you pass in. `module.network.vpc_file` reads back the output the module produced.

   Initialize and apply:

   ```bash
   cd environments/dev
   terraform init
   terraform apply -auto-approve
   ```

   You should see: `local_file.vpc`, `local_file.public_subnet`, and `local_file.private_subnet` created, plus three new `.txt` files in `environments/dev/`.

3. Add a second environment. Create `environments/prod/main.tf`:

   ```hcl
   terraform {
     required_providers {
       local = {
         source = "hashicorp/local"
       }
     }
   }

   module "network" {
     source      = "../../modules/network"
     name_prefix = "prod-net"
     environment = "prod"
     base_path   = "."
   }

   output "prod_vpc_file" {
     value = module.network.vpc_file
   }
   ```

   Then initialize and apply:

   ```bash
   cd ../prod
   terraform init
   terraform apply -auto-approve
   ```

   You should see: three `.txt` files in `environments/prod/` with `prod` in the names, independent from dev. Each environment has its own `.terraform/` and `terraform.tfstate`, so dev and prod never share state — the same isolation the remote backend gave you in the previous lesson, applied per environment. This lesson uses local state so you can run it without cloud credentials; the remote-backend pattern from the previous lesson applies per environment the same way.

## Exercise

On your own, extend what you just built:

1. Add a new input variable `owner` (string) to `modules/network/variables.tf` and include it in the content of each `local_file` resource.
2. Add a new output `file_count` to `modules/network/outputs.tf` that returns the number of files the module creates.
3. Create a third environment `environments/staging/main.tf` that calls the module with `name_prefix = "staging-net"`, `environment = "staging"`, and your `owner` value.
4. Run `terraform init`, `terraform plan`, and `terraform apply` in `environments/staging`. Confirm `terraform plan` reports 3 resources to add and the apply writes the three staging `.txt` files.

No solution is provided — write the code yourself and verify with the check below.

## Check your work

From `environments/staging`:

- `terraform validate` returns no errors.
- `terraform plan` reports exactly 3 resources to add.
- `terraform apply -auto-approve` creates `staging-vpc.txt`, `staging-public-subnet.txt`, and `staging-private-subnet.txt`.
- `terraform state list` shows `local_file.vpc`, `local_file.public_subnet`, and `local_file.private_subnet`.

## Common mistakes

- Forgetting `source = "..."` inside the `module` block — Terraform won't know where to find the module.
- Referencing `module.network.vpc_file` in the caller before the `module "network"` block is declared.
- Hardcoding `dev` inside `modules/network/main.tf` instead of using `var.environment` — then the module can't be reused for prod.
- Reading `module.network.vpc_file` as if it were `var.vpc_file` — outputs live on `module.<name>.<output>`, not `var`.

## Next

[Plan and apply Terraform from CI with OIDC](../../00_index/learning-path.md)

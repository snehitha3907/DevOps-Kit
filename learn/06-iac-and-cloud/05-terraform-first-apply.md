---
last_verified: 2026-11-13
tool_version: n/a
---
# Provision and destroy your first infrastructure

The Terraform primer showed you the plan/apply/destroy cycle in theory. This lesson runs it for real: you write a small network in HCL, preview the changes with `terraform plan`, create them with `terraform apply`, confirm a second plan reports no changes, then tear it all down with `terraform destroy`. No cloud account is needed — everything runs against local files using the `local` provider.

## What you'll learn
- Write, plan and apply a configuration for a small network
- Show that a second plan reports no changes
- Destroy everything and confirm nothing is left

## Before you start
- [Terraform — quick primer](../../Terraform/notes/0000-primer-terraform.md) — the plan/apply/destroy cycle, providers, resources, and state.
- [Infrastructure as Code Concepts — quick primer](../../docs/concepts/infrastructure-as-code-concepts/0000-primer-infrastructure-as-code-concepts.md) — declarative vs imperative, state, and drift detection.
- [AWS identity and networking basics](./03-aws-iam-vpc-basics.md) — what a VPC, subnet, and route table are, so the network you define below is meaningful.
- Terraform installed; confirm with `terraform --version`.

## Walkthrough

1. Create a working directory and a configuration that defines a small network — a VPC, a public subnet, and a private subnet — as local files.

   ```hcl
   terraform {
     required_providers {
       local = {
         source = "hashicorp/local"
       }
     }
   }

   provider "local" {}

   resource "local_file" "vpc" {
     content  = "name = lab-vpc\ncidr = 10.0.0.0/16"
     filename = "${path.module}/vpc.conf"
   }

   resource "local_file" "subnet_public" {
     content  = "name = public-subnet\nvpc = lab-vpc\ncidr = 10.0.1.0/24"
     filename = "${path.module}/subnet-public.conf"
   }

   resource "local_file" "subnet_private" {
     content  = "name = private-subnet\nvpc = lab-vpc\ncidr = 10.0.2.0/24"
     filename = "${path.module}/subnet-private.conf"
   }
   ```

   Save this as `main.tf` in an empty folder. The `local` provider needs no credentials and costs nothing.

2. Initialize the working directory so Terraform downloads the `local` provider:

   ```bash
   terraform init
   ```

   You should see Terraform install the `hashicorp/local` provider and report that the working directory is initialized.

3. Preview the changes Terraform will make:

   ```bash
   terraform plan
   ```

   You should see a plan that adds the three files: `3 to add, 0 to change, 0 to destroy`.

4. Apply the plan to create the network files:

   ```bash
   terraform apply -auto-approve
   ```

   You should see `Apply complete! Resources: 3 added, 0 changed, 0 destroyed.` and the three `.conf` files in your folder.

5. Run `terraform plan` again — with nothing changed, it should report no changes:

   ```bash
   terraform plan
   ```

   You should see `No changes. Your infrastructure matches the configuration.` (or `0 to add, 0 to change, 0 to destroy`).

6. Destroy everything and confirm nothing is left:

   ```bash
   terraform destroy -auto-approve
   ```

   You should see `Destroy complete! Resources: 3 destroyed.`

   Then confirm the state is empty:

   ```bash
   terraform state list
   ```

   You should see no output — the state holds no managed resources.

## Exercise

1. In an empty folder, write a `main.tf` that uses the `local` provider to define a small network of at least three files (for example a VPC, a subnet, and a route table). Do not copy the walkthrough verbatim — change the names, CIDR blocks, and file names.
2. Run `terraform init`, then `terraform plan`, then `terraform apply`.
3. Run `terraform plan` a second time and confirm it reports no changes.
4. Run `terraform destroy` and confirm `terraform state list` returns nothing.

## Check your work

- `terraform plan` after the first apply shows `3 to add, 0 to change, 0 to destroy` (or your resource count).
- `terraform apply` creates the files you declared in `main.tf`.
- The second `terraform plan` reports no changes (`0 to add, 0 to change, 0 to destroy`).
- `terraform destroy` removes the files, and `terraform state list` prints nothing afterward.

## Common mistakes

- Forgetting `terraform init` before `terraform plan` — Terraform cannot show a plan until the provider is installed.
- Editing `terraform.tfstate` by hand — state is Terraform's record of what it manages; never edit it directly.
- Destroying resources you still need — `terraform destroy` removes every managed resource in the configuration, with no undo.

## Next

[Keep Terraform state remote and locked](../../00_index/learning-path.md)

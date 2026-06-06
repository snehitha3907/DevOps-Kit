# Terraform — quick primer

> First-day notes for someone who's never used Terraform. Personal voice, plain language.

## What is it?

Terraform is an infrastructure-as-code tool from HashiCorp. If Docker is container-as-code and Kubernetes is orchestration-as-code, Terraform is infrastructure-as-code — you describe servers, networks, DNS, and cloud services in config files, and Terraform creates them. I'm used to clicking around the AWS console or SSH-ing into a VPS; Terraform turns that into a repeatable, shareable plan.

## What does it do?

You write `.tf` files declaring what you want — "an EC2 instance, a security group opening port 80, and an S3 bucket" — then run `terraform init`, `terraform plan`, and `terraform apply`. It figures out what exists vs what you declared and makes the API calls to match them. You can destroy everything with `terraform destroy`.

## Why does it exist?

Before Terraform, people either clicked cloud consoles (error-prone, not repeatable) or wrote scripts with cloud-specific CLIs (hard to share, no drift detection). Terraform gives a single declarative language across AWS, Azure, GCP, and even on-prem things like Proxmox. The plan/apply cycle catches drift — if someone manually adds a resource, `terraform plan` shows the diff.

## Key terminology

- **Provider** — A plugin for a platform. `provider "aws" { region = "us-east-1" }` sets it up.
- **Resource** — A thing to create. `resource "aws_instance" "web" { ami = "ami-abc123" }` declares one.
- **State** — A snapshot of real infrastructure. Stored in `terraform.tfstate`. If it gets lost, Terraform doesn't know what it manages.
- **Plan** — A diff. `terraform plan` shows what will be created, changed, or destroyed.
- **Apply** — Executes the plan. `terraform apply` makes the API calls.
- **Destroy** — Tears down everything. `terraform destroy` removes managed resources.
- **Module** — A reusable group of resources. `module "vpc" { source = "./vpc" }` pulls it in.
- **Variable** — Input values. `variable "region" { default = "us-east-1" }` keeps configs flexible.
- **Output** — Exposes values. `output "ip" { value = aws_instance.web.public_ip }` prints the IP.
- **Backend** — Where state is stored. Local by default; S3 or Terraform Cloud for teams.

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
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
}
```

Save as `main.tf`, run `terraform init && terraform apply`, and it writes a local file. No cloud account needed.

## What I'll cover next

I'll install Terraform and initialize my first project, then work through the main CLI commands — init, plan, apply, and destroy — to see how the workflow feels end to end.

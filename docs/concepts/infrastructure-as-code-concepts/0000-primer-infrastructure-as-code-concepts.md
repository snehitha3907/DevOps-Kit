---
last_verified: 2026-07-20
tool_version: n/a
---

# Infrastructure as Code Concepts — quick primer

> First-day notes on Infrastructure as Code. What it is, why it matters, and the key ideas to know.

## What is it?

Infrastructure as Code (IaC) is the practice of managing and provisioning computing infrastructure through machine-readable definition files instead of manual processes or interactive console clicks. Instead of logging into a cloud provider's web UI and clicking "Create server," I describe the desired infrastructure in code and let a tool apply it.

The core idea is simple: infrastructure should be treated like software. It gets versioned, reviewed, tested, and deployed through the same pipelines I use for application code. Tools like Terraform, Ansible, and CloudFormation each take a different approach to this, but they all share the goal of replacing manual setup with repeatable, auditable definitions.

IaC sits between "I SSHed in and ran these commands once" and "a platform engineer manually provisions everything." It gives me the best of both worlds — the speed of automation with the control of explicit definitions.

## Why does it matter for DevOps?

As a DevOps practitioner, IaC is how I bridge the gap between writing code and running it. Without IaC, every environment — development, staging, QA, production — is a manual reenactment of a checklist. With IaC, I run the same definition against every environment and get identical results.

IaC also gives me reproducibility. If a server gets misconfigured at 3 AM, I don't have to remember what I did six months ago. I can inspect the Terraform state or Ansible playbook that defines the expected state, compare it to reality, and re-apply if needed. Disaster recovery stops being a panicked scramble and becomes a documented procedure.

Onboarding new team members gets faster too. Instead of sitting with them for a day explaining which ports to open and which packages to install, I point them at the codebase. They run `terraform apply` or `ansible-playbook site.yml` and have a working environment in minutes.

## Key terminology

- **Declarative** — Describing the desired end state without listing the steps to get there. Example: "I want three nginx servers running" instead of "install nginx, start service, wait for port 80."
- **Imperative** — Listing explicit commands to execute in order. Example: a bash script that runs `apt install`, `systemctl start`, and `ufw allow` one after another.
- **State file** — A record of what infrastructure currently exists and its configuration. Example: `terraform.tfstate` tracks every AWS instance, security group, and S3 bucket Terraform has created.
- **Provider** — A plugin that understands how to create and manage resources in a specific platform. Example: the `aws` provider in Terraform knows how to create EC2 instances, S3 buckets, and RDS databases.
- **Resource** — A single piece of infrastructure defined in code. Example: an `aws_instance` resource or an `ansible.builtin.apt` task.
- **Module** — A reusable, self-contained bundle of IaC code that can be shared and composed. Example: a Terraform module for S3 buckets with versioning and encryption that I can drop into multiple projects.
- **Workspace** — An isolated instance of state for the same configuration. Example: Terraform workspaces `dev`, `staging`, and `prod` let me run identical code against separate state files.
- **Drift detection** — Comparing actual infrastructure against the declared state to find unmanaged changes. Example: noticing that someone manually resized an EC2 instance outside of Terraform.
- **Plan** — A preview of what changes IaC will make before applying them. Example: `terraform plan` shows "1 to add, 0 to change, 0 to destroy" so I can verify the impact.
- **Apply** — Executing the planned changes to make real infrastructure match the code. Example: `terraform apply` creates the resources the plan described.

## A concrete example

Here's the smallest useful IaC pattern: define an EC2 instance in Terraform, preview the change, then apply it.

```hcl
# main.tf — my desired state
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}
```

```bash
# Initialize, preview, and apply
terraform init
terraform plan    # shows what will be created
terraform apply   # creates the actual instance
```

I describe what I want in HCL, preview the exact changes with `plan`, then apply them. The state file remembers everything so future runs only change what's needed.

## How this connects to what's next

IaC concepts apply across every infrastructure tool. Once I understand providers, resources, and state, I can pick up Terraform, Ansible, OpenTofu, or Pulumi without relearning the fundamentals. The examples will differ, but the mental model of "define state, plan changes, apply" stays the same.

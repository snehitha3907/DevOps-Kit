---
last_verified: 2026-07-13
tool_version: n/a
---

# Azure CLI — quick primer

> First-day notes for someone who's never used the Azure CLI. Personal voice, plain language.

## What is it?

Azure CLI (`az`) is Microsoft's cross-platform command-line tool for managing Azure cloud resources. It is one of three main ways to interact with Azure — the others being the Azure Portal (web UI) and Azure PowerShell. Think of it as the cloud equivalent of a local terminal: instead of running `ls` to list files, you run `az vm list` to list virtual machines.

## What does it do?

It lets you create, read, update, and delete Azure resources — resource groups, VMs, databases, storage accounts, Kubernetes clusters, DNS zones — from a terminal or a CI/CD pipeline. Almost everything you can do in the Portal can be scripted with `az`.

## Why does it exist?

Before the CLI, managing Azure meant either clicking through the Portal (slow, error-prone, impossible to repeat) or writing custom PowerShell scripts. The CLI gives a consistent command surface that works the same on Linux, macOS, and Windows. DevOps engineers use it daily for automation — provisioning infra in pipelines, troubleshooting from a jump box, and wrapping IaC tooling.

## Key terminology

- **Resource group** — A logical container for related Azure resources. Example: `az group create --name my-rg --location eastus`.
- **Subscription** — A billing boundary and access scope. Every `az` command runs in a subscription context (`az account set --subscription "Pay-As-You-Go"`).
- **`az`** — The CLI binary. Everything starts with `az <group> <command>`. Example: `az storage account create`.
- **`--output` / `-o`** — Controls output format: `json` (default), `table`, `tsv`, `yaml`. Example: `az vm list -o table`.
- **`--query`** — JMESPath filter to pick specific fields from JSON output. Example: `az vm list --query "[].{Name:name, Location:location}"`.
- **Service principal** — A non-human identity for automation, used instead of a user account in CI/CD. Example: `az ad sp create-for-rbac`.
- **Location / region** — The Azure datacenter region where a resource lives. Example: `eastus`, `westeurope`, `southeastasia`.
- **`az login`** — Authenticates the CLI. Opens a browser by default; supports service principal login for automation.
- **ARM (Azure Resource Manager)** — The underlying REST API that `az` wraps. Every CLI command maps to an ARM API call.

## A tiny example

```bash
# Log in — opens a browser for authentication
az login

# Create a resource group in the East US region
az group create --name my-first-rg --location eastus

# List all resource groups in a clean table
az group list -o table
```

This logs you in, creates a resource group called `my-first-rg`, then lists all groups in a table view.

## What I'll cover next

Installing the CLI on my machine, logging in without a browser for CI/CD use, and trying basic commands against real resources like VMs and storage accounts.

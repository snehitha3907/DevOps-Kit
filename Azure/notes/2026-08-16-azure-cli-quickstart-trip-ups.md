---
last_verified: 2026-08-16
tool_version: n/a
sources: []
---

# Azure CLI quickstart — what tripped me up

> First-day notes following the Azure CLI quickstart. Personal voice, plain language.

## What I was trying to do

I wanted to get comfortable with the Azure CLI so I could manage resources from my terminal instead of clicking through the portal. I followed the official quickstart, installed the CLI, logged in, and started creating resource groups and storage accounts.

## What actually worked

Once I had `az` installed and `az login` completed, the basic commands felt familiar. `az group create` and `az storage account create` both worked on the first try once I picked a region that supports the storage account SKU I wanted. Listing resources with `az resource list` gave me a quick sanity check that everything landed where I expected.

## Got stuck on

**Resource group location vs. storage account location.** I assumed creating a resource group in `eastus` would automatically place every child resource there too. It doesn't. The storage account defaults to whatever region you pass to it, and if you omit it, Azure picks one for you — which isn't always what you want. I spent ten minutes looking for my storage account in the wrong region.

**`az login` output is noisy.** After running `az login`, the CLI prints a long JSON blob of subscriptions and tenants. As a beginner, I wasn't sure if that was expected or an error. It's normal, but a quiet-mode flag would have helped.

**Naming rules for storage accounts.** The quickstart used a simple name, but my first attempt failed because the name was already taken and because I didn't realize storage account names must be globally unique and lowercase-only. The error message mentioned "name conflict" but didn't say it was global until I read the docs page.

## What I'd try next

I want to explore `az configure` to set default values like location and output format so I don't have to type `--location eastus` on every command. I'm also curious about `--output table` vs `--output json` — table is friendlier for quick checks, but JSON is easier to pipe into other tools.

---
last_verified: 2026-07-14
tool_version: n/a
---

# Google Cloud SDK — quick primer

> First-day notes for someone who's never used the Google Cloud SDK. Personal voice, plain language.

## What is it?

The Google Cloud SDK is a set of command-line tools for managing Google Cloud Platform resources. Its main component is `gcloud`, but it also includes `gsutil` (for Cloud Storage) and `bq` (for BigQuery). If you've used the AWS CLI (`aws`) or the Azure CLI (`az`), this is Google's equivalent — one CLI to rule all their cloud services.

## What does it do?

It lets you create, inspect, update, and delete GCP resources from a terminal — VMs, storage buckets, databases, Kubernetes clusters, IAM policies, and more. You can run ad-hoc commands to troubleshoot, script entire infrastructure setups, or use it inside CI/CD pipelines for automated deployments.

## Why does it exist?

Before the SDK, you had to use the GCP Console web UI for everything — fine for one-off tasks, terrible for repeatability. The SDK gives a consistent command surface that works the same on Linux, macOS, and Windows. DevOps engineers use it daily for provisioning infra, troubleshooting issues in live environments, and wrapping Terraform or Ansible workflows with GCP-specific steps.

## Key terminology

- **`gcloud`** — The primary CLI tool. Every command follows `gcloud <service> <command>`. Example: `gcloud compute instances list`.
- **`gsutil`** — CLI tool for Cloud Storage (buckets and objects). Example: `gsutil ls gs://my-bucket/`.
- **`bq`** — CLI tool for BigQuery. Example: `bq query --use_legacy_sql=false 'SELECT 1'`.
- **Project** — The top-level container for GCP resources. Most `gcloud` commands need `--project` or `gcloud config set project`.
- **Zone / Region** — Where resources live. Zones are sub-divisions of regions. Example: `us-central1-a` (zone), `us-central1` (region).
- **`gcloud config`** — Persistent settings for the CLI (project, region, zone, account). Example: `gcloud config set compute/zone us-central1-a`.
- **Service account** — A non-human identity for automation. Used instead of a user account in pipelines.
- **Application Default Credentials (ADC)** — A strategy that `gcloud` and GCP client libraries use to find credentials automatically. Set via `gcloud auth application-default login`.
- **`--format`** — Controls output: `json`, `yaml`, `table`, `text`, `csv`, `list`. Example: `gcloud compute instances list --format="table(name,zone,status)"`.
- **`--filter`** — Server-side filtering of results. Example: `gcloud compute instances list --filter="status=RUNNING"`.

## A tiny example

```bash
# List all Compute Engine instances in the default project, as a table
gcloud compute instances list --format="table(name,zone,status)"
```

This one-liner shows every VM across every zone — name, zone, and whether it's running or stopped. It's the first thing I run to orient myself in a project.

## What I'll cover next

I want to try installing the SDK from scratch on a fresh machine, then move on to practical commands — listing resources, creating a bucket, and configuring authentication for automated use.

---
last_verified: 2026-10-30
tool_version: n/a
sources: []
---

# Pulumi state management and secrets encryption guide

Pulumi manages infrastructure state automatically as part of its core workflow. When you run `pulumi up`, the engine calculates the desired state, compares it against the last known state, and records any changes. This section covers how state is stored, how to configure backend storage, and how to handle sensitive values so they are never written to plaintext in version control.

## What does it do?

Pulumi's state engine tracks the lifecycle of every resource created or modified by a stack. State is stored in a `Pulumi.<stack>.json` file by default, but can be configured to use remote backends such as AWS S3, Azure Blob Storage, or Google Cloud Storage. Secrets are encrypted using the cloud provider's KMS integration before being written to state, and the encryption key is managed by the selected backend.

## Why does it exist?

Before Pulumi, infrastructure tools often required manual state file management, which led to merge conflicts, lost changes, and accidental exposure of sensitive values in git history. Pulumi addresses this by providing a consistent model for state reconciliation and by default encrypting secrets at rest. Teams that previously relied on shell scripts or ad-hoc Terraform workflows find that Pulumi's state model reduces operational overhead and improves auditability.

## Key terminology

- **Stack** – A logical grouping of resources and their current state, identified by a name and backend configuration.
- **State file** – The JSON document that Pulumi uses to track resource IDs, attributes, and outputs across runs.
- **Backend** – The storage system that persists the state file; options include local file systems, S3, Azure Blob, and GCS.
- **Secret** – A value such as a password or API key that Pulumi encrypts before persisting in the state file.

## A tiny example

The following Pulumi Python program demonstrates how to mark an output as a secret so that it is encrypted when written to state:

```python
import pulumi
import pulumi_aws as aws

bucket = aws.s3.Bucket("my-bucket")
secret_key = pulumi.Output.create(bucket.id).apply(lambda v: pulumi.Secret(v))

pulumi.export("bucket_name", bucket.bucket)
pulumi.export("secret_key", secret_key)
```

This ensures that `secret_key` is never stored in plaintext in the state file or version-controlled artifacts.

## What I'll cover next

I plan to explore how to configure a remote backend for state persistence and how to migrate an existing local stack to a cloud-backed storage solution.
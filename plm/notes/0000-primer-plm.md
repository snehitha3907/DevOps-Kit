---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# Pulumi — quick primer

> First-day notes for someone who's never used Pulumi. Personal voice, plain language.

## What is it?

I just learned Pulumi is a way to define cloud infrastructure using a normal programming language instead of a YAML or DSL file. I already knew Terraform's HCL a little; Pulumi is the same idea — describe what you want, let the tool create it — but I write it in Python, TypeScript, Go, or C#, with real loops, functions, and if-statements instead of template expressions.

The analogy that clicked for me: Pulumi is to cloud resources what an ORM is to databases. I stop hand-writing raw SQL (or raw YAML) for everything and instead describe what I want in code, and the tool translates that into the underlying calls. It sits in the infrastructure-as-code corner, next to Terraform and OpenTofu, and it talks to the same clouds through provider plugins.

## What does it do?

It lets me declare a cloud resource as an object in code, preview what creating it would change, deploy it with one command, and remember what it built so the next run only changes the diff. I keep the program in git like any other code, and Pulumi keeps track of the real-world things it created so my code and the cloud stay in sync.

## Why does it exist?

Before tools like this, I clicked through consoles or ran one-off CLI commands, which meant nobody could reproduce what I built and a typo could silently drift from what I meant. Then came declarative templates, which fixed reproducibility but made logic painful — counting loops and string templates for things a for-loop does naturally. Pulumi exists for people who already think in code and want the same tests, linters, and packages for their infrastructure that they have for their apps. The people I see reaching for it day-to-day are small platform teams managing app stacks who'd rather import a library than learn another templating language.

## Key terminology

- **Program** — the code file where I declare what I want. Example: a short Python file that creates one storage bucket.
- **Stack** — a named instance of my program, usually one per environment. Example: separate `dev` and `prod` stacks from the same code with different settings.
- **Provider** — the plugin that teaches Pulumi to talk to one cloud. Example: the AWS provider turns my bucket object into real API calls.
- **Preview** — a dry look at what would change before anything happens. Example: I run preview, see "1 to create", then decide to deploy.
- **State** — Pulumi's memory of what it already built and which outputs came back. Example: after creating a bucket, it remembers the bucket's real name for the next run.
- **Output** — a value the cloud hands back that I can reuse. Example: grabbing the bucket's endpoint to feed into an app's config.
- **Config** — per-stack settings so one program behaves differently per environment. Example: `dev` uses a small size while `prod` uses a bigger one.

## A tiny example

The smallest flow I can picture, in Python, is declare one bucket, preview it, then deploy it:

```python
import pulumi
import pulumi_aws as aws

bucket = aws.s3.Bucket("demo-bucket")
pulumi.export("bucket_name", bucket.id)
```

Then on the command line I would create a stack, preview the change, and deploy it. The caption for this: one bucket declared in plain Python, with its real name handed back as an output I could wire into something else.

## What I'll cover next

I want to actually install the CLI and stand up a stack from scratch, so the preview-then-deploy loop stops being theory. After that I'd like to try the same tiny stack twice — once for a dev stack and once for prod — to feel how stacks and config keep environments apart without duplicating code.

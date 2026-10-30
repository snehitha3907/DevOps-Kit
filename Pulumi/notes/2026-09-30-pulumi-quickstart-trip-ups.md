---
last_verified: 2026-09-30
tool_version: n/a
sources: []
---

# Pulumi quickstart — what tripped me up

I followed the official Pulumi quickstart this session and got a real stack deployed. Most of it worked on the first pass; a few things did not, and those are what I'm writing down here.

## What worked on the first try

`pulumi new python` scaffolded everything I needed: a `Pulumi.yaml` project file, a virtualenv, and a starter `__main__.py` with one S3 bucket already in it. I expected to have to hand-write that file, so the scaffold saved me a few minutes and gave me a working baseline I could diff against later.

The preview-then-deploy loop is the part I liked best. `pulumi preview` showed exactly one resource to create, and `pulumi up` confirmed the change before doing anything. The interactive prompt is the safety net, and `--yes` skips it when I already know what I want.

## What tripped me up

**1. The provider plugins are separate from the CLI.** My first `pulumi up` failed with a provider-not-found error for the AWS provider. The CLI and the provider plugin are different installs, and the plugin has to be present before the first real run. The fix was to install the AWS provider explicitly with `pulumi plugin install resource aws`, then re-run `pulumi up`.

**2. Stack config lives in a file named after the stack, not the project.** I looked for `Pulumi.yaml` to set per-environment values and nearly edited the project file. Stack settings live in `Pulumi.dev.yaml`. I set `config:aws:region: us-west-2` there and read it back with `pulumi config get aws:region`. The colon-separated `key: value` form threw me because it is not the usual YAML mapping I write.

**3. State is remote-capable but the default backend is a local file.** The quickstart's first run stores state in `~/.pulumi/` unless I set a backend. I tripped over the fact that a second developer who clones the repo gets no state at all, so their first `pulumi up` recreates everything. I need to decide up front whether I want the local dev backend or a real one before the stack stops being an experiment.

**4. `pulumi destroy` removes the resources, not the stack.** I ran destroy to clean up and expected the stack to disappear. It stayed, and a later `pulumi up` recreated the bucket with a new name because the old one was already gone. Remembering that the stack (the state file) and the resources it tracks are separate things would have saved me a confusing few minutes.

## What I'd try next

I want to take the same one-bucket program and make a second `prod` stack, then change the bucket name through stack config instead of editing the code, so I can feel how config separates environments without duplicating the program. After that I'd like to point the state at a real backend and watch what that does to the stack config file and to the local folder.
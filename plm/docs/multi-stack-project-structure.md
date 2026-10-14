---
last_verified: 2026-10-14
tool_version: n/a
sources: []
---

# How I structured a multi-stack Pulumi project: dev/staging stacks, StackReference, and cross-stack resource wiring

I stood up a small Pulumi project with three environments and needed the stacks to talk to each other instead of each one re-creating everything it needed. Here is the shape that worked.

## Layout

```
pulumi-project/
├── Pulumi.yaml            # project definition (name, runtime, description)
├── Pulumi.dev.yaml        # dev stack settings
├── Pulumi.staging.yaml    # staging stack settings
├── Pulumi.prod.yaml       # prod stack settings
├── stacks/
│   ├── dev/               # program for the dev stack
│   ├── staging/           # program for the staging stack
│   └── prod/              # program for the prod stack
└── components/            # shared Network component used by every stack
    └── network.py
```

One program per stack under `stacks/`, with shared logic living in `components/`. The stack programs are nearly identical — they import the same component and pass different config — which is the whole point.

## Stacks as environments

A Pulumi stack is a named instance of a program, and I treat one stack per environment. The `dev` stack gets small resource sizes and a generous budget; the `prod` stack gets the real sizes and tighter tags. Both run the same code, so the only difference is what the stack's config file says:

```yaml
# Pulumi.dev.yaml
config:
  aws:region: us-west-2
  app:instance-type: t3.micro
  app:owner: team-dev

# Pulumi.prod.yaml
config:
  aws:region: us-west-2
  app:instance-type: t3.large
  app:owner: team-prod
```

I read these back in code with `pulumi.config.get("app:instance-type")`, so the program never hard-codes an environment.

## Cross-stack wiring with StackReference

The networking stack and the application stack are separate programs, but the app needs the VPC's ID. Instead of duplicating the VPC or passing secrets around, I use a `StackReference`:

```python
import pulumi
import pulumi_aws as aws

network_stack = pulumi.StackReference("network", stack="dev")
vpc_id = network_stack.get_output("vpc_id")

vpc = aws.ec2.Vpc.get("app-vpc", vpc_id, opts=pulumi.ResourceOptions(parent=...))
```

The networking stack exports `vpc_id` through `pulumi.export`, and any other stack pulls it in with `StackReference("network", "<stack>")`. The reference is lazy — Pulumi resolves it at deploy time — so the two stacks stay decoupled in code and only resolve to real values when they need to.

## What I'd do differently

I initially put every stack's program in one file and branched on an environment variable. That quietly invited drift, because each branch could take a different code path. Keeping one program per stack under `stacks/` makes the diff between environments a config file, which is exactly where it should be.
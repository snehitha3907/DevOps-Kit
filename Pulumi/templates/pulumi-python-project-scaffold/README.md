---
last_verified: 2026-10-30
tool_version: n/a
sources: []
---

# Pulumi Python project scaffold

A starter Pulumi project in Python: the project file, two stack configs,
the Python entry point, and the package files needed to run it. The scaffold
is intentionally small — one bucket — so the shape of a real project is
visible without a wall of resources to read through.

## Layout

```
pulumi-python-project-scaffold/
├── README.md
├── Pulumi.yaml
├── Pulumi.dev.yaml
├── Pulumi.prod.yaml
├── __init__.py
└── requirements.txt
```

## What each file does

- `Pulumi.yaml` — the project definition. Tells Pulumi the project name, the
  runtime (python), and which Python major version to use.
- `Pulumi.<stack>.yaml` — per-stack config. `dev` and `prod` share the same
  namespaces but carry different values; secrets are stored encrypted under
  `secure:` prefixes.
- `__init__.py` — the program. Declares one S3 bucket and exports its real
  name and ARN so another resource or an app config can reference them.
- `requirements.txt` — declares the `pulumi` and `pulumi-aws` packages.

## How to use

1. Copy this directory into a repo of its own.
2. `pip install -r requirements.txt` to fetch `pulumi` and `pulumi-aws`.
3. `pulumi stack init dev`, then `pulumi up` to preview and deploy the dev
   stack.
4. Duplicate the dev stack file as `Pulumi.prod.yaml`, change the values, and
   `pulumi stack init prod` + `pulumi up` to deploy production.

## Verify

- `pip install -r requirements.txt` exits 0 and installs `pulumi` and
  `pulumi-aws`.
- `pulumi preview` shows exactly one resource to create and no errors.
- `pulumi stack output bucket_name` returns a real bucket name after deploy.

## Common errors

- **`@pulumi/aws` version mismatch with the provider** — pin the package
  version in `requirements.txt`; the package and the provider plugin are released
  separately and drift apart.
- **Bucket name already taken** — S3 bucket names are globally unique; change
  the name in `__init__.py` to something no other account has claimed.
- **Config key not found at runtime** — the key is read with
  `pulumi.Config.get("aws:region")`; if the stack file omits it, the call
  throws. Either set the value or use `getOrDefault`.

## References

- Pulumi project and stack file format: the `Pulumi.yaml` and
  `Pulumi.<stack>.yaml` files are documented in the Pulumi docs.
- Python runtime: the Python interpreter executes the `__init__.py` file;
  `requirements.txt` ensures the required packages are installed.
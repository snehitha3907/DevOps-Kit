---
last_verified: 2026-10-29
tool_version: n/a
sources: []
---

# Pulumi TypeScript project scaffold

A starter Pulumi project in TypeScript: the project file, two stack configs,
the TypeScript entry point, and the package and compiler files needed to run
it. The scaffold is intentionally small — one bucket — so the shape of a real
project is visible without a wall of resources to read through.

## Layout

```
pulumi-typescript-project-scaffold/
├── README.md
├── Pulumi.yaml
├── Pulumi.dev.yaml
├── Pulumi.prod.yaml
├── index.ts
├── package.json
└── tsconfig.json
```

## What each file does

- `Pulumi.yaml` — the project definition. Tells Pulumi the project name, the
  runtime (nodejs), and which Node major version to use.
- `Pulumi.<stack>.yaml` — per-stack config. `dev` and `prod` share the same
  namespaces but carry different values; secrets are stored encrypted under
  `secure:` prefixes.
- `index.ts` — the program. Declares one S3 bucket and exports its real name
  and ARN so another resource or an app config can reference them.
- `package.json` — declares the `@pulumi/pulumi` and `@pulumi/aws` packages.
- `tsconfig.json` — tells `tsc` how to compile the program before Pulumi runs
  it (Pulumi executes compiled JavaScript for the nodejs runtime).

## How to use

1. Copy this directory into a repo of its own.
2. `npm install` to fetch `@pulumi/pulumi` and `@pulumi/aws`.
3. `pulumi stack init dev`, then `pulumi up` to preview and deploy the dev
   stack.
4. Duplicate the dev stack file as `Pulumi.prod.yaml`, change the values, and
   `pulumi stack init prod` + `pulumi up` to deploy production.

## Verify

- `npm install` exits 0 and creates `node_modules`.
- `npx tsc` exits 0 and emits `index.js` (and nothing else in the root).
- `pulumi preview` shows exactly one resource to create and no errors.
- `pulumi stack output bucket_name` returns a real bucket name after deploy.

## Common errors

- **`@pulumi/aws` version mismatch with the provider** — pin the package
  version in `package.json`; the package and the provider plugin are released
  separately and drift apart.
- **`tsc` fails on missing types** — install `@types/node` and make sure
  `tsconfig.json` includes `"types": ["node"]`.
- **Bucket name already taken** — S3 bucket names are globally unique; change
  the name in `index.ts` to something no other account has claimed.
- **Config key not found at runtime** — the key is read with
  `pulumi.Config.get("aws:region")`; if the stack file omits it, the call
  throws. Either set the value or use `getOrDefault`.

## References

- Pulumi project and stack file format: the `Pulumi.yaml` and
  `Pulumi.<stack>.yaml` files are documented in the Pulumi docs.
- TypeScript runtime: the nodejs runtime executes the compiled JavaScript
  output of `tsc`; `tsconfig.json` is the compiler configuration.
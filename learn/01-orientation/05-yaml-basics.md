---
last_verified: 2026-11-02
tool_version: "yamllint 1.38.0"
sources:
  - https://yaml.org/spec/1.2.2/
  - https://yamllint.readthedocs.io/en/latest/quickstart.html
  - https://github.com/adrienverge/yamllint/releases/tag/v1.38.0
---

# Read and write YAML that validates

YAML is the format your tools read: Ansible playbooks, Kubernetes manifests, Docker Compose files, CI/CD configs. This lesson teaches you to write YAML correctly and to catch your own mistakes with `yamllint`, the same way a linter catches Python errors.

## What you'll learn

- Write mappings, lists and multi-line strings in YAML
- Validate a YAML file with yamllint and fix the errors it reports

## Before you start

- [Find your way around the lab shell](02-shell-navigation.md) — how to create, edit and inspect files from the command line
- [Scripting and automation — the basics](../../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md) — what scripting, Bash and Python are and why you need them before writing YAML tooling
- A Linux shell with Python 3 and pip. Confirm with `python3 --version` and `pip --version`.
- Install yamllint: `pip install --user yamllint` (or `sudo apt install yamllint` on Debian/Ubuntu).

## Walkthrough

1. Write a mapping and a list.

   ```yaml
   server:
     name: web-01
     ip: 10.0.0.11
     tags:
       - prod
       - web
   ```

   You should see: an indented mapping under `server:`, with `tags` holding a list. Indentation is YAML's only syntax — two spaces per level, consistently.

2. Write a multi-line string with a literal block scalar.

   ```yaml
   script: |
     #!/bin/bash
     echo "hello"
     echo "world"
   ```

   You should see: the `|` keeps every newline exactly as written. Use `|-` if you want the trailing newline stripped, and `|+` if you want it kept.

3. Fold long lines with the folded block scalar.

   ```yaml
   description: >
     This is a long paragraph that
     wraps onto several lines, and the
     blank line starts a new paragraph.
   ```

   You should see: `>` folds lines into spaces; a blank line creates a paragraph break.

4. Validate the file with yamllint.

   ```bash
   yamllint -f standard server.yml
   ```

   You should see: clean output means the file passes. Any line like `server.yml:5:1 error indentation: expected 2 but found 4 (indentation)` is a real error to fix.

5. Fix a reported error.

   If yamllint reports a trailing-space error, remove the whitespace at the end of that line. If it reports a duplicate key, delete the repeated key. If it reports a line too long, wrap it.

## Exercise

In `/tmp/yaml-lab`:

1. Create `app.yml` with a mapping for a service: name, replicas (a number), ports (a list of numbers), and a multi-line `description` using `|`.
2. Run `yamllint -f standard app.yml` and fix every error it reports until the output is clean.
3. Deliberately introduce one error (a trailing space, a duplicate key, a too-long line) and confirm yamllint catches it.

## Check your work

```bash
yamllint -f standard /tmp/yaml-lab/app.yml
```

You should see: no errors reported. Then:

```bash
python3 -c "import yaml; print(yaml.safe_load(open('/tmp/yaml-lab/app.yml')))"
```

You should see: the parsed mapping printed back, with `description` as a single string containing both lines.

## Common mistakes

- Forgetting indentation — YAML has no braces or brackets to hide behind; every line under a key must indent.
- Using tabs — YAML forbids tabs for indentation; use spaces.
- Writing `yes`, `no`, `on`, `off` as values — YAML 1.1 treats them as booleans; yamllint's `truthy` rule flags them. Use `true`/`false` or quote them.
- Forgetting the document start `---` — yamllint's `document-start` rule wants it by default.
- Trailing whitespace — the `trailing-spaces` rule catches it; editors usually strip it automatically.

## Next

[Write a safe Bash health-check script](06-bash-health-check.md)
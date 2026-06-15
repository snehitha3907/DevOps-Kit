# Wiring ansible-lint into an Ansible workflow

## Purpose

After writing a few playbooks, a lint step catches common mistakes before running them against a host. `ansible-lint` checks playbook syntax, best-practice violations, and idempotency risks — the kind of things that are easy to miss when iterating fast.

## Prerequisites

- Ansible installed (e.g. via pipx: `pipx install ansible`)
- A playbook to lint (this walkthrough uses `docker-python-setup.yaml` from `Ansible/configs/`)

## Steps

### 1. Install ansible-lint

Install it alongside Ansible in the same pipx environment so both tools share the same Ansible version:

```bash
pipx inject ansible ansible-lint
```

### 2. Run a first lint pass

```bash
ansible-lint Ansible/configs/docker-python-setup.yaml
```

The first run was quiet — no output. That might mean a clean playbook, or it could mean the remote rule download silently failed. Adding `--offline` avoids the download and gives more consistent feedback:

```bash
ansible-lint --offline Ansible/configs/nginx-webserver.yaml
```

This time two warnings appeared:

```
sanity-check[run-once]: Use of ansible.builtin.wait_for_connection with changed_when: false is correct but could use `connection: local`
fqcn[deep]: Found playbook level vars with `ansible` prefix
```

The first flags `wait_for_connection` style — the docs suggest `connection: local` as a cleaner alternative. The second flags variables prefixed `ansible_` in the playbook vars block, which trivy-lint categorizes as a "deep" FQCN namespace risk.

### 3. Fix violations

For `fqcn[deep]` there are two approaches: rename the variable to something without the `ansible_` prefix, or move it to a host var in the inventory. The second approach aligns better with how Ansible resolves `ansible_python_interpreter` anyway.

The `run-once` suggestion is more of a style preference — the official documentation shows the `wait_for_connection` pattern with `changed_when: false` as a valid approach, so this one is safe to suppress.

### 4. Set up a project-level config

A `.ansible-lint` file in the repo root controls which profile and rules apply:

```yaml
# .ansible-lint
profile: production
exclude_paths:
  - .git/
  - .github/
skip_list:
  - fqcn[deep]
  - run-once
ansible:
  version: "2.17"
```

The `profile: production` profile enables stricter checks like `no-changed-when` and `no-handler`. `fqcn[deep]` is skipped because `ansible_` prefixed variables in playbooks are common and the rule is overly broad for this use case. `run-once` is skipped because the `wait_for_connection` + `changed_when: false` combo is a documented pattern, not a bug.

### 5. Automate it

Adding ansible-lint before `ansible-playbook` calls is enough to catch most issues. One approach is a shell alias:

```bash
alias allint='ansible-lint --offline'
```

## Verify

After fixing the violations and setting the skip list, the playbooks pass clean:

```bash
ansible-lint --offline Ansible/configs/*.yaml
```

Exit code 0, no warnings. The two flags are gone. To confirm the config file is being read, run with `-v`:

```bash
ansible-lint --offline -v Ansible/configs/*.yaml
```

This shows which profile and skip rules are active.

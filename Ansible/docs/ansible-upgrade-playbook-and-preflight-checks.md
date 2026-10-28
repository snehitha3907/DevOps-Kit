---
last_verified: 2026-10-28
tool_version: ansible-core 2.21.6rc1
sources:
  - https://raw.githubusercontent.com/ansible/ansible/stable-2.21/changelogs/CHANGELOG-v2.21.rst
  - https://docs.ansible.com/projects/ansible/latest/reference_appendices/release_and_maintenance.html
  - https://www.redhat.com/en/technologies/management/ansible/upgrade
---

# Ansible upgrade playbook and pre-flight check reference

## Purpose

This reference documents a controlled upgrade path for an existing Ansible control node, including the pre-flight checks that must pass before the runtime or collections change. The goal is to make each failure mode visible in isolation rather than discovering it during a production rollout.

## When to use

Use this reference when a control node or automation image needs a newer ansible-core or Ansible package line, when collection metadata rejects the current runtime, or when a staged migration needs a repeatable verification sequence. It complements the migration guide by focusing on the playbook that performs the upgrade and the checks that gate it.

## Prerequisites

- A recorded inventory of control-node and target Python versions. The researched ansible-core 2.21 compatibility range lists control-node Python 3.12-3.14, target Python 3.9-3.14, and PowerShell 5.1-7.
- Access to the collections declared by the repository so incompatible `requires_ansible` metadata can be identified.
- A rollback copy of the current automation image or package environment.
- A known-good playbook run to use as the comparison point for idempotency and task results.

## Pre-flight checks

Run these checks before changing any package or collection:

1. Record current versions: `ansible --version` and `python --version` on the control node.
2. Confirm target Python versions fall within the researched ansible-core 2.21 compatibility range (control 3.12-3.14, target 3.9-3.14).
3. Validate collection metadata: `ansible-galaxy collection list` and review `requires_ansible` for each installed collection.
4. Run the existing playbook suite with deprecation warnings enabled and capture the baseline.
5. Confirm a rollback artifact (image or package environment) exists and is restorable.

## Upgrade playbook

```yaml
---
- name: Upgrade Ansible runtime and collections
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Record pre-upgrade versions
      ansible.builtin.command: ansible --version
      register: pre_version
      changed_when: false

    - name: Upgrade ansible-core
      ansible.builtin.pip:
        name: ansible-core
        state: latest
      become: true

    - name: Install pinned collections
      ansible.builtin.command: ansible-galaxy collection install -r collections/requirements.yml
      args:
        chdir: "{{ playbook_dir }}"
```

## Verify

- Re-run `ansible --version` and confirm the control node reports the intended ansible-core version.
- Re-run the full playbook suite against a test inventory and compare task counts and warnings to the baseline.
- Confirm collection metadata still resolves: `ansible-galaxy collection list`.

## Common errors

- `requires_ansible` mismatch after upgrade: a collection pins an older core. Pin the collection version in `collections/requirements.yml` or upgrade the collection.
- Python version out of range on control node: install a supported Python (3.12-3.14) before retrying.
- Connection plugin removal: replace `paramiko` with `ssh` and re-run.

## References

- https://docs.ansible.com/projects/ansible/latest/reference_appendices/release_and_maintenance.html
- https://www.redhat.com/en/technologies/management/ansible/upgrade

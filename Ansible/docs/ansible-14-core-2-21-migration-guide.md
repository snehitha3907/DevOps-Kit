---
last_verified: 2026-09-16
tool_version: Ansible 14.3.1 / ansible-core 2.21.3
sources:
  - https://docs.ansible.com/projects/ansible/latest/reference_appendices/release_and_maintenance.html
  - https://versionlog.com/ansible/14/
  - https://github.com/ansible/ansible/blob/v2.21.0/changelogs/CHANGELOG-v2.21.rst
  - https://docs.ansible.com/projects/ansible/latest/porting_guides/porting_guide_14.html
  - https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html
  - https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_templating.html
  - https://akshayghalme.com/blogs/ansible-playbook-patterns-production
---

# Ansible 14 and ansible-core 2.21 migration guide

## Purpose

This guide provides a controlled path from an earlier Ansible installation to Ansible 14.3.1 with ansible-core 2.21.3. Ansible 14 is based on ansible-core 2.21, whose release date is 2026-05-18. The target combination matters because collection compatibility, connection behavior, and failure reporting all sit at the boundary between the Ansible package and its core runtime.

The migration is split into compatibility checks, targeted playbook changes, and staged verification. The goal is to make the reasons for a failure visible before a broader rollout.

## When to use

Use this path when a control node or automation image needs the Ansible 14 package line, when collection metadata rejects the current core runtime, or when a Windows connection using the `psrp` plugin needs explicit service negotiation behavior. It also applies when a repository still uses the removed Paramiko connection plugin or legacy interpreter-discovery options.

This is a migration guide rather than a general Ansible tutorial. It assumes an existing inventory, playbook suite, and collection set that can be tested before changing the runtime used by automation.

## Prerequisites

- A recorded inventory of control-node and target Python versions. The researched ansible-core 2.21 compatibility range lists control-node Python 3.12–3.14, target Python 3.9–3.14, and PowerShell 5.1–7.
- A test environment that can run the current playbook suite with deprecation warnings enabled.
- Access to the collections declared by the repository so incompatible `requires_ansible` metadata can be identified.
- A rollback copy of the current automation image or package environment.
- A known-good playbook run to use as the comparison point for idempotency and task results.

## Steps

### 1. Establish the current baseline

Capture the current control-node and target runtime versions before changing packages. Run the existing suite and retain its task summary, warnings, and connection results. This baseline separates a migration regression from a pre-existing inventory or playbook problem.

Check collection declarations for `requires_ansible`. Ansible 14 changes collection installation behavior: `ansible-galaxy` refuses collections whose `requires_ansible` value is incompatible with the running ansible-core by default. Resolve the dependency or update the collection before treating the refusal as a transient installer error.

### 2. Move through a staged runtime change

Install the target Ansible and ansible-core versions in an isolated control-node environment or automation image. Verify that the installed pair is Ansible 14.3.1 with ansible-core 2.21.3, then run a small inventory check before invoking the full suite.

Run the playbook suite with deprecation warnings and retain the complete output. Review warnings for removed plugins, changed defaults, and deprecated result handling. Do not silence a warning until its owner and required change are known.

### 3. Update collection installation behavior

Review every collection installation step. The new default protects the runtime from incompatible collections, but an automation script that intentionally installs a mismatched collection must account for that behavior. Where the old behavior is deliberately required, the researched migration variable is `COLLECTIONS_ON_ANSIBLE_VERSION_MISMATCH=ignore`.

Prefer fixing the collection or runtime mismatch over making the compatibility guard permanent. Record any intentional exception with the collection name, reason, and owner.

### 4. Replace removed connection and interpreter options

Search playbooks, inventories, roles, and collection configuration for `ansible.builtin.paramiko`. The plugin was removed before Ansible 14, so replace it with a supported connection plugin and verify authentication, privilege escalation, and interpreter discovery on a representative target.

Search for `auto_legacy` and `auto_legacy_silent` under `interpreter_discovery`. Both options were dropped. Select the supported discovery behavior explicitly and test targets that previously relied on the legacy fallback.

For Windows hosts using `psrp`, review the connection default. The `negotiate_service` default changed from `WSMAN` to `host`. When the existing endpoint requires the previous behavior, set `ansible_psrp_negotiate_service=WSMAN` in host variables and verify the connection before expanding the host set.

### 5. Make failure reporting explicit

Review custom actions and modules that return a non-zero `rc` without an explicit `failed` value. Failure inference from that shape is deprecated in ansible-core 2.22. Make the failure state explicit now so the code does not depend on an inference that is being phased out.

Use `register` projections when one task needs to expose several result names, and review any reliance on implicit task-result access. These core changes make result handling clearer without changing the playbook's external workflow.

### 6. Rehearse the rollout

Run the suite with `--check --diff` where the modules support it, then run the normal test path. Use tags for surgical reruns and compare changed-task counts with the baseline. For a multi-host rollout, combine `serial` with `max_fail_percentage` so a bad connection or template does not spread across the entire inventory.

Keep dynamic `include_role` and static `import_role` behavior explicit. A role that must respond to runtime variables should use the dynamic form; a role whose task graph is intentionally fixed can remain static. The distinction affects when Ansible evaluates the role and should be visible in the repository.

## Verify

- Confirm the installed package pair is Ansible 14.3.1 with ansible-core 2.21.3.
- Confirm collection installation completes without an unexpected `requires_ansible` refusal.
- Run the full playbook suite and compare task results, warnings, and changed counts with the baseline.
- Exercise a Windows `psrp` host and verify that the intended negotiation service is used.
- Exercise a target that previously used legacy interpreter discovery and confirm the selected supported behavior.
- Re-run an idempotent playbook and confirm that expected tasks report no unnecessary changes.
- Exercise the staged rollout controls and verify that the configured failure threshold stops expansion as intended.

## Rollback

If the target environment fails compatibility checks or the playbook suite regresses, restore the recorded control-node image or package environment and rerun the baseline playbook path. Keep the pre-migration collection set and inventory unchanged during this recovery, then investigate the failing compatibility warning or connection behavior in the isolated environment before retrying the rollout.

## Common errors

- **Collection refusal after the runtime change.** The collection's `requires_ansible` value does not match ansible-core 2.21. Update the collection or runtime; use `COLLECTIONS_ON_ANSIBLE_VERSION_MISMATCH=ignore` only when the old installation behavior is intentionally required.
- **Windows connection failure after upgrade.** The `psrp` default now negotiates `host` instead of `WSMAN`. Set `ansible_psrp_negotiate_service=WSMAN` for an endpoint that requires the previous service.
- **Removed plugin or option remains in configuration.** Replace `ansible.builtin.paramiko` and remove `auto_legacy` or `auto_legacy_silent`; then test the affected target class rather than only parsing the file.
- **A custom action appears successful with a non-zero return code.** Add explicit failure communication instead of relying on `rc` inference.
- **A role behaves differently after conversion.** Check whether the change accidentally switched dynamic `include_role` behavior to static `import_role`, or vice versa.

## References

- Ansible release and maintenance information: https://docs.ansible.com/projects/ansible/latest/reference_appendices/release_and_maintenance.html
- Ansible 14 package history: https://versionlog.com/ansible/14/
- ansible-core 2.21 changelog: https://github.com/ansible/ansible/blob/v2.21.0/changelogs/CHANGELOG-v2.21.rst
- Ansible 14 porting guide: https://docs.ansible.com/projects/ansible/latest/porting_guides/porting_guide_14.html
- Role reuse guidance: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html
- Templating guidance: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_templating.html
- Playbook pattern reference: https://akshayghalme.com/blogs/ansible-playbook-patterns-production

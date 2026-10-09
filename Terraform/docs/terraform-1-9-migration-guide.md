---
last_verified: 2026-10-09
tool_version: n/a
---

# Terraform 1.9 migration guide: new features and breaking changes

## Purpose

This guide describes a repeatable process for moving an existing Terraform codebase onto the 1.9 release series: how to assess what the upgrade touches, how to roll it out one environment at a time, and how to back out if the plan output is not what was expected.

## When to use

Use this guide when the team's pinned Terraform version predates the 1.9 series and the codebase needs to move forward — for example, to stay on a supported release, to pick up language or workflow improvements, or to keep CI runners and local checkouts on the same binary. It also applies when a single stack lags behind the rest of the estate and needs to be brought into line.

## Prerequisites

- The current Terraform version each stack runs on, recorded per environment (root module, CI image, and any wrapper scripts).
- A readable copy of the upstream changelog for the release being moved to, so the feature and behaviour-change lists are evaluated against the actual codebase rather than from memory.
- Remote state with locking enabled, or a verified local-state backup procedure.
- Provider version constraints declared in every root module, so a CLI upgrade cannot silently pull new provider behaviour at the same time.

## Steps

### 1. Inventory what the upgrade can touch

List every root module, the Terraform version it runs today, and the provider constraints it declares. Check CI configuration and developer setup scripts for separate version pins — a root module upgraded locally but still planned with an older CI binary produces confusing diffs.

```hcl
terraform {
  required_version = ">= 1.5, < 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

Widen or move the `required_version` bound only after the migration is verified, not before. A narrow bound that rejects the new binary is preferable to a silent mixed-version estate during the rollout.

### 2. Back up state before touching anything

Pull a copy of every state file the migration will operate on and store it outside the backend. State moves forward with the binary that writes it; a backup taken beforehand is what makes a rollback credible.

```bash
terraform state pull > state-backup-before-1-9.json
terraform version
terraform init
```

Run `terraform init` with the new binary first so module and provider installation issues surface before any plan is evaluated.

### 3. Upgrade one environment and read the plan as the changelog

Start with the lowest-risk environment (typically development). Run a full plan with the new binary and compare it against a plan taken with the old binary on the same configuration. Any resource flagged for replacement or any output value change that has no corresponding configuration edit is a candidate breaking change — treat the plan diff, not release-note summaries, as the authoritative signal for this codebase.

```bash
terraform plan -out=tf19-migration.plan
terraform show -json tf19-migration.plan > tf19-migration.json
```

Pay particular attention to three recurring classes of breakage across Terraform minor releases: stricter validation of configuration that older versions accepted silently, provider behaviour changes that arrive bundled with a CLI upgrade when constraints are loose, and workflow changes in init, plan-file handling, or CLI output that break wrapper scripts and CI parsing.

### 4. Promote environment by environment

Apply in development, let it bake through at least one normal change cycle, then repeat the plan comparison in staging and finally in production. Keep the plan file produced in the previous step and apply exactly that file rather than re-planning at apply time, so the reviewed changes are the executed changes.

```bash
terraform apply tf19-migration.plan
```

Update the `required_version` bound and the CI/developer pins only after production has applied cleanly. Until then, the old pin is the guardrail that prevents an accidental partial upgrade.

### 5. Refresh locks and shared modules

After the CLI move, refresh the dependency lock file and confirm shared modules still validate under the new binary. Run the module's own validation and a plan in each caller before publishing a module version that claims support for the new series.

```bash
terraform init -upgrade
terraform validate
```

## Verify

- `terraform version` reports the intended 1.9 binary in every place plans are produced: local checkouts, CI runners, and wrapper images.
- A no-change plan (`terraform plan -detailed-exitcode` exits 0) on an untouched stack confirms the upgrade itself introduces no diff.
- Provider lock entries are unchanged unless a provider upgrade was deliberately included in the same change.
- At least one end-to-end apply per environment (development first, production last) completes with no replacements that lack a configuration cause.

## Rollback

- If the plan diff shows unexpected replacements, stop: keep the old binary pin, discard the plan file, and do not apply. The state backend is untouched until apply runs.
- If an apply has already written state with the new binary, restore from the backend's own version history or from the `state-backup-before-1-9.json` copy taken in Step 2, then re-pin the previous binary version and re-run `terraform init` plus a no-change plan to confirm the restore.
- Revert the `required_version` and CI pin changes in version control so the next run cannot pick up the new binary by accident.

## Common errors

**Mixed binaries across local and CI.** A developer plans with the new binary while CI still runs the old one (or the reverse), producing plan diffs that reproduce on neither side. The fix is a single version source — one pin file or image tag — read by both.

**Upgrading providers in the same change as the CLI.** A loose provider constraint lets `init -upgrade` pull new provider behaviour alongside the CLI move, and the resulting diff gets blamed on the wrong layer. Pin providers, migrate the CLI first, then upgrade providers as a separate change.

**Skipping the plan-file round trip.** Re-planning at apply time instead of applying the reviewed plan file lets intervening edits or refreshed data sources alter the change set. Always `plan -out` and `apply` the same file during a migration.

**No state backup before the first apply.** Without the pre-migration `state pull` copy, a bad apply leaves only the backend's built-in history as a recovery path. Take the explicit backup every time.

## References

- Upstream changelog for the 1.9 release series (read the behaviour-change list for the exact version being moved to before starting Step 1)
- Terraform `required_version` and provider constraint documentation
- Backend state history for the state backend in use

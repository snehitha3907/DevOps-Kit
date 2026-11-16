---
last_verified: 2026-11-16
tool_version: 1.17.2
sources:
  - https://github.com/hashicorp/terraform/releases/tag/v1.17.2
  - https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
  - https://github.com/aws-actions/configure-aws-credentials/releases
  - https://github.com/hashicorp/setup-terraform/releases/tag/v4.0.1
  - https://developer.hashicorp.com/terraform/cli/commands/plan
  - https://developer.hashicorp.com/terraform/cli/commands/apply
---

# Plan and apply Terraform from CI with OIDC

The previous lesson showed you how to call the same Terraform module from dev and prod, each with its own state. This lesson takes that configuration into CI: instead of storing long-lived AWS keys in GitHub, the pipeline authenticates with OIDC, plans every pull request, and applies only after the change is merged — so nobody runs `terraform apply` from their laptop, and no secret sits in a repository secret store.

## What you'll learn

- Authenticate CI to the cloud with OIDC instead of stored keys — an IAM OIDC provider, a role whose trust policy pins the GitHub token's `sub`, and a workflow that trades the token for temporary credentials with `aws-actions/configure-aws-credentials`.
- Post the plan on the PR and apply only after merge — `terraform plan ... -out=tfplan` runs on pull requests, the output is commented on the PR, the saved plan is uploaded, and a separate job gated on a push to `main` (optionally a GitHub Environment approval) runs `terraform apply tfplan`.

## Before you start

- [Reusable Terraform modules](./07-terraform-modules.md) — a module with `variables.tf`, `main.tf`, `outputs.tf`, called once per environment; this lesson runs `terraform init/plan/apply` against that same layout in CI.
- [Reuse pipeline steps across repositories](../05-ci-cd/05-gha-reusable-workflows.md) — reusable workflows with `on: workflow_call`, inputs, and secrets; the same idea of keeping pipeline logic in one place applies here.
- Terraform installed; confirm with `terraform --version` (this lesson targets Terraform 1.17.2).
- A GitHub repository and an AWS account where you can create an IAM OIDC provider and IAM role (one-time setup). The AWS CLI helps here; confirm with `aws --version`.

## Walkthrough

### 1. Set up OIDC between GitHub and AWS (one time)

Create the OIDC provider once per AWS account:

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com
```

Then create an IAM role (e.g. `terraform-github-actions`) whose trust policy lets GitHub Actions assume it. Pin `aud` to `sts.amazonaws.com` and scope `sub` to your repository so only this repo's workflows can assume the role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:OWNER/REPO:*"
        }
      }
    }
  ]
}
```

Give the role a permissions policy covering the resources your Terraform manages (for example S3, EC2, IAM) — least privilege, the same way you would scope a user's access keys. In the workflow, the job needs `permissions: id-token: write` to mint the OIDC token, then `aws-actions/configure-aws-credentials@v6` exchanges it for temporary credentials when you pass `role-to-assume` and no static keys.

A wildcard `sub` (`repo:OWNER/REPO:*`) lets any branch or PR in the repo assume the role. For production workloads, scope it precisely — `repo:OWNER/REPO:pull-request` for the plan job and `repo:OWNER/REPO:ref:refs/heads/main` for the apply job (two roles, same OIDC provider), or guard apply behind a GitHub Environment with required reviewers.

You should see: the provider exists in IAM > Identity providers, and the role's trust relationship references `token.actions.githubusercontent.com` with your repo in the `sub` condition.

### 2. Add the CI workflow

In your repo, create `.github/workflows/terraform-plan-apply.yml`. The `plan` job runs on every pull request, authenticates with OIDC, plans, and posts the result to the PR:

```yaml
name: Terraform plan and apply

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v4
        with:
          terraform_version: 1.17.2

      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: arn:aws:iam::ACCOUNT_ID:role/terraform-github-actions
          aws-region: us-east-1

      - name: Initialize Terraform
        run: terraform init

      - name: Plan and save the plan file
        run: |
          terraform plan -no-color -input=false -out=tfplan | tee plan.txt

      - name: Post the plan as a PR comment
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            const plan = require('fs').readFileSync('plan.txt', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '### Terraform plan for ${{ github.event.pull_request.head.sha }}\n\n```\n' + plan + '\n```'
            });

      - name: Upload the saved plan
        uses: actions/upload-artifact@v4
        with:
          name: tfplan
          path: tfplan
          retention-days: 1
```

`terraform plan -out=tfplan` writes a saved plan file; `tee plan.txt` duplicates the human-readable output so the comment step can read it. `pull-requests: write` is required in addition to `id-token: write` for the comment to post.

You should see: after you open a pull request, a new comment appears on it with the full `terraform plan` output, and a `tfplan` artifact is attached to the workflow run.

### 3. Apply only after merge

Add a second job that runs only on a push to `main`, downloads the saved plan, and applies it:

```yaml
  apply:
    needs: plan
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v4
        with:
          terraform_version: 1.17.2

      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: arn:aws:iam::ACCOUNT_ID:role/terraform-github-actions
          aws-region: us-east-1

      - name: Initialize Terraform
        run: terraform init

      - name: Download the saved plan
        uses: actions/download-artifact@v4
        with:
          name: tfplan

      - name: Apply the saved plan
        run: terraform apply -input=false -auto-approve tfplan
```

`terraform apply tfplan` applies exactly what was planned and refuses if state or remote objects drifted in the meantime. Pair it with `environment: production` (or a separate role scoped to `ref: refs/heads/main`) so a human approves production changes.

You should see: merging a PR to `main` starts the apply job; after the optional environment approval, Terraform applies the saved plan and the real infrastructure matches the PR's plan.

## Exercise

On your own, in a scratch repository:

1. Create the OIDC provider and IAM role in your AWS account, with the trust policy scoped to your repository.
2. Add a small Terraform configuration — for example, the local-file module pattern from the previous lesson — and commit it.
3. Add `.github/workflows/terraform-plan-apply.yml` with the plan and apply jobs above, substituting your role ARN and region.
4. Open a pull request and confirm a plan comment appears on it.
5. Merge the pull request to `main` and confirm the apply job runs `terraform apply tfplan`.

No solution is provided — do the setup yourself and verify with the check below.

## Check your work

From a pull request against `main`:

- The workflow run shows `Configure AWS credentials via OIDC` succeeded with no `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` secrets referenced.
- A comment with the `terraform plan` output appears on the pull request.
- A `tfplan` artifact is attached to the run.

From `main` after merge:

- `terraform apply -input=false -auto-approve tfplan` (replayed locally against the downloaded plan) applies without a state-drift rejection.
- The apply job only starts on a push to `main`, not on pull requests.

## Common mistakes

- Storing `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as GitHub secrets — OIDC exists so you do not have to; long-lived keys in secrets are exactly what this lesson replaces.
- Forgetting `permissions: id-token: write` — without it the job cannot mint an OIDC token and `configure-aws-credentials` fails with `sts:AssumeRoleWithWebIdentity` errors.
- A trust-policy `sub` that does not match the workflow (wrong repo or branch) — the role trust policy and the token's subject must line up exactly.
- Running `terraform apply` without `-auto-approve` in CI — it hangs waiting for interactive input and never completes.
- Applying a stale plan — if someone merged ahead of you, re-plan first; `terraform apply tfplan` rejects a plan that no longer matches current state.

## Next

[Ansible — quick primer](../../Ansible/notes/0000-primer-ansible.md)

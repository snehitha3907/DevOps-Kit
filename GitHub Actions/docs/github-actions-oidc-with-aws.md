---
last_verified: 2026-10-04
tool_version: n/a
sources:
  - https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html
---

# GitHub Actions OIDC with AWS: a complete guide

> Replace long-lived AWS access-key secrets in CI with a short-lived, workload-identity credential that AWS only issues to a specific repository, ref, and environment.

## Purpose

A CI pipeline that deploys to AWS usually starts by storing `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as repository secrets. Those keys do not expire, they cannot be scoped to a single branch or a single GitHub Environment, and they have to be rotated on a schedule that someone has to remember. OpenID Connect (OIDC) removes the secret entirely: the workflow asks GitHub for a signed identity token for itself, AWS verifies that token against a trust policy, and STS hands back session credentials with a bounded lifetime.

This guide covers the whole path — the IAM trust policy, the token claims that constrain it, the workflow permissions that mint the token, the exchange itself, provisioning the role from Terraform, and folding the pattern into the multi-environment deploy template already in this folder.

## When to use

Use OIDC when a workflow in GitHub needs AWS credentials and the credential can be bound to the workflow's identity rather than to a stored value:

- A deploy job that needs to push an image, update an ECS service, or apply infrastructure.
- A reusable deploy workflow shared across an organization, where giving every repository its own copy of a static key is worse than a shared role plus a scoped trust policy.
- Anywhere the current workaround is a recurring access-key-rotation ticket rather than a design.

Stay with static secrets when the credential is consumed outside GitHub Actions (a laptop, a bastion host, another CI system that cannot mint an OIDC token), or when the AWS account is shared with systems that cannot be constrained by a trust policy condition. The migration is incremental: the two mechanisms coexist, and the static secret can stay in place until the OIDC path has proven itself.

## Prerequisites

- An AWS account and a role that the pipeline is allowed to assume. If the role does not exist yet, create it as part of this guide.
- Permission to register an OIDC provider in IAM. This is a one-time, account-level change.
- The `org/repo` slug of the workflow repository, and the branch or Environment name the trust policy should be limited to.
- A workflow file you control: `.github/workflows/<file>.yml` in that repository.

## How the exchange works

Five moving parts, each described in its own step below:

1. IAM holds an **OIDC provider** whose URL is the Actions issuer, plus a **role** whose trust policy names that provider.
2. GitHub mints a **JWT** for the job and exposes it to the job as a request endpoint plus a bearer token.
3. The job **presents** that JWT to STS, asking to assume the role.
4. STS **verifies** the JWT signature, then checks the trust policy conditions against the token's claims.
5. STS returns **temporary credentials** — an access key, a secret key, and a session token — that expire on their own.

The trust policy is the security boundary. If its conditions are too loose, any repository can mint a token your account will accept.

## Steps

### 1. Register the OIDC provider and create the role

Register the provider once per AWS account. The URL must match the Actions issuer **exactly**, with no trailing slash — a trailing slash is the single most common reason a correctly-scoped trust policy still fails to verify tokens.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity"
    }
  ]
}
```

Then create the role and attach that trust policy. Note the role ARN — the workflow needs it. Keep the role's permissions scoped to the operations the deploy actually performs; see `../../AWS/docs/iam-policy-least-privilege-walkthrough.md` for the process of narrowing an action list to what each component really calls.

### 2. Scope the trust policy to one repository and one ref

An unscoped trust policy above trusts **every** repository on GitHub. Add conditions on the token claims before the role is usable. The `sub` claim is the identity of the job; the `aud` claim is the service the token was requested for.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:my-org/my-app:ref:refs/heads/main"
        }
      }
    }
  ]
}
```

The `sub` value is not free text — its shape is fixed by what the job is, so a table is easier than a paragraph:

| Job declares | `sub` claim |
|---|---|
| nothing, running on a branch | `repo:my-org/my-app:ref:refs/heads/main` |
| nothing, running on a tag | `repo:my-org/my-app:ref:refs/tags/v1` |
| `environment: staging` | `repo:my-org/my-app:environment:staging` |
| triggered by `pull_request` | `repo:my-org/my-app:pull_request` |

Two scoping mistakes to avoid here. Trusting `repo:my-org/*:ref:refs/heads/main` hands the role to every repository in the org that happens to have a `main` branch. Trusting the `repository_owner` claim alone is broader still — it authorizes the whole org, not one repo. Exact repository plus exact ref, or exact repository plus exact Environment, is the right unit.

### 3. Ask the workflow for a token

The token is opt-in. A job can only request it if its `permissions` block includes `id-token: write`:

```yaml
permissions:
  contents: read
  id-token: write
```

Setting `permissions` explicitly is what makes the block above necessary: once any scope is declared, every scope you did not declare is set to `none`. A workflow that adds `id-token: write` while dropping `contents: read` trades an AWS failure for a checkout failure.

`permissions` can also be set per job. On a repository with many workflows, declaring it at job level rather than workflow level keeps `id-token: write` off jobs that never talk to AWS.

### 4. Exchange the token for credentials

**Option A — the AWS credential-configuration action.** This is the usual path; it exports credentials as environment variables for the rest of the job.

```yaml
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@<commit-sha>
        with:
          role-to-assume: arn:aws:iam::123456789012:role/gha-deploy-my-app
          aws-region: eu-west-1
```

Pin third-party actions to a **full commit SHA**, not a mutable tag. A tag is a moving target: whoever controls the repository can repoint it, and your pipeline picks up the change without a commit on your side. The Terraform registry guidance makes the same point about module sources — a full commit SHA is used there specifically to avoid supply-chain drift from a mutable tag.

The credentials the step exports are scoped to the job. A later job in the same workflow starts with no credentials, which is usually what you want.

**Option B — call STS directly.** When the action is not wanted, the token is still reachable from the environment and STS exposes the exchange as a plain API call. One step can do the whole thing, writing the result to `$GITHUB_ENV` so later steps in the job pick the credentials up:

```yaml
      - name: Assume the deploy role
        env:
          ROLE_ARN: arn:aws:iam::123456789012:role/gha-deploy-my-app
          AWS_REGION: eu-west-1
        run: |
          curl -sS -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" \
            "$ACTIONS_ID_TOKEN_REQUEST_URL&audience=sts.amazonaws.com" \
            | jq -r .value > oidc-token.txt
          aws sts assume-role-with-web-identity \
            --role-arn "$ROLE_ARN" \
            --role-session-name "gha-${{ github.run_id }}-${{ github.run_attempt }}" \
            --web-identity-token file://oidc-token.txt \
            --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
            --output text \
            | { read -r key secret token; \
                 { echo "AWS_ACCESS_KEY_ID=$key"; \
                   echo "AWS_SECRET_ACCESS_KEY=$secret"; \
                   echo "AWS_SESSION_TOKEN=$token"; \
                   echo "AWS_REGION=$AWS_REGION"; } >> "$GITHUB_ENV"; }
          rm -f oidc-token.txt
```

Two details are load-bearing. The request URL already carries a query string, so the audience is appended with `&` rather than `?`. And `role-session-name` is required by the API — `${{ github.run_id }}-${{ github.run_attempt }}` makes it unique per attempt, which is what shows up in CloudTrail when auditing who assumed the role.

The two `ACTIONS_ID_TOKEN_REQUEST_*` env vars exist only in a job that has `id-token: write`. Without it they are empty and the request comes back unauthorized — which is the failure mode most often mistaken for a trust-policy problem.

### 5. Provision the same role from Terraform

The provider and role are ordinary infrastructure, so they belong in the Terraform module that owns the AWS account rather than in a console click. The resource names below are the standard AWS provider names:

```hcl
resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["<current thumbprint>"]
}

resource "aws_iam_role" "gha_deploy" {
  name = "gha-deploy-my-app"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github_actions.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:my-org/my-app:ref:refs/heads/main"
        }
      }
    }]
  })
}
```

The thumbprint is the one value here that must be checked against the account rather than copied: GitHub rotates its signing certificate, and a stale thumbprint list shows up as a token that verifies nowhere. Read the current value from the IAM console before applying, and keep the trust policy in version control so a plan diff shows when the `sub` scope changes.

Three layout rules apply if this role lives in a shared module: the `providers` block is declared only in the root module, environment-specific values belong under `envs/`, and a reusable nested module carries a `README.md` — without one it reads as internal-only. Setting `aws_default_tags` in the root module means the role and its policy inherit the account's tags without repeating them.

### 6. Wire it into the multi-environment deploy template

`../templates/multi-env-deploy/reusable-deploy.yml` already runs one deploy job per environment, and the job declares `environment: ${{ inputs.environment }}`. That declaration is what makes the Environment-scoped `sub` usable: with `environment:` set, the token's `sub` is `repo:my-org/my-app:environment:<name>`, so one trust policy per environment covers all three.

Two changes are needed in that template:

- Add a role ARN per environment as a `workflow_call` input, so the reusable workflow selects the role rather than hard-coding one.
- Grant `id-token: write` in the **calling** workflow as well as the reusable one. A called workflow cannot raise the token permissions its caller granted; if `deploy-caller.yml` declares only `contents: read` at workflow level, `id-token: write` in the reusable workflow is silently capped and the token request fails.

With the role ARN as an input and a matching trust policy condition per environment, the deploy job gains three lines and loses its secret:

```yaml
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@<commit-sha>
        with:
          role-to-assume: ${{ inputs.role_arn }}
          aws-region: ${{ inputs.aws_region }}
```

### 7. Delete the long-lived access-key secrets

Only after the OIDC path has run green on every branch that deploys. Removing the secrets earlier leaves the pipeline broken with no fallback, and the rollback below depends on them still existing.

## Verify

Verification has two halves, and the second half is the one people skip.

**Confirm the identity you got.** Add a temporary step after the credential step:

```yaml
      - name: Confirm identity
        run: aws sts get-caller-identity
```

The printed account ID and role ARN must match the role the trust policy names. If the role ARN that comes back is not the one the workflow asked for, the trust policy is matching a broader condition than intended — go back to Step 2 and narrow the `sub`.

**Confirm the policy actually constrains.** A trust policy that accepts everything also lets a legitimate deploy succeed, so a green deploy proves nothing about scoping. Push a throwaway branch, or edit the `sub` condition to a ref that does not exist, and confirm the assumption is **denied**. A policy that cannot be made to fail has not been tested.

Then confirm the boundary holds in the other direction: remove `id-token: write` from the workflow and confirm the token request fails, which proves the grant is what was authorising the exchange rather than something ambient.

## Rollback

The role is additive — nothing breaks while it sits unused. Rolling back means reverting in this order:

1. Re-create the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` repository secrets with a key from an IAM user whose policy matches the role's.
2. Remove the credential step and restore the secret-consuming steps in the workflow.
3. Leave the OIDC provider and role in place. They cost nothing while unused, and keeping them means the migration does not have to be rebuilt. Delete the trust policy only once the static credentials are confirmed working, so there is never a window where neither path is live.

If the rollback is because of a suspected credential leak, skip to step 1 and delete the leaked key immediately rather than restoring around it.

## Common errors

- **`Could not load credentials` / token request unauthorized.** `id-token: write` is missing from the job. Declaring a `permissions` block without it also drops `contents: read`, which then breaks `actions/checkout` — the two failures appear in sequence and look unrelated.
- **`id-token: write` present in the reusable workflow but the caller never grants it.** A called workflow can only narrow the permissions its caller granted. Grant it in the caller.
- **Token verifies but the assumption is denied.** The `sub` condition does not match the job. A job on a branch and a job that declares `environment:` produce different `sub` values, and a `pull_request` run produces another.
- **`Invalid identity token` or signature mismatch on every call.** The OIDC provider URL in IAM has a trailing slash or an `https://` mismatch with the Actions issuer.
- **Trust policy too broad and nothing fails.** `repo:my-org/*` or a `repository_owner`-only condition accepts every repo in the org. Narrow to one repo plus one ref or Environment and re-run the denial test.
- **Deploy works locally, fails in CI.** The role ARN is account-specific and the account IDs are easy to transpose between the Terraform output, the trust policy, and the workflow input.
- **Credentials missing in a later job.** The credential step exports into the job that ran it, not the workflow. Repeat the step in each job that calls AWS, or move the AWS work into one job.
- **Session expires mid-deploy.** The role's configured maximum session duration is the ceiling on the credential. Raise it on the role, or split the work — the token itself is re-minted per job, so a fresh job gets a fresh session.
- **Everything worked, then broke after a fork PR.** Fork pull requests run with a restricted token and a different identity. Do not widen the trust policy to accommodate them; keep fork builds off the AWS-touching path.

## References

- `../templates/multi-env-deploy/README.md` — the caller/reusable-workflow pair this pattern plugs into.
- `../../AWS/docs/iam-policy-least-privilege-walkthrough.md` — narrowing the role's action list to what the deploy really calls.
- `composite-actions-vs-reusable-workflows.md` — when the shared deploy logic should be a reusable workflow rather than a composite action.
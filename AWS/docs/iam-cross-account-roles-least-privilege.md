---
last_verified: 2026-10-07
tool_version: n/a
---

# IAM cross-account roles with least privilege

## Purpose

When two AWS accounts need to work together — a workload account holding the data and a tools account running the automation, or your account and a partner's — the pattern that holds up is a role in the target account that a principal from the other account is allowed to assume, with both sides of the role scoped down. The trust policy decides *who* may assume the role, and the permissions policy decides *what* the assumed session may touch. This is one workable arrangement; the console walkthroughs describe variations (identity-center assignment, federation through an external provider), and either gets you to the same place. What follows is the role-based version because it maps most directly onto least privilege: each cross-account need gets its own narrowly-scoped role.

The single-account scoping companion to this doc is `iam-policy-least-privilege-walkthrough.md` in this folder — read that first if per-resource action scoping is new, since every pattern below assumes policies are already scoped to specific actions and ARNs.

## When to use

Reach for a cross-account role when the caller and the resource live in different accounts and you want no long-lived credentials crossing the boundary. Typical cases: a deployment pipeline in a tooling account that writes to buckets in a workload account, a read-only audit role a security account assumes into every member account, or a partner that needs temporary access to one shared dataset. If caller and resource share an account, an ordinary role or group with a scoped policy is simpler — cross-account machinery buys nothing there. And if one role starts collecting permissions for three unrelated consumers, that is the sign to split it: one role per consumer and purpose keeps each policy reviewable.

## Prerequisites

You need administrator (or IAM-management) access in both accounts for setup, the twelve-digit ID of the trusting and trusted accounts, and a clear list of the actions the consumer actually calls — the same "list real needs first" exercise from the companion walkthrough. No tooling beyond the console or any IAM client is required; everything below is policy text plus the assume-role exchange.

## Steps

### 1. Name one role per consumer and purpose

Create the role in the account that owns the resources (the trusting account), with a name that records both ends, e.g. `tooling-deploy-to-workload-readwrite` or `security-audit-readonly`. The mix-up I kept making early on was one shared `cross-account-access` role that every consumer assumed — convenient for a week, then every policy change needed sign-off from all consumers at once. Splitting by consumer keeps the blast radius of each change obvious. A read-only consumer and a read-write consumer get two roles even when they touch the same bucket; the read-only policy stays short and nobody has to reason about which statements apply to whom.

### 2. Scope the trust policy to the exact caller

The trust policy is where cross-account access is granted or withheld, so it should name the precise principal, not the whole account. For a pipeline role assumed by one execution role in the tooling account:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111122223333:role/tooling-pipeline-execution"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```

Two details carry most of the weight here. First, the principal names one role, not the account root: trusting `arn:aws:iam::111122223333:root` would hand the decision of who may assume to the other account's administrators, which is sometimes intended (whole-team access) but should be a deliberate choice, not the default. Second, the condition narrows the exchange further — multi-factor presence for human-assumed roles is the common one. When the consumer is an outside party rather than your own second account, add a unique external ID string to the condition and share it out of band; that way a confused-deputy mix-up (the third party being tricked into assuming your role on someone else's behalf) fails closed unless the caller presents the secret ID. The docs also describe session tagging and source-identity conditions as alternatives for tracing who did what — worth knowing about, though principal-plus-condition covers most setups.

### 3. Attach a least-privilege permissions policy

The permissions policy on the role follows the same scoping discipline as any same-account policy: only the actions the consumer calls, only on the resources it touches. For the read-only audit role, that might be a short list of describe and list actions across specific resource ARNs; for the deploy role, write actions on exactly the deployment bucket and the log group it writes to. Nothing in this step is cross-account-specific, which is the point — once the trust policy has admitted the right caller, authorization works like any other role. If the consumer's needs grow, extend this policy rather than widening the trust policy; who may enter and what they may do stay independent decisions.

### 4. Assume the role from the trusted account and use the session

From the trusted side, the caller exchanges its own credentials for temporary session credentials for the role, then uses those for the target-account calls. Sessions should request the shortest duration the workflow tolerates and the narrowest session scope the task allows — a deploy job that only writes to one prefix can further scope itself down at assume time rather than relying solely on the role's policy. When the session ends, the credentials simply expire; there is nothing to rotate and nothing stored, which is the whole advantage over sharing static keys across the boundary.

## Verify

Confirm the arrangement by checking three things. First, the trust policy names the exact caller principal and carries the intended condition — if the principal is an account root, confirm that breadth was deliberate and not a placeholder that stuck. Second, every action in the permissions policy maps to a real need from the prerequisites list, and the role's session can perform each of them against the real resources. Third, run the negative checks through the IAM policy simulator the way the companion walkthrough does: simulate an action the consumer should not have (deleting the bucket, touching an unrelated table) and confirm it reports denied, and simulate an assume-role call from a principal that is not in the trust policy and confirm the exchange is refused. If a legitimate call fails at runtime while the simulator allows it, the mismatch is usually in the trust-policy condition (a missing MFA flag or wrong external ID) rather than the permissions policy — re-read the condition block before widening anything.

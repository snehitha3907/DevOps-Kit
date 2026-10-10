---
last_verified: 2026-10-10
tool_version: n/a
---

# GitHub Apps vs OAuth Apps: choosing the right integration

## Purpose

Decide whether a GitHub App or an OAuth App is the right registration type for a workload that talks to GitHub programmatically. The two models look similar from the outside — both are registered in developer settings, both receive credentials, both authenticate API calls — but they answer a different question: *who is the actor?*

A GitHub App is an actor in its own right. It is registered once, installed on the repositories or organizations it should work with, and acts under its own identity with permissions declared per category. It can run without any user present and can subscribe to webhook events.

An OAuth App is a proxy for a user. It asks a user to authorize it, receives a token that represents that user, and can do what the user can do — no more. It fits user-facing tooling where the work should happen under the user's identity and permissions.

## When to use

| Requirement | GitHub App | OAuth App |
|---|---|---|
| Unattended automation (CI jobs, bots, scheduled work) | Good fit — acts on its own behalf, no user session needed | Poor fit — the authorization belongs to a user and ends with that user's session |
| Granular, repository-scoped permissions | Yes — permissions are declared per category and can be read-only or read-write, narrowed to the installed repositories | Indirect — the token reflects what the authorizing user granted, not a per-category declaration |
| React to repository events (pushes, pull requests, issues) | Yes — webhook subscriptions push events to the app | No — no event channel; the app must poll or wait for the user |
| Shared across many repositories or organizations | Yes — installed wherever needed, one identity everywhere | Only where each user can authorize it |
| User-facing tool that needs the user's own access | Possible but indirect — the app can act on a user's behalf through its own flow | Good fit — the token represents the user directly |

When the answers split across rows, the actor question from the Purpose section usually breaks the tie: automation that nobody is watching wants a GitHub App; a tool a person drives interactively wants an OAuth App.

## Prerequisites

- A GitHub account with access to the developer settings area where integrations are registered.
- For organization-wide installs, organization owner or admin rights.
- A written list of the actions the integration needs: which repository surfaces (contents, pull requests, issues, workflows) and whether each is read or write.
- A decision, recorded before registration, on whether a user must be present for the integration to work.

## Steps

1. **Name the actor.** Write down whether the integration behaves as its own actor or as a stand-in for a user. This single answer eliminates one model in most cases.
2. **List the permissions.** For a GitHub App, map every required action to the narrowest permission category and prefer read-only where the workload only reads. For an OAuth App, list what the authorizing user must be able to do.
3. **Consider presence and lifetime.** Unattended, long-running workloads favor a GitHub App, whose credentials are issued for the integration. User-driven sessions favor an OAuth App, whose authorization begins when the user consents.
4. **Consider events.** If the workload must react to activity, choose a GitHub App and subscribe to the events it needs; the platform pushes matching activity to the app's endpoint. An OAuth App has no event channel and must poll for changes.
5. **Consider distribution.** GitHub Apps are installed per repository or organization and keep one identity across installs. OAuth Apps are authorized per user and travel with each user's grant.
6. **Register the integration.** In developer settings, create the registration using the type chosen in step 1, set the permissions and events from steps 2 and 4, and store the issued credentials (client identifier and secret; the private key for a GitHub App) outside the repository — in the secret store of the platform running the workload, never in committed files.
7. **Issue the first token** through the model's flow and scope the first test to a single repository before widening the install.

## Verify

- In developer settings, confirm the registration shows the type chosen in step 1 and that permissions and events match steps 2 and 4.
- Make a minimal read call with the issued token and confirm it succeeds inside the granted scope and fails outside it.
- For a GitHub App, confirm the repository or organization audit trail shows the app's own identity, not a user's.
- For an OAuth App, confirm the authorization prompt requests only what the integration actually needs.
- Compare the result against the decision table in When to use; if the integration no longer matches its row, revisit step 1 rather than widening permissions.

## Common errors

- **Using an OAuth App for unattended automation.** The authorization belongs to a user, so the workflow breaks when the user leaves, revokes access, or the session ends. Register a GitHub App instead.
- **Requesting broad access up front.** Grant the narrowest scope that works; widen deliberately when a specific need appears.
- **Treating issued tokens as long-lived.** Tokens are credentials — rotate them, re-issue them on a schedule, and never embed one in a committed file or image.
- **Skipping the actor decision.** Registering the wrong type means rebuilding authentication later; write the actor down before touching developer settings.
- **Describing the two models interchangeably in runbooks.** Readers then authorize the wrong flow; name the model explicitly wherever the integration is documented.

## References

- GitHub's developer documentation for GitHub Apps: registration, permissions, installations, and webhooks.
- GitHub's developer documentation for OAuth Apps: authorization and token flows.
- This kit's related note: [Deploy keys vs fine-grained PATs for CI/CD](./how-i-wired-deploy-keys-vs-fine-grained-pats-for-cicd.md) — the other common way to authenticate CI against GitHub, and when it beats both models above.

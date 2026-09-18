---
last_verified: 2026-09-18
tool_version: n/a
sources: []
---

# First Azure CLI login + resource list

> Scratch notes from installing the Azure CLI and poking at my subscription for the first time.

## What I tried

I installed the Azure CLI on my laptop and ran `az login`. A browser window popped up asking me to pick my account, then the terminal dumped a big JSON blob of subscriptions. I then ran `az account list --output table` to see it in a friendlier shape, and `az resource list --output table` to see what already lives in my subscription.

## What worked

`az login` worked on the second try (first time I closed the browser tab too early). `az account show` confirmed I was on the right subscription. `az resource list` came back empty for me, which makes sense — I haven't created anything yet.

## Got stuck on

**The login JSON scared me.** After `az login` the CLI prints every subscription and tenant as raw JSON. I thought something had errored. It hadn't — that's just the default output. `--output table` is much calmer.

**Which subscription am I on?** I have access to two subscriptions and the commands silently used the first one. I ran `az account set --subscription "<name>"` to pin the one I want before I create anything.

## What I'd try next

I want to create a resource group and list it to prove the loop works end to end. Also curious what `az configure --list-defaults` does — setting a default location once sounds nicer than typing it every time.

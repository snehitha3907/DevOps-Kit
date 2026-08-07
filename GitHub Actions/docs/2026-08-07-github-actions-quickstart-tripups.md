---
last_verified: 2026-08-07
tool_version: n/a
sources: []
---

# GitHub Actions quickstart — what tripped me up

I followed the official GitHub Actions quickstart to get my first workflow running. Here is what actually happened versus what I expected, and the parts that slowed me down.

## Step 1: Creating the workflow file

The guide says to add `.github/workflows/ci.yml` to the repo. I created the `.github/workflows/` directory locally and pushed the file. The sample workflow they show runs `echo "Hello from Actions"` on `ubuntu-latest`. I copied that and added a second step that prints the runner's default Python version.

```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run a one-line script
        run: echo "Hello from Actions"
      - name: Check Python version
        run: python --version
```

## Step 2: Watching it run

After pushing, I clicked the Actions tab. A new run had already started — triggered by the push that added the workflow file itself. That part was smoother than expected. The run took about 30 seconds total: a few seconds queuing, ~20 seconds to provision the runner, then ~5 seconds for the two steps. Each step's output is expandable and streams in real time.

## Got stuck on

**1. The workflow file name matters for the UI tab.** I named my file `ci.yml` and the Actions tab showed "CI" as the workflow name. Later I tried `test.yml` and the tab showed both workflows grouped by the `name:` field. If you reuse the same name, they merge under one tab entry. That confused me at first — I thought the second file overwrote the first.

**2. `on: [push]` triggers on every branch push.** I assumed it only ran on the default branch. Nope. Every push to any branch triggers a run. I had a dozen runs from my experiment branches before I noticed. For a real project I would scope it with `on: push: branches: [main]`.

**3. Logs show timestamps in relative time by default.** Click the gear icon in the top-right of the logs panel to switch to absolute UTC timestamps. That would have saved me a minute of head-scratching during a `--debug` run.

**4. The `ubuntu-latest` runner already has a ton of stuff pre-installed.** Python 3, Node.js, Docker CLI, curl, git — it is all there. I ran `python --version` and got 3.12 without any setup step. I was going to add a Python setup action, but for simple scripts it is unnecessary.

## What I'd try next

I want to set up a workflow that actually runs my Python tests and caches pip dependencies. The quickstart only covers the basics — I need to look at `actions/setup-python`, caching with `actions/cache`, and maybe matrix builds. The fact that the runner comes with so much pre-installed means I can start simple and add complexity as I go.

# GitHub Actions quickstart — what tripped me up

I followed the official GitHub Actions quickstart guide to set up my first workflow. Here's what actually happened vs what I expected.

## Step 1: Creating the workflow file

The guide says to create `.github/workflows/ci.yml` in my repo. I already had a repo with some Python files from earlier experiments. I just created the directory structure and added the YAML file manually through the GitHub web UI — creating the `.github/workflows/` folder from the file creation dialog.

The sample workflow they show:

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
```

I copied that almost verbatim. The only change I made was adding a second step that ran `python --version` just to see the runner's default environment.

## Step 2: Watching it run

After pushing the workflow file, I clicked the "Actions" tab in the repo. Sure enough, a new run had already started — triggered by the push that added the workflow file itself. That part was smoother than expected.

The run took about 30 seconds (a few seconds queuing, 20-ish seconds to provision the runner, then maybe 5 seconds actually running the two steps). I clicked into the run to see the logs. Each step's output is expandable and you can see real-time streaming.

## What tripped me up

**1. The workflow file name matters for the UI tab.** I named my file `ci.yml` and the Actions tab showed "CI" as the workflow name — which is correct. But I tried a second file called `test.yml` later and the tab showed both workflows grouped by the `name:` field. If you reuse the same name, they merge under one tab entry. That confused me at first — I thought the second file overwrote the first.

**2. `on: [push]` triggers on every branch push.** I assumed it only ran on default branch. Nope. Every push to any branch triggers a run. I had a dozen runs from my experiment branches before I noticed. For a real project I'd scope it with `on: push: branches: [main]`.

**3. Logs show timestamps in relative time by default.** Click the gear icon in the top-right of the logs panel to switch to absolute UTC timestamps. That would've saved me a minute of head-scratching during a `--debug` run.

**4. The ubuntu-latest runner already has a ton of stuff pre-installed.** Python 3, Node.js, Docker CLI, curl, git — it's all there. I ran `python --version` and got 3.12 without any setup step. I was going to add a Python setup action, but for simple scripts it's unnecessary.

## What I'd try next

I want to set up a workflow that actually runs my Python tests and caches pip dependencies. The quickstart only covers the basics — I need to look at `actions/setup-python`, caching with `actions/cache`, and maybe matrix builds. The fact that the runner comes with so much pre-installed means I can start simple and add complexity as I go.

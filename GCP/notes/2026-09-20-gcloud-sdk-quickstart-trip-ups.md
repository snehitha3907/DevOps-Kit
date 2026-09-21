---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# Following the gcloud quickstart — what tripped me up

I wanted a working `gcloud` setup so I could list projects and poke at Compute Engine from the terminal. I followed the quickstart path: install the SDK, run the init flow, then try a few read-only commands.

## What I was trying to do

Get `gcloud` installed, sign in, pick a project, and run something harmless like listing VMs. I also wanted to understand how configs and auth work before I touch anything that costs money.

## Steps I took

1. I installed the SDK and ran `gcloud init`. It asked me to sign in through the browser and then pick a project and a default region.
2. I ran `gcloud projects list` to confirm auth worked. That part went fine once the browser flow finished.
3. I tried `gcloud compute instances list`. It failed at first because I had no default project set in the active config.
4. I ran `gcloud config set project my-project` and then the list command worked.
5. I explored `gcloud config list` and `gcloud auth list` to see which account and project were active.

## Got stuck on

The project versus config split confused me. I assumed signing in picked a project for me, but `gcloud` kept asking for `--project`. Turns out the init flow sets one config, and I can have several named configs with `gcloud config configurations list`. I was editing the wrong one for a while.

Auth also surprised me. There is my user login from `gcloud init`, and then there is application auth used by local client libraries. I ran a small Python client and it complained about missing credentials until I learned those are two separate logins. For now I am sticking to the CLI login and leaving app auth alone.

The third trip-up was output flags. I kept adding `--format json` in the wrong position and getting usage errors. Putting global flags after the resource action worked, for example `gcloud compute instances list --format json`. Tab completion helped once I slowed down and read the usage line.

## What worked

Named configs clicked once I listed them. I made one config for learning and left the default alone, so I can switch back with `gcloud config configurations activate <name>`. Read-only commands like `projects list` and `compute instances list` are good smoke tests after any auth change.

## What I'd try next

I want to spin up a throwaway VM with a firewall rule and SSH in via `gcloud compute ssh`, then tear it all down the same day. I also want to practice `--filter` and `--format` so I can script small inventory checks without parsing full JSON by hand.

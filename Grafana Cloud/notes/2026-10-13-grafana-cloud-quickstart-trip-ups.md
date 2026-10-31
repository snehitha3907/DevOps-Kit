---
last_verified: 2026-10-13
tool_version: n/a
---

# Grafana Cloud quickstart — what tripped me up

I followed the official Grafana Cloud quickstart this session: signed up for a free stack, wired the Grafana Agent, and pushed my first metric sample into the hosted instance. The hosted side is the same Grafana I ran in Docker earlier, just with a signup and a URL attached — the panels, the time picker, Explore, and the dashboard JSON editor are all familiar.

## What I did

Signed up and landed in a stack with one pre-created Prometheus datasource already wired. I did not have to add a data source by hand, which was the thing I expected to be fiddly. I opened Explore, ran an instant query, got series back. Then I built a stat panel, saved it as a dashboard, and copied the JSON model out of the dashboard menu — that's going to be how I build the next ones.

The Grafana Agent piece was the part the quickstart spends the most time on. I downloaded the binary, wrote a minimal config with a single prometheus.scrape job, and ran it. Samples started showing up in Explore within a minute or two.

## Got stuck on

**The agent config and the stack endpoint live in two different places.**
The quickstart hands you an `--server` URL and an `--token` for the agent, but finding where to copy them from took a couple of clicks. The URL is at the top of the stack's "Details" page and the token is under "Agent configuration" — they're not on the same screen, and the quickstart doesn't spell out exactly where each one comes from. I pasted the wrong thing into the config file twice before I noticed the token field is base64-encoded in the example and needs decoding.

**The free stack's remote-write path is not the same as a self-hosted Prometheus remote_write.**
I assumed I could point an existing Prometheus at the Grafana Cloud remote-write endpoint and have it work like any other remote-write receiver. It can, but the endpoint URL and the org/instance identifiers are specific to the stack, and the username is the `mimir` user id, not "grafana". The quickstart covers the agent path, not the remote-write path, so I had to dig into the docs to find the right credentials.

**Scrape interval is set on the job, not on the panel or the datasource.**
I spent a while looking for where to set the scrape interval in the UI before remembering the agent config owns that, not the panel. The datasource in the hosted stack is just a query front-end — it doesn't control how often anything is scraped.

**The first panel said "No data" until I saved and re-opened the dashboard.**
I built a panel, saw data in the preview, saved the dashboard, and the saved panel showed "No data" until I closed it and reopened. Saving triggers a re-query against the persisted panel definition; the preview uses the live query. Not a bug, but it looks like one.

## What I'd try next

- Figure out how the agent is supposed to push into this stack and where the endpoint and token live, so I don't have to guess at it next time.
- Set up a second scrape job for node metrics via the unix exporter and compare the two job blocks to see what changes between them.
- Try the remote-write path with my own Prometheus so I understand the difference from the agent path the quickstart covers.
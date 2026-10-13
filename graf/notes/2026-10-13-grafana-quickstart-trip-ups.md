---
last_verified: 2026-10-13
tool_version: n/a
---

# Grafana quickstart — what tripped me up

I followed the official Grafana quickstart end to end this session: install, add a data source, build a dashboard, set up alerting. I ran it against a local Docker container, since that's the path the quickstart recommends for a first try.

## What I did

Installed Grafana with the recommended Docker command and logged in at `localhost:3000` with the default `admin`/`admin` credentials. The quickstart asks you to change the password on first login, which I did.

Then I added Prometheus as a data source through the UI, built a couple of panels, saved the dashboard, and created one alert rule. The flow itself is smooth — the docs walk you through each step in order and nothing fights back.

## Got stuck on

**The quickstart's first data-source step assumes Prometheus is already running.**
The guide says "add a Prometheus data source" without mentioning that you need a Prometheus instance to point at. I typed `localhost:9090` and the save-and-test failed, because Grafana running in Docker can't see a process on my laptop's localhost. I had to either start Prometheus separately or point the URL at the host address. The quickstart doesn't flag this — it assumes you already have metrics flowing.

**The dashboard URL after saving is not the one I expected.**
I saved a dashboard, clicked the share icon, and copied a link that showed an embedded view with a time-range parameter baked in. When I opened it in a fresh tab it looked fine, but the URL didn't behave like a normal dashboard link — it had `?viewPanel=...` and a `var-` parameter string. For sharing with a teammate I wanted the plain dashboard URL, which is the one in the address bar after clicking the dashboard title, not the share-panel link.

**Alerting rules show "No data" for a while after saving.**
I created an alert rule on a query that definitely returns data, saved it, and the alert list said "No data" for about a minute. The quickstart doesn't mention the delay — it's just the first evaluation cycle. Not a bug, but confusing when you're expecting instant feedback.

**The legacy alerting page is still reachable and shows nothing.**
I had a bookmark to `/alerting` from an older Grafana version. Clicking it took me to the legacy alerting UI, which doesn't reflect the new rules I'd created. The quickstart only covers Unified Alerting. The correct page is `/alerting/list` (or the Alerting icon in the left nav). If you land on the legacy page you'll think your rules don't exist.

## What I'd try next

- Set up a proper provisioning directory (YAML files under `/etc/grafana/provisioning/`) instead of clicking through the UI every time — the docs cover this and it's the path I'd take for anything I want to version-control.
- Explore Grafana's built-in Loki integration for log correlation; the quickstart only covers metrics.
- Write a small provisioning YAML for the data source and dashboard I built, then diff it against what the UI exported to see how the two relate.
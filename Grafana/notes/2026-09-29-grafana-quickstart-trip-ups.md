---
last_verified: 2026-09-29
tool_version: n/a
---

# 2026-09-29-grafana-quickstart-trip-ups.md

Following the official Grafana quickstart and writing up what tripped me up.

## What I did

I spun up Grafana locally via Docker to run through the "Getting started" guide on grafana.com. The guide walks through: install → add a data source → build a dashboard → set up alerting. I used the Docker Compose approach since it's what the quickstart recommends for a first try.

```bash
docker run -d -p 3000:3000 --name grafana grafana/grafana-enterprise
```

Logged in at http://localhost:3000 with admin/admin, changed the password when prompted. So far so good.

## Got stuck on

**Data source provisioning via env vars doesn't persist the way I expected.**
The quickstart shows adding Prometheus as a data source through the UI. I wanted to automate it, so I tried the `GF_DATASOURCES` environment variable approach documented in "Configure Grafana with environment variables." My compose file had:

```yaml
environment:
  - GF_DATASOURCES='{"apiVersion": 1, "datasources": [{"name": "Prometheus", "type": "prometheus", "url": "http://prometheus:9090", "access": "proxy"}]}'
```

Grafana started, the data source appeared in the UI, but it was read-only — I couldn't edit or delete it from the UI. The docs mention this behavior but I missed it on the first pass: datasources configured via provisioning are managed by the config, not the database. If you want to manage them in the UI later, you have to add them there manually (or use the HTTP API).

**Dashboard JSON import path is picky about `uid` vs `id`.**
I exported a dashboard from another instance and tried importing it via the API (`POST /api/dashboards/db`). The import succeeded but the dashboard didn't show up in the UI list. Turns out the exported JSON had `"id": 123` (numeric) but no `"uid"`. Grafana requires a `uid` for the dashboard to be addressable. Adding `"uid": "my-dashboard"` to the JSON before import fixed it.

**Alerting rule evaluation interval defaults to 1m but the UI shows "No data" until the first evaluation completes.**
I created a simple alert rule on a Prometheus query that returns data. The rule saved fine, but the alert list showed "No data" for about a minute. The quickstart doesn't mention this delay — it's just the first evaluation cycle. Not a bug, but confusing if you're expecting instant feedback.

**The "Unified Alerting" toggle is on by default in current Grafana but the legacy alerting UI is still reachable via direct URL.**
I clicked a bookmarked link to `/alerting` from an older version and saw the legacy alerting page, which doesn't reflect the new alert rules I'd created. The quickstart only covers Unified Alerting. If you land on the legacy page, you'll think your rules aren't there. The correct page is `/alerting/list` (or the Alerting icon in the left nav).

## What I'd try next

- Use the HTTP API to provision dashboards and alert rules programmatically instead of relying on UI clicks — the API is stable and lets me version-control the definitions.
- Explore Grafana's built-in Loki integration for log correlation; the quickstart only covers metrics.
- Set up a proper provisioning directory (YAML files under `/etc/grafana/provisioning/`) instead of cramming JSON into env vars — cleaner separation and easier to review in git.
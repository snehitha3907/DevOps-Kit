---
last_verified: 2026-09-30
tool_version: n/a
---

# My first hosted dashboard in Grafana Cloud

Spent this session poking around the Grafana Cloud UI. Turns out the hosted side is the same Grafana I ran in Docker earlier, with a signup and a URL attached — the panels, the time picker, Explore, the dashboard JSON editor, all of it familiar. The free stack gave me a subdomain and a `grafana.com`-hosted instance, which is the main difference from what I had locally.

What I actually did:

- Signed up, landed in a stack with one pre-created Prometheus datasource. I did not have to wire a datasource by hand, which was the thing I expected to be fiddly.
- Opened Explore, ran an instant query, got series back. Seeing real data on the first query was a nice surprise.
- New -> Dashboard, dragged in a stat panel, picked the Prometheus datasource, saved it. My first hosted dashboard.
- Found the JSON model button in the dashboard menu and copied the JSON out. That is going to be how I build the next ones.

Things I got wrong: I spent a while looking for where to set the scrape interval in the UI before remembering the datasource owns that, not the panel. And the first panel said "No data" until I actually saved and re-opened the dashboard.

TODO: figure out how the agent I started with (see `../configs/`) is supposed to push into this stack, and where the endpoint and token live. I do not want to guess at that and send samples to the wrong place.

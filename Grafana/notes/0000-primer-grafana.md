---
last_verified: 2026-09-25
tool_version: n/a
sources: []
---

# Grafana — quick primer

> First-day notes for someone who's never used Grafana. Personal voice, plain language.

## What is it?

Grafana is an open-source dashboarding tool I just started reading about. It sits in the observability corner of my DevOps world, right next to Prometheus. If Prometheus is the thing that collects numbers, Grafana is the thing that draws them — I point it at a data source and it turns raw query results into graphs, gauges, and tables I can actually read at 3am.

The comparison that clicked for me: Prometheus is to metrics what a database is to rows, and Grafana is the reporting layer on top — closer to a spreadsheet chart than to a database console. It does not store my data itself; it borrows it, draws it, and forgets it.

## What does it do?

I connect a data source, type a query, and drop the result onto a panel. Panels snap together into dashboards I can share with a link instead of pasting screenshots into chat. I can add dropdown variables so one dashboard serves every service, and I can attach alert rules so Grafana taps me on the shoulder when a query crosses a threshold.

## Why does it exist?

Before tools like this, every team stared at raw query output or hand-rolled chart pages that rotted within a month. Incident response meant SSHing into boxes and eyeballing logs while the outage clock ticked. Grafana gave teams one shared screen: the same dashboard link works for the on-call engineer, the teammate helping out, and the manager asking for status. SRE and platform folks live in it day to day; pretty much anyone who owns a service ends up with at least one board.

## Key terminology

- **Data source** — where Grafana reads numbers from. Example: my local Prometheus on `localhost:9090`.
- **Panel** — a single chart or readout on a dashboard. Example: a graph of request rate over the last hour.
- **Dashboard** — a saved set of panels with layout and time range. Example: a "web health" board with traffic, errors, and latency side by side.
- **Query** — the question I ask the data source. Example: failed requests divided by total requests.
- **Variable** — a dropdown that re-runs every panel with a new value. Example: pick which service the whole dashboard shows.
- **Alert rule** — a threshold check pinned to a query. Example: warn me if the error share stays above five percent for ten minutes.
- **Snapshot** — a frozen, shareable copy of a dashboard. Example: attach one to an incident review so the graphs survive after the data ages out.

## A tiny example

```bash
docker run -d --name my-grafana -p 3000:3000 grafana/grafana
```

This starts Grafana on my machine. I open `localhost:3000` in a browser and log in with the default admin account to reach the home screen.

## What I'll cover next

I want to get it actually running via Docker and confirm the login page answers, then click through the UI myself — adding a data source, building a panel, saving a dashboard — and write down everywhere I stumble. After that, real queries against a live source.

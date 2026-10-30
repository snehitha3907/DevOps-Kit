---
last_verified: 2026-09-25
tool_version: n/a
sources: []
---

# Poking around the Grafana UI — data sources, panels, dashboards

> Started Grafana in Docker and clicked through the UI to learn where everything lives.

## What I was trying to do

I had a fresh Grafana and zero dashboards. I wanted to add a data source, build one panel with a real query, and save it as a dashboard.

## What worked

Adding a data source was smooth: Connections in the left nav, Add data source, pick Prometheus, paste the URL, hit Save and test. The green success banner told me straight away the connection was alive.

Building my first panel also clicked fast: Dashboards, New, Add visualization, pick the data source, type a query, and the graph draws live above the editor. The time-range picker in the top right made it easy to zoom from the last hour out to the last day.

## Got stuck on

**Grafana-in-Docker cannot see my laptop's localhost.** I typed `localhost:9090` as the Prometheus URL and the test failed. Inside the container, localhost means the container itself. Pointing it at the host address fixed it — the save-and-test banner went green immediately.

**My first panel was empty.** The query was fine; the time range just had no data in it. Widening from the last hour to the last six hours made the graph appear. Lesson learned: empty panel, check the time picker first.

**Unsaved dashboards vanish.** I refreshed the page before saving and lost my panel. Hitting Save dashboard early and often is now a habit.

## What I'd try next

I want to add a dropdown variable so one dashboard can flip between services, and set up my first alert rule so Grafana tells me when something breaks instead of me staring at graphs.

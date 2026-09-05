---
last_verified: 2026-09-05
tool_version: n/a
sources: []
---

# Prometheus getting started — what tripped me up

> Following the official Prometheus getting-started guide and writing down the parts that didn't work on the first try.

## What I was trying to do

I wanted to stand up a local Prometheus instance, point it at a running container, and see metrics appear in the UI. The official quickstart makes it look straightforward: download, unzip, run with a config file. I expected to have a dashboard open within ten minutes.

## What actually worked

The install steps themselves were fine. Downloading the tarball, extracting the `prometheus` binary, and starting it with `--config.file` and `--storage.tsdb.path` flags all worked on the first try. Opening `http://localhost:9090` loaded the UI without any issue, and the Targets page showed `prometheus` as UP immediately. That part was genuinely smooth.

Configuring a scrape target was also simple once I understood the YAML structure. A minimal `scrape_configs` block with a `job_name` and `static_configs` pointing at my app's `:9100/metrics` endpoint was all I needed for a single static target.

## Got stuck on

**The binary is named `prometheus`, not `prometheus-server`.** I kept typing `prometheus-server` out of habit from systemd package installs. The tarball only contains `prometheus` — no init script, no systemd unit. That cost me a few minutes of "command not found" before I listed the extracted directory.

**Scrape targets need to be reachable from inside the Prometheus container.** When I ran Prometheus in Docker, I used `localhost:9090` as a target — that resolves to the container itself, not the host. Any target running on the host machine needs to be addressed via `host.docker.internal` (Docker Desktop/Mac) or by adding `--network host` (Linux). The Targets page showed them as DOWN with no obvious error message, just a grey down arrow.

**The default retention is 15 days of metrics data.** I was surprised how quickly the data directory grew. Within a few hours of testing with a 15-second `scrape_interval`, my `data/` folder was already several hundred megabytes. Setting `--storage.tsdb.retention.time=7d` early would have saved me a disk-full scare.

**PromQL's `rate()` needs at least two data points.** My first attempt at `rate(http_requests_total[1m])` returned empty results. The range selector needs the scrape interval to fire at least twice within the window. With a fresh target and a 1-minute range, the first scrape or two will come back empty. Extending the range to `[5m]` or waiting a couple of scrape cycles fixed it.

## What I'd try next

I want to set up Alertmanager so that DOWN targets actually notify me instead of silently failing. I also need to learn how `relabel_configs` works — that's how you dynamically add targets from service discovery instead of hardcoding them in `static_configs`.

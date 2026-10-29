---
last_verified: 2026-10-29
tool_version: n/a
sources:
  - https://prometheus.io/docs/
  - https://prometheus.io/docs/prometheus/latest/configuration/configuration/
---
# Prometheus project scaffold

> A minimal, reusable scaffold for bootstrapping a Prometheus-based metrics pipeline. Use this as a starting point to add scrape targets, rules, and dashboards for a new service.

## Purpose

This scaffold provides a clean layout for a Prometheus project: a base configuration, example alerting/recording rules, helper scripts for validation, and dashboard placeholders. It is intended for local development or as a template for CI-driven configuration checks.

## When to use

Use when starting a new observability setup with Prometheus. Extend with your service's exporters, adjust scrape jobs, and add Alertmanager integration as needed. For full stack deployment, see the `prometheus-alertmanager-grafana-stack` template.

## Prerequisites

- Prometheus installed locally or in the target environment
- Basic familiarity with Prometheus configuration and PromQL
- Network access to the targets you plan to scrape

## Steps

1. Copy this directory to your project.
2. Update `config/prometheus.yml` with your scrape targets.
3. Add custom rules under `rules/` as needed.
4. Run the validation script in `scripts/` to check configuration syntax.
5. Start Prometheus pointing to the updated configuration.

## Verify

- Configuration validates successfully via the provided script.
- Prometheus starts without errors.
- Targets appear in the Prometheus UI Targets page.

## Rollback

- Revert changes to `config/prometheus.yml` or rule files to a known-good state.
- Restart Prometheus after reverting configuration.

## Common errors

- **Configuration parse error**: check indentation and YAML syntax; use the validation script.
- **Target unreachable**: verify network/firewall and the target's metrics endpoint.

---
last_verified: 2026-11-24
tool_version: n/a
sources:
  - https://grafana.com/docs/grafana-cloud/send-data/metrics/metrics-prometheus
  - https://grafana.com/docs/grafana-cloud/security-and-account-management/authentication-and-permissions/access-policies/create-access-policies
  - https://prometheus.io/docs/prometheus/3.15/configuration/configuration/
  - https://prometheus.io/docs/practices/remote_write
  - https://grafana.com/docs/grafana-cloud/send-data/metrics/metrics-prometheus/ingestion-errors
---

# Ship metrics to Grafana Cloud

In [A Grafana dashboard kept in Git](../09-observability/04-grafana-dashboard-as-code.md) you provisioned a Prometheus data source and a dashboard from files so Grafana queries your local Prometheus. This lesson flips the flow: instead of only reading metrics locally, you ship the sample app's metrics from Prometheus to your Grafana Cloud stack with `remote_write`, then point the same dashboard at the Grafana Cloud stack so its panels query the metrics that just arrived.

## What you'll learn
- Add a `remote_write` block to `prometheus.yml` that sends the app's metrics to your Grafana Cloud stack (stack endpoint, Metrics instance ID, Cloud Access Policy token with `metrics:write`)
- Validate the config and restart Prometheus so it starts shipping samples to Grafana Cloud
- Provision a Grafana data source from a file that points at the Grafana Cloud stack and reuse the existing dashboard so its panels query the shipped metrics

## Before you start
- [A Grafana dashboard kept in Git](../09-observability/04-grafana-dashboard-as-code.md) — how to provision a Prometheus data source and dashboard from files; adapt `app-overview-dashboard.json` and `prometheus-datasource.yaml` here
- The sample app running and Prometheus scraping it on port 9090 (from the scrape-and-alert lesson)
- A Grafana Cloud stack with a Prometheus service; copy the Metrics instance ID and a Cloud Access Policy token with the `metrics:write` scope from the stack's Details page (Prometheus card). The token is shown only once, and generating one requires the Admin role.
- Prometheus installed; confirm with `promtool check config --help`. Grafana Cloud is SaaS, so there is no client release version to pin — configure the per-stack endpoint and instance ID from the Cloud Portal.
- Companion files: `Grafana Cloud/configs/prometheus-remote-write-grafana-cloud.yaml` and `Grafana Cloud/configs/grafana-cloud-datasource.yaml`

## Walkthrough

1. Add the `remote_write` block to `prometheus.yml`.

   Open your `prometheus.yml` and add a `remote_write` section. The URL is the `/api/prom/push` endpoint on your Grafana Cloud stack; the username is your numeric Metrics instance ID and the password is your Cloud Access Policy token:

   ```yaml
   remote_write:
     - url: https://<METRICS_INSTANCE_ID>.grafana.net/api/prom/push
       basic_auth:
         username: <METRICS_INSTANCE_ID>
         password: <CLOUD_ACCESS_POLICY_TOKEN>
       write_relabel_configs:
         - source_labels: [__name__]
           regex: 'demo_http.*'
           action: keep
   ```

   `write_relabel_configs` limits which series are sent (here only the app's `demo_http_*` metrics) so you stay under the ingestion soft cap. Relabeling runs after external labels. You can also tune `remote_timeout` (default 30s), `send_interval` (default 1m), and `max_samples_per_send` (default 2000). A complete example lives at `Grafana Cloud/configs/prometheus-remote-write-grafana-cloud.yaml`.

   You should see: a `remote_write:` block in `prometheus.yml` with your stack's endpoint, instance ID, and token.

2. Validate the config and restart Prometheus.

   ```bash
   promtool check config prometheus.yml
   ```

   You should see: `Checking prometheus.yml` followed by `SUCCESS: ...` (no syntax errors). Then restart Prometheus so it picks up the new block — however you run it (Docker, systemd, or the Prometheus binary).

   You should see: Prometheus restarts without errors and its log shows the remote_write client attempting to connect to the stack endpoint (real credentials required; with placeholder values it retries until you insert the real token).

3. Confirm samples are shipping to Grafana Cloud.

   After a couple of minutes, query the Grafana Cloud Prometheus API directly with your instance ID and token:

   ```bash
   curl -s -u <METRICS_INSTANCE_ID>:<CLOUD_ACCESS_POLICY_TOKEN> \
     "https://<METRICS_INSTANCE_ID>.grafana.net/api/prom/api/v1/query?query=up" \
     | python3 -m json.tool
   ```

   You should see: a JSON `data.result` array containing series for the sample app (e.g. `up`, `demo_http_requests_total`), proving Prometheus shipped them and Grafana Cloud stored them. You can also open the stack's Details page (Prometheus card) and confirm the "Last received" timestamp is moving.

4. Reuse the dashboard against the Grafana Cloud stack.

   Provision a Grafana data source that points at the Grafana Cloud stack instead of localhost. Save this as `Grafana Cloud/configs/grafana-cloud-datasource.yaml`:

   ```yaml
   apiVersion: 1
   datasources:
     - name: Grafana Cloud (Prometheus)
       type: prometheus
       access: proxy
       url: https://<METRICS_INSTANCE_ID>.grafana.net/api/prom
       basicAuth: true
       basicAuthUser: <METRICS_INSTANCE_ID>
       secureJsonData:
         basicAuthPassword: <CLOUD_ACCESS_POLICY_TOKEN>
       editable: false
   ```

   Mount it under `/etc/grafana/provisioning/datasources/` alongside the existing provider, restart Grafana, and open the `App overview` dashboard. Its panels already reference a pinned `uid`, so you only need to swap the data source behind that `uid` to the Grafana Cloud one.

   You should see: Grafana's data-sources page lists `Grafana Cloud (Prometheus)` as healthy, and the dashboard panels plot data from Grafana Cloud rather than local Prometheus.

## Exercise

Do the full flow on your own against your own Grafana Cloud stack:

1. Add a `remote_write` block to your `prometheus.yml` with your stack's endpoint, instance ID, and a `metrics:write` token, keeping only the app's series via `write_relabel_configs`.
2. Validate with `promtool check config`, restart Prometheus, and confirm samples arrive in Grafana Cloud (the Details page "Last received" moves or the query in step 3 returns series).
3. Provision a Grafana data source pointed at the Grafana Cloud stack from a file, restart Grafana, and confirm the `App overview` dashboard now plots data from Grafana Cloud.

Record each result yourself — no solution is provided.

## Check your work

```bash
promtool check config prometheus.yml                                                          # config is valid
grep -A6 "remote_write:" prometheus.yml                                                       # remote_write block present
curl -sf -u <METRICS_INSTANCE_ID>:<CLOUD_ACCESS_POLICY_TOKEN> \
  "https://<METRICS_INSTANCE_ID>.grafana.net/api/prom/api/v1/query?query=up" \
  | python3 -m json.tool                                                                      # Cloud returns series
grep -rn "grafana.net" "Grafana Cloud/configs/grafana-cloud-datasource.yaml"                  # datasource points at Cloud stack
```

You should see: `promtool` reports SUCCESS, the `remote_write:` block appears with your endpoint and instance ID, the Cloud query returns a `data.result` array with app series, and the datasource YAML contains your stack's `grafana.net` URL.

## Common mistakes

- `401 Unauthorized: Invalid token` on remote_write: wrong Metrics instance ID (copied from the Loki stack instead of Prometheus), missing `metrics:write` scope, expired/revoked token, or the wrong region's endpoint. Re-copy username and token from the Prometheus card Details page and confirm the token has `metrics:write`.
- Sending every series: without `write_relabel_configs` you ship all series and can hit the ~25,000 samples/second soft cap; keep the relabel rule that only keeps the app's metrics.
- Prometheus cannot read environment variables, so credentials cannot be injected straight from a Kubernetes Secret in a ConfigMap — give the changed ConfigMap a new versioned name (e.g. `_v2`) instead of editing in place.
- Dashboard panels blank: the data source `uid` the dashboard references does not match the provisioned Grafana Cloud data source, or the data source is not healthy. Check Grafana's data-sources page first.

## Next

[Browse the full learning path](../../00_index/learning-path.md)

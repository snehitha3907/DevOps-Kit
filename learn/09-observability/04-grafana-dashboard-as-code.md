---
last_verified: 2026-11-19
tool_version: 13.3.1
sources:
  - https://grafana.com/docs/grafana/latest/administration/provisioning/
  - https://github.com/grafana/grafana/releases/tag/v13.3.1
  - https://stackharbor.com/en/knowledge-base/grafana-provisioning-dashboards-as-code/
---
# A Grafana dashboard kept in Git

In [Grafana — quick primer](../../graf/notes/0000-primer-grafana.md) you saw that Grafana draws metrics it borrows from a data source and that a dashboard is just a saved set of panels. In [Scrape the sample app and alert on errors](03-prometheus-scrape-and-alert.md) you pointed Prometheus at the sample app and confirmed it scrapes `demo_http_requests_total`, `demo_http_errors_total`, and `demo_http_latency_seconds_avg`. This lesson turns those metrics into a dashboard that lives in Git: you provision a Prometheus data source and a dashboard from files, restart Grafana, and confirm the panels show the app's request rate, error rate, and latency without a single UI click.

## What you'll learn

- Provision a Prometheus data source and a dashboard from files by writing `provisioning/datasources/*.yaml` and `provisioning/dashboards/*.yaml`, pointing at a folder of dashboard JSON.
- Show the app's request rate, error rate, and latency in panels that reference the data source by its pinned `uid`.

## Before you start

- [Grafana — quick primer](../../graf/notes/0000-primer-grafana.md) — what a data source, panel, and dashboard are; Grafana reads metrics, it does not store them.
- [Prometheus — quick primer](../../Prometheus/notes/0000-primer-prometheus.md) — scrape jobs, targets, and the `/metrics` endpoint the dashboard queries.
- [Monitoring and observability concepts](../../docs/concepts/monitoring-observability-concepts/0000-primer-monitoring-observability-concepts.md) — metrics, dashboards, and why a shared view beats ad-hoc queries.
- [Scrape the sample app and alert on errors](03-prometheus-scrape-and-alert.md) — the Prometheus instance and sample app this dashboard reads from.
- Grafana 13.3.1 runnable via Docker (`docker --version`); default login `admin`/`admin`, which Grafana asks you to change on first login.
- The sample app from the previous lesson running on port 8000, with Prometheus scraping it on port 9090.
- Companion files used in this lesson: [prometheus-datasource.yaml](../../Grafana/configs/prometheus-datasource.yaml), [dashboards-provider.yaml](../../Grafana/configs/dashboards-provider.yaml), and [app-overview-dashboard.json](../../Grafana/configs/app-overview-dashboard.json) (all under `Grafana/configs/`).

## Walkthrough

1. Confirm Prometheus is scraping the app.

   From the previous lesson, the sample app should be running on port 8000 and Prometheus on port 9090. Verify the metrics exist:

   ```bash
   curl -s "http://localhost:9090/api/v1/query?query=demo_http_requests_total" | python3 -m json.tool
   ```

   You should see: a JSON result with at least one series for `demo_http_requests_total`. If the result is empty, start the app and Prometheus first — the dashboard panels will be blank without data.

2. Write the data source provisioning file.

   Save this as `Grafana/configs/prometheus-datasource.yaml`. It declares one Prometheus data source and pins a stable `uid` (`prometheus-main`) so dashboards can resolve it across environments:

   ```yaml
   apiVersion: 1
   datasources:
     - name: Prometheus (main)
       type: prometheus
       access: proxy
       url: http://localhost:9090
       uid: prometheus-main
       isDefault: true
       editable: false
   ```

   Only one data source per organization may be `isDefault: true`. `access: proxy` makes the Grafana backend fetch the metrics, so the browser never talks to Prometheus directly.

3. Write the dashboard provider file.

   Save this as `Grafana/configs/dashboards-provider.yaml`. It tells Grafana to load every JSON file under `/var/lib/grafana/dashboards`:

   ```yaml
   apiVersion: 1
   providers:
     - name: 'App dashboards'
       orgId: 1
       type: file
       disableDeletion: true
       updateIntervalSeconds: 30
       allowUiUpdates: true
       options:
         path: /var/lib/grafana/dashboards
         foldersFromFilesStructure: true
   ```

   `updateIntervalSeconds` must be greater than 10 to force polling on bind mounts; at 10 or below Grafana switches to filesystem watching, which can miss updates on network filesystems. `disableDeletion: true` keeps a dashboard from disappearing if its source file is temporarily removed.

4. Write the dashboard JSON.

   Save this as `Grafana/configs/app-overview-dashboard.json`. Each panel queries Prometheus through the pinned `uid` (`prometheus-main`) instead of the `${DS_PROMETHEUS}` template that an "export for sharing" produces:

   ```json
   {
     "title": "App overview",
     "uid": "app-overview",
     "tags": ["app", "provisioned"],
     "timezone": "browser",
     "refresh": "30s",
     "time": { "from": "now-1h", "to": "now" },
     "panels": [
       {
         "id": 1,
         "title": "Request rate",
         "type": "timeseries",
         "datasource": { "type": "prometheus", "uid": "prometheus-main" },
         "targets": [{ "expr": "rate(demo_http_requests_total[5m])", "refId": "A" }],
         "gridPos": { "h": 8, "w": 12, "x": 0, "y": 0 }
       },
       {
         "id": 2,
         "title": "Error rate",
         "type": "timeseries",
         "datasource": { "type": "prometheus", "uid": "prometheus-main" },
         "targets": [{ "expr": "rate(demo_http_errors_total[5m]) / rate(demo_http_requests_total[5m])", "refId": "A" }],
         "gridPos": { "h": 8, "w": 12, "x": 12, "y": 0 }
       },
       {
         "id": 3,
         "title": "Latency (avg)",
         "type": "timeseries",
         "datasource": { "type": "prometheus", "uid": "prometheus-main" },
         "targets": [{ "expr": "demo_http_latency_seconds_avg", "refId": "A" }],
         "gridPos": { "h": 8, "w": 24, "x": 0, "y": 8 }
       }
     ]
   }
   ```

   The error-rate panel divides two `rate()` calls so it stays correct even if the counters reset. If your app exposed a histogram instead of the `demo_http_latency_seconds_avg` gauge, you would use `histogram_quantile(0.95, rate(..._bucket[5m]))` here.

5. Validate the files before starting Grafana.

   ```bash
   python3 -m json.tool Grafana/configs/app-overview-dashboard.json >/dev/null && echo "dashboard JSON valid"
   ```

   You should see: `dashboard JSON valid`. A single invalid JSON file makes Grafana skip every dashboard in that provider directory, so validate every file before restart.

6. Start Grafana with the files mounted.

   ```bash
   docker run -d --name grafana -p 3000:3000 \
     -v "$PWD/Grafana/configs/prometheus-datasource.yaml:/etc/grafana/provisioning/datasources/prometheus.yaml" \
     -v "$PWD/Grafana/configs/dashboards-provider.yaml:/etc/grafana/provisioning/dashboards/dashboards.yaml" \
     -v "$PWD/Grafana/configs/app-overview-dashboard.json:/var/lib/grafana/dashboards/app-overview.json" \
     grafana/grafana:13.3.1
   ```

   You should see: the container ID printed and `docker ps` showing `grafana` running. Mounting individual files (rather than the whole `configs/` folder) keeps the YAML provisioning files out of the dashboard directory.

7. Confirm the data source and dashboard loaded.

   Wait a few seconds, then query the Grafana API:

   ```bash
   curl -s http://localhost:3000/api/health
   curl -s -u admin:admin http://localhost:3000/api/datasources/uid/prometheus-main
   curl -s -u admin:admin "http://localhost:3000/api/search?query=app-overview"
   ```

   You should see: the health endpoint reporting `database: ok`, the data source returned with `uid: prometheus-main`, and the search returning the `App overview` dashboard. If the dashboard is missing, check `docker logs grafana` for a YAML or JSON parse error — the provider never loads on a syntax error.

8. View the dashboard and confirm data appears.

   Open `http://localhost:3000`, log in (`admin`/`admin`, then set a new password), and open the `App overview` dashboard.

   You should see: three panels — request rate, error rate, and latency — plotting data from the sample app. If a panel is empty, the metric name does not exist yet or the time range predates the data; verify first with `curl .../api/v1/query?query=up` against Prometheus, then widen the dashboard time range.

## Exercise

Do the flow on your own, then extend it:

1. Run the sample app on a second port (e.g. 8001) and add a second `scrape_config` named `my-app` to Prometheus.
2. Add a second data source entry (or a second dashboard JSON) that points at the new job, keeping the pinned `uid` scheme.
3. Add a fourth panel to `app-overview-dashboard.json` — for example total requests (`demo_http_requests_total`) or an error count — and give it a new `id` and `gridPos`.
4. Re-run `python3 -m json.tool` on the dashboard file, restart the Grafana container, and confirm the new panel appears and plots data.

No solution is provided — run each step and verify it yourself.

## Check your work

```bash
python3 -m json.tool Grafana/configs/app-overview-dashboard.json >/dev/null && echo "dashboard JSON valid"   # JSON parses
grep -n "prometheus-main" Grafana/configs/app-overview-dashboard.json Grafana/configs/prometheus-datasource.yaml  # uid pinned in both
curl -sf http://localhost:3000/api/health | python3 -m json.tool                                          # Grafana healthy
curl -s -u admin:admin "http://localhost:3000/api/search?query=app-overview" | python3 -m json.tool       # dashboard registered
```

You should see: the JSON parses with no error, `prometheus-main` appears in both files, Grafana reports `database: ok`, and the search returns the `App overview` dashboard by uid `app-overview`.

## Common mistakes

- "Datasource ... was not found" in panels: the `uid` in the dashboard JSON does not match the provisioned data source `uid`, or a leftover `${DS_PROMETHEUS}` template survived an "export for sharing". Align the uids and remove `__inputs`.
- "Only one datasource per organization can be marked as default": two YAMLs (or a manually created datasource) both set `isDefault: true`. Set only one default per org.
- Provider never loaded / "finished to provision dashboards" missing: the provider YAML is in the wrong directory or has a YAML syntax error. Validate the YAML and confirm `options.path` matches the mount and is readable by the Grafana user.
- One invalid JSON file skips all dashboards in that provider directory: validate every JSON with `python3 -m json.tool` before restart and move bad files out.
- Dashboard appears but panels show no data: the metric names do not exist yet or the time range predates the data. Verify with `curl .../api/v1/query?query=up` against Prometheus first.
- Filesystem watch misses updates on bind mounts: set `updateIntervalSeconds` above 10 to force polling.

## Next

[Continue the learning path](../../00_index/learning-path.md)

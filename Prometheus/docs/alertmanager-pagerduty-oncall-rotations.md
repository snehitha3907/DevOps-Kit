---
last_verified: 2026-09-30
tool_version: n/a
---

# Wiring Prometheus Alertmanager with PagerDuty for on-call rotations

## Purpose

Prometheus fires alerts from rule evaluations, and Alertmanager decides who gets told, how often, and through which channel. This doc shows one path from a firing Prometheus alert to a PagerDuty incident that lands on the current on-call rotation. It builds on the demo alerts already in this kit — `DemoHighErrorRate` (warning) and `DemoExporterDown` (critical) in [recording-vs-alerting-rules.yaml](../configs/recording-vs-alerting-rules.yaml), fed by the exporter in [custom-app-exporter.py](../scripts/custom-app-exporter.py).

This is one way to wire it; the Alertmanager docs also describe other receiver types and routing functions, so treat this as a starting route tree rather than the only layout.

## Steps

1. Confirm the alerts fire in Prometheus first. Check the rules page shows both demo groups healthy and trigger each condition (drive errors at the demo endpoint for the error-ratio alert, stop the exporter for the down alert) until the alert state moves from pending to firing.

2. Create the PagerDuty side: one service per rotation (for example, a demo-app service owned by the team rotation), with its escalation policy pointing at the schedule that defines who is on call. Take note of the service integration key — Alertmanager uses that key to deliver, and the schedule handles who is paged, so rotations are managed in PagerDuty rather than in YAML.

3. Add a PagerDuty receiver in the Alertmanager config. Keep the key out of the file by reading it from the environment or a mounted secret file:

```yaml
receivers:
  - name: team-pagerduty
    pagerduty_configs:
      - service_key: <pagerduty-integration-key>
        description: '{{ .CommonAnnotations.summary }}'
        severity: '{{ .CommonLabels.severity }}'
```

4. Route by severity so warning and critical take different urgency paths. Match on the `severity` label the demo rules already set, with a catch-all default so no alert goes nowhere:

```yaml
route:
  receiver: team-pagerduty
  group_by: [alertname, job]
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  routes:
    - match:
        severity: critical
      receiver: team-pagerduty
      repeat_interval: 30m
    - match:
        severity: warning
      receiver: team-pagerduty
      repeat_interval: 12h
```

Grouping by alert name and job keeps one flap from paging repeatedly, while the shorter repeat for critical pages again if the exporter stays down. The docs also suggest grouping by labels such as instance when one host dominates a group.

5. Point Prometheus at Alertmanager so firing alerts are delivered:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets: [<alertmanager-host-and-port>]
```

Reload both configs after editing (Prometheus rule reload for the demo rules, Alertmanager config reload for the route tree) so the new wiring takes effect without a restart.

## Verify

Send a test alert through each route and confirm the matching PagerDuty incident appears on the expected service with the right severity. Then resolve the test condition: the warning alert for an elevated error ratio should arrive once and stay quiet for its long repeat window, while stopping the exporter should page the critical path and repeat until the target is back up. If either route delivers to the wrong service or never arrives, re-check the `severity` label on the firing alert and the receiver name spelling in the route — a mismatched label silently falls through to the default receiver.

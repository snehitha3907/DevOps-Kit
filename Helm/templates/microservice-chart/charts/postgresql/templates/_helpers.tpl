# last_verified: 2026-10-04 · Helm · n/a
{{/*
The name comes from the parent chart's helper on purpose. Named templates are
compiled across a chart and its subcharts as one set, so a subchart can call a
template the parent defines — and the parent is always compiled, whereas a
disabled dependency's templates are not something the parent should rely on. One
definition, so the Service this chart creates and the host the parent's Deployment
dials can never disagree.
*/}}
{{- define "postgresql.fullname" -}}
{{- include "microservice-chart.databaseServiceName" . }}
{{- end -}}

{{- define "postgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Generated when auth.password is empty. This is a throwaway local-development
credential, not a secret store — anything beyond a sandbox cluster should set
auth.password from an external secret manager.
*/}}
{{- define "postgresql.password" -}}
{{- if .Values.auth.password -}}
{{- .Values.auth.password -}}
{{- else -}}
{{- randAlphaNum 24 -}}
{{- end -}}
{{- end -}}

{{/*
# last_verified: 2026-10-04 · Helm · n/a
*/}}

{{/*
Chart name, overridable with nameOverride. Every other name helper builds on this,
so changing nameOverride moves the whole set consistently.
*/}}
{{- define "microservice-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Release-qualified name. Truncated to 63 characters because this value becomes a
Kubernetes label value and a Service name, both of which cap at 63.
*/}}
{{- define "microservice-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart name and version as a single label value. `+` is legal in a semver but not
in a label, so it is replaced.
*/}}
{{- define "microservice-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels. selectorLabels is the immutable subset — anything added here that
also lands in the selector makes an existing Deployment un-updatable.
*/}}
{{- define "microservice-chart.labels" -}}
helm.sh/chart: {{ include "microservice-chart.chart" . }}
{{ include "microservice-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ include "microservice-chart.name" . }}
{{- end }}

{{- define "microservice-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "microservice-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount to bind. serviceAccount.name wins so an externally created
account can be referenced; otherwise the generated one is used, and when
create is false and no name is set, the pod falls back to `default`.
*/}}
{{- define "microservice-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "microservice-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Fully-qualified image reference. global.imageRegistry is checked first so one
registry override reaches this chart and the postgresql subchart alike; image.tag
falls back to .Chart.AppVersion so bumping appVersion is enough to move images.
*/}}
{{- define "microservice-chart.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry .Values.image.repository $tag -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end -}}
{{- end }}

{{/*
Merged pull-secret list for the chart and for global.imagePullSecrets. Both are
emitted from one helper so a pod spec can never end up with two imagePullSecrets
keys — the second would silently replace the first.
Entries are {name: <secret>} maps, matching the shape used everywhere else in the
chart, and the merged list is de-duplicated.
*/}}
{{- define "microservice-chart.imagePullSecrets" -}}
{{- $secrets := concat (.Values.global.imagePullSecrets | default (list)) (.Values.imagePullSecrets | default (list)) | uniq -}}
{{- if $secrets }}
imagePullSecrets:
{{- range $secrets }}
  - name: {{ .name }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Name of the Service the postgresql subchart creates. Defined here, in the parent,
on purpose: named templates are compiled across the chart and all its subcharts
together, so the subchart can call this back (charts/postgresql/templates/_helpers.tpl
does exactly that) while a disabled subchart is never asked for anything. Defining
it in both places would let the two names drift apart and produce a Deployment
pointing at a Service that does not exist.
*/}}
{{- define "microservice-chart.databaseServiceName" -}}
{{- printf "%s-postgresql" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Database host for the Deployment's env block. When the postgresql subchart is
enabled the dependency's service name is used, so the value cannot drift away
from what the subchart actually creates; otherwise it falls back to whatever the
operator set in config.dbHost.
*/}}
{{- define "microservice-chart.dbHost" -}}
{{- if .Values.database.enabled -}}
{{- include "microservice-chart.databaseServiceName" . -}}
{{- else -}}
{{- .Values.config.dbHost -}}
{{- end -}}
{{- end }}

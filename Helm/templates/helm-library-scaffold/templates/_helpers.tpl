{{/*
# last_verified: 2026-10-21 · Helm · n/a
*/}}

{{/*
Library chart helpers - reusable templates for Helm charts
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "helm-library.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "helm-library.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "helm-library.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-library.labels" -}}
helm.sh/chart: {{ include "helm-library.chart" . }}
{{ include "helm-library.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels - immutable subset used in selectors
*/}}
{{- define "helm-library.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-library.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "helm-library.annotations" -}}
meta.helm.sh/release-name: {{ .Release.Name | quote }}
meta.helm.sh/release-namespace: {{ .Release.Namespace | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm-library.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "helm-library.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Image reference with registry support
*/}}
{{- define "helm-library.image" -}}
{{- $registry := .Values.global.imageRegistry | default .Values.image.registry -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry .Values.image.repository $tag -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end -}}
{{- end }}

{{/*
Merged image pull secrets
*/}}
{{- define "helm-library.imagePullSecrets" -}}
{{- $secrets := concat (.Values.global.imagePullSecrets | default (list)) (.Values.imagePullSecrets | default (list)) -}}
{{- if $secrets }}
imagePullSecrets:
{{- range $secrets }}
  - name: {{ .name }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Generate environment variables from config map
*/}}
{{- define "helm-library.envFrom" -}}
{{- if .Values.envFrom }}
envFrom:
{{- range .Values.envFrom }}
  {{- if .configMapRef }}
  - configMapRef:
      name: {{ .configMapRef.name }}
  {{- end }}
  {{- if .secretRef }}
  - secretRef:
      name: {{ .secretRef.name }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "ado-agent.name" -}}
ado-agent
{{- end }}

{{- define "ado-agent.fullname" -}}
{{ include "ado-agent.name" . }}
{{- end }}

{{- define "ado-agent.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "local-path-provisioner.namespace" -}}
{{ .Values.namespace.name }}
{{- end -}}

{{- define "local-path-provisioner.serviceAccountName" -}}
local-path-provisioner-service-account
{{- end -}}

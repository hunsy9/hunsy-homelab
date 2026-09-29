{{- define "hunsy-hermes-runtime.name" -}}
{{- default .Chart.Name .Values.fullnameOverride -}}
{{- end -}}

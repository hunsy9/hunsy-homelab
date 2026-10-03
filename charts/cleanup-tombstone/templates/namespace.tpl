{{- if .Values.namespace.name }}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.namespace.name | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "0"
{{- end }}

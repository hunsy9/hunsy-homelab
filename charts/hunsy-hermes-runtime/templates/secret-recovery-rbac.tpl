{{- if and .Values.rbac.enabled .Values.rbac.secretRecovery.enabled }}
# Temporary grant: create cannot be restricted by resourceNames in Kubernetes RBAC.
# Allows creating Secrets in this namespace, not reading or modifying existing ones.
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ printf "%s-secret-recovery" (include "hunsy-hermes-runtime.name" .) | quote }}
  namespace: {{ .Values.namespace.name | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["create"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ printf "%s-secret-recovery" (include "hunsy-hermes-runtime.name" .) | quote }}
  namespace: {{ .Values.namespace.name | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ printf "%s-secret-recovery" (include "hunsy-hermes-runtime.name" .) | quote }}
subjects:
  - kind: ServiceAccount
    name: {{ required "secretRecovery.serviceAccount.name is required" .Values.rbac.secretRecovery.serviceAccount.name | quote }}
    namespace: {{ required "secretRecovery.serviceAccount.namespace is required" .Values.rbac.secretRecovery.serviceAccount.namespace | quote }}
{{- end }}

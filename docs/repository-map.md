# Hunsy platform repository map

This repo is the infrastructure/GitOps entry point. Developer agents should use this map before claiming they do not know where application code lives.

## Primary repositories

| Area | Repository | Local path on Seunghun's Mac | Notes |
|---|---|---|---|
| Infrastructure / GitOps | <https://github.com/hunsy9/hunsy-homelab> | `~/hunsy-platform/hunsy-homelab` | Ansible, kubeadm learning cluster, Argo CD apps-of-apps, Helm charts, site values. |
| Asset platform | <https://github.com/hunsy9/hunsy-asset-platform> | `~/hunsy-platform/hunsy-asset-platform` | FastAPI asset API/dashboard, Google Sheets source of truth, Toss Invest read-only integration, snapshot writer, `assets-mcp`, and `bot-handoff-mcp` source. |
| Hermes runtime image | <https://github.com/hunsy9/hunsy-hermes-runtime> | `~/hunsy-platform/hunsy-hermes-runtime` | Container wrapper for Hermes gateway/API runtime, including Developer Agent CLI tools. Images publish to `ghcr.io/hunsy9/hunsy-hermes-runtime`. |
| Legacy Discord agent | <https://github.com/hunsy9/hunsy-discord-agent> | `~/hunsy-platform/hunsy-discord-agent` | Legacy custom Discord proxy bot. Removed from GitOps after moving Developer Agent to Hermes native Discord gateway. Keep for reference/archive; do not extend unless explicitly requested. |

## Current `hunsy-*` cluster app mapping

| Argo CD app | Source repo / image family | GitOps location | Runtime namespace | Purpose |
|---|---|---|---|---|
| `hunsy-asset-platform` | `hunsy-asset-platform` / `ghcr.io/hunsy9/hunsy-asset-platform/api-server` | `sites/az/hunsy-asset-platform` + `charts/hunsy-asset-platform` | `hunsy-asset-platform` | Asset API/dashboard, Google Sheets + Toss read-only integration, daily snapshot CronJob. |
| `hunsy-assets-mcp` | `hunsy-asset-platform/apps/assets-mcp` / `ghcr.io/hunsy9/hunsy-asset-platform/assets-mcp` | `sites/az/hunsy-assets-mcp` + `charts/hunsy-assets-mcp` | `hunsy-assets-mcp` | MCP server for asset data/tools consumed by Hermes agents. |
| `hunsy-bot-handoff-mcp` | `hunsy-asset-platform/apps/bot-handoff-mcp` / `ghcr.io/hunsy9/hunsy-asset-platform/bot-handoff-mcp` | `sites/az/hunsy-bot-handoff-mcp` + `charts/hunsy-bot-handoff-mcp` | `hunsy-hermes-jasani` | Approved template-based Discord handoff MCP from 자사니 to 개바리. |
| `hunsy-hermes-developer-runtime` | `hunsy-hermes-runtime` image | `sites/az/hunsy-hermes-developer-runtime` + `charts/hunsy-hermes-runtime` | `hunsy-hermes-developer-runtime` | Developer Agent / 개바리. GitOps/app developer bot with scoped Kubernetes/Argo/GitHub access. |
| `hunsy-hermes-jasani` | `hunsy-hermes-runtime` image | `sites/az/hunsy-hermes-jasani` + `charts/hunsy-hermes-runtime` | `hunsy-hermes-jasani` | Asset assistant / 자사니. Asset MCP + handoff MCP, no Kubernetes/GitHub powers. |
| `hunsy-hermes-sre` | `hunsy-hermes-runtime` image | `sites/az/hunsy-hermes-sre` + `charts/hunsy-hermes-runtime` | `hunsy-hermes-sre` | SRE / 스리. Kubernetes/SRE diagnostics bot with pod exec diagnostics and approval-gated operations. |
| `hunsy-hermes-runtime` | `hunsy-hermes-runtime` image | `sites/az/hunsy-hermes-runtime` + `charts/hunsy-hermes-runtime` | `hunsy-hermes-runtime` | Baseline/internal Hermes runtime connected to asset MCP. |
| `hunsy-ops-dashboard` | `hunsy-ops-dashboard` image | `sites/az/hunsy-ops-dashboard` + `charts/hunsy-ops-dashboard` | `hunsy-hermes-runtime` | Lightweight ops dashboard exposed at `ops.seung.site`. |

## Non-`hunsy-*` supporting apps

| App | GitOps location | Namespace | Notes |
|---|---|---|---|
| `cloudflared` | `sites/az/cloudflared` + `charts/cloudflared` | `cloudflared` | Cloudflare Tunnel for public hostnames. |
| `gateway-api` | `sites/az/gateway-api` + `charts/gateway-api` | `gateway-system` | Shared GatewayClass/Gateway/EnvoyProxy resources. |
| `local-path-provisioner` | `sites/az/local-path-provisioner` + `charts/local-path-provisioner` | `local-path-storage` | Lightweight local PV provisioner. |
| `metrics-server` | `sites/controller/metrics-server` | `kube-system` | Enables `kubectl top`. |
| `kube-prometheus-stack` | `sites/controller/kube-prometheus-stack` | `monitoring` | Prometheus/Grafana/Alertmanager stack. |

## Agent operating notes

- Do not search the public web to rediscover these private repositories; use this file and Git remotes.
- Do not ask the user for repository URLs that are already listed here.
- Secret/token values are never stored in this map.
- GitHub write access from the in-cluster Developer Agent is intentionally scoped through mounted credentials and Secrets; never print credential file contents.
- 자사니 is intentionally read-only for infrastructure: asset/handoff MCP only, no Kubernetes/GitHub/Secret access.
- 스리는 intentionally has broader SRE diagnostics RBAC, including pod exec, but Secret value output and infrastructure changes remain approval-gated by prompt policy.
- For app source changes outside `hunsy-homelab`, confirm the approved credential/permission path before attempting to push.

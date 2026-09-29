# Hunsy platform repository map

This repo is the infrastructure/GitOps entry point. Developer agents should use this map before claiming they do not know where application code lives.

## Primary repositories

| Area | Repository | Local path on Seunghun's Mac | Notes |
|---|---|---|---|
| Infrastructure / GitOps | <https://github.com/hunsy9/hunsy-homelab> | `~/hunsy-platform/hunsy-homelab` | Ansible, kubeadm learning cluster, Argo CD apps-of-apps, Helm charts, site values. Developer Agent currently has deploy-key push access only to this repo. |
| Asset platform | <https://github.com/hunsy9/hunsy-asset-platform> | `~/hunsy-platform/hunsy-asset-platform` | FastAPI asset API, Google Sheets source of truth, Toss Invest read-only integration, snapshot writer, `assets-mcp` app. |
| Hermes runtime image | <https://github.com/hunsy9/hunsy-hermes-runtime> | `~/hunsy-platform/hunsy-hermes-runtime` | Container wrapper for Hermes gateway/API runtime, including Developer Agent CLI tools. Images publish to `ghcr.io/hunsy9/hunsy-hermes-runtime`. |
| Legacy Discord agent | <https://github.com/hunsy9/hunsy-discord-agent> | `~/hunsy-platform/hunsy-discord-agent` | Legacy custom Discord proxy bot. Removed from GitOps after moving Developer Agent to Hermes native Discord gateway. Keep for reference/archive; do not extend unless explicitly requested. |

## Cluster-deployed app mapping

| Argo CD app | Source repo | GitOps location | Runtime namespace |
|---|---|---|---|
| `hunsy-asset-platform` | `hunsy-asset-platform` image | `sites/az/hunsy-asset-platform` + `charts/hunsy-asset-platform` | `hunsy-asset-platform` |
| `hunsy-assets-mcp` | `hunsy-asset-platform/apps/assets-mcp` image | `sites/az/hunsy-assets-mcp` + `charts/hunsy-assets-mcp` | `hunsy-assets-mcp` |
| `hunsy-hermes-runtime` | `hunsy-hermes-runtime` image | `sites/az/hunsy-hermes-runtime` + `charts/hunsy-hermes-runtime` | `hunsy-hermes-runtime` |
| `hunsy-hermes-developer-runtime` | `hunsy-hermes-runtime` image | `sites/az/hunsy-hermes-developer-runtime` + `charts/hunsy-hermes-runtime` | `hunsy-hermes-developer-runtime` |
| `cloudflared` | upstream image | `sites/az/cloudflared` + `charts/cloudflared` | `cloudflared` |
| `gateway-api` | local chart only | `sites/az/gateway-api` + `charts/gateway-api` | `gateway-system` |

## Agent operating notes

- Do not search the public web to rediscover these private repositories; use this file and Git remotes.
- Do not ask the user for repository URLs that are already listed here.
- Secret/token values are never stored in this map.
- GitHub write access from the in-cluster Developer Agent is intentionally narrow: currently `hunsy-homelab` only through a repository-scoped deploy key.
- For app source changes outside `hunsy-homelab`, ask for an approved credential/permission path before attempting to push.

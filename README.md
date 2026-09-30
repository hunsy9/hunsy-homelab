# hunsy-homelab

Hunsy 홈랩 Kubernetes/GitOps 인프라 저장소다. MacBook에서 Ansible로 호스트/부트스트랩을 관리하고, 클러스터 내부 애플리케이션은 Argo CD apps-of-apps와 Git-managed Helm chart로 관리한다.

## Current cluster

| Node alias | Kubernetes node | IP | Role |
|---|---|---:|---|
| `controller` | `k8s-control-01` | `192.168.0.150` | kubeadm learning control plane, later RKE2 server |
| `az` | `k8s-worker-01` | `192.168.0.24` | kubeadm learning worker, main workload node |

## Repository map

Developer agents should read [`docs/repository-map.md`](docs/repository-map.md) before asking where app repositories live.

| Area | Repository | Notes |
|---|---|---|
| Infrastructure / GitOps | <https://github.com/hunsy9/hunsy-homelab> | This repo. Ansible, kubeadm learning cluster, Argo CD apps-of-apps, Helm charts, site values. |
| Asset platform apps | <https://github.com/hunsy9/hunsy-asset-platform> | API/dashboard, Google Sheets integration, Toss read-only integration, snapshot job, assets MCP, bot handoff MCP image source. |
| Hermes runtime image | <https://github.com/hunsy9/hunsy-hermes-runtime> | Container wrapper for Hermes gateway/API runtime and developer-agent tooling. |

Legacy note: `hunsy-discord-agent` was removed from GitOps after moving to Hermes native Discord gateway. Keep it as archive/reference only.

## Current `hunsy-*` applications

These are the home-lab-owned `hunsy-*` Argo CD applications currently represented in GitOps.

| Argo CD app | Purpose | Runtime namespace | Source/image | GitOps location | Exposure / consumers |
|---|---|---|---|---|---|
| `hunsy-asset-platform` | Main asset platform API/dashboard. Reads Google Sheets, Toss read-only credentials, provides asset summary and daily snapshot CronJob. | `hunsy-asset-platform` | `ghcr.io/hunsy9/hunsy-asset-platform/api-server` | `charts/hunsy-asset-platform` + `sites/az/hunsy-asset-platform` | `asset.seung.site`, internal service `hunsy-asset-platform-api` |
| `hunsy-assets-mcp` | MCP server exposing asset-platform data/tools to Hermes agents. | `hunsy-assets-mcp` | `ghcr.io/hunsy9/hunsy-asset-platform/assets-mcp` | `charts/hunsy-assets-mcp` + `sites/az/hunsy-assets-mcp` | Consumed by 자사니 and Hermes runtimes at `http://hunsy-assets-mcp.hunsy-assets-mcp.svc.cluster.local:8080/mcp` |
| `hunsy-bot-handoff-mcp` | Narrow MCP server for bot-to-bot handoff. Creates approved template-based Discord handoff threads/messages in `#봇-문의채널`. | `hunsy-hermes-jasani` | `ghcr.io/hunsy9/hunsy-asset-platform/bot-handoff-mcp` | `charts/hunsy-bot-handoff-mcp` + `sites/az/hunsy-bot-handoff-mcp` | Consumed by 자사니 at `http://hunsy-bot-handoff-mcp.hunsy-hermes-jasani.svc.cluster.local:8080/mcp` |
| `hunsy-hermes-developer-runtime` | Developer Agent / 개바리. Native Hermes Discord gateway for platform development, GitOps checks, scoped Kubernetes/Argo read/patch, GitHub work. | `hunsy-hermes-developer-runtime` | `ghcr.io/hunsy9/hunsy-hermes-runtime` | `charts/hunsy-hermes-runtime` + `sites/az/hunsy-hermes-developer-runtime` | Discord `#플랫폼개발` and `#봇-문의채널`; ClusterIP API server on `8642` |
| `hunsy-hermes-jasani` | Asset assistant / 자사니. Native Hermes Discord gateway for casual asset consultation with asset MCP and approved handoff to 개바리. | `hunsy-hermes-jasani` | `ghcr.io/hunsy9/hunsy-hermes-runtime` | `charts/hunsy-hermes-runtime` + `sites/az/hunsy-hermes-jasani` | Discord `#자산관리`; consumes `asset` and `handoff` MCP servers; ClusterIP API server on `8642` |
| `hunsy-hermes-runtime` | Baseline/internal Hermes runtime instance connected to asset MCP. Kept ClusterIP-only. | `hunsy-hermes-runtime` | `ghcr.io/hunsy9/hunsy-hermes-runtime` | `charts/hunsy-hermes-runtime` + `sites/az/hunsy-hermes-runtime` | Internal ClusterIP API server on `8642` |
| `hunsy-ops-dashboard` | Lightweight ops dashboard web UI. | `hunsy-hermes-runtime` | `ghcr.io/hunsy9/hunsy-ops-dashboard` | `charts/hunsy-ops-dashboard` + `sites/az/hunsy-ops-dashboard` | `ops.seung.site` via Gateway API / Cloudflare Tunnel |

## Non-`hunsy-*` platform apps

The wider cluster also includes non-`hunsy-*` infrastructure apps such as Argo CD, Gateway API/Envoy Gateway, cloudflared, local-path-provisioner, metrics-server, kube-prometheus-stack, Alertmanager Discord adapter, monitoring rules, and whoami smoke app. Keep those documented near their own chart/site directories; this README focuses on `hunsy-*` owned applications.

## GitOps layout

```text
charts/<app>/                         # user-owned Helm chart
sites/<site>/<app>/application.yaml    # Argo CD Application
sites/<site>/<app>/values.yaml         # site-specific values
sites/root-app.yaml                    # apps-of-apps root Application
```

Rules:

- New owned Kubernetes resources go under `charts/<app>/`.
- Site-specific deployment wiring goes under `sites/<site>/<app>/`.
- Official upstream charts are referenced directly from the Argo CD `Application` and only values live in `sites/`.
- Secrets are referenced by name/key only. Secret values are not committed.

## Ansible

Install Ansible on the MacBook:

```bash
brew install ansible
```

Verify node access:

```bash
ansible all -m ping
ansible-playbook playbooks/00-verify.yml
```

Prepare Rocky Linux hosts for Kubernetes experiments:

```bash
ansible-playbook playbooks/10-prepare-rocky.yml --check --diff
ansible-playbook playbooks/10-prepare-rocky.yml
```

## Boundaries

- Ansible owns host OS preparation and kubeadm/RKE2 bootstrap.
- Kubernetes applications are owned by Argo CD apps-of-apps and Git-managed Helm charts, not by ad-hoc `kubectl apply`.
- Hermes runtimes are ClusterIP-only unless explicitly exposed through protected routes.
- 자사니 has no Kubernetes/GitHub/Secret powers; it talks to asset/handoff MCP only.
- 개바리 has scoped developer/runtime access, not node/root/Secret access.
- Secrets should not be committed in plaintext.

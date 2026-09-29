# hunsy-homelab

Code-managed homelab infrastructure and GitOps control plane for Hunsy's personal platform.

Current cluster:

- `controller` / `k8s-control-01` / `192.168.0.150`: kubeadm learning control plane, later RKE2 server
- `az` / `k8s-worker-01` / `192.168.0.24`: kubeadm learning worker, later RKE2 agent and main workload node

## Repository map

Developer agents should read [`docs/repository-map.md`](docs/repository-map.md) before asking where app repositories live.

Primary repos:

| Area | Repository |
|---|---|
| Infrastructure / GitOps | <https://github.com/hunsy9/hunsy-homelab> |
| Asset platform API / dashboard / MCP / snapshot jobs | <https://github.com/hunsy9/hunsy-asset-platform> |
| Hermes runtime image | <https://github.com/hunsy9/hunsy-hermes-runtime> |
| Legacy custom Discord proxy bot | <https://github.com/hunsy9/hunsy-discord-agent> |

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
- Secrets should not be committed in plaintext.

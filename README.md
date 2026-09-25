# hunsy-homelab

Code-managed homelab infrastructure.

Current plan:

- `controller` / `k8s-control-01` / `192.168.0.150`: kubeadm learning control plane, later RKE2 server
- `az` / `k8s-worker-01` / `192.168.0.24`: kubeadm learning worker, later RKE2 agent and main workload node

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
- Kubernetes applications should later be owned by Flux, not by ad-hoc `kubectl apply`.
- Secrets should not be committed in plaintext.

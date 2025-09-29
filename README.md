# kOps + ArgoCD Prototype (All values filled)

> Region: **ap-south-1**, Domain: **demo-kops.local** (for real DNS use your Route53 zone!), Cluster: **dev.k8s.demo-kops.local**

## Quickstart

### 1) Terraform foundations
```bash
cd infra-live/dev
make init && make apply && make outputs
```

### 2) kOps tool install & cluster create
```bash
cd ../../cluster-ops
ansible-playbook playbooks/install-tools.yml
ansible-playbook playbooks/cluster-create.yml
```

> Update your kubeconfig as directed by `kops` and ensure `kubectl get nodes` returns Ready nodes.

### 3) Add-ons (Ingress + Monitoring)
```bash
ansible-playbook playbooks/addons-bootstrap.yml
```

### 4) GitOps (ArgoCD)
```bash
cd ../gitops
helm repo add argo https://argoproj.github.io/argo-helm && helm repo update
helm upgrade --install argocd argo/argo-cd -n argocd --create-namespace -f argocd/values.yaml
kubectl apply -f envs/dev/project.yaml
kubectl apply -f envs/dev/root-app.yaml
```

### 5) Verify
```bash
kubectl -n retail get deploy,svc,ingress
kubectl -n observability get pods
```

## Notes
- This prototype uses NGINX containers for the retail services so it runs anywhere.
- Change `base_domain` in `infra-live/dev/terraform.tfvars` to your public Route53 zone for real ingress hostnames and TLS.
# test-modules

# ArgoCD in e2e-monitor cluster

## ArgoCD Installation

```shell
helm install argocd argo/argo-cd -n argocd --create-namespace
```

The following is the installed configuration of ArgoCD

| Chart Name | Namespace | Public Cloud | Region | Project |
|---|---|---|---|---|
| argocd | argocd | GCP | europe-west2 | elastic-cloud-dev |

## Connecting to ArgoCD web interface

Port forward to ArgoCD service

```shell
kubectl port-forward service/argocd-server 8080:80 -n argocd
```

Retrieve the admin password

```shell
kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data | map_values(@base64d)'
```

Then open web browser to http://localhost:8080, and login with user: `admin`.

## Application Deployment

There's a single helm chart that manages all of the ArgoCD Applications/Projects/etc, and installing/updating this chart will allow ArgoCD to update all of the associated sub-components.

### Installing e2e-cluster-applications helm chart

#### Ensure Argo repository is setup

```shell
helm repo add argo https://argoproj.github.io/argo-helm
```

#### Install Helm chart

```shell
cd charts/argocd/e2e-cluster-applications
helm install argocd argo/argo-cd -n argocd --create-namespace
```

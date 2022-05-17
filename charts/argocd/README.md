# ArgoCD in e2e-monitor cluster

[ArgoCD](https://argo-cd.readthedocs.io/en/stable/) is used to declaratively define the components we use within our E2E-Monitor cluster, and ensure any updates are pushed out to the Kubernetes cluster in a GitOps style.

## ArgoCD Installation

ArgoCD is already installed and functional within the cluster, but for historical purposes, this is the process that was followed.

```shell
helm repo add argo https://argoproj.github.io/argo-helm
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

## Using the Argo CLI

Install the ArgoCLI using the [documentation](https://argo-cd.readthedocs.io/en/stable/cli_installation/).

Login

```
# ensure you port-forward first
argocd login localhost:8080
```

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

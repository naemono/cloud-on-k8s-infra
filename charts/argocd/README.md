# ArgoCD in e2e-monitor cluster

[ArgoCD](https://argo-cd.readthedocs.io/en/stable/) is used to declaratively define the components we use within our E2E-Monitor cluster, and ensure any updates are pushed out to the Kubernetes cluster in a GitOps style.

## ArgoCD Installation

ArgoCD is already installed and functional within the cluster, but for historical purposes, this is the process that was followed to install, and to upgrade ArgoCD, and it's requirements.

*Note* The ArgoCD wrapper helm chart used here, including it's bootstrap mechanism, which adds the argocd-vault-plugin, was initially written by the k8s-region team, and is located [here](https://github.com/elastic/cloud/tree/master/go/k8s-region/deploy), so all credit goes to them.

```shell
cd charts/argocd
make argocd-deploy
```

The following is the installed configuration of ArgoCD

| Chart Name | Namespace | Public Cloud | Region | Project |
|---|---|---|---|---|
| argo-cd | argocd | GCP | europe-west2 | elastic-cloud-dev |

## Connecting to ArgoCD web interface

Port forward to ArgoCD service

```shell
make argocd-ui
Argo-CD is available at: https://localhost:8090
Credentials: admin / password
```

## Using the Argo CLI

Install the ArgoCLI using the [documentation](https://argo-cd.readthedocs.io/en/stable/cli_installation/).

Login

```
# ensure you port-forward, or run `make argocd-ui` first
argocd login localhost:8090
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
helm upgrade --install e2e-monitor-applications -n argocd .
```

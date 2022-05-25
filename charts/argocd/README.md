# ArgoCD in e2e-monitor cluster

[ArgoCD](https://argo-cd.readthedocs.io/en/stable/) is used to declaratively define the components we use within our E2E-Monitor cluster, and ensure any updates are pushed out to the Kubernetes cluster in a GitOps style.

## ArgoCD Installation

ArgoCD is already installed and functional within the cluster, but for historical purposes, this is the process that was followed to install, and to upgrade ArgoCD, and it's requirements.

```shell
cd charts/argocd
make argocd-deploy
```

The following is the installed configuration of ArgoCD

| Chart Name | Namespace | Public Cloud | Region |
|---|---|---|---|
| argo-cd | argocd | GCP | europe-west2 |

## Connecting to ArgoCD web interface

Port forward to ArgoCD service

```shell
# password is stored in secret
kubectl get secret -n argocd argocd-initial-admin-secret -o go-template='{{.data.password | base64decode}}
make argocd-ui
Argo-CD is available at: https://localhost:8090
Credentials: admin / <above-password-stored-in-secret>
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

#### Install Helm chart

```shell
cd charts/argocd/e2e-cluster-applications
helm upgrade --install e2e-monitor-applications -n argocd .
```

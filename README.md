# cloud-on-k8s-infra

This repository holds the managed infrastructure for the Elastic/cloud-on-k8s team.

## Outstanding questions

1. Do we want this [Helm Chart](./charts/e2e-cluster-applications/) to be something that is published to the [Elastic Helm Dev Repository](https://helm-dev.elastic.co/helm/) instead of just managed within a git repository?  If so, we'll probably want to leverage something like [Helm Chart Releaser Github Action](https://github.com/marketplace/actions/helm-chart-releaser), to release this automatically upon any version changes on merge to master/main.
2. What credentials do we want to use to authenticate against https://github.com/elastic/cloud-on-k8s-infra?  I'm currently using a personal temporary SSH Key, and a personal github token, that will be deleted upon merge and migration to a valid user.  *note* Mario Duarte is opening an issue with infra team to start this discussion, as k8s-region team has this same issue.

## ArgoCD Installation and Basic Connectivity

See [ArgoCD Readme](./charts/argocd/README.md)

## Installed Application within E2E Monitor Cluster

A Single helm chart manages all underlying Argo Applications within the cluster

```
helm ls -n argocd -f e2e-monitor-applications
NAME                    	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART                         	APP VERSION
e2e-monitor-applications	argocd   	8       	2022-05-18 14:15:09.500721 -0500 CDT	deployed	e2e-cluster-applications-0.1.9
```

### List of components that Helm Chart Manages

* Helm Repositories
  * Elastic (https://helm.elastic.co)
  * Nginx (https://helm.nginx.com/stable)
  * Cert-Manager (https://charts.jetstack.io)
* Helm Charts
  * ECK Operator (https://github.com/elastic/cloud-on-k8s#elastic-cloud-on-kubernetes-eck)
  * Nginx Ingress Controller (https://github.com/nginxinc/kubernetes-ingress#nginx-ingress-controller)
  * Cert-Manager (https://github.com/cert-manager/cert-manager)
* ArgoCD Applications/Projects
  * Project named e2e-monitor
  * e2e-monitor git repository controlled by values file: `https://{{ .Values.spec.source.repo.provider }}/{{ .Values.spec.source.repo.organization }}/{{ .Values.spec.source.repo.repository }}/applications/e2e-monitor`
* ArgoCD Git Repository Credentials
  * Git SSH key for authenticating against VCS.  Must be provided via values file, see [Template](./charts/e2e-cluster-applications/templates/07-source-repository-ssh-key.yaml).
    * NOTE: This must be transitioned from personal fork (https://github.com/naemono/cloud-on-k8s-infra), and personal credentials after merge.

*Note* the installed values will need to be updated after merge
```
helm get values -n argocd e2e-monitor-applications
USER-SUPPLIED VALUES:
spec:
  source:
    repo:
      organization: naemono
      provider: github.com
      repository: cloud-on-k8s-infra
    sshKey: |
      -----BEGIN OPENSSH PRIVATE KEY-----
```

*Note* The following vault secret `secret/ci/elastic-cloud/eck/argocd/vault-creds` will need to be updated with new credentials after outstanding question #2 is answered.

## Examples of updating components

### Updating version of ECK Operator

To update the version of the ECK Operator that is used within the E2E-Monitor cluster:

1. Checkout git repository

```
git clone https://github.com/elastic/cloud-on-k8s-infra
```

2. Change directory to helm chart

```
cd charts/e2e-cluster-applications
```

3. Run a `helm upgrade` setting the new version using the helm values.

```
helm upgrade e2e-monitor-applications -n argocd . --set version.eckOperator=2.2.1
```

4. Update default value in [values file](./charts/e2e-cluster-applications/values.yaml), and bump chart `version` in [Chart.yaml](./charts/e2e-cluster-applications/Chart.yaml)

5. Create pull request for new default version.

### Updating e2e-monitor Ingress Object

1. Makes changes to [Ingress Yaml File](./applications/e2e-monitor/e2e-ingress.yaml)

2. Create pull request with changes.

3. After merging of changes to master/main, the changes will be automatically synced to the `e2e-monitor` Kubernetes cluster.

### Updating the Helm Chart

It's likely that changes will need to be made to the overlying [Helm Chart](./charts/e2e-cluster-applications/) in the future, and when that happens, the release process is as follows

1. Make necessary changes to Helm Chart

2. Ensure you have bumped the `version` in [Chart.yaml](./charts/e2e-cluster-applications/Chart.yaml)

3. Create pull request for changes.

4. Once changes are merged, run a `helm upgrade`

```
cd charts/e2e-cluster-applications
helm upgrade e2e-monitor-applications -n argocd .
```
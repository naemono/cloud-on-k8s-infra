# E2E-Monitor ArgoCD Application

All files in this directory are managed by an [ArgoCD Application](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#applications) in [source control](../../charts/e2e-cluster-applications/templates/02-e2e-monitor-application.yaml). Any updates to files in this directory, which are merged to the git `targetRevision/branch` defined in [Helm values file](../../charts/e2e-cluster-applications/values.yaml) will be automatically synced to the `e2e-monitor` Kubernetes cluster.

## Note about ArgoCD 'Sync Waves'

All managed resources in this directory have been assigned an ArgoCD [Sync Wave](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/). This allows certain resources, such as helm repositories and custom resources, to be installed before attempting to install the objects that depend on these resources to already be successfully installed. Every resource defined here should have an annotation defined on the *parent* resource (the application definition in the parent helm chart) such as the following example:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "2"
```

### Existing sync waves

* Sync wave 0
  * Sync wave 0 is the default sync wave for argocd resources if no wave is defined.
  * Helm repositories are installed in this sync wave.
  * Any resources which have no requirements (ex: secrets) are also installed at this stage.
* Sync wave 1
  * Helm applications are installed during this sync wave, which install their custom resources for other applications to use.
* Sync wave 2
  * All other resources are installed during this sync wave.
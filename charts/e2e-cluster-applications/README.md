# Cluster Bootstrapping Helm Chart

## Description

This helm chart is intended to be the initial helm chart installed within a cluster after the ArgoCD installation has succeeded on the cluster that will be managing this target cluster (These cluster can, and likely will be one in the same)

### Currently Installed/Managed Applications

* ArgoCD Project named 'e2e-monitor'
* ArgoCD Git Repository Secret
* ArgoCD Git Repository credentials
* Argocd Application pointing to git:org/repo/applications/e2e-monitor, which contains
    * ECK Operator
    * ECK objects  (ES/Kibana/APMServer CRDs) in default namespace
    * Nginx Ingress
    * gcs-credentials secret pulled from vault
    * CertManager
    * Let's Encrypt Issuer for CertManager, with account information pulled from vault
    * Elasticsearch snapshot repo, and policy configmaps, which aren't automatically applied.

# Cluster Bootstrapping Helm Chart

## Description

This helm chart is intended to be the initial helm chart installed within a cluster after the ArgoCD installation has succeeded on the cluster that will be managing this target cluster (These cluster can, and likely will be one in the same)

### Currently Installed/Managed Applications

* ECK Operator

### TODO Applications

* CertManager
* Let's Encrypt Issuer for CertManager
* ECK objects  (ES/Kibana/APMServer CRDs) in default NS
* Elasticsearch snapshot repo, and policy?
* Ingress of some sort?

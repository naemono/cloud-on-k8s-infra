##@ Deployment

# This should only need to be run on the initial argocd installation or upgrade
# or when vault credentials that argocd should use change, as it bootstraps
# the credentials for argocd, and runs a 'helm upgrade argocd'.
.PHONY: argocd-deploy
argocd-deploy: ## Deploys Argo-CD into current context
	VALUES_FILE=e2e-monitor-values.yaml ./argocd.sh deploy

##@ Argocd

argocd-ui:
	@echo "Argo-CD is available at: https://localhost:8090"
	@echo "Credentials: admin / `kubectl get secret -n argocd argocd-initial-admin-secret --template={{.data.password}} | base64 -d`"
	kubectl port-forward -n argocd svc/argo-cd-argocd-server 8090:443

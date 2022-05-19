# ROOT_DIR is the absolute path of this Makefile
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

##@ Deployment

.PHONY: argocd-deploy
argocd-deploy: ## Deploys Argo-CD into current context
	VALUES_FILE=${ROOT_DIR}/e2e-monitor-values.yaml ./argocd.sh deploy

##@ Argocd

argocd-ui:
	@echo "Argo-CD is available at: https://localhost:8090"
	@echo "Credentials: admin / `kubectl get secret -n argocd argocd-initial-admin-secret --template={{.data.password}} | base64 -d`"
	kubectl port-forward -n argocd svc/argo-cd-argocd-server 8090:443

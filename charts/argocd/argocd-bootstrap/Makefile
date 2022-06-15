VAULT_TOKEN ?= $(shell cat ~/.vault-token)
VAULT_ADDR ?= https://localhost:8200

argocd-vault-plugin:
ifeq (, $(shell which argocd-vault-plugin))
        $(error "the argocd-vault-plugin plugin is required to deploy, download binary from https://github.com/argoproj-labs/argocd-vault-plugin/releases"")
endif

generate-argocd-credentials: argocd-vault-plugin
	@AVP_KV_VERSION=1 AVP_TYPE=vault \
		AVP_AUTH_TYPE=token \
		VAULT_ADDR=${VAULT_ADDR} \
		VAULT_TOKEN=${VAULT_TOKEN} \
		argocd-vault-plugin generate . | sed s#VAULT_ADDR_TO_BE_REPLACED#${VAULT_ADDR}#g

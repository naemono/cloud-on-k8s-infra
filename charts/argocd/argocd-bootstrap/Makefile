VAULT_TOKEN ?= $(shell cat ~/.vault-token)
VAULT_ADDR ?= "https://secrets.elastic.co:8200"

generate:
	@AVP_KV_VERSION=1 AVP_TYPE=vault \
		AVP_AUTH_TYPE=token \
		VAULT_ADDR=${VAULT_ADDR} \
		VAULT_TOKEN=${VAULT_TOKEN} \
		argocd-vault-plugin generate .

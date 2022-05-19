# ELASTICSEARCH CONFIDENTIAL
# __________________
#
#  Copyright Elasticsearch B.V. All rights reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of Elasticsearch B.V. and its suppliers, if any.
# The intellectual and technical concepts contained herein
# are proprietary to Elasticsearch B.V. and its suppliers and
# may be covered by U.S. and Foreign Patents, patents in
# process, and are protected by trade secret or copyright
# law.  Dissemination of this information or reproduction of
# this material is strictly forbidden unless prior written
# permission is obtained from Elasticsearch B.V.

VAULT_TOKEN ?= $(shell cat ~/.vault-token)
VAULT_ADDR ?= "https://secrets.elastic.co:8200"

generate:
	@AVP_KV_VERSION=1 AVP_TYPE=vault \
		AVP_AUTH_TYPE=token \
		VAULT_ADDR=${VAULT_ADDR} \
		VAULT_TOKEN=${VAULT_TOKEN} \
		argocd-vault-plugin generate .

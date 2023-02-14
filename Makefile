
CNPG_VERSION ?= 1.18
CNPG_VERSION_MINOR ?= 1

update-cnpg-operator:
	curl -L https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-$(CNPG_VERSION)/releases/cnpg-$(CNPG_VERSION).$(CNPG_VERSION_MINOR).yaml > cnpg-operator.yaml

run-apply:
	kubectl apply -k .

apply: run-apply

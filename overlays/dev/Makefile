
SECRET_PATH ?= secret/rubin/usdf-butler/postgres

get-secrets-from-vault:
	mkdir -p etc/.secrets/
	set -e; for i in username password; do vault kv get --field=$$i $(SECRET_PATH) > etc/.secrets/$$i ; done

clean-secrets:
	rm -rf etc/.secrets/

run-apply:
	kubectl apply -k .

dump:
	kubectl kustomize .

apply: get-secrets-from-vault run-apply clean-secrets



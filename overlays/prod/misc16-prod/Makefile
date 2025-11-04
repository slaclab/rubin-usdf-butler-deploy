
SECRET_PATH ?= secret/rubin/usdf-butler/postgres-misc16
S3_SECRET_PATH ?= secret/rubin/usdf-butler/s3-misc16

get-secrets-from-vault:
	mkdir -p etc/.secrets/
	set -e; for i in username password; do vault kv get --field=$$i $(SECRET_PATH) > etc/.secrets/$$i ; done
	set -e; for i in client-id client-secret; do vault kv get --field=$$i $(S3_SECRET_PATH) > etc/.secrets/$$i ; done

clean-secrets:
	rm -rf etc/.secrets/

run-apply:
	kubectl apply -k .

run-kustomize:
	kubectl kustomize .

dump: get-secrets-from-vault run-kustomize clean-secrets


apply: get-secrets-from-vault run-apply clean-secrets

vault kv put secret/rubin/usdf-butler-misc/misc-prod/misc-db/s3 \
client-id=ZST8BCAMHXTT5SMHQPQA \
client-secret=5eFBgjyHRfFiMq3ICgI2rnAuslKlTjmQtfl5NEuL \
   secret-key=5eFBgjyHRfFiMq3ICgI2rnAuslKlTjmQtfl5NEuL \
url=https://s3dfrgw.slac.stanford.edu/rubin-usdf-butler-misc16

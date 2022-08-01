
CNPG_VERSION ?= 1.16
SECRET_PATH ?= secret/rubin/usdf-butler/postgres


update-zalando:
	cd zalando
	git pull

apply-zalando-operator:
	kubectl apply -k  zalando-operator/

apply-zalando-db:
	#kubectl create ns postgres || true
	#kubectl apply -f huge-pages-fix.yaml -f zalando-postgres.yaml
	kubectl apply -k .

apply-zalando: apply-zalando-operator apply-zalando-db
	 
#apply: apply-zalando
#	kubectl apply -f service.yaml

pgbouncer:
	docker build . -f Dockerfile.pgbouncer -t slaclab/pgbouncer:master-22
	docker push slaclab/pgbouncer:master-22





cnpg-operator:
	curl -L https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-$(CNPG_VERSION)/releases/cnpg-$(CNPG_VERSION).0.yaml > cnpg-operator.yaml
	kubectl apply -f cnpg-operator.yaml


get-secrets-from-vault:
	mkdir -p etc/.secrets/
	set -e; for i in username password; do vault kv get --field=$$i $(SECRET_PATH) > etc/.secrets/$$i ; done

clean-secrets:
	rm -f etc/.secrets/

apply:
	kubectl apply -k .


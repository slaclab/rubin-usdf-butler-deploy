export NS=$1
export CLUSTER=$2
export DB=$3
envsubst '${DB}' <alter-db.sql.tmpl >alter-db.sql
cat alter-db.sql | kubectl cnpg psql $CLUSTER -n $NS 

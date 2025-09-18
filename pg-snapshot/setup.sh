#!/usr/bin/env bash

export NS=$1
export DB=$2

export PGPASSWORD=$(openssl rand -hex 16)
envsubst '$PGPASSWORD' <create_monitor_user.sql.tmpl >create_monitor_user.sql
envsubst '$NS $DB $PGPASSWORD' <snap-activity.yaml.tmpl >snap-activity.yaml
cat create_monitor_user.sql | kubectl cnpg psql $DB -n $NS 
cat create_stats_table.sql | kubectl cnpg psql $DB -n $NS 
kubectl apply -f snap-activity.yaml

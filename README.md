
This repo holds the Rubin USDF Butler Postgres infrastructure kubernetes manifests.

We use the [cloudnative-pg operator](https://cloudnative-pg.io/) in order to support a managed postgres service on our own infrastructure.

We need different kustomize overlays to present the postgres environments. For lack of imagination, we currently have a `prod` and `dev` environment.

# Configuration Changes

To perform a configuration change or postgres image perform the following.

* Update the `cnpg-butler-database.yaml` manifest in the dev or prod overlay
* Log into the appropriate kubernetes cluster
    * [Dev](https://k8s.slac.stanford.edu/usdf-butler-dev)
    * [Prod](https://k8s.slac.stanford.edu/usdf-butler)
* Check cluster status with `kubectl cnpg status usdf-butler -n prod` replacing -n with the namespace.  Check for status of healthy and 2 instances
```
Status:             Cluster in healthy state 
Instances:          2
Ready instances:    2
```

* Change directory the appropriate environemnt.  Replacing environment below with dev or prod.  Set your environment variable for vault, login into vault if not currently logged in, and apply the configuration with make.
```
export VAULT_ADDR=https://vault.slac.stanford.edu
cd overlays/$ENVIRONMENT
make apply
```
* Check cluster status with `kubectl cnpg status usdf-butler -n prod` replacing -n with the namespace. 

The vault login command is `vault login -method=ldap username=$USER` replacing with your ldap username.


# Deployment

As we are reliant on kubernetes for the infrastructure, we assume that you already have a suitable KUBECONFIG configured.

Deployment comes in two parts:

## Deploy the CNPG Operator

The cnpg operator will install into `cnpg-system` namespace.

```
CNPG_VERSION=1.16 CNPG_VERSION_MINOR=0 make update-cnpg-operator
make apply-cnpg-operator
```

In the above, we define through environment variables the version of the operator we wish to install/update. This will literally fetch the manifest and dump the contents into `cnpg-operator.yaml`. `make apply-cnpg-operator` will then use kustomize to apply that manifest onto kubernets to install the operator.

Note that in order to hep revision control our operator deployment, we also commit/push changes for the `cnpg-operator.yaml`.

## Deploy the appropriate overlay

```
cd overlays/$ENVIRONMENT
make apply
```

## Common Tasks

requires installation of the cnpg [kubectl plugin](https://cloudnative-pg.io/documentation/1.17/cnpg-plugin/#cloudnativepg-plugin)

### Get status of cluster

```
kubectl cnpg status usdf-butler
```

### Promote a replica to primary

```
kubectl cnpg promote usdf-butler
```

## Pg Sphere Extension

For a database that needs pgsphere enabled.
Connect to database with `\c lsstdb1`.  From database `CREATE EXTENSION pg_sphere;`

## Monitoring

We utilise the built in prometheus monitoring of cnpg and have a [live dashboard](https://grafana.slac.stanford.edu/d/z7FCA4Nnk/cloud-native-postgresql).

[Link to on how to calculate work mem](https://www.enterprisedb.com/postgres-tutorials/how-tune-postgresql-memory)

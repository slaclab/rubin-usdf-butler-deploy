# Playbook for USDF Butler


## Table of Contents

* [Backup and Restore](#backup-and-restore)
* [WAL Archiving](#wal-archiving)

## Backup and Restore

CloudNativePG supports online/hot backup of Postgres through continous backpu and WAL archiving.  Backups is based on the Barman tool.  Full info [here](https://cloudnative-pg.io/documentation/1.18/backup_recovery)  Backups are configured on each Postgres cluster to back up to an S3 bucket in Ceph.  WAL logs are also archived to the same S3 bucket in Ceph.  An example of the configuration in prod is below.  Backups are retained for 15 days.  Please note that older backups are retained if a successful backup has not been performed in the last 15 days.

```
    backup:
      retentionPolicy: "15d"
        barmanObjectStore:
        destinationPath: s3://rubin-usdf-butler
        endpointURL: https://s3dfrgw.slac.stanford.edu
        s3Credentials:
            accessKeyId:
            name: s3-creds
            key: ACCESS_KEY_ID
            secretAccessKey:
            name: s3-creds
            key: ACCESS_SECRET_KEY
```

## Restoring from Backup

To restore from backup a new cluster needs to be provisioned.  Backups cannot be restored to the existing cluster.  To perform the restore use the following instructions.

Check the current backup status.  An example from the `prod2`` namespace below.  

```
    kubectl get backups -n prod2

    usdf-butler2-backup-1674765451   3d19h   usdf-butler2   completed   
    usdf-butler2-backup-1674777600   3d16h   usdf-butler2   completed   
    usdf-butler2-backup-1674864000   2d16h   usdf-butler2   completed   
    usdf-butler2-backup-1674950400   40h     usdf-butler2   completed   
    usdf-butler2-backup-1675036800   16h     usdf-butler2   completed
```

Add these the cnpg-database yaml.  Update `targetTime` value to the correct restore time.  Update the `barmanObjectStore` to the correct object store values

```
    bootstrap:
        recovery:
        source: usdf-butler
        recoveryTarget:
            targetTime: "2023-01-23 16:50:00.00000+00"

    externalClusters:
        - name: usdf-butler
        barmanObjectStore:
            destinationPath: s3://rubin-usdf-butler
            endpointURL: https://s3dfrgw.slac.stanford.edu
            s3Credentials:
            accessKeyId:
                name: s3-creds
                key: ACCESS_KEY_ID
            secretAccessKey:
                name: s3-creds
                key: ACCESS_SECRET_KEY
            wal:
              maxParallel: 8
```


## WAL Archiving


To check status of the WAL Archiving enter `kubectl cnpg status usdf-butler2 -n prod2` replacing the cluster names and the namespace.  Note that WAL archiving is Ok.  The first and last WAL archives are detailed below.

```
    kubectl cnpg status usdf-butler2 -n prod2

    Continuous Backup status
    First Point of Recoverability:  2023-01-26T22:09:48Z
    Working WAL archiving:          OK
    WALs waiting to be archived:    0
    Last Archived WAL:              000000170000027E00000058   @   2023-01-30T16:16:00.550447Z
    Last Failed WAL:                0000001700000278000000C0   @   2023-01-26T20:34:05.322281Z
```
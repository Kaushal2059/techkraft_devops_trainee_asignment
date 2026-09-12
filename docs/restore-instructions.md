# Database Restore Instructions

## Restore procedure

1. Extract the compressed backup archive while replacing yyyymmdd to the backup date eg: 20260912:
```bash
   tar -xzf /var/backups/db/db_backup_YYYYMMDD.sql.tar.gz -C /var/backups/db
```

2. Restore into the running Postgres container:
```bash
   cat /var/backups/db/db_backup_YYYYMMDD.sql | docker exec -i techkraft_devops_trainee_asignment-db-1 psql -U appuser -d appdb
```
   `docker exec -i` keeps stdin open so the piped SQL file streams into `psql` running inside the container.

3. Verify the restore:
```bash
   docker exec -it techkraft_devops_trainee_asignment-db-1 psql -U appuser -d appdb -c "\dt"
```

## Verified

This procedure was tested end-to-end: created a table with data, took a backup, dropped the table (simulating data loss), restored from the backup archive, and confirmed the data returned intact.
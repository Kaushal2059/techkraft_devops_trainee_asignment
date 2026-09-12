#!/bin/bash

DB_CONTAINER="techkraft_devops_trainee_asignment-db-1"
DB_USER="appuser"
DB_NAME="appdb"
BACKUP_DIR="/var/backups/db"

# date +%Y%m%d = today's date as YYYYMMDD, used in the filename
DATE=$(date +%Y%m%d)
BACKUP_FILE="${BACKUP_DIR}/db_backup_${DATE}.sql"

docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"

# Compress the dump into .tar.gz
tar -czf "${BACKUP_FILE}.tar.gz" -C "$BACKUP_DIR" "$(basename "$BACKUP_FILE")"

# Remove the uncompressed .sql now that we have the .tar.gz version
rm "$BACKUP_FILE"

# Retention: delete backups older than 7 days
find "$BACKUP_DIR" -name "db_backup_*.sql.tar.gz" -mtime +7 -delete

echo "Backup completed: ${BACKUP_FILE}.tar.gz"

#!/bin/bash
set -euo pipefail

# Configuration
DB_NAME="myapp_production"
DB_USER="postgres"
BACKUP_DIR="/var/backups/postgres"
RETENTION_DAYS=7
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.sql.gz"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting backup of database: $DB_NAME"

# Dump the database and compress it
pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

echo "[$(date)] Backup written to: $BACKUP_FILE"

# Remove backups older than RETENTION_DAYS
echo "[$(date)] Removing backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "[$(date)] Backup complete. Current backups:"
ls -lh "$BACKUP_DIR"

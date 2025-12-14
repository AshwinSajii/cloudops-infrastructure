#!/bin/bash
set -e

BACKUP_DIR="$(pwd)/backups"
RETENTION_DAYS=7

echo "[INFO] Cleaning backups older than $RETENTION_DAYS days"

find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -print -delete

echo "[INFO] Cleanup completed"

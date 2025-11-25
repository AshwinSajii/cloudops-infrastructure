#!/bin/bash
set -e

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="backup_${DATE}.tar.gz"
BACKUP_DIR="$HOME/cloudops/backups"

echo "[INFO] Starting MinIO backup..."

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$HOME/cloudops/minio-data/uploads"

echo "[INFO] Uploading backup to MinIO..."
mc alias set local http://127.0.0.1:9000 minioadmin minioadmin
mc cp "$BACKUP_DIR/$BACKUP_FILE" local/backups/

echo "[SUCCESS] Backup completed: $BACKUP_FILE"

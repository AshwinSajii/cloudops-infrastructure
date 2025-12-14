#!/bin/bash
set -e

BACKUP_DIR="$(pwd)/backups"
DATE=$(date +%F_%H-%M)

mkdir -p "$BACKUP_DIR"

echo "[INFO] Starting backup at $DATE"

docker run --rm \
  -v minio-data:/data \
  -v "$BACKUP_DIR":/backup \
  alpine \
  tar czf /backup/minio_backup_$DATE.tar.gz /data

echo "[INFO] Backup created: minio_backup_$DATE.tar.gz"

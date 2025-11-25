#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: restore.sh <backup_filename>"
    exit 1
fi

BACKUP_NAME="$1"
BACKUP_DIR="$HOME/cloudops/backups"

echo "[INFO] Restoring backup: $BACKUP_NAME"

tar -xzf "$BACKUP_DIR/$BACKUP_NAME" -C "$HOME/cloudops/minio-data/"

echo "[SUCCESS] Restore completed!"

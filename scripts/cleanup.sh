#!/bin/bash
set -e

BACKUP_DIR="$HOME/cloudops/backups"

echo "[INFO] Deleting backups older than 30 days..."
find "$BACKUP_DIR" -type f -mtime +30 -delete
echo "[SUCCESS] Cleanup done."

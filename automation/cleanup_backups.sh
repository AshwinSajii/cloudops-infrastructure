#!/bin/bash

# ===== Cleanup Script: Delete MinIO Backups Older Than 30 Days =====

RETENTION_DAYS=30
BUCKET="local/backups"

echo "=== Starting retention cleanup: removing backups older than $RETENTION_DAYS days ==="

# Get current timestamp in seconds
NOW=$(date +%s)

# List all files in backups bucket
mc ls $BUCKET | while read -r line; do
    FILE_DATE=$(echo $line | awk '{print $1}')
    FILE_NAME=$(echo $line | awk '{print $5}')

    # Skip empty lines
    if [ -z "$FILE_NAME" ]; then
        continue
    fi

    # Convert file date to timestamp
    FILE_TIMESTAMP=$(date -d "$FILE_DATE" +%s)

    # Calculate age in days
    AGE_DAYS=$(( ($NOW - $FILE_TIMESTAMP) / 86400 ))

    # Check if older than retention
    if [ $AGE_DAYS -gt $RETENTION_DAYS ]; then
        echo "Deleting old backup ($AGE_DAYS days old): $FILE_NAME"
        mc rm $BUCKET/$FILE_NAME
    fi
done

echo "=== Retention cleanup completed ==="

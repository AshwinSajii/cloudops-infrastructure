#!/bin/bash

echo "=== RESTORE PROCESS STARTED ==="

# Ask for the backup file inside MinIO
echo "Available backup files:"
mc ls local/backups/

echo
read -p "Enter the backup filename to restore (e.g., backup_2025-01-01_02-00-00.tar.gz): " BACKUP_FILE

if [ -z "$BACKUP_FILE" ]; then
    echo "No file entered. Exiting."
    exit 1
fi

TEMP_DIR=~/cloudops/restore_temp
mkdir -p $TEMP_DIR

# Download from MinIO
echo "Downloading $BACKUP_FILE from MinIO..."
mc cp local/backups/$BACKUP_FILE $TEMP_DIR/

echo "Extracting..."
tar -xzf $TEMP_DIR/$BACKUP_FILE -C $TEMP_DIR/

RESTORE_DIR=$(find $TEMP_DIR -maxdepth 1 -type d -name "backups_temp_*")
if [ -z "$RESTORE_DIR" ]; then
    echo "Could not find restore folder."
    exit 1
fi

echo "Restoring web1 and web2..."
cp -r $RESTORE_DIR/web1 ~/cloudops/
cp -r $RESTORE_DIR/web2 ~/cloudops/

echo "Restoring nginx configs..."
sudo cp -r $RESTORE_DIR/nginx/* /etc/nginx/
sudo systemctl reload nginx

echo "Restoring Prometheus configs..."
cp -r $RESTORE_DIR/prometheus/* ~/cloudops/prometheus/
docker restart prometheus

echo "Restoring Grafana provisioning..."
docker cp $RESTORE_DIR/grafana_provisioning/ grafana:/etc/grafana/provisioning
docker restart grafana

echo "Restoring node_exporter..."
cp -r $RESTORE_DIR/node_exporter ~/cloudops/node_exporter

echo "Cleanup..."
rm -rf $TEMP_DIR

echo "=== RESTORE COMPLETED SUCCESSFULLY ==="

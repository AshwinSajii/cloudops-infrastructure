#!/bin/bash

# Timestamp
TODAY=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup directory
BACKUP_DIR=~/cloudops/backups_temp_$TODAY
mkdir -p $BACKUP_DIR

echo "=== Creating backup at $TODAY ==="

# 1. Backup Flask apps
cp -r ~/cloudops/web1 $BACKUP_DIR/
cp -r ~/cloudops/web2 $BACKUP_DIR/

# 2. Backup nginx configs
cp -r /etc/nginx $BACKUP_DIR/nginx/

# 3. Backup Prometheus config
cp -r ~/cloudops/prometheus $BACKUP_DIR/

# 4. Backup Grafana provisioning (optional)
# If using docker grafana:
docker cp grafana:/etc/grafana/provisioning $BACKUP_DIR/grafana_provisioning/

# 5. Backup node_exporter binary
cp -r ~/cloudops/node_exporter $BACKUP_DIR/

# 6. TAR the backup
tar -czf ~/cloudops/backup_$TODAY.tar.gz -C ~/cloudops $(basename $BACKUP_DIR)

# 7. Upload to MinIO backups bucket
mc cp ~/cloudops/backup_$TODAY.tar.gz local/backups/

# 8. Cleanup
rm -rf $BACKUP_DIR
echo "Backup completed and uploaded to MinIO: backup_$TODAY.tar.gz"

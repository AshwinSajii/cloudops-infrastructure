import boto3
import os
import tarfile
import datetime
from notify import send_discord
from config import (
    BACKUP_DIR, MINIO_BUCKET,
    MINIO_ENDPOINT, MINIO_ACCESS_KEY, MINIO_SECRET_KEY
)

timestamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")

# Create S3/MinIO client
s3 = boto3.client(
    "s3",
    endpoint_url=MINIO_ENDPOINT,
    aws_access_key_id=MINIO_ACCESS_KEY,
    aws_secret_access_key=MINIO_SECRET_KEY,
    region_name="us-east-1"
)

def create_tar(path, output):
    with tarfile.open(output, "w:gz") as tar:
        tar.add(path, arcname=os.path.basename(path))

try:
    # ----- CREATE BACKUPS -----
    app_backup = f"{BACKUP_DIR}/app-backup-{timestamp}.tar.gz"
    uploads_backup = f"{BACKUP_DIR}/uploads-backup-{timestamp}.tar.gz"

    create_tar("/home/ashwin/cloudops/web1", app_backup)
    create_tar("/home/ashwin/cloudops/minio-data/uploads", uploads_backup)

    # ----- UPLOAD TO MINIO -----
    s3.upload_file(app_backup, MINIO_BUCKET, f"app/{os.path.basename(app_backup)}")
    s3.upload_file(uploads_backup, MINIO_BUCKET, f"uploads/{os.path.basename(uploads_backup)}")

    # ----- SUCCESS ALERT -----
    send_discord(
        f"✅ **Backup Completed & Uploaded to MinIO**\n\n"
        f"• App backup → `minio/backups/app/{os.path.basename(app_backup)}`\n"
        f"• Uploads backup → `minio/backups/uploads/{os.path.basename(uploads_backup)}`\n"
        f"• Timestamp: **{timestamp}**"
    )

    print("Backup completed and uploaded to MinIO.")

except Exception as e:

    # ----- FAILURE ALERT -----
    send_discord(
        f"❌ **Backup FAILED!**\n\nError:\n```{str(e)}```"
    )
    raise

import os
import time
import boto3
from notify import send_discord
from config import (
    BACKUP_DIR, MINIO_BUCKET,
    MINIO_ENDPOINT, MINIO_ACCESS_KEY, MINIO_SECRET_KEY
)

# Retention in seconds (30 days)
RETENTION = 30 * 24 * 60 * 60

now = time.time()

# Local cleanup
def cleanup_local():
    removed_files = []
    for f in os.listdir(BACKUP_DIR):
        path = os.path.join(BACKUP_DIR, f)
        if os.path.isfile(path):
            if now - os.path.getmtime(path) > RETENTION:
                os.remove(path)
                removed_files.append(f)
    return removed_files

# MinIO cleanup
def cleanup_minio():
    s3 = boto3.client(
        "s3",
        endpoint_url=MINIO_ENDPOINT,
        aws_access_key_id=MINIO_ACCESS_KEY,
        aws_secret_access_key=MINIO_SECRET_KEY,
    )

    removed = []
    resp = s3.list_objects_v2(Bucket=MINIO_BUCKET)

    if "Contents" not in resp:
        return removed

    for obj in resp["Contents"]:
        age = now - obj["LastModified"].timestamp()
        if age > RETENTION:
            s3.delete_object(Bucket=MINIO_BUCKET, Key=obj["Key"])
            removed.append(obj["Key"])

    return removed

try:
    deleted_local = cleanup_local()
    deleted_minio = cleanup_minio()

    send_discord(
        "🧹 **Backup Cleanup Completed (30 Days Retention)**\n\n"
        f"🗑 Removed local: `{len(deleted_local)}` files\n"
        f"🗑 Removed MinIO: `{len(deleted_minio)}` objects\n"
    )

except Exception as e:
    send_discord(
        f"❌ Cleanup FAILED:\n```{str(e)}```"
    )
    raise

#!/bin/bash

set -e

echo "🚧 Stopping old MinIO container..."
docker stop minio 2>/dev/null || true
docker rm minio 2>/dev/null || true

echo "🔍 Searching for any MINIO anonymous volumes..."
VOLUME=$(docker volume ls --format "{{.Name}}" | grep -v cloudops_minio-data | grep -i "minio" || true)

if [ -n "$VOLUME" ]; then
    echo "⚠️  Found old volume: $VOLUME"
    echo "🧹 Removing old MinIO anonymous volume..."
    docker volume rm "$VOLUME" || true
else
    echo "✔ No old MinIO volumes found."
fi

echo "📁 Ensuring bind-mount folder exists..."
mkdir -p ./minio-data

echo "📥 Copying old uploads + backups into new folder..."
sudo cp -r /var/lib/docker/volumes/cloudops_minio-data/_data/. ./minio-data/ 2>/dev/null || true

echo "🚀 Recreating MinIO with docker-compose..."
docker compose up -d minio

echo ""
echo "========================================"
echo "✅ FIX COMPLETE"
echo "MinIO is now correctly using: $(pwd)/minio-data"
echo "You can confirm with:"
echo "   docker exec -it minio ls -R /data"
echo "========================================"

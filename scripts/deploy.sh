#!/bin/bash

echo "[INFO] Stopping services..."
sudo systemctl stop web1 web2 nginx node_exporter prometheus

echo "[INFO] Pulling latest code..."
git pull

echo "[INFO] Reloading systemd..."
sudo systemctl daemon-reload

echo "[INFO] Starting services..."
sudo systemctl start web1 web2 nginx node_exporter prometheus

echo "[SUCCESS] Deployment completed!"

#!/bin/bash
echo "Checking system services..."

systemctl is-active --quiet nginx || echo "Nginx DOWN"
systemctl is-active --quiet web1 || echo "Web1 DOWN"
systemctl is-active --quiet web2 || echo "Web2 DOWN"
systemctl is-active --quiet node_exporter || echo "Node Exporter DOWN"

echo "Health check complete."

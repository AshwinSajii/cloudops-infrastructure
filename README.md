# 🌐 CloudOps Infrastructure

A full infrastructure stack including:

- **Flask Web Applications (Web1 & Web2)**
- **MinIO Object Storage**
- **Automated Backups to MinIO**
- **Automated Cleanup (30 days retention)**
- **Automated Restore Utility**
- **Nginx Load Balancer**
- **Prometheus + Node Exporter Monitoring**
- **Systemd Services & Timers**
- **Zero-downtime deployment**

This project is designed for reliable, fully automated infrastructure running locally or on a VM.

---

# 📁 Project Structure

```

cloudops/
├── automation/         # Backup, cleanup, restore, notifications
├── backups/            # Local fallback backups
├── lb/                 # Nginx load balancer config
├── logs/               # App + system logs
├── minio-data/         # MinIO storage (excluded from Git)
├── web1/               # Flask app 1
├── web2/               # Flask app 2
├── prometheus/         # Prometheus config
├── node_exporter/      # Node exporter binary folder
├── scripts/            # Deployment scripts (optional)
├── venv/               # Python virtual environment
└── README.md

````

---

# 🚀 Deployment Setup

## 1️⃣ Clone the repo

```bash
git clone https://github.com/<your-username>/cloudops . 
````

## 2️⃣ Create Python virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
pip install flask boto3
```

---

# 🌐 Web Apps (Web1 & Web2)

Two Flask apps:

* Web1 → `127.0.0.1:5001`
* Web2 → `127.0.0.1:5000`

Both apps upload images to **MinIO** and display a gallery.

Start manually:

```bash
python web1/app/app.py
python web2/app/app.py
```

Or via systemd:

```bash
sudo systemctl start web1
sudo systemctl start web2
```

---

# 💾 MinIO (Object Storage)

Start MinIO:

```bash
docker run -d \
  --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -v ~/cloudops/minio-data:/data \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin \
  quay.io/minio/minio server /data --console-address ":9001"
```

Create uploads bucket:

```bash
mc alias set local http://localhost:9000 minioadmin minioadmin
mc mb local/uploads
```

---

# 📦 Automated Backups

Backups run daily at **midnight** using systemd.

### Backup script:

`automation/backup.py`

Creates:

* **App code backup**
* **Uploads backup**
* **Uploads both to MinIO**
* Logs success/failure
* Optional Discord notifications

### Run backup manually:

```bash
/home/ashwin/cloudops/venv/bin/python3 automation/backup.py
```

---

# 🔁 Automated Cleanup

Cleans up:

* Local backups older than 30 days
* MinIO backups older than retention
* Deletes old logs

Script:

`automation/cleanup.py`

Timer: **00:30 AM daily**

---

# ♻️ Restore Utility

Quickly restore:

* App code
* Uploaded files
* Previous snapshots

Command:

```bash
python3 automation/restore.py <backup_filename>
```

---

# 📡 Prometheus Monitoring

### Start Prometheus

```bash
sudo systemctl start prometheus
```

Prometheus UI:
👉 [http://localhost:9090/](http://localhost:9090/)

### Prometheus config:

`prometheus/prometheus.yml`

Monitors:

* Web1
* Web2
* Node exporter
* Backup status (optional)

---

# 📊 Node Exporter

Collects server metrics.

Start:

```bash
sudo systemctl start node_exporter
```

Metrics at:

👉 [http://localhost:9100/metrics](http://localhost:9100/metrics)

---

# 🔀 Nginx Load Balancer

Nginx forwards:

* `/` → Web1 + Web2 (round-robin)
* Static files
* Health checks

Config:

`/etc/nginx/sites-available/cloudops`

Test config:

```bash
sudo nginx -t
sudo systemctl restart nginx
```

Load balancer:
👉 [http://localhost/](http://localhost/)

---

# 🧭 Systemd Services

| Service                  | Description       |
| ------------------------ | ----------------- |
| web1.service             | Flask Web App 1   |
| web2.service             | Flask Web App 2   |
| prometheus.service       | Prometheus server |
| node_exporter.service    | Node exporter     |
| cloudops-backup.service  | Backup job        |
| cloudops-cleanup.service | Cleanup job       |

Enable everything:

```bash
sudo systemctl enable --now web1 web2 prometheus node_exporter cloudops-backup.timer cloudops-cleanup.timer
```

---

# ⏱ Timers

List active timers:

```bash
systemctl list-timers | grep cloudops
```

---

# 🔒 .gitignore

This project excludes:

* MinIO data
* Binaries
* Secrets
* Backups
* Logs
* Systemd units
* Virtual environment

Ensures a clean repository.

---

# 🛠 Development Workflow

Modify code → commit → push.

To update systemd services:

```bash
sudo systemctl daemon-reload
sudo systemctl restart <service>
```

---

# 🆘 Troubleshooting

### Prometheus won’t start?

Delete the data dir:

```bash
sudo rm -rf /var/lib/prometheus/*
```

### Node exporter already running?

Find & kill:

```bash
sudo lsof -i :9100
sudo kill <PID>
```

### MinIO bucket missing?

Recreate:

```bash
mc mb local/uploads
```

---

# 🙌 Credits

Built by **Ashwin**
Automated and optimized with **CloudOps Infrastructure Framework

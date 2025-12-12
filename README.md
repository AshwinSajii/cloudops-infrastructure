--

# 🚀 CloudOpsComplete

A fully containerized mini-cloud platform featuring:

* **Two Flask applications (web1 & web2)**
* **NGINX load balancer**
* **MinIO S3 object storage** (for uploads & backups)
* **Automated backup service**
* **Prometheus + Node Exporter monitoring**
* **Grafana dashboards**
* **GitHub Actions CI pipeline**

---

# 📦 Project Structure

```
cloudopscomplete/
│
├── docker-compose.yml          # Full infrastructure stack
├── nginx.conf                  # Load balancer config
├── monitoring.yml              # Prometheus scrape config
│
├── web1/                       # First Flask instance
│   ├── Dockerfile
│   └── app/
│       ├── app.py
│       ├── templates/
│       └── static/
│
├── web2/                       # Second Flask instance
│   ├── Dockerfile
│   └── app/
│       ├── app.py
│       ├── templates/
│       └── static/
│
├── prometheus/
│   └── prometheus.yml
│
├── minio-data/                 # Local persistent MinIO storage
│   ├── uploads/
│   └── backups/
│
└── .github/workflows/ci.yml    # GitHub Actions CI for lint/build
```

---

# 🏗️ How It Works

### ▶️ **web1 & web2 Flask apps**

Both apps serve:

* `/upload` — upload files to MinIO
* `/gallery` — list all uploaded objects
* `/who` — identify server instance ("WEB1" / "WEB2")

---

### ▶️ **NGINX Load Balancer**

Handles round-robin traffic between web1 and web2:

```
http://localhost        → web1 / web2 (balanced)
http://localhost/who    → identifies backend instance
```

---

### ▶️ **MinIO S3 Storage**

Interface:

* Console: [http://localhost:9001](http://localhost:9001)
* API: [http://localhost:9000](http://localhost:9000)

Buckets created on startup:

* `uploads`
* `backups`

Uploads from the app appear in MinIO automatically.

---

### ▶️ **Prometheus Monitoring**

Prometheus scrapes:

* web1
* web2
* node_exporter
* docker metrics (optional)

Dashboard:
👉 [http://localhost:9090](http://localhost:9090)

---

### ▶️ **Grafana Dashboarding**

Grafana UI:
👉 [http://localhost:3000](http://localhost:3000)
Default login:

```
admin / admin
```

You can add Prometheus as a data source.

---

### ▶️ **Automated Backups (cron-style container)**

A lightweight Alpine container:

* Archives app data and uploads
* Pushes them to the `backups` bucket in MinIO
* Runs every 24 hours (changeable)

Backup results stored in:

```
minio-data/backups/
```

---

# 🚀 Running the Full Stack

From inside the project:

```bash
docker compose up -d --build
```

Stop the stack:

```bash
docker compose down
```

---

# 🧪 Testing the App

### Upload:

```
http://localhost/upload
```

### Gallery:

```
http://localhost/gallery
```

### Check load balancer:

```
curl http://localhost/who
```

Expected output:

```
Hello from WEB1   or   Hello from WEB2
```

---

# 🛠️ Development Commands

### Rebuild only web1

```bash
docker compose build web1 --no-cache
docker compose up -d web1
```

### Check MinIO data on host

```bash
ls -R minio-data/
```

### Check container logs

```bash
docker logs web1
docker logs web2
docker logs nginx-lb
```

---

# 🔄 GitHub CI Pipeline

The GitHub Actions workflow runs:

* Syntax validation
* Dockerfile sanity checks
* (Optional) Docker build test
* Ensures repo stays clean and buildable

Workflow location:

```
.github/workflows/ci.yml
```

You don't push images to Docker Hub — CI only validates code.

---

# 📚 Environment Variables

Flask apps rely on:

| Variable      | Description        |
| ------------- | ------------------ |
| S3_ENDPOINT   | MinIO endpoint URL |
| S3_BUCKET     | uploads            |
| S3_ACCESS_KEY | minioadmin         |
| S3_SECRET_KEY | minioadmin         |

All are defined in `docker-compose.yml`.

---

# 🧹 Cleanup

To remove all containers:

```bash
docker compose down --remove-orphans
```

To wipe MinIO data completely:

```bash
rm -rf minio-data/*
```

---

# ❤️ Credits

Built as a learning project for:

* Docker Orchestration
* Load Balancing
* S3 Object Storage
* Monitoring & Observability
* DevOps CI/CD using GitHub Actions

# 🌩️ CloudOps Infrastructure Platform  
**A Production-Style Cloud Operations Project | Load Balancing • Reverse Proxies • Monitoring • Automation • Backups • Linux Services**

![Architecture](docs/cloudops-architecture.png)

---

## 📘 Table of Contents
- [Overview](#overview)
- [Core Architecture](#core-architecture)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Architecture Diagram](#architecture-diagram)
- [Service Breakdown](#service-breakdown)
- [Automation](#automation)
- [Security Enhancements](#security-enhancements)
- [Deployment Guide](#deployment-guide)
- [Repository Structure](#repository-structure)
- [What This Project Demonstrates](#what-this-project-demonstrates)
- [Future Enhancements](#future-enhancements)

---

# 🚀 Overview

This project is a **fully functional Cloud Operations Infrastructure**, built to simulate a real-world production environment.  
It includes:

- A load balancer  
- Reverse proxies  
- Multiple backend services  
- Monitoring & observability  
- Automated backups to MinIO  
- Alerting  
- Secure environment management  
- Linux systemd orchestration  
- S3 object storage  
- Infrastructure documentation  

This repository is intentionally designed to demonstrate **Cloud, DevOps, SysAdmin, and SRE skills**.

---

# 🧱 Core Architecture

| Layer | Component | Description |
|-------|-----------|-------------|
| **Load Balancing** | NGINX (8080) | Distributes traffic between web1 and web2 |
| **Reverse Proxies** | NGINX (8081,8082) | Forward traffic to Flask apps |
| **Application Layer** | Flask apps (5001, 5002) | systemd-managed Python backend services |
| **Object Storage** | MinIO (9000/9001) | S3-compatible storage for uploads & backups |
| **Monitoring** | Prometheus (9090), Node Exporter (9100) | Full metrics collection & dashboards |
| **Automation** | Cron + Bash | Backup, restore, cleanup, alerts |

---

# 🛠️ Tech Stack

### **Infrastructure & Services**
- Ubuntu Linux  
- systemd services  
- NGINX load balancer + reverse proxy  
- Python Flask apps  
- MinIO S3 object storage (Docker)

### **Monitoring**
- Prometheus  
- Node Exporter  
- Grafana Integration Ready  

### **Automation**
- Cron jobs  
- Bash scripting  
- Discord webhook alerts  

---

# 🖼 Architecture Diagram (Textual)

```mermaid
flowchart TD
    LB[NGINX Load Balancer<br>Port 8080]
    RP1[NGINX Reverse Proxy - Web1<br>8081]
    RP2[NGINX Reverse Proxy - Web2<br>8082]
    APP1[Flask Web1 App<br>5001]
    APP2[Flask Web2 App<br>5002]
    MINIO[(MinIO S3 Storage<br>9000/9001)]
    PROM[Prometheus<br>9090]
    NODE[Node Exporter<br>9100]

    LB --> RP1 --> APP1
    LB --> RP2 --> APP2
    APP1 --> MINIO
    APP2 --> MINIO
    NODE --> PROM
````

---

# 🧩 Service Breakdown

### **1️⃣ NGINX Load Balancer**

* Routes traffic from `localhost:8080` → web1 & web2
* Round-robin distribution
* Resilience for testing service failover

---

### **2️⃣ Reverse Proxies (web1 & web2)**

Each proxy:

* Accepts on 8081/8082
* Forwards to Flask apps
* Restricts allowed HTTP methods
* Isolates the application layer from direct traffic

---

### **3️⃣ Flask Application Services**

Each app:

* Runs under its own `systemd` service
* Exposes:

  * `/info`
  * `/upload`
  * `/status`
* Logs to `~/cloudops/logs/`

---

### **4️⃣ MinIO S3 Storage**

* Stores **uploads** + **backups**
* Managed using Docker
* Access via:

  * UI → `localhost:9001`
  * API → `localhost:9000`

Buckets created:

* `uploads`
* `backups`

---

### **5️⃣ Monitoring Stack**

#### Node Exporter

* Runs on port 9100
* Collects Linux metrics

#### Prometheus

* Scrapes:

  * Node Exporter
  * Flask app endpoints
* UI available at `localhost:9090`

---

# 🤖 Automation

### **Backup Script**

* Tar + gzip full web app directory
* Store in `/backups` and MinIO
* Logs all runs
* Creates Discord alert on failure

### **Cleanup Script**

* Removes old backups > 30 days

### **Restore Script**

* Pull backup from MinIO
* Extract and fully restore app directory

### **Cron schedules**

| Task              | Schedule       |
| ----------------- | -------------- |
| Automated backup  | Every 12 hours |
| Cleanup           | Daily          |
| Prometheus scrape | 15s interval   |

---

# 🔐 Security Enhancements

* systemd EnvironmentFile for secrets
* Restricted file permissions (`700`)
* NGINX method filtering
* TLS-ready structure
* Removal of plaintext passwords
* Discord alerts instead of email (secure)

---

# 🚀 Deployment Guide

### Clone:

```bash
git clone https://github.com/AshwinSajii/cloudops-infrastructure.git
cd cloudops-infrastructure
```

### Start services:

```bash
sudo systemctl start web1 web2 nginx prometheus node_exporter
```

### View logs:

```bash
journalctl -u web1 -f
journalctl -u web2 -f
```

### Verify LB:

Visit → **[http://localhost:8080](http://localhost:8080)**

---

# 📂 Repository Structure

```
cloudops/
│── automation/
│   ├── backup.sh
│   ├── restore.sh
│   └── cleanup.sh
│
│── web1/
│── web2/
│── lb/
│── minio-data/
│── prometheus/
│── node_exporter/
│── logs/
│── docs/
│   └── cloudops-architecture.png
│
└── README.md
```

---

# 🏆 What This Project Demonstrates

### **Cloud & DevOps Skills**

* Systemd orchestration
* Linux service lifecycle
* Reverse proxying & LB engineering
* Observability pipeline
* S3 storage architecture
* Disaster recovery workflows

### **SRE Skills**

* Monitoring
* Alerting
* Automation
* Backup/restore design
* Failure simulation & resilience

---

# 🚧 Future Enhancements

* Add CI/CD pipeline
* Add Kubernetes version
* Add Terraform IaC provisioning
* Deploy publicly on a cloud provider
* Add HTTPS with Certbot

---

# 👨‍💻 Author

**Ashwin Saji**
Cloud | DevOps | SRE Enthusiast


If you want a **project video guide**, **resume bullet points**, or **LinkedIn post**, just tell me!
```

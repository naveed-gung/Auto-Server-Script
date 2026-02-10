<div align="center">

<img src="logo.svg" alt="Elite Auto Server Setup Logo" width="150" height="150">

<!-- Hero Section with Animated SVG Background Concept -->
<picture>
<source media="(prefers-color-scheme: dark)" srcset="assets/hero-dark.png">
<source media="(prefers-color-scheme: light)" srcset="assets/hero-light.png">
<img src="assets/image.png" alt="Elite Auto Server Setup" width="100%">
</picture>

# Elite Auto Server Setup

### Zero-Touch Production Server Provisioning for MERN Stack

<div align="center">

**Created by [naveed-gung](https://github.com/naveed-gung) | Portfolio: [naveed-gung.dev](https://naveed-gung.dev)**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-5.0+-4EAA25.svg?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-FCC624.svg?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-00C853.svg?style=for-the-badge)](https://github.com/naveed-gung/elite-server-setup)

**Created by [naveed-gung](https://github.com/naveed-gung)** • Star • Issues • Discussions

</div>

---

<!-- Technology Stack Showcase -->
<table>
<tr>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=nodejs" width="48" height="48" alt="Node.js"/>
<br><b>Node.js</b>
<br><sub>20.x LTS</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=mongodb" width="48" height="48" alt="MongoDB"/>
<br><b>MongoDB</b>
<br><sub>7.0+</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=nginx" width="48" height="48" alt="Nginx"/>
<br><b>Nginx</b>
<br><sub>Latest</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=docker" width="48" height="48" alt="Docker"/>
<br><b>Docker</b>
<br><sub>Optional</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=linux" width="48" height="48" alt="Linux"/>
<br><b>Linux</b>
<br><sub>Multi-OS</sub>
</td>
</tr>
</table>

</div>

---

## Table of Contents

<details open>
<summary><b>Click to expand/collapse</b></summary>

- [Overview](#-overview)
- [Features](#-features)
- [Quick Start](#-quick-start)
- [Configuration](#-configuration)
- [Post-Installation](#-post-installation-deploy-your-mern-application)
- [Maintenance](#-maintenance--operations)
- [Testing](#-testing--validation)
- [Troubleshooting](#-troubleshooting)
- [Architecture](#-project-architecture)
- [Security](#-security)
- [Contributing](#-contributing)
- [License](#-license)
- [Credits](#-credits--acknowledgments)

</details>

---

## Overview

> **Elite Auto Server Setup** is an enterprise-grade automation tool that provisions complete MERN infrastructure with zero human intervention. Deploy production-ready servers in minutes, not hours.

<div align="center">

```mermaid
graph LR
A[Fresh Server] -->|One Command| B[Elite Setup]
B --> C[Production Ready]

style A fill:#ff6b6b,stroke:#c92a2a,stroke-width:2px,color:#fff
style B fill:#4dabf7,stroke:#1971c2,stroke-width:3px,color:#fff
style C fill:#51cf66,stroke:#2f9e44,stroke-width:2px,color:#fff
```

| Component | Version | Purpose |
| -------------------------------------------------------------------------- | -------- | ----------------------------------- |
| <img src="https://skillicons.dev/icons?i=nodejs" width="16"/> **Node.js** | 20.x LTS | JavaScript runtime (via NodeSource) |
| <img src="https://skillicons.dev/icons?i=mongodb" width="16"/> **MongoDB** | 7.0+ | NoSQL database (Community Edition) |
| <img src="https://skillicons.dev/icons?i=nginx" width="16"/> **Nginx** | Latest | Reverse proxy + SSL termination |
| **PM2** | Latest | Process manager with clustering |
| <img src="https://skillicons.dev/icons?i=docker" width="16"/> **Docker** | Latest | Container runtime (optional) |
| **Certbot** | Latest | Let's Encrypt SSL automation |

</div>

### What This Tool Does

<table>
<tr>
<td width="50%" valign="top">

#### **Server Infrastructure**

```bash
 Node.js 20.x LTS + npm/npx
 MongoDB 7.0+ (authenticated)
 Nginx (reverse proxy + SSL)
 PM2 (process manager)
 Docker + Compose (optional)
 Certbot (Let's Encrypt SSL)
```

</td>
<td width="50%" valign="top">

#### **Security Hardening**

```bash
 UFW Firewall configuration
 Fail2ban brute-force protection
 SSH hardening (key-only auth)
 Automatic security updates
 MongoDB authentication
 Nginx security headers
```

</td>
</tr>
</table>

### What You Deploy After

<div align="center">

| Frontend | Backend | Database | DevOps |
|:--------:|:-------:|:--------:|:------:|
| <img src="https://skillicons.dev/icons?i=react,vue,angular" width="80"/> | <img src="https://skillicons.dev/icons?i=express,nodejs" width="60"/> | <img src="https://skillicons.dev/icons?i=mongodb" width="40"/> | <img src="https://skillicons.dev/icons?i=nginx,docker" width="60"/> |
| Your React/Vue app | Your Express API | Connected DB | Configured proxy |

</div>

---

## Features

<details open>
<summary><b> Intelligent Automation</b></summary>

<br>

<table>
<tr>
<td width="50"></td>
<td><b>Pre-flight System Checks</b><br>Validates OS compatibility, disk space, ports, and services before installation</td>
</tr>
<tr>
<td width="50"></td>
<td><b>Interactive CLI Wizard</b><br>Beautiful color-coded interface with real-time progress tracking</td>
</tr>
<tr>
<td width="50"></td>
<td><b>Non-Interactive Mode</b><br>JSON configuration support for CI/CD pipelines and automation</td>
</tr>
<tr>
<td width="50"></td>
<td><b>Idempotent Operations</b><br>Safe to run multiple times without conflicts or duplicates</td>
</tr>
<tr>
<td width="50"></td>
<td><b>Automatic Rollback</b><br>Reverts changes on failure with detailed logging and recovery</td>
</tr>
</table>

</details>

<details>
<summary><b> Technology Stack</b></summary>

<br>

<div align="center">

| Component | Version | Purpose | Status |
|:---------:|:-------:|:--------|:------:|
| <img src="https://skillicons.dev/icons?i=nodejs" width="20"/> **Node.js** | 20.x LTS | JavaScript runtime via NodeSource | |
| <img src="https://skillicons.dev/icons?i=mongodb" width="20"/> **MongoDB** | 7.0+ | NoSQL database (Community Edition) | |
| <img src="https://skillicons.dev/icons?i=nginx" width="20"/> **Nginx** | Latest | Reverse proxy + SSL termination | |
| **PM2** | Latest | Process manager with clustering | |
| <img src="https://skillicons.dev/icons?i=docker" width="20"/> **Docker** | Latest | Container runtime (optional) | |
| **Certbot** | Latest | Let's Encrypt SSL automation | |

</div>

</details>

<details>
<summary><b> Security Hardening</b></summary>

<br>

```mermaid
graph TD
A[ Security Layers] --> B[ UFW Firewall]
A --> C[ Fail2ban]
A --> D[ SSH Hardening]
A --> E[ Auto Updates]
A --> F[ MongoDB Auth]
A --> G[ Nginx Headers]

B --> H[ Production Ready]
C --> H
D --> H
E --> H
F --> H
G --> H

style A fill:#339af0,stroke:#1971c2,stroke-width:3px,color:#fff
style H fill:#51cf66,stroke:#2f9e44,stroke-width:3px,color:#fff
```

<table>
<tr>
<td>

- **UFW Firewall** - Strict rules (22, 80, 443, 27017)
- **Fail2ban** - Brute-force protection
- **SSH Hardening** - Key-only authentication
- **Auto Updates** - Unattended security patches

</td>
<td>

- **MongoDB Auth** - Required authentication
- **Nginx Headers** - X-Frame-Options, CSP, HSTS
- **System Limits** - Optimized file descriptors
- **Audit Logging** - Complete installation tracking

</td>
</tr>
</table>

</details>

<details>
<summary><b> Enterprise Features</b></summary>

<br>

<div align="center">

```ascii
┌─────────────────────────────────────────────────────────────┐
│ DEPLOYMENT REPORTS │ NOTIFICATIONS │
│ ├─ HTML dashboard │ ├─ Slack integration │
│ ├─ Text summaries │ ├─ Discord webhooks │
│ └─ System information │ └─ Email alerts │
├─────────────────────────────────────────────────────────────┤
│ CONFIGURATION │ BACKUP & ROLLBACK │
│ ├─ Pre-defined profiles │ ├─ Snapshot creation │
│ ├─ Custom JSON configs │ ├─ One-click restoration │
│ └─ Multi-environment │ └─ Version control │
└─────────────────────────────────────────────────────────────┘
```

</div>

</details>

---

## Quick Start

### Prerequisites

<div align="center">

| Requirement | Specification |
|:-----------:|:-------------|
| **OS** | <img src="https://skillicons.dev/icons?i=ubuntu" width="16"/> Ubuntu 20.04/22.04 LTS<br><img src="https://skillicons.dev/icons?i=debian" width="16"/> Debian 11/12<br><img src="https://skillicons.dev/icons?i=linux" width="16"/> CentOS 8+ / RHEL 8+ |
| **Access** | Root or sudo privileges |
| **Network** | Internet connection for downloads |
| **Resources** | Min 10GB disk, 1GB RAM |

</div>

### Installation Methods

<table>
<tr>
<td width="33%" align="center">

#### Method 1
**Interactive Mode**
<br><sub>Recommended for first-time users</sub>

```bash
git clone https://github.com/\
naveed-gung/elite-server-setup.git

cd elite-server-setup
sudo ./setup.sh
```

</td>
<td width="33%" align="center">

#### Method 2
**Quick Production**
<br><sub>Fast deployment with SSL</sub>

```bash
sudo ./setup.sh \
--profile=production \
--domain=api.yourdomain.com \
--ssl-email=admin@example.com
```

</td>
<td width="33%" align="center">

#### Method 3
**CI/CD Pipeline**
<br><sub>Automated deployment</sub>

```bash
sudo ./setup.sh \
--config=config/production.json \
--silent
```

</td>
</tr>
</table>

<div align="center">

### Installation Demo

```mermaid
sequenceDiagram
participant U as User
participant S as Setup Script
participant SYS as System

U->>S: Run ./setup.sh
S->>SYS: Pre-flight checks 
S->>SYS: Install Node.js 
S->>SYS: Install MongoDB 
S->>SYS: Install Nginx 
S->>SYS: Apply Security 
S->>U: Setup Complete!
```

</div>

---

## Configuration

<div align="center">

### Command-Line Options

</div>

<details open>
<summary><b>Core Options</b></summary>

```bash
Usage: ./setup.sh [OPTIONS]

Core Options:
--profile=PROFILE Use predefined profile (development|staging|production)
--config=FILE Load configuration from JSON file
--mode=MODE Installation mode (interactive|silent|unattended)
--silent Suppress all prompts (requires --config)

Component Selection:
--with-nodejs Install Node.js (default: enabled)
--with-mongodb Install MongoDB (default: enabled)
--with-nginx Install Nginx (default: enabled)
--with-pm2 Install PM2 (default: enabled)
--with-docker Install Docker (default: disabled)
--skip-security Skip security hardening (not recommended)

Network Configuration:
--domain=DOMAIN Domain name for SSL configuration
--ssl-email=EMAIL Email for Let's Encrypt certificates
--enable-ssl Enable SSL/TLS with Let's Encrypt

Version Selection:
--node-version=VERSION Node.js version (18|20|22, default: 20)
--mongodb-version=VERSION MongoDB version (6.0|7.0, default: 7.0)

Security Options:
--enable-firewall Configure UFW firewall (default: production only)
--enable-fail2ban Install Fail2ban protection (default: production only)
--harden-ssh Harden SSH configuration (default: production only)

Notifications:
--slack-webhook=URL Slack webhook for notifications
--discord-webhook=URL Discord webhook for notifications
--email=ADDRESS Email address for notifications

Advanced Options:
--mongodb-auth Enable MongoDB authentication (default: production only)
--mongodb-user=USERNAME MongoDB admin username (default: admin)
--mongodb-pass=PASSWORD MongoDB admin password (auto-generated if not set)
--backup-dir=PATH Backup directory (default: /var/backups/elite-setup)
--log-level=LEVEL Logging level (debug|info|warning|error)

Utility Options:
--dry-run Show what would be installed without making changes
--force Force installation even if services exist
--cleanup Remove installation artifacts after completion
-h, --help Show this help message
-v, --version Show version information
```

</details>

<details>
<summary><b>Component Selection</b></summary>

```bash
--with-nodejs # Install Node.js (default: enabled)
--with-mongodb # Install MongoDB (default: enabled)
--with-nginx # Install Nginx (default: enabled)
--with-pm2 # Install PM2 (default: enabled)
--with-docker # Install Docker (default: disabled)
--skip-security # Skip security hardening (not recommended)
```

</details>

<details>
<summary><b>Network Configuration</b></summary>

```bash
--domain=DOMAIN # Domain name for SSL configuration
--ssl-email=EMAIL # Email for Let's Encrypt certificates
--enable-ssl # Enable SSL/TLS with Let's Encrypt
```

</details>

<details>
<summary><b>Version Selection</b></summary>

```bash
--node-version=VERSION # 18|20|22 (default: 20)
--mongodb-version=VERSION # 6.0|7.0 (default: 7.0)
```

</details>

<details>
<summary><b>Security Options</b></summary>

```bash
--enable-firewall # Configure UFW firewall
--enable-fail2ban # Install Fail2ban protection
--harden-ssh # Harden SSH configuration
```

</details>

<details>
<summary><b>Notifications</b></summary>

```bash
--slack-webhook=URL # Slack webhook for notifications
--discord-webhook=URL # Discord webhook for notifications
--email=ADDRESS # Email address for notifications
```

</details>

### Configuration Profiles

<table>
<tr>
<td width="33%" valign="top">

#### Development

```bash
sudo ./setup.sh \
--profile=development
```

**Includes:**

- Node.js 20 + npm
- MongoDB without authentication
- Nginx without SSL
- PM2 in single-instance mode
- Minimal security (for local testing)

<sub>Perfect for local testing</sub>

</td>
<td width="33%" valign="top">

#### Production

```bash
sudo ./setup.sh \
--profile=production \
--domain=yourapp.com \
--ssl-email=admin@yourapp.com
```

**Includes:**

- Node.js 20 + npm
- MongoDB with authentication enabled
- Nginx with Let's Encrypt SSL
- PM2 in cluster mode
- Full security hardening
- Automatic updates enabled
- Notifications enabled

<sub>Production-ready setup</sub>

</td>
<td width="33%" valign="top">

#### Custom JSON

```bash
sudo ./setup.sh \
--config=config/custom.json
```

**Includes:**
- Custom versions
- Selective components
- Advanced options
- Fine-tuned security

<sub>Maximum flexibility</sub>

</td>
</tr>
</table>

<details>
<summary><b> Example: Custom JSON Configuration</b></summary>

```json
{
"profile": "production",
"nodejs": {
"enabled": true,
"version": "20"
},
"mongodb": {
"enabled": true,
"version": "7.0",
"auth": true,
"username": "admin",
"port": 27017
},
"nginx": {
"enabled": true,
"ssl": true,
"domain": "api.example.com",
"ssl_email": "admin@example.com"
},
"pm2": {
"enabled": true,
"instances": "max"
},
"docker": {
"enabled": false
},
"security": {
"firewall": true,
"fail2ban": true,
"ssh_hardening": true,
"auto_updates": true
},
"notifications": {
"slack_webhook": "https://hooks.slack.com/services/YOUR/WEBHOOK"
}
}
```

</details>

---

## Post-Installation: Deploy Your MERN Application

<div align="center">

```mermaid
graph LR
A[ Installation<br/>Complete] --> B[ Upload<br/>Code]
B --> C[ Install<br/>Dependencies]
C --> D[ Configure<br/>Environment]
D --> E[ Start with<br/>PM2]
E --> F[ Setup<br/>Nginx]
F --> G[ Live!]

style A fill:#51cf66,stroke:#2f9e44,stroke-width:2px,color:#fff
style G fill:#4dabf7,stroke:#1971c2,stroke-width:2px,color:#fff
```

</div>

### Step-by-Step Deployment Guide

<table>
<tr>
<td width="50%" valign="top">

#### 1. Verify Installation

```bash
# Run health check
sudo ./scripts/health-check.sh

# Check services
systemctl status nginx mongodb pm2

# View report
cat /var/log/elite-setup/report.html
```

#### 2. Upload Your Code

```bash
# Via Git (recommended)
cd /var/www
git clone https://github.com/user/app.git

# Via SCP
scp -r my-app/ user@server:/var/www/
```

#### 3. Install Dependencies

```bash
cd /var/www/your-app
npm install --production
npm run build # If using frontend
```

</td>
<td width="50%" valign="top">

#### 4. Configure Environment

```bash
# Create .env file
cat > .env << EOF
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://admin:pass@\
localhost:27017/myapp?authSource=admin
EOF

# Get MongoDB credentials
cat /root/.mongodb_credentials
```

#### 5. Start with PM2

```bash
# Start application
pm2 start server.js --name my-app -i max

# Save configuration
pm2 save
pm2 startup
```

#### 6. Configure Nginx

```bash
# Create site configuration
sudo nano /etc/nginx/sites-available/app
```

</td>
</tr>
</table>

<details>
<summary><b> Example Nginx Configuration</b></summary>

```nginx
server {
server_name yourdomain.com www.yourdomain.com;

# Proxy to Node.js app
location / {
proxy_pass http://localhost:3000;
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection 'upgrade';
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_cache_bypass $http_upgrade;
}

listen 443 ssl;
ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
include /etc/letsencrypt/options-ssl-nginx.conf;
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

server {
if ($host = www.yourdomain.com) {
return 301 https://$host$request_uri;
}
if ($host = yourdomain.com) {
return 301 https://$host$request_uri;
}
listen 80;
server_name yourdomain.com www.yourdomain.com;
return 404;
}
```

**Enable and reload:**

```bash
sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

</details>

<details>
<summary><b> MongoDB Connection Setup</b></summary>

```bash
# Get credentials
cat /root/.mongodb_credentials

# Connect to MongoDB
mongosh "mongodb://admin:YOUR_PASSWORD@localhost:27017/?authSource=admin"

# Create application database
use myapp
db.createUser({
user: "myappuser",
pwd: "secure_password",
roles: [{ role: "readWrite", db: "myapp" }]
})
```

**Update connection string in your app:**

```javascript
// In your Node.js app
const MONGODB_URI = "mongodb://myappuser:secure_password@localhost:27017/myapp?authSource=myapp";
```

</details>

---

## Maintenance & Operations

<div align="center">

### Daily Operations Dashboard

| Task | Command | Frequency |
|:----:|:--------|:---------:|
| | **Health Check** | Daily |
| | **View Logs** | As needed |
| | **Restart Services** | As needed |
| | **Backup Data** | Weekly |
| | **SSL Renewal** | Auto (90 days) |

</div>

<details open>
<summary><b> Health Monitoring</b></summary>

```bash
# Comprehensive health check
sudo ./scripts/health-check.sh

# Quick status check
systemctl status nginx mongodb pm2

# Resource monitoring
htop
pm2 monit
```

</details>

<details>
<summary><b> Log Management</b></summary>

<table>
<tr>
<td width="50%">

**Elite Setup Logs**
```bash
tail -f /var/log/elite-setup/setup.log
```

**Nginx Logs**
```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

</td>
<td width="50%">

**MongoDB Logs**
```bash
tail -f /var/log/mongodb/mongod.log
```

**PM2 Logs**
```bash
pm2 logs
pm2 logs app-name
```

</td>
</tr>
</table>

</details>

<details>
<summary><b> Backup & Restore</b></summary>

**Create Backup:**

```bash
# Backup MongoDB
mongodump --uri="mongodb://admin:password@localhost:27017" \
--out=/backup/mongo-$(date +%Y%m%d)

# Backup configurations
sudo tar -czf /backup/configs-$(date +%Y%m%d).tar.gz \
/etc/nginx \
/etc/mongod.conf \
/etc/systemd/system/pm2-*.service
```

**Rollback Installation:**

```bash
# Revert to pre-installation state
sudo ./scripts/rollback.sh
```

</details>

<details>
<summary><b> SSL Certificate Management</b></summary>

```bash
# Certificates auto-renew via certbot
# Check renewal status
sudo certbot renew --dry-run

# Force renewal
sudo certbot renew --force-renewal

# Reload Nginx after renewal
sudo systemctl reload nginx
```

</details>

---

## Testing & Validation

<div align="center">

### Comprehensive Validation Suite

</div>

```bash
# Run quick validation (no installation required)
./quick-test.sh

# Verbose output with detailed analysis
./quick-test.sh --verbose
```

**Test Coverage:**

- File structure validation (20+ tests)
- Bash syntax checking
- JSON configuration validation
- Security analysis (credentials, unsafe commands)
- Code quality metrics (LOC, functions, modularity)
- Documentation quality assessment
- Integration & compatibility tests
- Compliance & standards verification

<details>
<summary><b>Test Coverage Matrix</b></summary>

<div align="center">

| Category | Tests | Status |
|:---------|:-----:|:------:|
| File Structure | 20+ | |
| Syntax Checking | 15+ | |
| JSON Validation | 10+ | |
| Security Analysis | 25+ | |
| Code Quality | 12+ | |
| Documentation | 8+ | |
| Integration | 10+ | |
| Compliance | 5+ | |

</div>

</details>

<details>
<summary><b> Example Test Output</b></summary>

```
╔═══════════════════════════════════════════════════╗
║ ELITE AUTO SETUP - VALIDATION SUITE ║
║ Enterprise-Grade Testing Framework ║
║ Created by: naveed-gung ║
╚═══════════════════════════════════════════════════╝

Platform: Linux
Directory: /opt/elite-server-setup

═══════════════════════════════════════════════
1. FILE STRUCTURE VALIDATION
═══════════════════════════════════════════════

[] Main script: setup.sh
[] Documentation: README.md
[] License file: LICENSE
[] Library: lib/colors.sh (298 lines)
[] Library: lib/logger.sh (377 lines)

═══════════════════════════════════════════════
TEST SUMMARY
═══════════════════════════════════════════════

Total Tests: 85
 Passed: 82
 Failed: 0
 Warnings: 3

Success Rate: 96.5%
[██████████████████████████████████████████████░░░]

╔═══════════════════════════════════════════════╗
║ ALL TESTS PASSED! ║
║ Project is production-ready ║
╚═══════════════════════════════════════════════╝
```

</details>

---

## Troubleshooting

<div align="center">

### Common Issues & Solutions

</div>

<details>
<summary><b> MongoDB Connection Failed</b></summary>

```bash
# Check MongoDB status
sudo systemctl status mongodb

# Check logs
sudo tail -f /var/log/mongodb/mongod.log

# Verify authentication
mongosh --username admin --password --authenticationDatabase admin

# Restart MongoDB
sudo systemctl restart mongodb
```

**Common causes:**
- Wrong credentials
- Authentication database mismatch
- Port 27017 blocked
- MongoDB not started

</details>

<details>
<summary><b> Nginx Configuration Error</b></summary>

```bash
# Test configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log

# Reload configuration
sudo systemctl reload nginx
```

**Common causes:**
- Syntax errors in config
- Certificate path issues
- Port already in use
- Incorrect server_name

</details>

<details>
<summary><b> PM2 Process Crashes</b></summary>

```bash
# View PM2 logs
pm2 logs

# Check process status
pm2 list

# Restart app
pm2 restart app-name

# Monitor in real-time
pm2 monit
```

**Common causes:**
- Uncaught exceptions
- Memory leaks
- Port conflicts
- Missing dependencies

</details>

<details>
<summary><b> Firewall Blocking Connections</b></summary>

```bash
# Check UFW status
sudo ufw status verbose

# Allow specific port
sudo ufw allow 3000/tcp

# Reload firewall
sudo ufw reload
```

**Common causes:**
- Port not allowed in UFW
- Wrong protocol (TCP/UDP)
- Application not listening
- SELinux restrictions

</details>

<div align="center">

### Getting Help

<table>
<tr>
<td align="center" width="33%">
<img src="https://skillicons.dev/icons?i=github" width="48"/>
<br><b>GitHub Issues</b>
<br><sub><a href="https://github.com/naveed-gung/elite-server-setup/issues">Report a bug</a></sub>
</td>
<td align="center" width="33%">
<img src="https://skillicons.dev/icons?i=stackoverflow" width="48"/>
<br><b>Documentation</b>
<br><sub>README + inline comments</sub>
</td>
<td align="center" width="33%">
<img src="https://skillicons.dev/icons?i=discord" width="48"/>
<br><b>Community</b>
<br><sub><a href="https://github.com/naveed-gung/elite-server-setup/discussions">Join discussions</a></sub>
</td>
</tr>
</table>

**Before requesting help:**
1. Check logs: `/var/log/elite-setup/setup.log`
2. Run health check: `sudo ./scripts/health-check.sh`
3. Review report: `/var/log/elite-setup/report.html`
4. Include error messages in your issue

</div>

---

## Project Architecture

<div align="center">

```mermaid
graph TB
subgraph " Elite Server Setup"
A[setup.sh<br/>336 lines]
B[quick-test.sh<br/>Validation]
end

subgraph " Core Libraries - 3,850+ LOC"
C[colors.sh<br/>298 lines]
D[logger.sh<br/>377 lines]
E[utils.sh<br/>507 lines]
F[preflight.sh<br/>276 lines]
G[config.sh<br/>352 lines]
H[installer.sh<br/>586 lines]
I[security.sh<br/>380 lines]
J[reporting.sh<br/>465 lines]
K[notifications.sh<br/>420 lines]
end

subgraph " Configuration"
L[production.json]
M[development.json]
N[custom.json]
end

subgraph " Templates"
O[nginx.conf]
P[mongod.conf]
Q[ecosystem.config.js]
end

A --> C & D & E & F & G & H & I & J & K
A --> L & M & N
H --> O & P & Q

style A fill:#4dabf7,stroke:#1971c2,stroke-width:3px,color:#fff
style B fill:#51cf66,stroke:#2f9e44,stroke-width:2px,color:#fff
```

</div>

### Directory Structure

<details open>
<summary><b>Click to view complete structure</b></summary>

```
elite-server-setup/
│
├── setup.sh # Main entry point (336 lines)
├── quick-test.sh # Professional validation suite
├── LICENSE # MIT License
├── README.md # This documentation
│
├── lib/ # Core library modules (3,850+ LOC)
│ ├── colors.sh # Terminal UI & formatting (298 lines)
│ ├── logger.sh # Structured logging system (377 lines)
│ ├── utils.sh # 50+ utility functions (507 lines)
│ ├── preflight.sh # Pre-flight system checks (276 lines)
│ ├── config.sh # Configuration management (352 lines)
│ ├── installer.sh # Component installers (586 lines)
│ ├── security.sh # Security hardening (380 lines)
│ ├── reporting.sh # Report generation (465 lines)
│ └── notifications.sh # Alert system (420 lines)
│
├── config/ # Configuration profiles
│ ├── production.json # Production settings
│ ├── development.json # Development settings
│ └── custom.json # Custom configuration template
│
├── templates/ # Service configuration templates
│ ├── nginx.conf # Nginx main configuration
│ ├── site.conf # Nginx site template
│ ├── mongod.conf # MongoDB configuration
│ └── ecosystem.config.js # PM2 configuration
│
├── scripts/ # Utility scripts
│ ├── health-check.sh # System verification (200+ lines)
│ ├── rollback.sh # Installation reversal (150+ lines)
│ └── backup.sh # Backup automation
│
├── tests/ # Test suite
│ ├── run-tests.sh # Automated tests
│ └── integration/ # Integration tests
│
└── assets/ # Media assets
├── hero-dark.png # Dark mode banner
├── hero-light.png # Light mode banner
└── diagrams/ # Architecture diagrams
```

</details>

### Installation Flow

<div align="center">

```mermaid
stateDiagram-v2
[*] --> PreFlight: Start Setup

PreFlight --> Validation: System Check
Validation --> LoadConfig: Valid
Validation --> Error: Invalid

LoadConfig --> Backup: Load Settings
Backup --> InstallNode: Create Snapshot

InstallNode --> InstallMongo: Node.js 
InstallMongo --> InstallNginx: MongoDB 
InstallNginx --> InstallPM2: Nginx 
InstallPM2 --> Docker: PM2 

Docker --> Security: Skip Docker
Docker --> InstallDocker: Install Docker
InstallDocker --> Security: Docker 

Security --> HealthCheck: Apply Hardening
HealthCheck --> Report: Verify Services
Report --> Notify: Generate Report
Notify --> Complete: Send Alerts

Complete --> [*]: Success
Error --> [*]: Failed
```

</div>

### Component Architecture

<table>
<tr>
<td width="50%" valign="top">

#### Presentation Layer

```
colors.sh
├── Color definitions
├── Text formatting
├── Progress bars
├── Status indicators
└── UI components
```

**Features:**
- 16 color palette
- Bold/dim/underline styles
- Spinner animations
- Box drawing characters

</td>
<td width="50%" valign="top">

#### Logging Layer

```
logger.sh
├── Log levels (DEBUG|INFO|WARN|ERROR)
├── Timestamp formatting
├── File rotation
├── Console output
└── Error tracking
```

**Features:**
- Structured JSON logs
- Automatic rotation
- Log compression
- Error aggregation

</td>
</tr>
<tr>
<td width="50%" valign="top">

#### Utility Layer

```
utils.sh
├── System detection
├── Package management
├── File operations
├── Network utilities
└── Validation functions
```

**50+ Functions:**
- OS detection
- Version comparison
- Port checking
- Service management

</td>
<td width="50%" valign="top">

#### Configuration Layer

```
config.sh
├── Profile loading
├── JSON parsing
├── Environment setup
├── Validation
└── Defaults
```

**Features:**
- Multi-profile support
- JSON schema validation
- Environment detection
- Override system

</td>
</tr>
</table>

---

## Security

<div align="center">

### Multi-Layer Security Architecture

```mermaid
graph TB
subgraph " Network Layer"
A[UFW Firewall]
B[Fail2ban]
end

subgraph " Application Layer"
C[MongoDB Auth]
D[SSH Hardening]
E[Nginx Headers]
end

subgraph " System Layer"
F[Auto Updates]
G[System Limits]
H[Audit Logs]
end

A & B --> C & D & E
C & D & E --> F & G & H
F & G & H --> I[ Secured Server]

style I fill:#51cf66,stroke:#2f9e44,stroke-width:3px,color:#fff
```

</div>

### Security Hardening Applied

<details open>
<summary><b> Network Security</b></summary>

**UFW Firewall Configuration:**

```bash
# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allowed ports
ufw allow 22/tcp # SSH
ufw allow 80/tcp # HTTP
ufw allow 443/tcp # HTTPS
ufw allow 27017/tcp # MongoDB (localhost only)

# Rate limiting
ufw limit 22/tcp
```

**Fail2ban Protection:**

```ini
[sshd]
enabled = true
maxretry = 3
findtime = 600
bantime = 3600
```

</details>

<details>
<summary><b> Authentication & Access</b></summary>

**SSH Hardening:**

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
X11Forwarding no
MaxAuthTries 3
```

**MongoDB Authentication:**

```javascript
// Required authentication
security:
authorization: enabled

// Admin user
db.createUser({
user: "admin",
pwd: "[secure-random-password]",
roles: ["userAdminAnyDatabase", "readWriteAnyDatabase"]
})
```

</details>

<details>
<summary><b> Web Security Headers</b></summary>

**Nginx Security Headers:**

```nginx
# Security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

# HSTS (only with SSL)
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

</details>

<details>
<summary><b> System Security</b></summary>

**Automatic Updates:**

```bash
# Unattended security updates
apt-get install -y unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

**System Limits:**

```bash
# /etc/security/limits.conf
* soft nofile 65536
* hard nofile 65536
* soft nproc 32768
* hard nproc 32768
```

</details>

### Post-Installation Security Checklist

<div align="center">

| Task | Priority | Status |
|:-----|:--------:|:------:|
| Change default MongoDB password | Critical | ⬜ |
| Setup SSH key authentication | Critical | ⬜ |
| Configure automatic backups | High | ⬜ |
| Enable monitoring & alerting | High | ⬜ |
| Review firewall rules | Medium | ⬜ |
| Test disaster recovery | Medium | ⬜ |
| Setup SSL certificates | Critical | |
| Enable audit logging | High | |

</div>

<details>
<summary><b> View complete security checklist</b></summary>

```bash
# Generated at: /var/log/elite-setup/security-checklist.txt
cat /var/log/elite-setup/security-checklist.txt
```

**Recommended Actions:**

1. Change default MongoDB admin password immediately
2. Setup SSH keys and disable password authentication
3. Configure automated backups (daily recommended)
4. Enable monitoring and alerting (Prometheus, Grafana, or similar)
5. Review firewall rules for your specific needs
6. Test disaster recovery procedures
7. Setup email alerts for critical events
8. Review SSL configuration and certificate renewal

</details>

---

## Contributing

<div align="center">

### Help Us Improve Elite Server Setup!

<img src="https://skillicons.dev/icons?i=git,github,vscode,bash" width="160"/>

We welcome contributions from the community!

</div>

### Getting Started

<table>
<tr>
<td width="50%" valign="top">

#### 1. Fork & Clone

```bash
# Fork on GitHub, then clone
git clone https://github.com/\
YOUR_USERNAME/elite-server-setup.git

cd elite-server-setup
```

#### 2. Create Branch

```bash
# Create feature branch
git checkout -b feature/amazing-feature
```

#### 3. Make Changes

```bash
# Edit files
nano lib/installer.sh

# Test changes
./quick-test.sh --verbose
```

</td>
<td width="50%" valign="top">

#### 4. Commit Changes

```bash
# Stage changes
git add .

# Commit with message
git commit -m "Add: Amazing feature"
```

#### 5. Push & PR

```bash
# Push to your fork
git push origin feature/amazing-feature

# Open Pull Request on GitHub
```

#### 6. Code Review

- Wait for maintainer review
- Address feedback
- Merge when approved!

</td>
</tr>
</table>

### Contribution Guidelines

<details open>
<summary><b>Code Standards</b></summary>

**Follow existing code style**
- Use 4-space indentation
- Add comments for complex logic
- Keep functions under 50 lines
- Use meaningful variable names

**Write tests**
- Add tests for new features
- Ensure all tests pass
- Maintain test coverage

**Update documentation**
- Update README for new features
- Add inline code comments
- Include usage examples

**Commit message format**
```
Type: Short description

Longer description if needed

- Bullet points for details
- Reference issues: #123
```

**Types:** `Add`, `Fix`, `Update`, `Remove`, `Refactor`, `Docs`, `Test`

</details>

<details>
<summary><b>What to Contribute</b></summary>

**Bug Fixes**
- Fix reported issues
- Improve error handling
- Edge case coverage

**New Features**
- Additional installers
- New configuration options
- Enhanced security features

**Documentation**
- Improve README
- Add tutorials
- Fix typos

**Tests**
- Add test coverage
- Integration tests
- Performance tests

**UI/UX**
- Better terminal output
- Progress indicators
- Error messages

</details>

<details>
<summary><b>Development Setup</b></summary>

```bash
# Install development dependencies
sudo apt-get install -y shellcheck

# Run linter
shellcheck setup.sh lib/*.sh

# Run validation suite
./quick-test.sh --verbose

# Test in container (recommended)
docker run -it --rm -v $(pwd):/app ubuntu:22.04 bash
cd /app && ./setup.sh --profile=development
```

</details>

---

## License

<div align="center">

### MIT License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

</div>

```
MIT License

Copyright (c) 2025 naveed-gung

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Credits & Acknowledgments

**Created by: [naveed-gung](https://github.com/naveed-gung) | Portfolio: [naveed-gung.dev](https://naveed-gung.dev)**

<div align="center">

<img src="https://skillicons.dev/icons?i=nodejs,mongodb,nginx,docker,react,express,bash,linux,git,github,vscode" width="440"/>

### Built With Amazing Open Source Tools

</div>

<table>
<tr>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=nodejs" width="48"/>
<br><b>Node.js</b>
<br><sub>JavaScript Runtime</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=mongodb" width="48"/>
<br><b>MongoDB</b>
<br><sub>NoSQL Database</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=nginx" width="48"/>
<br><b>Nginx</b>
<br><sub>Web Server</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=docker" width="48"/>
<br><b>Docker</b>
<br><sub>Containers</sub>
</td>
<td align="center" width="20%">
<img src="https://skillicons.dev/icons?i=linux" width="48"/>
<br><b>Linux</b>
<br><sub>Operating System</sub>
</td>
</tr>
</table>

**Special thanks to:**
- **Node.js Foundation** - JavaScript runtime excellence
- **MongoDB Inc.** - Powerful NoSQL database platform
- **Nginx Team** - High-performance web server
- **Unitech** - PM2 process management
- **Let's Encrypt / Certbot** - Free SSL certificates for everyone
- **Linux Community** - Foundation of open source
- **Skill Icons** - Beautiful technology icons
- **Open Source Community** - For making this possible

---

## Changelog

### v1.0.0 (2025-10-12)

**Initial Release**

- Full MERN infrastructure automation
- Multi-OS support (Ubuntu, Debian, CentOS, RHEL)
- Configuration profiles (development/staging/production)
- Security hardening suite
- Health monitoring & reporting
- Multi-channel notifications (Slack, Discord, Email)
- Backup & rollback system
- Professional validation suite
- Comprehensive documentation
- Enterprise-grade code quality (3,850+ LOC)

<details>
<summary><b>Additional Features Detail</b></summary>

### Features

**Core Functionality:**
- Full MERN infrastructure automation
- Multi-OS support (Ubuntu, Debian, CentOS, RHEL)
- Interactive + non-interactive modes
- Configuration profiles (dev/staging/prod)

**Components:**
- Node.js 20.x LTS installation
- MongoDB 7.0+ with authentication
- Nginx with SSL/TLS support
- PM2 process manager
- Optional Docker installation

**Security:**
- UFW firewall configuration
- Fail2ban brute-force protection
- SSH hardening
- Automatic security updates
- MongoDB authentication
- Nginx security headers

**Operations:**
- Health monitoring & reporting
- Multi-channel notifications
- Backup & rollback system
- Professional validation suite

**Documentation:**
- Comprehensive README
- Inline code comments
- Usage examples
- Troubleshooting guide

**Quality:**
- 3,850+ lines of code
- 85+ validation tests
- Enterprise-grade architecture
- Production-ready

</details>

---

## Support

<div align="center">

### Need Help? We're Here!

<table>
<tr>
<td align="center" width="25%">
<img src="https://skillicons.dev/icons?i=github" width="64"/>
<br><br>
<b>GitHub Issues</b>
<br><sub>Report bugs or request features</sub>
<br><br>
<a href="https://github.com/naveed-gung/elite-server-setup/issues">
<img src="https://img.shields.io/github/issues/naveed-gung/elite-server-setup?style=for-the-badge" alt="Issues"/>
</a>
</td>
<td align="center" width="25%">
<img src="https://skillicons.dev/icons?i=stackoverflow" width="64"/>
<br><br>
<b>Documentation</b>
<br><sub>Complete guides & tutorials</sub>
<br><br>
<a href="#-table-of-contents">
<img src="https://img.shields.io/badge/Docs-Read%20Now-blue?style=for-the-badge" alt="Docs"/>
</a>
</td>
<td align="center" width="25%">
<img src="https://skillicons.dev/icons?i=discord" width="64"/>
<br><br>
<b>Community</b>
<br><sub>Join our discussions</sub>
<br><br>
<a href="https://github.com/naveed-gung/elite-server-setup/discussions">
<img src="https://img.shields.io/github/discussions/naveed-gung/elite-server-setup?style=for-the-badge" alt="Discussions"/>
</a>
</td>
<td align="center" width="25%">
<img src="https://skillicons.dev/icons?i=twitter" width="64"/>
<br><br>
<b>Updates</b>
<br><sub>Follow for latest news</sub>
<br><br>
<a href="https://github.com/naveed-gung">
<img src="https://img.shields.io/github/followers/naveed-gung?style=for-the-badge&logo=github" alt="Follow"/>
</a>
</td>
</tr>
</table>

### Show Your Support

**If this project helped you, please:**

<a href="https://github.com/naveed-gung/elite-server-setup">
<img src="https://img.shields.io/github/stars/naveed-gung/elite-server-setup?style=for-the-badge&logo=github" alt="Stars"/>
</a>
<a href="https://github.com/naveed-gung/elite-server-setup/fork">
<img src="https://img.shields.io/github/forks/naveed-gung/elite-server-setup?style=for-the-badge&logo=github" alt="Forks"/>
</a>
<a href="https://github.com/naveed-gung/elite-server-setup/watchers">
<img src="https://img.shields.io/github/watchers/naveed-gung/elite-server-setup?style=for-the-badge&logo=github" alt="Watchers"/>
</a>

</div>

---

<div align="center">

## Ready to Deploy?

### Start with one simple command:

```bash
sudo ./setup.sh
```

<br>

**Made with passion by [naveed-gung](https://github.com/naveed-gung) | Portfolio: [naveed-gung.dev](https://naveed-gung.dev)**

<img src="https://skillicons.dev/icons?i=linux,bash,nodejs,mongodb,nginx,docker,react,express,git,github,vscode" width="440"/>

<br><br>

---

### Project Stats

<img src="https://img.shields.io/github/repo-size/naveed-gung/elite-server-setup?style=for-the-badge&logo=github" alt="Repo Size"/>
<img src="https://img.shields.io/github/languages/top/naveed-gung/elite-server-setup?style=for-the-badge&logo=gnubash" alt="Top Language"/>
<img src="https://img.shields.io/github/last-commit/naveed-gung/elite-server-setup?style=for-the-badge&logo=github" alt="Last Commit"/>
<img src="https://img.shields.io/github/license/naveed-gung/elite-server-setup?style=for-the-badge" alt="License"/>

<br>

**Star us on GitHub — it motivates us a lot!**

[⬆ Back to top](#-elite-auto-server-setup)

</div>

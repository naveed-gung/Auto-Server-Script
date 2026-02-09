<div align="center">

# Elite Auto Server Setup

### Zero-Touch Production Server Provisioning for MERN Stack

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-5.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-orange.svg)](https://www.linux.org/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success.svg)](https://github.com/naveed-gung/elite-server-setup)

**Created by [naveed-gung](https://github.com/naveed-gung) | Portfolio: [naveed-gung.dev](https://naveed-gung.dev)**

<table>
<tr>
<td width="50%">
<img src="assets/image.png" alt="Elite Server Setup Banner" width="100%"/>
</td>
<td width="50%">
<img src="https://github.com/user-attachments/assets/8b8e5b5e-8b3e-4b8e-8b3e-8b3e8b3e8b3e/image.png" alt="Elite Server Setup Preview" width="100%"/>
</td>
</tr>
</table>

</div>

---

## <img src="https://skillicons.dev/icons?i=linux" width="24"/> Overview

**Elite Auto Server Setup** is an enterprise-grade automation tool that provisions complete MERN infrastructure with zero human intervention. This tool installs and configures the **server infrastructure** (MongoDB, Node.js, Nginx, PM2), applies security hardening, and prepares your server for production deployment.

### What This Tool Does

<img src="https://skillicons.dev/icons?i=nodejs,mongodb,nginx,docker" width="200"/>

- <img src="https://skillicons.dev/icons?i=nodejs" width="16"/> Installs **Node.js** (LTS) + npm/npx via NodeSource
- <img src="https://skillicons.dev/icons?i=mongodb" width="16"/> Installs **MongoDB** 7.0+ with authentication & optimization
- <img src="https://skillicons.dev/icons?i=nginx" width="16"/> Configures **Nginx** as reverse proxy with SSL/TLS support
- <img src="https://skillicons.dev/icons?i=pm2" width="16"/> Sets up **PM2** process manager for Node.js applications
- <img src="https://skillicons.dev/icons?i=docker" width="16"/> Optional **Docker** installation with docker-compose
- <img src="https://skillicons.dev/icons?i=bash" width="16"/> Hardens security (UFW firewall, Fail2ban, SSH hardening)
- <img src="https://skillicons.dev/icons?i=linux" width="16"/> Enables automated updates & comprehensive monitoring

### What You Deploy After Installation

<img src="https://skillicons.dev/icons?i=react,express,js,ts" width="160"/>

- Deploy your **React** frontend code
- Deploy your **Express.js** backend API
- Connect your application to the configured MongoDB database
- Use PM2 to manage your Node.js processes
- Configure Nginx to reverse proxy your application

---

## <img src="https://skillicons.dev/icons?i=github" width="24"/> Features

### <img src="https://skillicons.dev/icons?i=bash" width="20"/> Intelligent Automation

- **Pre-flight System Checks** - Validates OS compatibility, disk space, ports, and services
- **Interactive CLI Wizard** - Beautiful color-coded interface with progress tracking
- **Non-Interactive Mode** - JSON configuration for CI/CD pipelines
- **Idempotent Operations** - Safe to run multiple times without conflicts
- **Automatic Rollback** - Reverts changes on failure with detailed logging

### <img src="https://skillicons.dev/icons?i=linux" width="20"/> Technology Stack

| Component                                                                  | Version  | Purpose                             |
| -------------------------------------------------------------------------- | -------- | ----------------------------------- |
| <img src="https://skillicons.dev/icons?i=nodejs" width="16"/> **Node.js**  | 20.x LTS | JavaScript runtime (via NodeSource) |
| <img src="https://skillicons.dev/icons?i=mongodb" width="16"/> **MongoDB** | 7.0+     | NoSQL database (Community Edition)  |
| <img src="https://skillicons.dev/icons?i=nginx" width="16"/> **Nginx**     | Latest   | Reverse proxy + SSL termination     |
| **PM2**                                                                    | Latest   | Process manager with clustering     |
| <img src="https://skillicons.dev/icons?i=docker" width="16"/> **Docker**   | Latest   | Container runtime (optional)        |
| **Certbot**                                                                | Latest   | Let's Encrypt SSL automation        |

### <img src="https://skillicons.dev/icons?i=linux" width="20"/> Security Hardening

- **UFW Firewall** - Strict rules (ports 22, 80, 443, 27017)
- **Fail2ban** - Protection against brute-force attacks
- **SSH Hardening** - Disable root login, key-only authentication
- **Auto Updates** - Unattended security patches
- **MongoDB Auth** - Required authentication, localhost binding
- **Nginx Headers** - Security headers (X-Frame-Options, CSP, HSTS)
- **System Limits** - Optimized file descriptors and processes

### <img src="https://skillicons.dev/icons?i=github" width="20"/> Enterprise Features

- **Deployment Reports** - HTML/text reports with complete system information
- **Configuration Profiles** - Pre-configured development/staging/production modes
- **Multi-channel Notifications** - Slack, Discord, and email integration
- **Health Monitoring** - Automated post-install verification
- **Backup & Rollback** - Snapshot creation and restoration tools

---

## <img src="https://skillicons.dev/icons?i=bash" width="24"/> Quick Start

### Prerequisites

<img src="https://skillicons.dev/icons?i=ubuntu,debian,linux" width="120"/>

- **OS**: Ubuntu 20.04/22.04 LTS, Debian 11/12, CentOS 8+, RHEL 8+
- **Access**: Root or sudo privileges
- **Network**: Internet connection for downloads
- **Resources**: Minimum 10GB disk, 1GB RAM

### Installation

#### Method 1: Interactive Mode (Recommended)

```bash
# Clone the repository
git clone https://github.com/naveed-gung/elite-server-setup.git
cd elite-server-setup

# Run the installer
sudo ./setup.sh
```

The interactive wizard will guide you through the configuration.

#### Method 2: Quick Production Setup

```bash
sudo ./setup.sh \
  --profile=production \
  --domain=api.yourdomain.com \
  --ssl-email=admin@yourdomain.com \
  --slack-webhook=https://hooks.slack.com/services/YOUR/WEBHOOK
```

#### Method 3: Non-Interactive (CI/CD)

```bash
# Use a JSON configuration file
sudo ./setup.sh --config=config/production.json --silent
```

---

## <img src="https://skillicons.dev/icons?i=git" width="24"/> Configuration

### Command-Line Options

```bash
Usage: ./setup.sh [OPTIONS]

Core Options:
  --profile=PROFILE          Use predefined profile (development|staging|production)
  --config=FILE              Load configuration from JSON file
  --mode=MODE                Installation mode (interactive|silent|unattended)
  --silent                   Suppress all prompts (requires --config)

Component Selection:
  --with-nodejs              Install Node.js (default: enabled)
  --with-mongodb             Install MongoDB (default: enabled)
  --with-nginx               Install Nginx (default: enabled)
  --with-pm2                 Install PM2 (default: enabled)
  --with-docker              Install Docker (default: disabled)
  --skip-security            Skip security hardening (not recommended)

Network Configuration:
  --domain=DOMAIN            Domain name for SSL configuration
  --ssl-email=EMAIL          Email for Let's Encrypt certificates
  --enable-ssl               Enable SSL/TLS with Let's Encrypt

Version Selection:
  --node-version=VERSION     Node.js version (18|20|22, default: 20)
  --mongodb-version=VERSION  MongoDB version (6.0|7.0, default: 7.0)

Security Options:
  --enable-firewall          Configure UFW firewall (default: production only)
  --enable-fail2ban          Install Fail2ban protection (default: production only)
  --harden-ssh               Harden SSH configuration (default: production only)

Notifications:
  --slack-webhook=URL        Slack webhook for notifications
  --discord-webhook=URL      Discord webhook for notifications
  --email=ADDRESS            Email address for notifications

Advanced Options:
  --mongodb-auth             Enable MongoDB authentication (default: production only)
  --mongodb-user=USERNAME    MongoDB admin username (default: admin)
  --mongodb-pass=PASSWORD    MongoDB admin password (auto-generated if not set)
  --backup-dir=PATH          Backup directory (default: /var/backups/elite-setup)
  --log-level=LEVEL          Logging level (debug|info|warning|error)

Utility Options:
  --dry-run                  Show what would be installed without making changes
  --force                    Force installation even if services exist
  --cleanup                  Remove installation artifacts after completion
  -h, --help                 Show this help message
  -v, --version              Show version information
```

### Configuration Profiles

#### <img src="https://skillicons.dev/icons?i=vscode" width="16"/> Development Profile

```bash
sudo ./setup.sh --profile=development
```

**Includes:**

- Node.js 20 + npm
- MongoDB without authentication
- Nginx without SSL
- PM2 in single-instance mode
- Minimal security (for local testing)

#### <img src="https://skillicons.dev/icons?i=linux" width="16"/> Production Profile

```bash
sudo ./setup.sh --profile=production \
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

#### <img src="https://skillicons.dev/icons?i=docker" width="16"/> Custom Configuration (JSON)

Create `config/custom.json`:

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

Then run:

```bash
sudo ./setup.sh --config=config/custom.json
```

---

## <img src="https://skillicons.dev/icons?i=react" width="24"/> Post-Installation: Deploy Your MERN Application

### Step 1: Verify Installation

```bash
# Run health check
sudo ./scripts/health-check.sh

# Check service status
systemctl status nginx mongodb pm2

# View installation report
cat /var/log/elite-setup/report.html
```

### Step 2: Prepare Your Application

<img src="https://skillicons.dev/icons?i=git,github" width="80"/>

```bash
# Upload your code via Git
cd /var/www
git clone https://github.com/yourusername/your-mern-app.git
cd your-mern-app

# Or use SCP
scp -r my-app/ user@yourserver:/var/www/my-app/
```

### Step 3: Install Dependencies

<img src="https://skillicons.dev/icons?i=npm" width="40"/>

```bash
cd /var/www/your-mern-app

# Install production dependencies
npm install --production

# Build frontend (if using React/Vue)
npm run build
```

### Step 4: Configure Environment

```bash
# Create .env file
cat > .env << EOF
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://admin:password@localhost:27017/myapp?authSource=admin
EOF

# MongoDB credentials are stored in:
cat /root/.mongodb_credentials
```

### Step 5: Start with PM2

<img src="https://skillicons.dev/icons?i=nodejs" width="40"/>

```bash
# Start your Node.js application
pm2 start server.js --name my-app -i max

# Or use ecosystem file
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save
pm2 startup
```

### Step 6: Configure Nginx Reverse Proxy

<img src="https://skillicons.dev/icons?i=nginx" width="40"/>

```bash
# Create Nginx configuration
sudo nano /etc/nginx/sites-available/myapp.conf
```

**Example Nginx Configuration:**

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
sudo ln -s /etc/nginx/sites-available/myapp.conf /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Step 7: Connect to MongoDB

<img src="https://skillicons.dev/icons?i=mongodb" width="40"/>

```bash
# Get MongoDB credentials
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

**Update your app's connection string:**

```javascript
// In your Node.js app
const MONGODB_URI =
  "mongodb://myappuser:secure_password@localhost:27017/myapp?authSource=myapp";
```

---

## <img src="https://skillicons.dev/icons?i=linux" width="24"/> Maintenance & Operations

### Daily Operations

#### <img src="https://skillicons.dev/icons?i=bash" width="16"/> Check System Health

```bash
sudo ./scripts/health-check.sh
```

#### <img src="https://skillicons.dev/icons?i=linux" width="16"/> View Logs

```bash
# Elite Setup logs
tail -f /var/log/elite-setup/setup.log

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# MongoDB logs
tail -f /var/log/mongodb/mongod.log

# PM2 logs
pm2 logs
```

#### <img src="https://skillicons.dev/icons?i=docker" width="16"/> Restart Services

```bash
# Restart all services
sudo systemctl restart nginx mongodb

# Restart PM2 apps
pm2 restart all

# Reload Nginx config
sudo systemctl reload nginx
```

### Backup & Restore

#### <img src="https://skillicons.dev/icons?i=mongodb" width="16"/> Create Backup

```bash
# Backup MongoDB
mongodump --uri="mongodb://admin:password@localhost:27017" \
  --out=/backup/mongo-$(date +%Y%m%d)

# Backup configuration files
sudo tar -czf /backup/configs-$(date +%Y%m%d).tar.gz \
  /etc/nginx \
  /etc/mongod.conf \
  /etc/systemd/system/pm2-*.service
```

#### <img src="https://skillicons.dev/icons?i=bash" width="16"/> Rollback Installation

```bash
# Revert to pre-installation state
sudo ./scripts/rollback.sh
```

### SSL Certificate Renewal

<img src="https://skillicons.dev/icons?i=linux" width="40"/>

```bash
# Certificates auto-renew via certbot
# Check renewal status
sudo certbot renew --dry-run

# Force renewal
sudo certbot renew --force-renewal

# Reload Nginx after renewal
sudo systemctl reload nginx
```

---

## <img src="https://skillicons.dev/icons?i=github" width="24"/> Testing & Validation

### Run Validation Suite

```bash
# Quick validation (no installation)
./quick-test.sh

# Verbose output
./quick-test.sh --verbose
```

**Test Coverage:**

- ✅ File structure validation (20+ tests)
- ✅ Bash syntax checking
- ✅ JSON configuration validation
- ✅ Security analysis (credentials, unsafe commands)
- ✅ Code quality metrics (LOC, functions, modularity)
- ✅ Documentation quality assessment
- ✅ Integration & compatibility tests
- ✅ Compliance & standards verification

**Example Output:**

```
╔═══════════════════════════════════════════════════╗
║   ELITE AUTO SETUP - VALIDATION SUITE            ║
║   Enterprise-Grade Testing Framework             ║
║   Created by: naveed-gung                        ║
╚═══════════════════════════════════════════════════╝

Platform: Linux
Directory: /opt/elite-server-setup

═══════════════════════════════════════════════
  1. FILE STRUCTURE VALIDATION
═══════════════════════════════════════════════

[✓] Main script: setup.sh
[✓] Documentation: README.md
[✓] License file: LICENSE
[✓] Library: lib/colors.sh (298 lines)
[✓] Library: lib/logger.sh (377 lines)
...

═══════════════════════════════════════════════
  TEST SUMMARY
═══════════════════════════════════════════════

Total Tests:    85
✓ Passed:       82
✗ Failed:       0
⚠ Warnings:     3

Success Rate:   96.5%
[██████████████████████████████████████████████░░░]

╔═══════════════════════════════════════════════╗
║        ✓ ALL TESTS PASSED!                    ║
║   Project is production-ready                 ║
╚═══════════════════════════════════════════════╝
```

---

## <img src="https://skillicons.dev/icons?i=github" width="24"/> Troubleshooting

### Common Issues

#### <img src="https://skillicons.dev/icons?i=mongodb" width="16"/> MongoDB Connection Failed

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

#### <img src="https://skillicons.dev/icons?i=nginx" width="16"/> Nginx Configuration Error

```bash
# Test configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log

# Reload configuration
sudo systemctl reload nginx
```

#### <img src="https://skillicons.dev/icons?i=nodejs" width="16"/> PM2 Process Crashes

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

#### <img src="https://skillicons.dev/icons?i=linux" width="16"/> Firewall Blocking Connections

```bash
# Check UFW status
sudo ufw status verbose

# Allow specific port
sudo ufw allow 3000/tcp

# Reload firewall
sudo ufw reload
```

### Getting Help

<img src="https://skillicons.dev/icons?i=github,stackoverflow,discord" width="120"/>

If you encounter issues:

1. **Check Logs**: Review `/var/log/elite-setup/setup.log` for detailed logs
2. **Run Health Check**: Execute `sudo ./scripts/health-check.sh`
3. **Review Report**: Check `/var/log/elite-setup/report.html`
4. **Open Issue**: [Create a GitHub issue](https://github.com/naveed-gung/elite-server-setup/issues) with logs attached

---

## <img src="https://skillicons.dev/icons?i=git" width="24"/> Project Architecture

### Directory Structure

```
elite-server-setup/
├── setup.sh                    # Main entry point (336 lines)
├── quick-test.sh              # Professional validation suite
├── LICENSE                     # MIT License
├── README.md                   # This documentation
│
├── lib/                        # Core library modules (3,850+ LOC)
│   ├── colors.sh              # Terminal UI & formatting (298 lines)
│   ├── logger.sh              # Structured logging system (377 lines)
│   ├── utils.sh               # 50+ utility functions (507 lines)
│   ├── preflight.sh           # Pre-flight system checks (276 lines)
│   ├── config.sh              # Configuration management (352 lines)
│   ├── installer.sh           # Component installers (586 lines)
│   ├── security.sh            # Security hardening (380 lines)
│   ├── reporting.sh           # Report generation (465 lines)
│   └── notifications.sh       # Alert system (420 lines)
│
├── config/                     # Configuration profiles
│   ├── production.json        # Production settings
│   └── development.json       # Development settings
│
├── templates/                  # Service configuration templates
│   ├── nginx.conf             # Nginx main configuration
│   ├── mongod.conf            # MongoDB configuration
│   └── ecosystem.config.js    # PM2 configuration
│
├── scripts/                    # Utility scripts
│   ├── health-check.sh        # System verification (200+ lines)
│   └── rollback.sh            # Installation reversal (150+ lines)
│
└── tests/                      # Test suite
    └── run-tests.sh           # Automated tests
```

### Installation Flow

```mermaid
graph TD
    A[Start] --> B[Pre-flight Checks]
    B --> C{System Valid?}
    C -->|No| D[Display Errors & Exit]
    C -->|Yes| E[Load Configuration]
    E --> F[Create Backup Point]
    F --> G[Install Node.js]
    G --> H[Install MongoDB]
    H --> I[Install Nginx]
    I --> J[Install PM2]
    J --> K{Docker Enabled?}
    K -->|Yes| L[Install Docker]
    K -->|No| M[Apply Security]
    L --> M
    M --> N[Run Health Checks]
    N --> O[Generate Report]
    O --> P[Send Notifications]
    P --> Q[Success!]
```

---

## <img src="https://skillicons.dev/icons?i=linux" width="24"/> Security

### Hardening Applied

<img src="https://skillicons.dev/icons?i=linux,bash" width="80"/>

- **UFW Firewall**: Only ports 22, 80, 443, 27017 open
- **Fail2ban**: Protection against SSH brute-force attacks
- **SSH Hardening**:
  - Disable root login
  - Disable password authentication (key-only)
  - Custom SSH port (optional)
- **Automatic Updates**: Unattended security patches
- **MongoDB**: Authentication required, bind to localhost only
- **Nginx**: Security headers enabled (X-Frame-Options, CSP, HSTS, etc.)
- **System Limits**: Optimized file descriptors and process limits

### Security Checklist

After installation, review the security checklist:

```bash
cat /var/log/elite-setup/security-checklist.txt
```

**Recommended Actions:**

1. Change default MongoDB admin password
2. Configure SSH key-based authentication
3. Set up automatic backups
4. Enable monitoring and alerting
5. Review firewall rules
6. Test disaster recovery procedures

---

## <img src="https://skillicons.dev/icons?i=github" width="24"/> Contributing

<img src="https://skillicons.dev/icons?i=git,github,vscode" width="120"/>

Contributions are welcome! Please follow these steps:

### Development Setup

```bash
# Clone the repository
git clone https://github.com/naveed-gung/elite-server-setup.git
cd elite-server-setup

# Run validation tests
./quick-test.sh

# Make your changes
# ...

# Test your changes
./quick-test.sh --verbose
```

### Contribution Guidelines

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Code Standards

- Follow existing code style and conventions
- Add comments for complex logic
- Update documentation for new features
- Ensure all tests pass before submitting PR
- Keep commits atomic and well-described

---

## <img src="https://skillicons.dev/icons?i=github" width="24"/> License

<img src="https://skillicons.dev/icons?i=linux" width="40"/>

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

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
```

---

## <img src="https://skillicons.dev/icons?i=github" width="24"/> Credits & Acknowledgments

**Created by: [naveed-gung](https://github.com/naveed-gung) | Portfolio: [naveed-gung.dev](https://naveed-gung.dev)**

<img src="https://skillicons.dev/icons?i=nodejs,mongodb,nginx,docker,react,express,bash,linux,git,github,vscode" width="400"/>

Special thanks to the open-source community and the amazing tools that make this possible:

- **Node.js Foundation** - JavaScript runtime
- **MongoDB Inc.** - NoSQL database
- **Nginx Team** - Web server and reverse proxy
- **Unitech** - PM2 process manager
- **Let's Encrypt / Certbot** - Free SSL certificates
- **Linux Community** - Operating system foundation

---

## <img src="https://skillicons.dev/icons?i=github" width="24"/> Changelog

### v1.0.0 (2025-10-12)

**Initial Release** 🎉

- ✅ Full MERN infrastructure automation
- ✅ Multi-OS support (Ubuntu, Debian, CentOS, RHEL)
- ✅ Configuration profiles (development/staging/production)
- ✅ Security hardening suite
- ✅ Health monitoring & reporting
- ✅ Multi-channel notifications (Slack, Discord, Email)
- ✅ Backup & rollback system
- ✅ Professional validation suite
- ✅ Comprehensive documentation
- ✅ Enterprise-grade code quality (3,850+ LOC)

---

## <img src="https://skillicons.dev/icons?i=stackoverflow" width="24"/> Support

<div align="center">

### Need Help?

<img src="https://skillicons.dev/icons?i=github,stackoverflow,discord" width="120"/>

- **GitHub Issues**: [Report bugs or request features](https://github.com/naveed-gung/elite-server-setup/issues)
- **Documentation**: This README + inline code comments
- **Discussions**: [Join the community](https://github.com/naveed-gung/elite-server-setup/discussions)

### Show Your Support

If this project helped you, please ⭐ **star this repository** and share it with others!

[![GitHub stars](https://img.shields.io/github/stars/naveed-gung/elite-server-setup?style=social)](https://github.com/naveed-gung/elite-server-setup)
[![GitHub forks](https://img.shields.io/github/forks/naveed-gung/elite-server-setup?style=social)](https://github.com/naveed-gung/elite-server-setup/fork)

---

**Ready to deploy?** Start with: `sudo ./setup.sh`

**Made with ❤️ by [naveed-gung](https://github.com/naveed-gung) | Portfolio: [naveed-gung.dev](https://naveed-gung.dev)**

<img src="https://skillicons.dev/icons?i=linux,bash,nodejs,mongodb,nginx,docker,react,express,git,github" width="400"/>

</div>

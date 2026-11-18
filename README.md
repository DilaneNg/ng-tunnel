<!-- NG TUNNEL Banner -->
<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue.svg" alt="Version">
<a href="LICENSE">
  <img src="https://img.shields.io/badge/license-GPL--3.0-red.svg" alt="License: GPL-3.0">
</a>
  <img src="https://img.shields.io/badge/bash-5.0+-4EAA25.svg" alt="Bash">
  <img src="https://img.shields.io/badge/node.js-16.x+-339933.svg" alt="Node.js">
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome">
  <img src="https://img.shields.io/badge/Powered%20by-DilaneNg-ff69b4.svg" alt="Powered by DilaneNg">
</p>

<h1 align="center">🚀 NG TUNNEL</h1>

<p align="center">
  <strong>Enterprise-grade VPN tunnel management suite with dual-panel architecture</strong>
</p>

# 📋 Overview

NG TUNNEL is a comprehensive VPN management solution featuring both a terminal panel for direct VPS administration and a web panel for remote multi-client management. The architecture ensures zero redundancy—both panels operate on the same system files without conflicts.
Supported Protocols

    SSH WebSocket/UDP/TLS

    SSH + V2ray SlowDNS

    ZiVPN

    HAProxy load balancing
    
    3x-ui parallel installation 

🏗️ Main Architecture
```text

ng-tunnel/
├── terminal-panel/                 # Bash interactive SSH menu
│   ├── install.sh                  # Complete VPS installation
│   ├── menu.sh                     # Main panel interface (`menu` command)
│   └── ssh                     # SSH daemon configuration
│             
│
└── web-panel/                      # Node.js Admin/Reseller interface
    ├── deploy/
    │   └── install.sh              # Automated deployment with Certbot
    ├── server.js                   # Main application entry
    ├── routes/                     # API endpoints
    ├── views/                      # EJS templates
    ├── lib/                        # Core business logic
    ├── db/                         # Database schemas & migrations
    └── README.md                   # Web panel documentation
```
**🚀 Quick Installation**

> 📖 **Step-by-step installation guide (French): [GUIDE-INSTALLATION.md](./GUIDE-INSTALLATION.md)** — prerequisites, GitHub publishing step, web panel options, updates, uninstall and troubleshooting.

One-Command Install
```bash
curl -fsSL https://raw.githubusercontent.com/DilaneNg/ng-tunnel/main/bootstrap.sh | sudo bash
```

The bootstrap script intelligently detects installed components:

    First run: Clones repository to /opt/ng-tunnel and installs terminal panel (web panel optional)

    Subsequent runs: Performs git pull and updates installed panels only

Component-Specific Updates
```bash
cd /opt/ng-tunnel
```
# Update terminal panel only
bash terminal-panel/update.sh

# Update web panel only
bash web-panel/update.sh

🔧 Manual Installation
Terminal Panel
```bash

git clone https://github.com/DilaneNg/ng-tunnel.git ng-tunnel
cd ng-tunnel/terminal-panel
sudo bash install.sh
```
What's installed:

    menu command for SSH/ZiVPN/SlowDNS/HAProxy management

    Optimized SSH daemon configuration

    Service monitoring and auto-restart mechanisms

Web Panel
```bash
cd ../web-panel
sudo bash deploy/install.sh
```
**Installation features:**

    Interactive domain, port, and credentials setup

    Automatic Cloudflare proxy detection

    Adaptive TLS certificate issuance (Let's Encrypt)

    Non-interactive mode with CLI flags support

    ⚠️ Port Configuration: the panel runs on a dedicated public port (default: 2045; internal Node port 3000 in nginx mode) to avoid conflicts with HAProxy on ports 80/443.

Access URL: https://panel.yourdomain.com:port
Web Panel Management

After installation, the ngpanel command provides comprehensive management capabilities:
```bash

ngpanel status           # Show service status
ngpanel logs             # View application logs
ngpanel update           # Update to latest version
ngpanel domain <domain>  # Change domain
ngpanel port <port>      # Change web port
ngpanel credentials      # Update admin credentials
ngpanel backup           # Create system backup
ngpanel restore <file>   # Restore from backup
ngpanel uninstall        # Complete removal
```
🔄 Data Synchronization

The two panels maintain consistency through shared data files:
```text
Data Type       Shared File Location
SSH Accounts    /etc/ngtunnel/users.db

SSH Bandwidth Usage     /etc/ngtunnel/bandwidth/<user>.usage

ZiVPN Credentials & Quotas      /etc/zivpn/config.json
/etc/zivpn/passwords_meta.json
```
Key Benefit: Accounts created in either panel are immediately available in the other.
📦 Updating After Git Push
```bash

cd /opt/ng-tunnel
git pull

# Update terminal panel
cp terminal-panel/menu.sh /usr/local/bin/menu
chmod +x /usr/local/bin/menu

# Update web panel
cd web-panel
npm install                    # Only if package.json changed
systemctl restart ngpanel
```
**🛡️ Security Features**

    ✅ TLS encryption via Let's Encrypt

    ✅ Automatic certificate renewal

    ✅ Cloudflare proxy compatibility

    ✅ Secure session management

    ✅ Role-based access control (Admin/Reseller)

    ✅ Audit logging

    ✅ Rate limiting protection

**📊 Monitoring & Logging**

    Real-time service health checks

    User bandwidth tracking

    Connection monitoring

    System resource usage

    Comprehensive audit trails


# 🌍 Community & Support

<p align="center">

<a href="https://whatsapp.com/channel/A_REMPLACER">
  <img src="https://img.shields.io/badge/💬%20Official%20WhatsApp%20Channel-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" />
</a>

<a href="https://t.me/A_REMPLACER">
  <img src="https://img.shields.io/badge/✈️%20Telegram%20Channel%20%26%20Support-26A5E4?style=for-the-badge&logo=telegram&logoColor=white" />
</a>

<a href="https://github.com/DilaneNg/ng-tunnel">
  <img src="https://img.shields.io/badge/📦%20GitHub%20-%20DilaneNg-181717?style=for-the-badge&logo=github&logoColor=white" />
</a>

</p>

> ⚠️ **Before publishing:** replace every `A_REMPLACER` placeholder with your real channel links — here, in `web-panel/views/about.ejs`, in `terminal-panel/ngtunnel.sh` and in `terminal-panel/menu.sh`.


---

## 📧 Contact

**Author:** DilaneNg
**GitHub:** https://github.com/DilaneNg

---

# ⭐ Support the Project

If you find this project useful, consider giving it a ⭐ on GitHub.
It helps the project grow and motivates future development.

---

# 📄 License

This project is licensed under the **GPL-3.0 License** - see the [LICENSE](./LICENSE) file for details.

Copyright (c) 2026 **DilaneNg**

> ℹ️ This project is a fork of **NOVA XTUNNEL** (NOSTRA-DevOps), originally released under the GPL-3.0 License.

---

<p align="center">

<i>Powered by</i> <b>DilaneNg</b>

</p>

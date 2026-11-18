#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root."
   exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Mise à jour de NG TUNNEL (panel web)..."
npm install --omit=dev

if systemctl list-unit-files | grep -q "^ngpanel.service"; then
    systemctl restart ngpanel
    echo "✅ Service ngpanel redémarré."
else
    echo "⚠️ The ngpanel service does not exist yet — run deploy/install.sh first."
fi

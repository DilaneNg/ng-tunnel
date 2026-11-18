#!/bin/bash

cat << 'EOF' > /tmp/new_motd
#!/bin/bash
# Palette cohérente et visible — SANS BLANC
PRIMARY='\033[1;36m'   # Cyan Éclatant (Logo et Titre principal)
BLUE='\033[38;5;46m'      # Bleu Électrique (Textes informatifs et Liens)
SEP='\033[38;5;135m'       # Violet Pur / Magenta Éclatant (Séparateurs)
LABEL='\033[38;5;196m'     # Cyan pour les étiquettes (Tg, WA...)
ACTION='\033[1;31m'    # Rouge (Mot 'menu' pour l'action)
RESET='\033[0m'        # Reset

# Logo uniforme en Cyan Éclatant
echo -e "${PRIMARY}███╗   ██╗ ██████╗ ${RESET}"
echo -e "${PRIMARY}████╗  ██║██╔════╝${RESET}"
echo -e "${PRIMARY}██╔██╗ ██║██║  ███╗${RESET}"
echo -e "${PRIMARY}██║╚██╗██║██║   ██║${RESET}"
echo -e "${PRIMARY}██║ ╚████║╚██████╔╝${RESET}"
echo -e "${PRIMARY}╚═╝  ╚═══╝ ╚═════╝${RESET}"
echo -e ""
echo -e "${SEP}═══════════════════════════════════════════════════════${RESET}"
echo -e "${PRIMARY}                   NG-TUNNEL MANAGER                   ${RESET}"
echo -e "${SEP}═══════════════════════════════════════════════════════${RESET}"
echo -e "•${LABEL}Tg:${RESET}${BLUE}t.me/A_REMPLACER${RESET} •${LABEL}WA:${RESET}${BLUE}wa.me/A_REMPLACER${RESET}"
echo -e "•${LABEL}Gh:${RESET}${BLUE}github.com/DilaneNg${RESET}"
echo -e "${SEP}═══════════════════════════════════════════════════════${RESET}"
echo -e "${BLUE}        Welcome to NG TUNNEL VPN Server Manager.${RESET}"
echo -e "${BLUE}           Type ${ACTION}'menu'${RESET}${BLUE} to open the panel.${RESET}"
echo -e "${SEP}═══════════════════════════════════════════════════════${RESET}"
EOF

# 2. Déploiement dans le répertoire système
sudo mkdir -p /etc/update-motd.d
sudo cp /tmp/new_motd /etc/update-motd.d/99-ngtunnel-banner
sudo chmod +x /etc/update-motd.d/99-ngtunnel-banner

# 3. Suppression des résidus et scripts tiers 
sudo find /etc/update-motd.d/ -type f ! -name '99-ngtunnel-banner' -exec chmod -x {} + 2>/dev/null

# 4. Nettoyage des fichiers textes fixes
echo "" | sudo tee /etc/motd > /dev/null
echo "" | sudo tee /etc/issue > /dev/null
rm /tmp/new_motd

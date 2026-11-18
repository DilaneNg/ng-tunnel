#!/bin/bash
# Installed by NG TUNNEL deploy script.
# Certbot runs every script in /etc/letsencrypt/renewal-hooks/pre/ before attempting renewal.
systemctl is-active --quiet haproxy && systemctl stop haproxy
exit 0

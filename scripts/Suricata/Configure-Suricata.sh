#!/bin/bash

#
# Deploy Suricata IDS
# SOC Network Monitoring Platform
#

set -e


echo "[+] Starting Suricata deployment"


# Check root privileges

if [ "$EUID" -ne 0 ]; then
    echo "[!] Run this script as root"
    exit 1
fi


echo "[+] Updating package repository"

apt update


echo "[+] Installing Suricata"

apt install -y suricata suricata-update


echo "[+] Updating Suricata rules"

suricata-update


echo "[+] Testing configuration"

suricata -T -c /etc/suricata/suricata.yaml


echo "[+] Enabling Suricata service"

systemctl enable suricata


echo "[+] Starting Suricata"

systemctl restart suricata


echo "[+] Checking service status"

systemctl --no-pager status suricata


echo "[+] Checking loaded rules"

suricata --build-info


echo "[+] Suricata deployment completed successfully"
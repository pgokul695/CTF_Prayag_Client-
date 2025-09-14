#!/bin/bash
# CTF Environment Setup Script for Ubuntu
# Installs common tools via apt (and snap where noted) + sets up CTF domains for reverse proxy

set -euo pipefail
trap 'echo "[!] Error on line $LINENO. Exiting."; exit 1' ERR

# Change this to the IP address of your Nginx reverse proxy
REVERSE_PROXY_IP="10.0.9.132"

# Define your CTF domains (all mapped to REVERSE_PROXY_IP)
HOST_ENTRIES=(
    "$REVERSE_PROXY_IP   ctfd.prayag"
    "$REVERSE_PROXY_IP   welcome.ctf.prayag"
    "$REVERSE_PROXY_IP   webexploit.ctf.prayag"
    "$REVERSE_PROXY_IP   guess.ctf.prayag"
)

echo "[*] Updating package list..."
sudo apt update -y

echo "[*] Installing essentials..."
sudo apt install -y firefox vim curl wget jq git make cmake unzip apt-transport-https ca-certificates gnupg lsb-release

echo "[*] Installing VSCode (snap)..."
if ! command -v code &>/dev/null; then
    sudo snap install --classic code
fi

echo "[*] Installing compilers/interpreters..."
sudo apt install -y gcc g++ python3 python3-pip openjdk-21-jdk golang-go rustc perl ruby

echo "[*] Installing multimedia/audio editor (Audacity)..."
sudo apt install -y audacity

echo "[*] Installing binary exploitation & debugging tools..."
sudo apt install -y gdb radare2

echo "[*] Installing reverse engineering tools..."
sudo apt install -y apktool dex2jar

echo "[*] Installing cryptography tools..."
sudo apt install -y john hashcat sagemath

echo "[*] Installing forensics/stego tools..."
sudo apt install -y steghide foremost ffmpeg exiftool binwalk

echo "[*] Installing web exploitation tools..."
sudo apt install -y sqlmap gobuster nmap nikto

echo "[*] Installing networking tools..."
sudo apt install -y wireshark tshark tcpdump net-tools socat openvpn

echo "[*] Installing OSINT/misc tools..."
sudo apt install -y whois dnsutils theharvester

echo "[*] Adding CTF server entries to /etc/hosts..."
for entry in "${HOST_ENTRIES[@]}"; do
    if ! grep -qF "$entry" /etc/hosts; then
        echo "$entry" | sudo tee -a /etc/hosts >/dev/null
        echo "    [+] Added: $entry"
    else
        echo "    [-] Already present: $entry"
    fi
done

echo
echo "[*] All CTF tools installed (apt + snap) and hosts updated successfully!"

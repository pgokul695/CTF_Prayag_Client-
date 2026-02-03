#!/bin/bash
# Append CTF Nginx hosts to /etc/hosts safely

set -euo pipefail

REVERSE_PROXY_IP="10.0.9.132"

HOSTS=(
    "ctfd.ashwamedha"
    "welcome.ctf.ashwamedha"
    "resistance.ctf.ashwamedha"
    "lynx.ctf.ashwamedha"
    "assembly.ctf.ashwamedha"
)

echo "[*] Updating /etc/hosts..."

for host in "${HOSTS[@]}"; do
    entry="$REVERSE_PROXY_IP   $host"
    if ! grep -qE "^[0-9.]+\s+$host$" /etc/hosts; then
        echo "$entry" | sudo tee -a /etc/hosts >/dev/null
        echo "    [+] Added: $entry"
    else
        echo "    [-] Already exists: $host"
    fi
done

echo "[✓] Done."

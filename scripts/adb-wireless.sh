#!/bin/bash
# Auto-connect to Android device over Wireless Debugging via mDNS discovery.
# No manual IP:port entry needed — the port changes every time Wireless
# Debugging is toggled on the phone, this script re-discovers it each run.

set -euo pipefail

if adb devices | grep -q "device$"; then
    echo "Already connected: $(adb devices | grep 'device$')"
    exit 0
fi

adb start-server >/dev/null 2>&1
sleep 1

CANDIDATES=$(adb mdns services 2>/dev/null | grep "_adb-tls-connect._tcp" | awk '{print $NF}' | sort -u)

if [ -z "$CANDIDATES" ]; then
    echo "No device found via mDNS. Checklist on the phone:"
    echo "  - Wi-Fi and phone are on the same network as this Mac"
    echo "  - Settings > Developer options > Wireless debugging is ON"
    exit 1
fi

for target in $CANDIDATES; do
    echo "Trying $target ..."
    if adb connect "$target" 2>&1 | grep -q "connected"; then
        echo "Connected: $target"
        exit 0
    fi
done

echo "Found device(s) via mDNS but couldn't connect. If this is the first"
echo "time on this network, pair once from the phone's 'Pair device with"
echo "pairing code' screen:"
echo "  adb pair <ip>:<pairing_port>"
exit 1

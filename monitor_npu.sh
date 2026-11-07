#!/bin/bash
echo "=== NPU Load Monitor Started ==="
while true; do
    load=$(sudo cat /sys/kernel/debug/rknpu/load 2>/dev/null || echo "Permission denied")
    cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print int($1/1000)}')
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    printf "%s | Load: %s | Temp: %d°C\n" "$timestamp" "$load" "$cpu_temp"
    sleep 2
done
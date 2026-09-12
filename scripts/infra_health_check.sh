#!/bin/bash

LOG_FILE="/var/log/infra_health.log"
DISK_THRESHOLD=85
CONTAINER_NAME="techkraft_devops_trainee_asignment-app-1"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# --- CPU usage ---
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# --- RAM usage ---
RAM_USAGE=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100}')

# --- Disk usage (root partition) ---
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "----- Health Check: $TIMESTAMP -----"
echo "CPU Usage: ${CPU_USAGE}%"
echo "RAM Usage: ${RAM_USAGE}%"
echo "Disk Usage: ${DISK_USAGE}%"

# --- Docker running check ---
if ! systemctl is-active --quiet docker; then
    echo "[WARNING] Docker service is not running!"
    echo "$TIMESTAMP - [WARNING] Docker service is not running" >> "$LOG_FILE"
fi

# --- App container status check ---
CONTAINER_STATUS=$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)

if [ "$CONTAINER_STATUS" != "true" ]; then
    echo "[WARNING] Application container ($CONTAINER_NAME) is stopped!"
    echo "$TIMESTAMP - [WARNING] Application container is stopped" >> "$LOG_FILE"
fi

# --- Disk threshold check ---
if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    echo "[WARNING] Disk usage is above ${DISK_THRESHOLD}% (currently ${DISK_USAGE}%)"
    echo "$TIMESTAMP - [WARNING] Disk usage at ${DISK_USAGE}%, exceeds ${DISK_THRESHOLD}% threshold" >> "$LOG_FILE"
fi

echo "-------------------------------------"
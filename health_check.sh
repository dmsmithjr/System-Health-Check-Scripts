#!/bin/bash

# --- CONFIGURATION ---
DATE=$(date +%Y-%m-%d_%H%M%S)
LOG_FILE="health_report_$DATE.txt"
DISK_THRESHOLD=90 # Alert if disk usage exceeds 90%
HEALTH_STATUS="HEALTHY"

# Function to safely extract disk usage percentage
get_disk_usage() {
    # df / - Get disk usage for the root partition
    # awk 'NR==2 {print $5}' - Select the fifth column (usage %) from the second line
    # sed 's/%//g' - Remove the '%' sign for numeric comparison
    df / | awk 'NR==2 {print $5}' | sed 's/%//g'
}

# --- START REPORT GENERATION ---
echo "=========================================" > $LOG_FILE
echo "       SYSTEM HEALTH CHECK REPORT" >> $LOG_FILE
echo "=========================================" >> $LOG_FILE
echo "Date/Time of Check: $DATE" >> $LOG_FILE
echo "" >> $LOG_FILE


# --- UPTIME and LOAD AVERAGE CHECK ---
echo "--- UPTIME AND LOAD ---" >> $LOG_FILE
uptime >> $LOG_FILE
echo "" >> $LOG_FILE


# --- MEMORY (RAM) USAGE CHECK ---
echo "--- MEMORY (RAM) USAGE (in GB) ---" >> $LOG_FILE
# free -h displays the memory stats in human-readable format
free -h | grep -E 'total|Mem' >> $LOG_FILE 
echo "" >> $LOG_FILE


# --- DISK SPACE AND ALERTING ---
echo "--- DISK SPACE CHECK (Root Partition) ---" >> $LOG_FILE
# df -h / displays the human-readable disk stats for the root
df -h / >> $LOG_FILE 

DISK_USAGE=$(get_disk_usage)

if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    echo "ALERT: CRITICAL DISK USAGE! ($DISK_USAGE% used)" >> $LOG_FILE
    HEALTH_STATUS="UNHEALTHY"
else
    echo "Disk usage is normal ($DISK_USAGE% used)." >> $LOG_FILE
fi
echo "" >> $LOG_FILE


# --- CRITICAL SERVICE CHECK (SSHD) ---
echo "--- CRITICAL SERVICE CHECK (SSHD) ---" >> $LOG_FILE

# systemctl is-active --quiet sshd returns 0 (success) if service is running
if systemctl is-active --quiet sshd; then
    echo "SSHD Service: RUNNING" >> $LOG_FILE
else
    echo "ALERT: SSHD Service: STOPPED or FAILED" >> $LOG_FILE
    HEALTH_STATUS="UNHEALTHY"
fi
echo "" >> $LOG_FILE


# --- FINAL SUMMARY ---
echo "-----------------------------------------" >> $LOG_FILE
echo "Overall Health Status: $HEALTH_STATUS" >> $LOG_FILE
echo "=========================================" >> $LOG_FILE


# Output results to console and inform user
cat $LOG_FILE
echo ""
echo "Report successfully saved to: $LOG_FILE"

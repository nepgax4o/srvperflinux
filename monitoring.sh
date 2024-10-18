#!/bin/bash

echo "************ Server Performance Stats ************"
echo

# Total CPU usage
echo "Total CPU Usage:"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | \
           sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
           awk '{usage=100 - $1} END {print usage"%"}')
echo "CPU Usage: $CPU_USAGE"
echo

# Total memory usage
echo "Total Memory Usage:"
MEM_TOTAL=$(free -m | awk '/^Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/^Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/^Mem:/ {print $4}')
MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\",(${MEM_USED}/${MEM_TOTAL})*100}")
echo "Total: ${MEM_TOTAL}MB"
echo "Used: ${MEM_USED}MB"
echo "Free: ${MEM_FREE}MB"
echo "Memory Usage: ${MEM_PERCENT}%"
echo

# Total disk usage
echo "Total Disk Usage:"
DISK_TOTAL=$(df -h --total | grep 'total' | awk '{print $2}')
DISK_USED=$(df -h --total | grep 'total' | awk '{print $3}')
DISK_FREE=$(df -h --total | grep 'total' | awk '{print $4}')
DISK_PERCENT=$(df -h --total | grep 'total' | awk '{print $5}')
echo "Total: $DISK_TOTAL"
echo "Used: $DISK_USED"
echo "Free: $DISK_FREE"
echo "Disk Usage: $DISK_PERCENT"
echo

# Top 5 processes by CPU usage
echo "Top 5 Processes by CPU Usage:"
ps aux --sort=-%cpu | sed 1d | head -n 5
echo

# Top 5 processes by Memory usage
echo "Top 5 Processes by Memory Usage:"
ps aux --sort=-%mem | sed 1d | head -n 5
echo

# Stretch goals
echo "************ Additional Stats ************"
echo

# OS version
echo "Operating System Version:"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$NAME $VERSION"
else
    uname -a
fi
echo

# Uptime
echo "System Uptime:"
uptime -p
echo

# Load average
echo "Load Average:"
uptime | awk -F'load average:' '{ print $2 }'
echo

# Logged in users
echo "Logged in Users:"
who
echo

# Failed login attempts
echo "Failed Login Attempts (Last 5):"
if [ -f /var/log/btmp ]; then
    lastb | head -n 5
else
    echo "No failed login attempts found or /var/log/btmp not available."
fi
echo

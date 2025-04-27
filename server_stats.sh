#!/bin/bash

# Server Performance Statistics Script

# Function to display section headers
section_header() {
    echo "----------------------------------------"
    echo " $1"
    echo "----------------------------------------"
}

# Clear screen
clear

# Display current date and time
echo "Server Performance Statistics - $(date)"
echo ""

# 1. System Information
section_header "System Information"
echo "Hostname: $(hostname)"
echo "OS: $(cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo ""

# 2. CPU Usage
section_header "CPU Usage"
total_cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
echo "Total CPU Usage: $total_cpu_usage"
echo "Load Average: $(uptime | awk -F'load average: ' '{print $2}')"
echo ""

# 3. Memory Usage
section_header "Memory Usage"
free -h | awk '/^Mem:/ {print "Total: " $2, "Used: " $3, "Free: " $4, "Usage: " $3/$2 * 100 "%"}'
echo ""

# 4. Disk Usage
section_header "Disk Usage"
df -h | awk '/^\/dev\// {print $1 ": " $3 " used out of " $2 " (" $5 ")"}'
echo ""

# 5. Top Processes by CPU
section_header "Top 5 Processes by CPU Usage"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
echo ""

# 6. Top Processes by Memory
section_header "Top 5 Processes by Memory Usage"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo ""

# 7. User Information (Stretch Goal)
section_header "User Information"
echo "Logged in users:"
who
echo ""
echo "Failed login attempts (last 24h):"
journalctl --since "24 hours ago" | grep "Failed password" | wc -l
echo ""

# 8. Network Information (Stretch Goal)
section_header "Network Information"
echo "Active connections:"
ss -tulnp | grep -E 'tcp|udp'
echo ""
echo "IP Addresses:"
ip -4 addr show | grep inet
echo ""

# End of script
section_header "End of Report"
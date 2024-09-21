#! /bin/bash

PATH="$PATH:/usr/local/go/bin"

MEMORY=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%s", $5}')
CPU=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')
UPTIME=$(uptime | grep -Po '(?<=up )[^,]+')

printf "Memory\t\tDisk\t\tCPU\t\tUptime\n$MEMORY%%\t\t$DISK%\t\t$CPU%%\t\t$UPTIME" \
    | notify -bulk -silent -provider discord -id status

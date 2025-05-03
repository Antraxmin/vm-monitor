#!/bin/bash

source ./config.sh

check_thresholds() {
  local vm_name=$1
  local cpu=$2
  local mem=$3
  local disk=$4
  
  if (( $(echo "$cpu >= $CPU_CRITICAL" | bc -l) )); then
    send_alert "$vm_name" "CPU" "$cpu" "CRITICAL"
  elif (( $(echo "$cpu >= $CPU_WARNING" | bc -l) )); then
    send_alert "$vm_name" "CPU" "$cpu" "WARNING"
  fi
  
  if (( $(echo "$mem >= $MEM_CRITICAL" | bc -l) )); then
    send_alert "$vm_name" "Memory" "$mem" "CRITICAL"
  elif (( $(echo "$mem >= $MEM_WARNING" | bc -l) )); then
    send_alert "$vm_name" "Memory" "$mem" "WARNING"
  fi
  
  if (( $(echo "$disk >= $DISK_CRITICAL" | bc -l) )); then
    send_alert "$vm_name" "Disk" "$disk" "CRITICAL"
  elif (( $(echo "$disk >= $DISK_WARNING" | bc -l) )); then
    send_alert "$vm_name" "Disk" "$disk" "WARNING"
  fi
}

send_alert() {
  local vm_name=$1
  local metric=$2
  local value=$3
  local level=$4
  local timestamp=$(date)
  
  echo "[$timestamp] $level alert for $vm_name: $metric usage at $value%" >> "./logs/alerts.log"
  
  if [[ "$ENABLE_EMAIL_ALERTS" == true ]]; then
    echo "Alert: $vm_name $metric usage at $value% ($level)" | mail -s "VM Monitor Alert: $level" $EMAIL_ADDRESS
  fi
}
#!/bin/bash

source ./config.sh
source ./lib/utils.sh

get_cpu_usage() {
  local vm_user_host=$1
  ssh -o ConnectTimeout=5 -o BatchMode=yes $vm_user_host "top -bn1 | grep 'Cpu(s)' | awk '{print \$2+\$4}'" 2>/dev/null || echo "0"
}

get_memory_usage() {
  local vm_user_host=$1
  ssh -o ConnectTimeout=5 -o BatchMode=yes $vm_user_host "free | grep Mem | awk '{print \$3/\$2 * 100}'" 2>/dev/null || echo "0"
}

get_disk_usage() {
  local vm_user_host=$1
  ssh -o ConnectTimeout=5 -o BatchMode=yes $vm_user_host "df -h / | grep / | awk '{print \$5}' | sed 's/%//'" 2>/dev/null || echo "0"
}

collect_all_metrics() {
  local timestamp=$(date +%s)
  
  for vm in "${VMS[@]}"; do
    local vm_name=${vm%%:*}
    local vm_user_host=${vm#*:}
    
    echo "Collecting metrics from $vm_name..."
    
    if test_ssh_connection $vm_user_host; then
      local cpu=$(get_cpu_usage $vm_user_host)
      local mem=$(get_memory_usage $vm_user_host)
      local disk=$(get_disk_usage $vm_user_host)
      
      ensure_data_directory "$vm_name"
      echo "$timestamp,$cpu,$mem,$disk" >> "./data/$vm_name.csv"
      
      check_thresholds "$vm_name" "$cpu" "$mem" "$disk"
    else
      log_error "Cannot connect to $vm_name ($vm_user_host)"
    fi
  done
}
#!/bin/bash

source ./config.sh

NORMAL="\033[0m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"

show_header() {
  clear
  echo "===================================="
  echo "            VM monitor         "
  echo "===================================="
  echo "current: $(date)"
  echo "VM being monitored: ${#VMS[@]}"
  echo "===================================="
}

get_color_by_value() {
  local value=$1
  local warning=$2
  local critical=$3
  
  if (( $(echo "$value >= $critical" | bc -l) )); then
    echo -e $RED
  elif (( $(echo "$value >= $warning" | bc -l) )); then
    echo -e $YELLOW
  else
    echo -e $GREEN
  fi
}

create_bar_graph() {
  local value=$1
  local max_length=20
  local bar_length=$(echo "$value * $max_length / 100" | bc -l | awk '{print int($1)}')
  
  local color=$(get_color_by_value $value $2 $3)
  local bar=""
  
  for ((i=0; i<bar_length; i++)); do
    bar="${bar}█"
  done
  
  for ((i=bar_length; i<max_length; i++)); do
    bar="${bar}░"
  done
  
  echo -e "${color}${bar}${NORMAL} ${value}%"
}

show_vm_status() {
  local vm_name=$1
  local latest_data=$(tail -n 1 "./data/${vm_name}.csv")
  
  IFS=',' read -r timestamp cpu mem disk <<< "$latest_data"
  
  echo "VM: $vm_name"
  echo -n "  CPU: "
  create_bar_graph $cpu $CPU_WARNING $CPU_CRITICAL
  echo -n "  memory: "
  create_bar_graph $mem $MEM_WARNING $MEM_CRITICAL
  echo -n "  disk: "
  create_bar_graph $disk $DISK_WARNING $DISK_CRITICAL
  echo "-----------------------------------"
}

update_dashboard() {
  show_header
  
  for vm in "${VMS[@]}"; do
    local vm_name=${vm%%:*}
    show_vm_status "$vm_name"
  done
  
  echo "===================================="
  echo "q: exit | r: refresh"
  echo "===================================="
}
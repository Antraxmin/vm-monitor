#!/bin/bash

source ./config.sh
source ./lib/collect_metrics.sh
source ./lib/display.sh
source ./lib/alert.sh
source ./lib/utils.sh

mkdir -p ./data ./logs

DAEMON_MODE=false
if [[ "$1" == "--daemon" ]]; then
  DAEMON_MODE=true
fi

interactive_mode() {
  while true; do
    collect_all_metrics
    update_dashboard
    
    read -t $REFRESH_INTERVAL -n 1 key
    
    if [[ "$key" == "q" ]]; then
      echo "stop monitoring..."
      exit 0
    elif [[ "$key" == "r" ]]; then
      echo "refreshing..."
    fi
  done
}

daemon_mode() {
  echo "Start VM monitoring in daemon mode."
  echo "log file path: ./logs/monitor.log"
  
  while true; do
    collect_all_metrics >> ./logs/monitor.log 2>&1
    sleep $REFRESH_INTERVAL
  done
}

if [[ "$DAEMON_MODE" == true ]]; then
  daemon_mode
else
  interactive_mode
fi
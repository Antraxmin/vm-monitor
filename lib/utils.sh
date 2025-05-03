#!/bin/bash

log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message" >> ./logs/monitor.log
}

log_info() {
    log_message "INFO" "$1"
}

log_warning() {
    log_message "WARNING" "$1"
}

log_error() {
    log_message "ERROR" "$1"
}

test_ssh_connection() {
    local vm_user_host=$1
    ssh -o BatchMode=yes -o ConnectTimeout=5 $vm_user_host "echo 2>&1" >/dev/null
    return $?
}

get_latest_value() {
    local file=$1
    local column=$2
    
    if [[ ! -f "$file" ]]; then
        echo "0"
        return
    fi
    
    tail -n 1 "$file" | cut -d',' -f$column
}

format_percentage() {
    local value=$1
    printf "%.1f" $value
}

clamp_value() {
    local value=$1
    if (( $(echo "$value > 100" | bc -l) )); then
        echo "100"
    elif (( $(echo "$value < 0" | bc -l) )); then
        echo "0"
    else
        echo "$value"
    fi
}

is_greater_than() {
    local value=$1
    local threshold=$2
    
    if (( $(echo "$value > $threshold" | bc -l) )); then
        return 0
    else
        return 1
    fi
}

truncate_string() {
    local str=$1
    local max_length=$2
    
    if [[ ${#str} -gt $max_length ]]; then
        echo "${str:0:$max_length-3}..."
    else
        echo "$str"
    fi
}

readonly COLOR_RESET="\033[0m"
readonly COLOR_RED="\033[31m"
readonly COLOR_GREEN="\033[32m"
readonly COLOR_YELLOW="\033[33m"
readonly COLOR_BLUE="\033[34m"
readonly COLOR_MAGENTA="\033[35m"
readonly COLOR_CYAN="\033[36m"
readonly COLOR_WHITE="\033[37m"
readonly COLOR_BOLD="\033[1m"

print_colored() {
    local color=$1
    local text=$2
    echo -e "${color}${text}${COLOR_RESET}"
}

ensure_data_directory() {
    local vm_name=$1
    
    if [[ ! -d "./data" ]]; then
        mkdir -p "./data"
    fi
    
    if [[ ! -f "./data/${vm_name}.csv" ]]; then
        echo "timestamp,cpu,memory,disk" > "./data/${vm_name}.csv"
    fi
}

ensure_log_directory() {
    if [[ ! -d "./logs" ]]; then
        mkdir -p "./logs"
    fi
}

clear_screen() {
    tput clear
    tput cup 0 0
}

wait_for_key() {
    local timeout=$1
    local key
    
    read -t $timeout -n 1 key
    echo $key
}

get_vm_names() {
    local vm_names=()
    
    for vm in "${VMS[@]}"; do
        local vm_name=${vm%%:*}
        vm_names+=("$vm_name")
    done
    
    echo "${vm_names[@]}"
}

time_diff_seconds() {
    local timestamp1=$1
    local timestamp2=$2
    
    echo $(( timestamp2 - timestamp1 ))
}

format_duration() {
    local seconds=$1
    
    if [[ $seconds -lt 60 ]]; then
        echo "${seconds}s"
    elif [[ $seconds -lt 3600 ]]; then
        echo "$((seconds / 60))m $((seconds % 60))s"
    else
        echo "$((seconds / 3600))h $(((seconds % 3600) / 60))m $((seconds % 60))s"
    fi
}

is_already_running() {
    pgrep -f "$(basename $0)" | grep -v $$ >/dev/null
    return $?
}

get_file_size() {
    local file=$1
    
    if [[ -f "$file" ]]; then
        du -k "$file" | cut -f1
    else
        echo "0"
    fi
}

rotate_log() {
    local log_file=$1
    local max_size=$2  
    
    if [[ $(get_file_size "$log_file") -gt $max_size ]]; then
        local timestamp=$(date "+%Y%m%d%H%M%S")
        mv "$log_file" "${log_file}.${timestamp}"
        touch "$log_file"
        log_info "${log_file} -> ${log_file}.${timestamp}"
    fi
}
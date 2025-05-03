#!/bin/bash

VMS=(
  "vm1:user@vm1_ip"
  "vm2:user@vm2_ip"
  # Add more VMs 
)

CPU_WARNING=70
CPU_CRITICAL=90
MEM_WARNING=80
MEM_CRITICAL=95
DISK_WARNING=75
DISK_CRITICAL=90

REFRESH_INTERVAL=5

# email alert (beta)
ENABLE_EMAIL_ALERTS=true
EMAIL_ADDRESS="your@email.com"
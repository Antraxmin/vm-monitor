#!/bin/bash

echo "Start installing VM Monitoring Dashboard..."

echo "Install the required package..."
sudo apt-get update
sudo apt-get install -y bc sshpass curl mailutils

echo "Create directory structure..."
mkdir -p lib logs data

echo "Grant execute permission to the script file..."
chmod +x monitor.sh
chmod +x lib/*.sh

echo "installation has been completed!"
echo "Edit config.sh file to update VM information and settings"
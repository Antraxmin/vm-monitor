# VM Monitor
VM Monitor is a terminal-based tool that provides **real-time monitoring of system resources across multiple Linux virtual machines**. Built entirely with shell scripts, it offers a centralized view of CPU, memory, and disk usage with visual indicators and configurable alerts.

<p float="left">
  <img src="https://velog.velcdn.com/images/antraxmin/post/71d79638-383a-4f97-9970-cefdcaf12e74/image.png" width="30%" />
  <img src="https://velog.velcdn.com/images/antraxmin/post/4af4fbec-c9c1-47b4-9f1e-d4f2f883a264/image.png" width="58%" />
</p>

## Features
- Monitor multiple VMs from a central location
- Track CPU, memory, and disk usage with automatic refreshing
- ASCII bar graphs with color-coded status indicators
- Configurable warning and critical thresholds with notification system
- Run in interactive mode with a dashboard UI or as a background daemon
- Minimal dependencies, works on any Linux system with SSH access

## Requirements
- Linux/Unix environment
- Bash shell
- SSH access to target VMs
- Core utilities: bc, curl, mail (optional)

## Installation

#### 1. Clone this repository
```bash
git clone https://github.com/yourusername/vm-monitor.git
cd vm-monitor
```

#### 2. Run the installation script
```bash
./install.sh
```

### Configure your VM settings
```bash
vi config.sh
```


## Configuration
Edit `config.sh` to set up your VMs and alert thresholds

```bash
VMS=(
  "vm1:user@vm1_ip"
  "vm2:user@vm2_ip"
  # Add more VMs 
)

# Threshold settings (%)
CPU_WARNING=70
CPU_CRITICAL=90
MEM_WARNING=80
MEM_CRITICAL=95
DISK_WARNING=75
DISK_CRITICAL=90

# Monitoring interval (seconds)
REFRESH_INTERVAL=5

# Alert settings (beta)
ENABLE_EMAIL_ALERTS=true
EMAIL_ADDRESS="your@email.com"
````

## Usage
### Interactive Mode
Run the dashboard in interactive mode with:

```bash
./monitor.sh
```
In this mode, you'll see a real-time dashboard with color-coded resource bars.

- `q` to quit
- `r` to manually refresh

### Daemon Mode
Run the monitoring script in the background:

```bash
./monitor.sh --daemon
```
This will collect metrics and trigger alerts without displaying the dashboard.

## Project Structure
```
vm-monitor/
├── README.md                   
├── install.sh                      # Dependency installation script
├── config.sh                       # Configuration file
├── monitor.sh                      # Main monitoring script
├── lib/
│   ├── collect_metrics.sh          # Metric collection functions
│   ├── display.sh                  # Dashboard display functions
│   ├── alert.sh                    # Alert management functions
│   └── utils.sh                    # Utility functions
├── logs/                       # Log directory
└── data/                       # Metrics data directory
````

## Setting Up Test Environment
For testing purposes, you can use Multipass to create VMs:

```
multipass launch --name test-vm1
multipass launch --name test-vm2
multipass launch --name test-vm3
```

## Working on...
- Monitoring major system service health
- Verifying Port Accessibility
- Automate service restart options
- Network performance metrics
- Disk cleanup automation
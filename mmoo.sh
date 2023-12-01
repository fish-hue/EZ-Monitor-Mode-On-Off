#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run the script as root"
  exit
fi

# Function to list available USB Wi-Fi antennas
list_interfaces() {
  iw dev | awk '$1=="Interface"{print $2}'
}

# Function to enable monitor mode on a selected interface
enable_monitor_mode() {
  echo "Available USB Wi-Fi antennas:"
  list_interfaces

  read -p "Enter the interface name to enable monitor mode: " interface

  if [[ -z "$interface" ]]; then
    echo "Invalid input. Exiting..."
    exit 1
  fi

  sudo iw dev "$interface" set monitor none
  echo "Monitor mode enabled on interface: $interface"
}

# Function to disable monitor mode on selected interface
disable_monitor_mode() {
  echo "Available USB Wi-Fi antennas in monitor mode:"
  list_interfaces

  read -p "Enter the interface name to disable monitor mode: " interface

  if [[ -z "$interface" ]]; then
    echo "Invalid input. Exiting..."
    exit 1
  fi

  sudo iw dev "$interface" set type managed
  echo "Monitor mode disabled on interface: $interface"
}

# Main menu
echo "1. Enable monitor mode"
echo "2. Disable monitor mode"
echo "3. Exit"

read -p "Enter your choice: " choice

case $choice in
  "1")
    enable_monitor_mode
    ;;
  "2")
    disable_monitor_mode
    ;;
  "3")
    exit 0
    ;;
  *)
    echo "Invalid choice. Exiting..."
    exit 1
    ;;
esac

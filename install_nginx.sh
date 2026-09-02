#!/bin/bash

# Script to install and start Nginx on Ubuntu EC2
# Author: Your Name
# Usage: sudo bash install_nginx.sh

# Exit on error
set -e

echo "============================"
echo " Starting Nginx Installation "
echo "============================"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (use sudo)."
  exit 1
fi

# Update package lists
echo "Updating system packages..."
apt update -y

# Install Nginx
echo "Installing Nginx..."
apt install -y nginx

# Enable Nginx to start on boot
echo "Enabling Nginx service..."
systemctl enable nginx

# Start Nginx service
echo "Starting Nginx service..."
systemctl start nginx

# Check Nginx status
echo "Checking Nginx status..."
systemctl status nginx --no-pager

# Display server IP (helpful for EC2 users)
# PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "unknown")
echo "======================================="
echo "Nginx installation completed successfully!"
echo "You can visit your server at: http://$PUBLIC_IP"
echo "======================================="
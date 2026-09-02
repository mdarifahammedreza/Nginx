#!/bin/bash

# Script to install Docker and Docker Compose on Ubuntu (EC2-ready)
# Author: Your Name
# Usage: sudo bash install_docker.sh

set -e  # Exit on error

echo "======================================"
echo "   Starting Docker Installation...    "
echo "======================================"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root."
  exit 1
fi

# Step 1: Update system packages
echo "Updating package index..."
apt update -y

# Step 2: Install dependencies
echo "Installing prerequisites..."
apt install -y ca-certificates curl gnupg lsb-release

# Step 3: Add Docker’s official GPG key
echo "Adding Docker’s GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Step 4: Set up the Docker repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 5: Install Docker Engine, CLI, containerd, and Compose plugin
echo "Installing Docker Engine and Docker Compose..."
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 6: Enable and start Docker
echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

# Step 7: Create docker group if not exists
echo "Creating docker group (if not exists)..."
groupadd docker || true

# Step 8: Add current user to docker group
USER_NAME=${SUDO_USER:-$USER}
echo "Adding user '$USER_NAME' to docker group..."
usermod -aG docker "$USER_NAME"

# Step 9: Refresh group membership (no logout needed)
echo "Refreshing group membership..."
newgrp docker <<EONG
docker --version
docker compose version
EONG

# Step 10: Verify Docker is running
echo "Verifying Docker installation..."
docker run --rm hello-world || true

echo "======================================"
echo " Docker + Docker Compose Installed!   "
echo "======================================"
echo "You can now run Docker without sudo."
echo "If you still face permission issues, log out and back in."

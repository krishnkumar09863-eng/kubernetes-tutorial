#!/bin/bash

# ============================================
# KIND Installation Script for AWS EC2 Ubuntu
# ============================================

set -e

echo "======================================"
echo "Updating Ubuntu Packages..."
echo "======================================"

sudo apt update && sudo apt upgrade -y

echo "======================================"
echo "Installing Required Packages..."
echo "======================================"

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "======================================"
echo "Adding Docker GPG Key..."
echo "======================================"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "======================================"
echo "Adding Docker Repository..."
echo "======================================"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "======================================"
echo "Updating Package List..."
echo "======================================"

sudo apt update

echo "======================================"
echo "Installing Docker..."
echo "======================================"

sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "======================================"
echo "Starting Docker Service..."
echo "======================================"

sudo systemctl start docker
sudo systemctl enable docker

echo "======================================"
echo "Adding Current User to Docker Group..."
echo "======================================"

sudo usermod -aG docker $USER
newgrp docker

echo "======================================"
echo "Installing kubectl..."
echo "======================================"

curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

echo "======================================"
echo "Installing KIND..."
echo "======================================"

curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64

chmod +x ./kind

sudo mv ./kind /usr/local/bin/kind

echo "======================================"
echo "Verifying Installations..."
echo "======================================"

echo "Docker Version:"
docker --version

echo ""
echo "kubectl Version:"
kubectl version --client

echo ""
echo "KIND Version:"
kind --version

echo "======================================"
echo "Creating KIND Cluster..."
echo "======================================"

kind create cluster

echo "======================================"
echo "Checking Kubernetes Nodes..."
echo "======================================"

kubectl get nodes

echo "======================================"
echo "Checking Docker Containers..."
echo "======================================"

docker ps

echo "======================================"
echo "KIND Installation Completed Successfully!"
echo "======================================"

echo ""
echo "IMPORTANT:"
echo "Logout and login again OR run:"
echo "newgrp docker"
echo ""
echo "to use Docker without sudo."

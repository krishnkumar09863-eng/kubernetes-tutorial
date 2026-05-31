# Minikube Installation Guide

This README explains how to install Docker, kubectl, and Minikube on Ubuntu, then start a local Minikube cluster using the Docker driver.

## Requirements
- Ubuntu-based Linux distribution
- Internet access
- sudo privileges

## Overview
This guide covers:
- updating the system,
- installing Docker,
- enabling and starting Docker,
- adding the current user to the Docker group,
- installing kubectl,
- installing Minikube,
- starting a multi-node Minikube cluster, and
- verifying the cluster.

## Installation Steps

### 1. Update System
Update package lists and install available upgrades.

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Docker
Install Docker from the Ubuntu package repositories.

```bash
sudo apt install -y docker.io
```

### 3. Enable and Start Docker
Enable Docker to start on boot, then start the service immediately.

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

### 4. Add User to Docker Group
Add the current user to the Docker group and refresh the group membership.

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### 5. Verify Docker
Check Docker installation and ensure the daemon is running.

```bash
docker --version
docker ps
```

### 6. Install kubectl
Download kubectl, make it executable, and install it to `/usr/local/bin/`.

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo install kubectl /usr/local/bin/
```

Verify kubectl:

```bash
kubectl version --client
```

### 7. Install Minikube
Download the latest Minikube binary and install it.

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### 8. Verify Minikube
Confirm Minikube is installed correctly.

```bash
minikube version
```

### 9. Start Minikube (Docker Driver)
Start a Minikube cluster using the Docker driver with 3 nodes.

```bash
minikube start --driver=docker --nodes=3
```

### 10. Verify Cluster
Verify the Kubernetes cluster and control plane status.

```bash
kubectl get nodes
kubectl cluster-info
```

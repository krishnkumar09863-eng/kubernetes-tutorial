# Installing KIND (Kubernetes IN Docker) on AWS EC2 Ubuntu Instance

## What is KIND?

KIND (Kubernetes IN Docker) lets you run Kubernetes clusters using Docker containers as Kubernetes nodes.

Instead of creating multiple virtual machines, KIND uses lightweight Docker containers for:

- Kubernetes control plane nodes
- Worker nodes

Benefits:

- Lightweight
- Fast
- Beginner-friendly
- Great for DevOps practice and CI/CD testing

---

## How KIND Works

Kubernetes usually requires multiple servers or VMs.

KIND runs a Kubernetes cluster inside Docker on a single host:

```text
AWS EC2 Ubuntu Server
        ↓
      Docker
        ↓
KIND creates Docker containers
        ↓
Containers behave like Kubernetes nodes
```

Example node names:

```text
kind-control-plane   → Control plane node
kind-worker          → Worker node
```

---

## Recommended AWS EC2 Instance

### Recommended:

`t3.medium`

### Why?

Kubernetes and Docker need memory, and 4 GB is the practical minimum for a small KIND cluster.

| Instance Type | RAM | Suitable? |
|---|---|---|
| t2.micro | 1 GB | ❌ Very slow |
| t3.micro | 1 GB | ❌ Not recommended |
| t3.small | 2 GB | ⚠️ Basic only |
| t3.medium | 4 GB | ✅ Best beginner choice |

---

## Recommended Ubuntu AMI

Use:

```text
Ubuntu Server 22.04 LTS
```

---

# Prerequisites

- AWS EC2 instance running Ubuntu 22.04
- SSH access to the instance
- A non-root user with `sudo` privileges (Ubuntu default user is `ubuntu`)

---

# Step 1 — Connect to EC2 Instance

From your local machine:

```bash
ssh -i your-key.pem ubuntu@YOUR_PUBLIC_IP
```

Example:

```bash
ssh -i devops-key.pem ubuntu@13.233.xx.xx
```

---

# Step 2 — Update Ubuntu Packages

```bash
sudo apt update && sudo apt upgrade -y
```

---

# Step 3 — Install Docker

Install required packages:

```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
```

Add Docker’s GPG key:

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Add the Docker repository:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update package lists and install Docker Engine:

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

---

# Step 4 — Verify Docker Installation

Check the Docker version:

```bash
docker --version
```

Expected result should show a Docker version number.

Check Docker service status:

```bash
sudo systemctl status docker
```

Look for:

```text
Active: active (running)
```

Press `q` to exit the status view.

---

# Step 5 — Install KIND

Install KIND using the official release binary:

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

Verify KIND:

```bash
kind --version
```

---

# Step 6 — Create a KIND Cluster

Create a cluster with the default configuration:

```bash
kind create cluster --name kind-cluster
```

If the cluster is created successfully, KIND will print the kubeconfig path.

---

# Step 7 — Verify the Kubernetes Cluster

Install `kubectl` if it is not already installed:

```bash
sudo apt install -y kubectl
```

Check cluster status:

```bash
kubectl cluster-info --context kind-kind-cluster
kubectl get nodes
```

Expected output includes the `kind-control-plane` node in `Ready` state.

---

# Step 8 — Clean Up

Delete the KIND cluster when you're done:

```bash
kind delete cluster --name kind-cluster
```

---

## Notes

- If Docker commands require `sudo`, keep using `sudo` or add your user to the `docker` group.
- KIND is intended for local/test clusters, not production workloads.
- Use `kind load docker-image` to load images into the cluster if needed.

to exit status screen.

---

# Step 6 — Enable Docker at Boot

```bash
sudo systemctl enable docker
```

## Explanation

Docker will automatically start after reboot.

---

# Step 7 — Enable Non-Root Docker Access

By default Docker requires sudo.

We will allow normal user access.

---

## Add Current User to Docker Group

```bash
sudo usermod -aG docker $USER
```

---

## Apply Group Changes

```bash
newgrp docker
```

---

## Test Docker Without sudo

```bash
docker ps
```

## Expected Output

```text
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

If no error appears, Docker access is working.

---

# Step 8 — Install kubectl

## Download kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

---

## Make kubectl Executable

```bash
chmod +x kubectl
```

---

## Move kubectl to System Path

```bash
sudo mv kubectl /usr/local/bin/
```

---

# Step 9 — Verify kubectl Installation

## Command

```bash
kubectl version --client
```

## Expected Output

```text
Client Version: v1.xx.x
```

---

# Step 10 — Install KIND

## Download KIND Binary

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
```

---

## Make KIND Executable

```bash
chmod +x ./kind
```

---

## Move KIND to System Path

```bash
sudo mv ./kind /usr/local/bin/kind
```

---

# Step 11 — Verify KIND Installation

## Command

```bash
kind --version
```

## Expected Output

```text
kind version 0.xx.x
```

---

# Step 12 — Create Your First KIND Cluster

## Command

```bash
kind create cluster
```

---

# What Happens Internally?

KIND will:

1. Pull Kubernetes node image
2. Create Docker containers
3. Configure Kubernetes
4. Start cluster

---

# Expected Output

```text
Creating cluster "kind" ...
 ✓ Ensuring node image
 ✓ Preparing nodes
 ✓ Writing configuration
 ✓ Starting control-plane
 ✓ Installing CNI
 ✓ Installing StorageClass

Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info
```

---

# Step 13 — Verify Cluster

## Check Nodes

```bash
kubectl get nodes
```

## Expected Output

```text
NAME                 STATUS   ROLES           AGE   VERSION
kind-control-plane   Ready    control-plane   1m    v1.xx.x
```

---

# Step 14 — Check Docker Containers Used as Nodes

## Command

```bash
docker ps
```

## Expected Output

```text
CONTAINER ID   IMAGE      NAMES
xxxxx          kindest/node   kind-control-plane
```

This proves:

✅ Kubernetes node is actually a Docker container.

---

# Step 15 — Check Cluster Information

```bash
kubectl cluster-info
```

## Expected Output

```text
Kubernetes control plane is running at https://127.0.0.1:xxxxx
CoreDNS is running at ...
```

---

# Delete Cluster (Optional)

If you want to remove the cluster:

```bash
kind delete cluster
```

---

# Common Troubleshooting

# 1. Docker Permission Denied

## Error

```text
permission denied while trying to connect to Docker daemon
```

## Fix

Run:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Or reconnect SSH session.

---

# 2. KIND Cluster Creation Fails

## Cause

Usually low RAM.

## Fix

Use:

```text
t3.medium
```

instead of t2.micro.

---

# 3. kubectl Command Not Found

## Fix

Check:

```bash
echo $PATH
```

Ensure:

```text
/usr/local/bin
```

exists in PATH.

---

# 4. Docker Service Not Running

## Fix

Start Docker manually:

```bash
sudo systemctl start docker
```

---

# 5. Unable to Pull Images

## Cause

Internet or Security Group issue.

## Fix

Ensure EC2 Security Group allows:

```text
Outbound Internet Access
```

---

# Useful KIND Commands

## List Clusters

```bash
kind get clusters
```

---

## Export Cluster Logs

```bash
kind export logs
```

---

## View Kubernetes Pods

```bash
kubectl get pods -A
```

---

# Final Architecture Overview

```text
AWS EC2 Ubuntu
      ↓
   Docker Engine
      ↓
KIND creates containers
      ↓
Containers become Kubernetes Nodes
      ↓
kubectl manages the cluster
```

---


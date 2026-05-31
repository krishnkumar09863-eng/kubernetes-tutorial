#!/bin/bash

# update ubuntu packages
sudo apt update && sudo apt upgrade -y

# install docker
sudo apt install docker.io -y

# enable docker service
sudo systemctl enable docker

# start docker
sudo systemctl start docker

# add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# verify docker installation
docker --version
docker ps

# install kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# verify kind installation
kind version

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# verify kubectl
kubectl version --client

# create kind config file
cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

# create kubernetes cluster
kind create cluster --name dev-cluster --config kind-config.yaml

# verify cluster
kind get clusters
kubectl get nodes

# delete cluster when done
# kind delete cluster --name dev-cluster

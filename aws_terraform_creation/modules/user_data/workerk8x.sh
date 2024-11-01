#!/bin/bash
# Update the package index
sudo apt update -y
# Install essential tools
sudo apt install -y curl wget git
# Install Docker
sudo apt install -y docker.io
sudo usermod -aG docker $(whoami)
newgrp docker
sudo chmod 777 /var/run/docker.sock
# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
# Set up Kubernetes repository
sudo apt install -y apt-transport-https ca-certificates gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Install Kubernetes components
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
#Install and Configure Node Exporter
sudo useradd --system --no-create-home --shell /bin/false node_exporter
#Download and install Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar xvf node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter*
#Create a Node Exporter service file
cat <<EOL | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9101

[Install]
WantedBy=multi-user.target
EOL
#Start and enable Node Exporter service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
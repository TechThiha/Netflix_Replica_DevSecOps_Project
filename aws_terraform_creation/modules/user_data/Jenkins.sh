#!/bin/bash
sudo apt update -y
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
sudo apt update -y
sudo apt install temurin-17-jdk -y
/usr/bin/java --version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y
#install docker
sudo apt update -y
sudo apt install docker.io docker-compose -y
sudo usermod -aG docker ubuntu  
newgrp docker
sudo chmod 777 /var/run/docker.sock
# Create a temporary directory
temp_dir="/tmp/docker_compose"
mkdir -p "$temp_dir"
cat > "$temp_dir/docker-compose.yml" <<EOF
version: "3"
services:
  sonarqube:
    image: sonarqube:latest
    ports:
      - "9000:9000"
    environment:
      - SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar
      - SONAR_JDBC_USERNAME=sonar
      - SONAR_JDBC_PASSWORD=sonar
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    depends_on:
      - db

  db:
    image: postgres:12
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
  postgresql:
  postgresql_data:
EOF
# Run Docker Compose
cd $temp_dir
docker-compose up -d
cd
# install trivy
sudo apt install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update -y
sudo apt install trivy -y
#install Grafana on Jenkins Server
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt update -y
sudo apt install grafana -y
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
#install Kubectl on Jenkins Server
sudo apt update -y
sudo apt install curl -y
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
#Create a system user for Prometheus
sudo useradd --system --no-create-home --shell /bin/false prometheus
#Create directories for Prometheus
sudo mkdir -p /data /etc/prometheus
#Download and install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.53.2/prometheus-2.53.2.linux-amd64.tar.gz
tar -xvf prometheus-2.53.2.linux-amd64.tar.gz
sudo mv prometheus-2.53.2.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-2.53.2.linux-amd64/promtool /usr/local/bin/
sudo mv prometheus-2.53.2.linux-amd64/consoles/ /etc/prometheus/
sudo mv prometheus-2.53.2.linux-amd64/console_libraries/ /etc/prometheus/
sudo mv prometheus-2.53.2.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
#Configure Prometheus
cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:7718"]

  - job_name: node_export
    static_configs:
      - targets: ["localhost:9101"]

  - job_name: 'Jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['localhost:8080']
EOL
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
rm -rf prometheus-2.53.2.linux-amd64
rm -f prometheus-2.53.2.linux-amd64.tar.gz
#Create a Prometheus service file
cat <<EOL | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:7718 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
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
#Check Prometheus configuration and reload
promtool check config /etc/prometheus/prometheus.yml
curl -X POST http://localhost:7718/-/reload
sleep 60
sudo chown -R jenkins:jenkins /var/lib/jenkins/workspace
sudo chmod -R 755 /var/lib/jenkins/workspace
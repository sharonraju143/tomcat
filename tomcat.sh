#!/bin/bash

# Update package list and install Java (if not already installed)
sudo apt update
sudo apt install default-jdk -y

# Create a Tomcat user
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

# Download Tomcat (adjust the version as needed)
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz -P /tmp

# Extract and move Tomcat files
sudo tar xf /tmp/apache-tomcat-9.0.80.tar.gz -C /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-9.0.80 /opt/tomcat/latest

# Set ownership and permissions
sudo chown -R tomcat: /opt/tomcat/latest
sudo chmod +x /opt/tomcat/latest/bin/*.sh
sudo chmod +x /opt/tomcat/latest/bin/startup.sh


# Create a systemd service file for Tomcat
echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/default-java
Environment=CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat/latest
Environment=CATALINA_BASE=/opt/tomcat/latest
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/tomcat.service

# Reload systemd and start Tomcat service
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

#!/bin/bash

# Install necessary packages
sudo apt-get update
sudo apt-get install -y default-jdk

# Create a tomcat user and group
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

# Download and extract Tomcat
TOMCAT_VERSION="9.0.80"  # Update to the desired version
wget https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -P /tmp
tar xf /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat

# Set proper ownership and permissions
chown -R tomcat:tomcat /opt/tomcat/apache-tomcat-${TOMCAT_VERSION}
chmod +x /opt/tomcat/apache-tomcat-${TOMCAT_VERSION}/bin/*.sh

# Create a systemd service file
cat << EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/default-java
Environment=CATALINA_PID=/opt/tomcat/apache-tomcat-${TOMCAT_VERSION}/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat/apache-tomcat-${TOMCAT_VERSION}
Environment=CATALINA_BASE=/opt/tomcat/apache-tomcat-${TOMCAT_VERSION}
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
ExecStart=/opt/tomcat/apache-tomcat-${TOMCAT_VERSION}/bin/startup.sh
ExecStop=/opt/tomcat/apache-tomcat-${TOMCAT_VERSION}/bin/shutdown.sh
User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Tomcat
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

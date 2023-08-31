#!/bin/bash

# Update package repositories
sudo apt update
sudo apt upgrade -y

# Install Java 11
sudo apt install openjdk-11-jdk -y

# Download Tomcat 9
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.54/bin/apache-tomcat-9.0.80.tar.gz

# Extract Tomcat archive
tar -xf apache-tomcat-9.0.80.tar.gz

# Move Tomcat to a desired location (e.g., /opt)
sudo mv apache-tomcat-9.0.80 /opt

# Set environment variables for Tomcat
echo 'export CATALINA_HOME="/opt/apache-tomcat-9.0.80"' >> ~/.bashrc
source ~/.bashrc

# Start Tomcat service
$CATALINA_HOME/bin/startup.sh

# Display instructions for accessing Tomcat
echo "Tomcat 9 has been installed and started."
echo "You can access it at http://localhost:8080/"

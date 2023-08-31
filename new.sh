#!/bin/bash

# Update package repositories
sudo apt update
sudo apt upgrade -y

# Install Java 11
sudo apt install openjdk-11-jdk -y
# change ownership

# Download Tomcat 9
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz

# Extract Tomcat archive
tar -xvzf apache-tomcat-9.0.80.tar.gz
#changed directory
cd ./apache-tomcat-9.0.80/bin
chmod +x ./apache-tomcat-9.0.80/bin/startup.sh 
chmod +x ./apache-tomcat-9.0.80/bin/shutdown.sh
#triggered script
./shutdown.sh
./startup.sh

# Display instructions for accessing Tomcat
echo "Tomcat 9 has been installed and started."
echo "You can access it at http://localhost:8080/"

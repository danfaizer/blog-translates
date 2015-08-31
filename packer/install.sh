#!/bin/bash

sudo yum clean all
sleep 1

# Create the required folders
sudo mkdir -p /opt/translates
sudo chmod 750 /opt/translates

# Decompress the application & change correct permissions
sudo tar -xvf /opt/translates.tar.gz -C /opt/translates
sudo chown -R ec2-user:ec2-user /opt/translates

# Load RVM environment
source /home/ec2-user/.rvm/scripts/rvm

# Install required gems
cd /opt/translates
/home/ec2-user/.rvm/gems/ruby-2.2.1/bin/bundle install

sudo chmod +x /etc/init.d/translates
sudo chkconfig translates on

# Install datadog
bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/install_agent.sh)"
sudo bash -c "echo tags: translates >> /etc/dd-agent/datadog.conf"
sudo bash -c "echo log_level: WARN >> /etc/dd-agent/datadog.conf"

# Install Prana
cd /tmp
wget http://dl.bintray.com/netflixoss/Prana/Prana-0.0.1.zip
unzip Prana-0.0.1.zip
sudo mv Prana-0.0.1 /opt/Prana

sudo pip install flask
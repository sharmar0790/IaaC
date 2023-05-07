#!/bin/bash

set -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "Updating yum"
# Ensure that your software packages are up to date on your instance by using the following command to perform a quick software update:
sudo yum update


echo "Add the Jenkins repo using the following command:"
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

echo "Import a key file from Jenkins-CI to enable installation from the package:"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key && sudo yum upgrade

echo "#Install Java (Amazon Linux 2):"
#sudo amazon-linux-extras install java-openjdk11 -y

echo "Install Java (Amazon Linux 2023) and jenkins"
#sudo dnf install java-11-amazon-corretto -y && sudo yum install jenkins -y
sudo yum install java-17-amazon-corretto-devel -y && sudo yum install jenkins -y

echo "Enable the Jenkins service to start at boot:"
sudo systemctl enable jenkins

echo "Start Jenkins as a service:"
sudo systemctl start jenkins

echo "Install GitHub Plugin to integrate with jenkins"
sudo yum install git -y


echo "Install and Configure Docker"
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

echo "Setup the repo"
sudo yum install docker -y &&
    sudo usermod -a -G docker ec2-user &&
    sudo usermod -a -G docker jenkins &&
    id ec2-user &&
    newgrp docker

sudo systemctl enable docker.service &&
      systemctl start docker.service

sudo yum clean all



#Use the following command to display this password:
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword
#Amazon Java Version installation commands - https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/amazon-linux-install.html

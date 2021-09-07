#!/bin/bash

# Update the system and install EPEL repo
#sudo yum -y update
sudo yum -y install epel-release
#sudo yum -y update

# Install ansible
sudo yum -y install ansible
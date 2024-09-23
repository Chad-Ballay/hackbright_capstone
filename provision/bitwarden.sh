#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
    
# Update
apt-get update
apt-get upgrade -y

apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y install docker-ce docker-ce-cli docker-compose-plugin containerd.io
groupadd -f docker
usermod -aG docker vagrant

# Bitwarden
useradd -m -p $(openssl passwd -1 bitwarden) bitwarden
usermod -aG docker bitwarden
mkdir /opt/bitwarden
chmod -R 700 /opt/bitwarden
chown -R bitwarden:bitwarden /opt/bitwarden
curl -Lso /opt/bitwarden/bitwarden.sh "https://func.bitwarden.com/api/dl/?app=self-host&platform=linux" && chmod 700 /opt/bitwarden/bitwarden.sh
chown bitwarden:bitwarden /opt/bitwarden/bitwarden.sh

#Belt and suspenders check
apt-get update
apt-get upgrade -y
shutdown -r now

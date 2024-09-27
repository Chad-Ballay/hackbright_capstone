#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
    
# Update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common \
  nodejs \
  npm \
  unzip \
  docker-ce \
  docker-ce-cli \
  docker-compose-plugin \
  containerd.io

npm install -g maildev
nohup maildev &


# User Setup
groupadd -f docker
usermod -aG docker vagrant
useradd -m -s /bin/bash  q -p $(openssl passwd -1 bitwarden) bitwarden
usermod -aG docker bitwarden

# Bitwarden
mkdir -m 755 /opt/bitwarden
chown -R bitwarden:bitwarden /opt/bitwarden
curl -Lso /opt/bitwarden/bitwarden.sh "https://func.bitwarden.com/api/dl/?app=self-host&platform=linux" \
 && chmod 700 /opt/bitwarden/bitwarden.sh
chown bitwarden:bitwarden /opt/bitwarden/bitwarden.sh

curl -Lso /opt/bitwarden/docker-stub-US.zip https://github.com/bitwarden/server/releases/download/v2024.9.1/docker-stub-US.zip \
 && chmod 700 /opt/bitwarden/docker-stub-US.zip                                      
chown bitwarden:bitwarden /opt/bitwarden/docker-stub-US.zip
cd /opt/bitwarden/
su bitwarden -c "unzip /opt/bitwarden/docker-stub-US.zip -d /opt/bitwarden/bwdata" 

mkdir -m 755 /opt/bitwarden/bwdata/scripts
chown bitwarden:bitwarden /opt/bitwarden/bwdata/scripts
curl -Lso /opt/bitwarden/bwdata/scripts/run.sh "https://func.bitwarden.com/api/dl/?app=self-host&platform=linux&variant=run" \
 && chmod 700 /opt/bitwarden/bwdata/scripts/run.sh
chown bitwarden:bitwarden /opt/bitwarden/bwdata/scripts/run.sh



#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
    
# Update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get -y install \
  virtualbox-guest-additions-iso \
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
pgrep -f maildev 1>/dev/null || nohup maildev &


# User Setup
groupadd -f docker
usermod -aG docker vagrant
useradd -m -s /bin/bash -p $(openssl passwd -1 bitwarden) bitwarden
usermod -aG docker bitwarden

# Bitwarden
mkdir -m 755 /opt/bitwarden
chown -R bitwarden:bitwarden /opt/bitwarden
curl -Lso /opt/bitwarden/bitwarden.sh "https://func.bitwarden.com/api/dl/?app=self-host&platform=linux" \
 && chmod 700 /opt/bitwarden/bitwarden.sh
chown bitwarden:bitwarden /opt/bitwarden/bitwarden.sh

#curl -Lso /opt/bitwarden/docker-stub-US.zip https://github.com/bitwarden/server/releases/download/v2024.9.1/docker-stub-US.zip \
# && chmod 700 /opt/bitwarden/docker-stub-US.zip                                      
#chown bitwarden:bitwarden /opt/bitwarden/docker-stub-US.zip
#cd /opt/bitwarden/
#su bitwarden -c "unzip /opt/bitwarden/docker-stub-US.zip -d /opt/bitwarden/bwdata" 

#mkdir -m 755 /opt/bitwarden/bwdata/scripts
#chown bitwarden:bitwarden /opt/bitwarden/bwdata/scripts
#curl -Lso /opt/bitwarden/bwdata/scripts/run.sh "https://func.bitwarden.com/api/dl/?app=self-host&platform=linux&variant=run" \
# && chmod 700 /opt/bitwarden/bwdata/scripts/run.sh
#chown bitwarden:bitwarden /opt/bitwarden/bwdata/scripts/run.sh

#oIFS=$IFS
#IFS="
#"
#set -a
#. /vagrant/provision/custom_values.env
#set +a
#envsubst < "/vagrant/provision/global.override.env" > /opt/bitwarden/bwdata/env/global.override.env
#IFS=$oIFS
#chmod 600 /opt/bitwarden/bwdata/env/global.override.env
#chown bitwarden:bitwarden /opt/bitwarden/bwdata/env/global.override.env

#cd /opt/bitwarden/bwdata/
#su bitwarden -c "openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout identity.key -out identity.crt -subj '/CN=Bitwarden IdentityServer' -days 10950"
#su bitwarden -c "openssl pkcs12 -export -out ./identity/identity.pfx -inkey identity.key -in identity.crt -passout pass:$IDENTITY_CERT_PASSWORD"

#su bitwarden -c "mkdir /opt/bitwarden/bwdata/ssl/localhost"
#sed -i 's/bitwarden.example.com/localhost/g' /opt/bitwarden/bwdata/nginx/default.conf
#sed -i 's/ssl_trusted_certificate/#ssl_trusted_certificate/g' /opt/bitwarden/bwdata/nginx/default.conf
#sed -i 's/RANDOM_DATABASE_PASSWORD/$DB_PASSWORD/g' /opt/bitwarden/bwdata/env/mssql.override.env
#sed -i 's/bitwarden.example.com/localhost/g' /opt/bitwarden/bwdata/web/app-id.json
#USER_UID=`id -u bitwarden`
#USER_GID=`id -g bitwarden`
#echo "LOCAL_UID=`id -u bitwarden`" > /opt/bitwarden/bwdata/env/uid.env
#echo "LOCAL_GID=`id -g bitwarden`" >> /opt/bitwarden/bwdata/env/uid.env
#echo " `id -u bitwarden`
#shutdown -r now

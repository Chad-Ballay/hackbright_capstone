#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

###  MAIN  ###
apt-get update
apt-get upgrade -y

apt-get -y install \
  virtualbox-guest-additions-iso \
  apt-transport-https \
  ca-certificates \
  curl \
  libnss3-tools \
  ubuntu-desktop 

#Networking setup
echo "" >> /etc/hosts
echo "10.0.0.10 WLSX01.test.local" >> /etc/hosts
echo "10.0.0.11 WWIN01.test.local" >> /etc/hosts
echo "10.0.0.12 SLSX01.test.local" >> /etc/hosts
echo "10.0.0.13 WLSX02.test.local" >> /etc/hosts

#Certificate setup
cp /vagrant/provision/certificates/mkcert* /usr/local/share/ca-certificates/
chmod 644 /usr/local/share/ca-certificates/
update-ca-certificates
dpkg-reconfigure ca-certificates
mkdir -p /etc/pki/nssdb
certutil -N -d sql:/etc/pki/nssdb
for i in `ls -1 /etc/ssl/certs | egrep -v '(.0$|:$)'`
do
   certutil -A -d sql:/etc/pki/nssdb -n $(basename $i) -t "TC,," -i /etc/ssl/certs/$i
done

#User Setup
mkdir -m 755 /etc/skel/.config
echo "set -o vi" >> /etc/skel/.bashrc
su vagrant mkdir -m 755 ~vagrant/.config/
touch /etc/skel/.config/gnome-initial-setup-done
touch ~vagrant/.config/gnome-initial-setup-done
sed -i 's/=lts/=never/g' /etc/update-manager/release-upgrades
cp -r /etc/pki /etc/skel/.pki
mkdir -m 700 /etc/skel/snap/
mkdir -m 755 /etc/skel/snap/bitwarden
mkdir -m 755 /etc/skel/snap/bitwarden/120
cp -r /etc/pki /etc/skel/snap/bitwarden/120/.pki


#User Creation
for i in `cat /vagrant/provision/users/users.unl`
do
  USER=`echo $i |cut -f1 -d\|`
  EMAIL=`echo $i | cut -f2 -d\|`
  PASSWORD=`echo $i | cut -f3 -d\|`
  useradd -m -s /bin/bash -p "$(openssl passwd -6 $EMAIL)" $USER
done

#Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt -f install
apt install --fix-broken 
mkdir -m 755 -p /etc/opt/chrome/policies/managed
cp /vagrant/provision/managed_policies.json /etc/opt/chrome/policies/managed/managed_policies.json
cp /vagrant/provision/bitwarden.json /etc/opt/chrome/policies/managed/bitwarden.json
cp /vagrant/provision/extension_settings.json /etc/opt/chrome/policies/managed/extension_settings.json
chmod 644 /etc/opt/chrome/policies/managed/*json


#Setup BitWarden 
snap install bitwarden

#Configure Favorites
echo "user-db:user" > /etc/dconf/profile/user
echo "system-db:local" >>  /etc/dconf/profile/user
chmod 644 /etc/dconf/profile/user
mkdir -m 655 /etc/dconf/db/local.d/
echo "[org/gnome/shell]" > /etc/dconf/db/local.d/00-favorite-apps
echo "favorite-apps = ['gedit.desktop', 'gnome-terminal.desktop', 'nautilus.desktop', 'google-chrome.desktop', 'bitwarden_bitwarden.desktop']" >> /etc/dconf/db/local.d/00-favorite-apps
dconf update

apt-get update
apt-get upgrade -y

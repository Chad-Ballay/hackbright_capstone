#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

###  MAIN  ###
apt-get update
apt-get upgrade -y

#Disable GNOME initial screen
mkdir -m 755 /etc/skel/.config
touch /etc/skel/.config/gnome-initial-setup-done


#Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt -f install
apt install --fix-broken 


#Setup BitWarden Web Extension 
mkdir -m 755 -p /etc/opt/chrome/policies/managed
cp /vagrant/provision/managed_policies.json /etc/opt/chrome/policies/managed/managed_policies.json
cp /vagrant/provision/bitwarden.json /etc/opt/chrome/policies/managed/bitwarden.json
chmod 644 /etc/opt/chrome/policies/managed/*json

#Setup BitWarden Desktop App
echo "export BITWARDEN_APPDATA_DIR=~/.bitwarden" >> /etc/skel/.profile
echo "set -o vi" >> /etc/skel/.profile


#Configure Favorites
echo "user-db:user" > /etc/dconf/profile/user
echo "system-db:local" >>  /etc/dconf/profile/user
chmod 644 /etc/dconf/profile/user
mkdir -m 655 /etc/dconf/db/local.d/
echo "[org/gnome/shell]" > /etc/dconf/db/local.d/00-favorite-apps
echo "favorite-apps = ['gedit.desktop', 'gnome-terminal.desktop', 'nautilus.desktop', 'google-chrome.desktop', 'bitwarden_bitwarden.desktop']" >> /etc/dconf/db/local.d/00-favorite-apps
dconf update


#Restart to be safe
apt-get update
apt-get upgrade -y
shutdown -r now
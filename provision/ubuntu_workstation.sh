#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

install_chrome_extension () {
  preferences_dir_path="/opt/google/chrome/extensions"
  pref_file_path="$preferences_dir_path/$1.json"
  upd_url="https://clients2.google.com/service/update2/crx"
  mkdir -p "$preferences_dir_path"
  echo "{" > "$pref_file_path"
  echo "  \"external_update_url\": \"$upd_url\"" >> "$pref_file_path"
  echo "}" >> "$pref_file_path"
  echo Added \""$pref_file_path"\" ["$2"]
}



###  MAIN  ###
apt-get update
apt-get upgrade -y

#Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt -f install
apt install --fix-broken 


#Setup BitWarden Web Extension 
#install_chrome_extension "nngceckbapebfimnlniiiahkandclblb" "Bitwarden Password Manager"
mkdir -m 755 -p /etc/opt/chrome/policies/managed
cp /vagrant/provision/managed_policies.json /etc/opt/chrome/policies/managed/managed_policies.json
cp /vagrant/provision/bitwarden.json /etc/opt/chrome/policies/managed/bitwarden.json
chmod 644 /etc/opt/chrome/policies/managed/*json

#Configure Favorites
echo "user-db:user" > /etc/dconf/profile/user
echo "system-db:local" >>  /etc/dconf/profile/user
chmod 644 /etc/dconf/profile/user
mkdir -m 655 /etc/dconf/db/local.d/
echo "[org/gnome/shell]" > /etc/dconf/db/local.d/00-favorite-apps
echo "favorite-apps = ['gedit.desktop', 'gnome-terminal.desktop', 'nautilus.desktop', 'google-chrome.desktop']" >>/etc/dconf/db/local.d/00-favorite-apps
dconf update


#Restart to be safe
apt-get update
apt-get upgrade -y
shutdown -r now
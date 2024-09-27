# Infrastructure
| Server 	| Purpose                       	| IP        	| Credentials                         	|
|--------	|-------------------------------	|-----------	|-------------------------------------	|
| WWIN01 	| Windows 11 User Desktop       	| 10.0.0.10 	| vagrant:vagrant                     	|
| WLSX01 	| Ubuntu 22.04 User Desktop     	| 10.0.0.11 	| vagrant:vagrant                     	|
| SLSX01 	| Ubuntu 22.04 Bitwarden Server 	| 10.0.0.12 	| vagrant:vagrant bitwarden:bitwarden 	|

### WLSX01
* Suppresses the initial welcome screen for end users.
* Installs Chrome.
* Installs Bitwarden extension in Chrome as a managed policy.
* Updates user's menu to have some default items.

### SLSX01
* Creates bitwarden user account.
* Installs Docker and several other packages that are needed.
* Creates a SMTP catcher for account verification emails.
* Installs Bitwarden.



https://www.virtualbox.org/manual/ch06.html

https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/
https://github.com/gusztavvargadr/packer
https://medium.com/@williamwarley/mastering-vagrant-a-practical-guide-to-building-and-managing-virtual-development-environments-22dc6910f6a3

https://support.google.com/chrome/a/answer/9025903?sjid=2942855955945696706-NC
https://support.google.com/chrome/a/answer/9024365?hl=en&ref_topic=902694
https://support.google.com/chrome/a/answer/3115278?sjid=2942855955945696706-NC
https://github.com/google/ChromeBrowserEnterprise/tree/main/docs/policy_examples


https://help.gnome.org/admin/system-admin-guide/stable/desktop-favorite-applications.html.en

https://bitwarden.com/help/configure-clients-selfhost/

https://github.com/Darki8/ChromeKiosk/blob/afb57d663b341576812c96f2bca2ed79879abd03/KioskChromeScript.sh#L110


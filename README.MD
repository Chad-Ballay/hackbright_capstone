# Infrastructure
| Server 	| Purpose                       	| IP        	| Credentials                         	|
|--------	|-------------------------------	|-----------	|-------------------------------------	|
| WWIN01 	| Windows 11 User Desktop       	| 10.0.0.10 	| vagrant:vagrant                     	|
| WLSX01 	| Ubuntu 22.04 User Desktop     	| 10.0.0.11 	| vagrant:vagrant                     	|
| SLSX01 	| Ubuntu 22.04 Bitwarden Server 	| 10.0.0.12 	| vagrant:vagrant bitwarden:bitwarden 	|

# Users
| UserId      | Email                  | First_Name | Last_Name | Alternative_email          | Credentials                |
|-------------|------------------------|------------|-----------|----------------------------|----------------------------|
| david.perry | david.perry@test.local | David      | Perry     | david_perry9779@icloud.com | David_perry9779@icloud.com |
| gavin.smith | gavin.smith@test.local | Gavin      | Smith     | gavin_smith9779@icloud.com | Gavin_smith9779@icloud.com |
| james.jones | james.jones@test.local | James      | Jones     | james_jones9779@icloud.com | James_jones9779@icloud.com |
| lane.pipes  | lane.pipes@test.local  | Lane       | Pipes     | chad.ballay@icloud.com     | Chad.ballay@icloud.com     |
| chad.ballay | chad.ballay@gmail.com  | Chad       | Ballay    |                            | 5D2SN1xW9iWz               |

# Links
SMTP mailtrap http://10.0.0.12:1080/
Bitwarden access https://10.0.0.12/


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


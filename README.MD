# Isolated Environment Creation

## Requirements
* Windows 11 - Currently the only targeted development environment.
* Kali Linux - [Kali Linux Link](https://cdimage.kali.org/kali-2024.2/kali-linux-2024.2-virtualbox-amd64.7z)
* Virtual Box - [Virtual Box Link](https://download.virtualbox.org/virtualbox/7.0.20/VirtualBox-7.0.20-163906-Win.exe)
* Metasploitable2 - [Metasploitable2 Link](https://sourceforge.net/projects/metasploitable/files/latest/download)
* Metasploitable3 - [Metasploitable3 Link](https://app.vagrantup.com/rapid7/boxes/metasploitable3-ub1404/versions/0.1.12-weekly/providers/virtualbox/unknown/vagrant.box)

## Setting up your machine
1. Get Install Virtual Box.  (Currently running Version 7.0.20 r163906)
2. Add the Virtual Box installation directory to your %PATH% variable.  
3. Download the VirtualBox image of Kali Linux.
4. Extract the *.vbox and *.vdi file.  (Note the path of where you extracted it.)
5. Download the Metasploitable2 zip file.  
6. Extract the *.vmdk file.  (It'll be a bit of a headache later on dealing with this.)


### Base Level Setup
Need to create the isolated network that all of these things will use.  For now I'm keeping the network pretty small.  192.168.10.120-192.168.10.120
```
VBoxManage dhcpserver add --netname sandboxnet --ip 192.168.10.1 --netmask 255.255.255.0 --lowerip 192.168.10.100 --upperip 192.168.10.120 --enable
VBoxManage natnetwork add --netname externalnet --network 10.0.2.0/24 --enable --dhcp on

```

### Creating the Kali VM
Rough idea is to create a VM, rename it to a more managable name, and set the network to being internal only.
```
VBoxManage registervm C:\Users\chadb\code\vagrant\installation_media\kali-linux-2024.2-virtualbox-amd64\kali-linux-2024.2-virtualbox-amd64.vbox

VBoxManage modifyvm kali-linux-2024.2-virtualbox-amd64 --name KaliLinux

VBoxManage modifyvm KaliLinux --nic1=intnet  --intnet1=sandboxnet 
VBoxManage modifyvm KaliLinux --nic2=natnetwork  --nat-network1=externalnet

```

### Creating the Metasploitable3 target VM
Rough idea is that we will download the prebuilt vagrant box, set it up in virtual box, connect it to the isolated network, and then power it on in a headless mode so that it's running.
```
VBoxManage createvm --name Metasploitable2 --ostype "Ubuntu\_64" --register 

VBoxManage modifyvm Metasploitable2 --memory 1024

VBoxManage storagectl "Metasploitable2" --name "SATA Controller" --add sata 

VBoxManage storageattach "Metasploitable2" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium 'C:\Users\chadb\code\vagrant\installation_media\metasploitable-linux-2.0.0\Metasploitable2-Linux\Metasploitable.vmdk'

VBoxManage modifyvm Metasploitable2 --nic1=intnet  --intnet1=sandboxnet 
```

## First Steps
It'll take a while for all the VM's to start up so give it a bit when you run this.  We are starting up Metasploitable in the background since we want to break into it and don't need no front door.
```
VBoxManage startvm KaliLinux

VBoxManage startvm Metasploitable2 --type=headless
```

Once everything is up, you'll have a Virtual Box window into your Kali box.  Get a command line and run this to verify that your network is isolated.
```
ping -a -g 192.168.10.1 192.168.10.255 2>/dev/null
```
You should get something like this.
```
┌──(kali㉿kali)-[~]
└─$ fping -a -g 192.168.10.1 192.168.10.255 2>/dev/null
192.168.10.1
192.168.10.100
192.168.10.101
```
## File/Dir Structure
```
PS C:\Users\chadb\code\vagrant> dir -s


    Directory: C:\Users\chadb\code\vagrant


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/25/2024  12:29 AM                installation_media
-a----         8/25/2024  12:01 AM           3316 README.MD


    Directory: C:\Users\chadb\code\vagrant\installation_media


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/25/2024   2:44 AM                KaliLinux
d-----         8/25/2024  12:29 AM                metasploitable-linux-2.0.0
-a----         8/23/2024   2:34 AM     3312647871 kali-linux-2024.2-virtualbox-amd64.7z
-a----         8/24/2024  10:29 PM      865084584 metasploitable-linux-2.0.0.zip
-a----         8/23/2024   1:57 AM      110252592 VirtualBox-7.0.20-163906-Win.exe


    Directory: C:\Users\chadb\code\vagrant\installation_media\KaliLinux


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/25/2024   2:42 AM                Logs
-a----         8/25/2024   2:45 AM    26947683328 kali-linux-2024.2-virtualbox-amd64.vdi
-a----         5/27/2024   4:12 PM           3021 KaliLinux-1.16.vbox
-a----         8/25/2024   2:44 AM           7280 KaliLinux.vbox
-a----         8/25/2024   2:42 AM           6989 KaliLinux.vbox-prev


    Directory: C:\Users\chadb\code\vagrant\installation_media\KaliLinux\Logs


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         8/25/2024   2:42 AM              0 VBox.log
-a----         8/25/2024   2:42 AM         197636 VBox.log.1
-a----         8/25/2024   2:38 AM         230342 VBox.log.2
-a----         8/25/2024  12:46 AM         259900 VBox.log.3
-a----         8/25/2024   2:42 AM           4251 VBoxHardening.log


    Directory: C:\Users\chadb\code\vagrant\installation_media\metasploitable-linux-2.0.0


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         8/25/2024  12:29 AM                Metasploitable2-Linux


    Directory: C:\Users\chadb\code\vagrant\installation_media\metasploitable-linux-2.0.0\Metasploitable2-Linux


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         8/25/2024  12:29 AM           8684 Metasploitable.nvram
-a----         8/25/2024   2:48 AM     1926103040 Metasploitable.vmdk
-a----         8/25/2024  12:29 AM              0 Metasploitable.vmsd
-a----         8/25/2024  12:29 AM           2804 Metasploitable.vmx
-a----         8/25/2024  12:29 AM            269 Metasploitable.vmxf
```

## Virtual Box Config
```
PS C:\Users\chadb\code\vagrant> VBoxManage list vms
"KaliLinux" {8fd2164a-bbcd-4f35-8d09-326ba8364f6d}
"Metasploitable2" {75280f78-703c-483d-88f4-397dfaafeef1}
PS C:\Users\chadb\code\vagrant> VBoxManage showvminfo KaliLinux
Name:                        KaliLinux
Encryption:                  disabled
Groups:                      /
Guest OS:                    Debian (64-bit)
UUID:                        8fd2164a-bbcd-4f35-8d09-326ba8364f6d
Config file:                 C:\Users\chadb\code\vagrant\installation_media\KaliLinux\KaliLinux.vbox
Snapshot folder:             C:\Users\chadb\code\vagrant\installation_media\KaliLinux\Snapshots
Log folder:                  C:\Users\chadb\code\vagrant\installation_media\KaliLinux\Logs
Hardware UUID:               8fd2164a-bbcd-4f35-8d09-326ba8364f6d
Memory size:                 2048MB
Page Fusion:                 disabled
VRAM size:                   128MB
CPU exec cap:                100%
HPET:                        disabled
CPUProfile:                  host
Chipset:                     piix3
Firmware:                    BIOS
Number of CPUs:              2
PAE:                         enabled
Long Mode:                   enabled
Triple Fault Reset:          disabled
APIC:                        enabled
X2APIC:                      enabled
Nested VT-x/AMD-V:           disabled
CPUID Portability Level:     0
CPUID overrides:             None
Boot menu mode:              message and menu
Boot Device 1:               HardDisk
Boot Device 2:               DVD
Boot Device 3:               Not Assigned
Boot Device 4:               Not Assigned
ACPI:                        enabled
IOAPIC:                      enabled
BIOS APIC mode:              APIC
Time offset:                 0ms
BIOS NVRAM File:             C:\Users\chadb\code\vagrant\installation_media\KaliLinux\KaliLinux.nvram
RTC:                         UTC
Hardware Virtualization:     enabled
Nested Paging:               enabled
Large Pages:                 enabled
VT-x VPID:                   enabled
VT-x Unrestricted Exec.:     enabled
AMD-V Virt. Vmsave/Vmload:   enabled
IOMMU:                       None
Paravirt. Provider:          Default
Effective Paravirt. Prov.:   KVM
State:                       running (since 2024-08-25T07:42:20.843000000)
Graphics Controller:         VMSVGA
Monitor count:               1
3D Acceleration:             disabled
2D Video Acceleration:       disabled
Teleporter Enabled:          disabled
Teleporter Port:             0
Teleporter Address:
Teleporter Password:
Tracing Enabled:             disabled
Allow Tracing to Access VM:  disabled
Tracing Configuration:
Autostart Enabled:           disabled
Autostart Delay:             0
Default Frontend:
VM process priority:         default
Storage Controllers:
#0: 'IDE', Type: PIIX4, Instance: 0, Ports: 2 (max 2), Bootable
  Port 1, Unit 0: Empty
#1: 'SATA', Type: IntelAhci, Instance: 0, Ports: 1 (max 30), Bootable
  Port 0, Unit 0: UUID: 6c53af52-8b7b-4ba5-bbd0-80f7313bd9d7
    Location: "C:\Users\chadb\code\vagrant\installation_media\KaliLinux\kali-linux-2024.2-virtualbox-amd64.vdi"
NIC 1:                       MAC: 080027D22679, Attachment: Internal Network 'sandboxnet', Cable connected: on, Trace: off (file: none), Type: 82540EM, Reported speed: 0 Mbps, Boot priority: 0, Promisc Policy: deny, Bandwidth group: none
NIC 2:                       MAC: 080027BC2AB2, Attachment: NAT Network 'externalnet', Cable connected: on, Trace: off (file: none), Type: 82540EM, Reported speed: 0 Mbps, Boot priority: 0, Promisc Policy: deny, Bandwidth group: none
NIC 3:                       disabled
NIC 4:                       disabled
NIC 5:                       disabled
NIC 6:                       disabled
NIC 7:                       disabled
NIC 8:                       disabled
Pointing Device:             USB Tablet
Keyboard Device:             PS/2 Keyboard
UART 1:                      disabled
UART 2:                      disabled
UART 3:                      disabled
UART 4:                      disabled
LPT 1:                       disabled
LPT 2:                       disabled
Audio:                       enabled (Driver: DirectSound, Controller: AC97, Codec: AD1980)
Audio playback:              enabled
Audio capture:               disabled
Clipboard Mode:              Bidirectional
Drag and drop Mode:          Bidirectional
Session name:                GUI/Qt
Video mode:                  1120x753x32 at 0,0 enabled
VRDE:                        disabled
OHCI USB:                    enabled
EHCI USB:                    disabled
xHCI USB:                    disabled
USB Device Filters:          <none>
Available remote USB devices: <none>
Currently attached USB devices: <none>
Bandwidth groups:            <none>
Shared folders:              <none>
VRDE Connection:             not active
Clients so far:              0
Recording enabled:           no
Recording screens:           1
 Screen 0:
    Enabled:                 yes
    ID:                      0
    Record video:            yes
    Record audio:            no
    Destination:             File
    File:                    C:\Users\chadb\code\vagrant\installation_media\KaliLinux\KaliLinux-screen0.webm
    Options:                 vc_enabled=true,ac_enabled=false,ac_profile=med
    Video dimensions:        1024x768
    Video rate:              512kbps
    Video FPS:               25fps
Description:
Kali Rolling (2024.2) x64
2024-05-27

- - - - - - - - - - - - - - - - - -

Username: kali
Password: kali
(US keyboard layout)

- - - - - - - - - - - - - - - - - -

* Kali Homepage:
https://www.kali.org/

* Kali Documentation:
https://www.kali.org/docs/

* Kali Tools:
https://www.kali.org/tools/

* Forum/Community Support:
https://forums.kali.org/

* Community Chat:
https://discord.kali.org
* Guest:
Configured memory balloon:   0MB
OS type:                     Linux26_64
Additions run level:         2
Additions version:           6.0.0 r127566
Guest Facilities:
Facility "VirtualBox Base Driver": active/running (last update: 2024/08/25 07:42:40 UTC)
Facility "VirtualBox System Service": active/running (last update: 2024/08/25 07:42:41 UTC)
Facility "Seamless Mode": active/running (last update: 2024/08/25 07:44:29 UTC)
Facility "Graphics Mode": active/running (last update: 2024/08/25 07:44:29 UTC)

PS C:\Users\chadb\code\vagrant> VBoxManage showvminfo Metasploitable2
Name:                        Metasploitable2
Encryption:                  disabled
Groups:                      /
Guest OS:                    Ubuntu\_64
UUID:                        75280f78-703c-483d-88f4-397dfaafeef1
Config file:                 C:\Users\chadb\VirtualBox VMs\Metasploitable2\Metasploitable2.vbox
Snapshot folder:             C:\Users\chadb\VirtualBox VMs\Metasploitable2\Snapshots
Log folder:                  C:\Users\chadb\VirtualBox VMs\Metasploitable2\Logs
Hardware UUID:               75280f78-703c-483d-88f4-397dfaafeef1
Memory size:                 1024MB
Page Fusion:                 disabled
VRAM size:                   8MB
CPU exec cap:                100%
HPET:                        disabled
CPUProfile:                  host
Chipset:                     piix3
Firmware:                    BIOS
Number of CPUs:              1
PAE:                         enabled
Long Mode:                   enabled
Triple Fault Reset:          disabled
APIC:                        enabled
X2APIC:                      disabled
Nested VT-x/AMD-V:           disabled
CPUID Portability Level:     0
CPUID overrides:             None
Boot menu mode:              message and menu
Boot Device 1:               Floppy
Boot Device 2:               DVD
Boot Device 3:               HardDisk
Boot Device 4:               Not Assigned
ACPI:                        enabled
IOAPIC:                      enabled
BIOS APIC mode:              APIC
Time offset:                 0ms
BIOS NVRAM File:             C:\Users\chadb\VirtualBox VMs\Metasploitable2\Metasploitable2.nvram
RTC:                         local time
Hardware Virtualization:     enabled
Nested Paging:               enabled
Large Pages:                 enabled
VT-x VPID:                   enabled
VT-x Unrestricted Exec.:     enabled
AMD-V Virt. Vmsave/Vmload:   enabled
IOMMU:                       None
Paravirt. Provider:          Default
Effective Paravirt. Prov.:   None
State:                       powered off (since 2024-08-25T07:48:53.485000000)
Graphics Controller:         VBoxVGA
Monitor count:               1
3D Acceleration:             disabled
2D Video Acceleration:       disabled
Teleporter Enabled:          disabled
Teleporter Port:             0
Teleporter Address:
Teleporter Password:
Tracing Enabled:             disabled
Allow Tracing to Access VM:  disabled
Tracing Configuration:
Autostart Enabled:           disabled
Autostart Delay:             0
Default Frontend:
VM process priority:         default
Storage Controllers:
#0: 'SATA Controller', Type: IntelAhci, Instance: 0, Ports: 30 (max 30), Bootable
  Port 0, Unit 0: UUID: c98b1998-f3eb-4d66-b8fe-b301d07017c8
    Location: "C:\Users\chadb\code\vagrant\installation_media\metasploitable-linux-2.0.0\Metasploitable2-Linux\Metasploitable.vmdk"
NIC 1:                       MAC: 080027C44651, Attachment: Internal Network 'sandboxnet', Cable connected: on, Trace: off (file: none), Type: 82540EM, Reported speed: 0 Mbps, Boot priority: 0, Promisc Policy: deny, Bandwidth group: none
NIC 2:                       disabled
NIC 3:                       disabled
NIC 4:                       disabled
NIC 5:                       disabled
NIC 6:                       disabled
NIC 7:                       disabled
NIC 8:                       disabled
Pointing Device:             PS/2 Mouse
Keyboard Device:             PS/2 Keyboard
UART 1:                      disabled
UART 2:                      disabled
UART 3:                      disabled
UART 4:                      disabled
LPT 1:                       disabled
LPT 2:                       disabled
Audio:                       enabled (Driver: Default, Controller: AC97, Codec: STAC9700)
Audio playback:              disabled
Audio capture:               disabled
Clipboard Mode:              disabled
Drag and drop Mode:          disabled
VRDE:                        disabled
OHCI USB:                    disabled
EHCI USB:                    disabled
xHCI USB:                    disabled
USB Device Filters:          <none>
Bandwidth groups:            <none>
Shared folders:              <none>
Recording enabled:           no
Recording screens:           1
 Screen 0:
    Enabled:                 yes
    ID:                      0
    Record video:            yes
    Record audio:            no
    Destination:             File
    File:                    C:\Users\chadb\VirtualBox VMs\Metasploitable2\Metasploitable2-screen0.webm
    Options:                 vc_enabled=true,ac_enabled=false,ac_profile=med
    Video dimensions:        1024x768
    Video rate:              512kbps
    Video FPS:               25fps
* Guest:
Configured memory balloon:   0MB
```


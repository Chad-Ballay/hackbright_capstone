Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 900
  config.vbguest.iso_path = "https://download.virtualbox.org/virtualbox/7.0.20/VBoxGuestAdditions_7.0.20.iso"
  config.vbguest.auto_update = false
  config.vbguest.auto_reboot = true
  config.vagrant.plugins = ["vagrant-vbguest"]

  # config.vm.define "ubuntu" do |ubuntu|
  #   ubuntu.vm.box = "gusztavvargadr/ubuntu-desktop-2204-lts"
  #   ubuntu.vm.box_version = "2204.0.2408"
  #   ubuntu.vm.hostname= "WLSX01"
  #   ubuntu.vm.network :private_network, ip: "10.0.0.10"
  #   ubuntu.vm.provider "virtualbox" do |vb, override|
  #     vb.memory = "8192"
  #     vb.cpus ="2"
  #     vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
  #   end
  #   ubuntu.vm.provision "shell" do |script|
  #     script.path ="./provision/ubuntu_workstation.sh"
  #   end
  # end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "gusztavvargadr/ubuntu-desktop-2204-lts"
    ubuntu.vm.hostname= "WLSX01"
    ubuntu.vm.network :private_network, ip: "10.0.0.10"
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus ="2"
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
      vb.customize ["modifyvm", :id, "--vram", "32"]
    end
    ubuntu.vm.provision "shell" do |script|
      script.path ="./provision/ubuntu_workstation.sh"
    end
  end

  config.vm.define "windows" do |windows|
    windows.vm.box = "gusztavvargadr/windows-11"
    windows.vm.box_version = "2302.0.2408"
    windows.vm.hostname= "WWIN01"
    windows.vm.network :private_network, ip: "10.0.0.11"
    windows.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus ="2"
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    end
  end

  config.vm.define "bitwarden" do |bw|
    bw.vm.box = "gusztavvargadr/ubuntu-server-2204-lts"
    bw.vm.network :private_network, ip: "10.0.0.12"
    bw.vm.network :forwarded_port, guest: 443, host: 443, auto_correct: true
    bw.vm.network :forwarded_port, guest: 1080, host: 1080, auto_correct: true
    bw.vm.hostname = "bitwarden"
    bw.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus = "1"
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
      vb.customize ["modifyvm", :id, "--vram", "32"]
    end
    bw.vm.provision "shell" do |script|
      script.path ="./provision/bitwarden.sh"
    end
  end  

end

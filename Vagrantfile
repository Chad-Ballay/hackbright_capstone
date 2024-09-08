Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-disksize", "vagrant-vbguest", "vagrant-hostsupdater"]
  config.vm.box = "ubuntu/jammy64"

  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.hostname = "www.local"
  config.goodhosts.aliases = ["bitwarden.local", "bitwarden.home"]

  config.disksize.size = "20GB"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "8192"
    vb.cpus = "2"
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    apt-get update
    apt-get upgrade -y
    apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

    apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose docker-buildx-plugin docker-compose-plugin

    groupadd -f docker
    usermod -aG docker vagrant

  SHELL

end

Vagrant.configure("2") do |config|

    config.vm.define "kali" do |kali|
        kali.vm.box = "kalilinux/rolling"
        kali.vm.hostname = "kali-linux"
        kali.vm.network "private_network", type: "dhcp",
            virtualbox__intnet: "sandboxnet"
        kali.vm.provider "virtualbox" do |vb|
            vb.name = "Kali Linux"
            vb.memory = 8192
            vb.cpus = 2

        end
    end

    # config.vm.define "metasploitable3" do |metasploitable3|
    #     metasploitable3.vm.box = "rapid7/metasploitable3-win2k8"
    #     metasploitable3.vm.hostname = "metasploitable2-win2k8"
    #     metasploitable3.vm.network "private_network", type: "dhcp",
    #         virtualbox__intnet: "sandboxnet"
    #     metasploitable3.vm.provider "virtualbox" do |vb|
    #         vb.name = "Metasploitable 3"
    #         vb.memory = 4096
    #         vb.cpus = 2
    #         vb.customize ["modifyvm", :id, "--vram", "32"]
    #     end
    # end
end
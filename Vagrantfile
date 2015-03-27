Vagrant.configure("2") do |config|
	
	# Specify the base box
	config.vm.box = "chef/ubuntu-14.10"
	
	# Setup port forwarding
    config.vm.network "private_network", ip: "192.168.56.101"
	config.vm.network :forwarded_port, guest: 2331, host: 2331, auto_correct: true

    # Setup synced folder
    config.vm.synced_folder "./", "/var/www", create: true, group: "www-data", owner: "www-data"

    # VM specific configs
    config.vm.provider "virtualbox" do |v|
    	v.name = "Miit Development Vagrant"
    	v.customize ["modifyvm", :id, "--memory", "1024"]
    end

    # Shell provisioning
    config.vm.provision "shell" do |s|
    	s.path = "provision/setup.sh"
    end
end
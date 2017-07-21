# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.

  ## Ansible Tower

  config.vm.define "ansible230" do |ansy|
    ansy.vm.box = "ansible/tower"
    #ansy.vm.hostname = "ansi0"
    ansy.vm.hostname = "ansible230"
    #ansy.vm.network :private_network, :auto_network => true
    ansy.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', 3064]
    end
    ansy.vm.provision :shell, inline: "if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi"
    ansy.vm.provision :shell, inline: "cp /vagrant/files/id_rsa* /root/.ssh"
    ansy.vm.provision :shell, inline: "kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile"
    ansy.vm.provision :shell, inline: <<-SHELL 
      if rpm --quiet -q epel-release; then
        echo 'EPEL repo present'
      else
        echo 'Adding EPEL repo'
        rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
      fi
    SHELL
  end

  ## Ansible clients

  config.vm.define "centos0" do |centy|
    centy.vm.box = "centos/7"
    centy.vm.hostname = "centos0"
    centy.vm.autostart = false
    #centy.vm.network :"private_network", ip: "192.168.33.10" 
    centy.vm.network :private_network, :auto_network => true
    centy.vm.provision :shell, inline: "if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi"
    centy.vm.provision :shell, inline: "cp /vagrant/files/id_rsa* /root/.ssh"
    centy.vm.provision :shell, inline: "kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile"
    centy.vm.provision :shell, inline: <<-SHELL 
      if rpm --quiet -q epel-release; then
        echo 'EPEL repo present'
      else
        echo 'Adding EPEL repo'
        rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
      fi
    SHELL
  end

  config.vm.define "centos1" do |centy|
    centy.vm.box = "centos/7"
    centy.vm.hostname = "centos1"
    centy.vm.autostart = false
    centy.vm.network :private_network, :auto_network => true
    centy.vm.provision :shell, inline: "if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi"
    centy.vm.provision :shell, inline: "cp /vagrant/files/id_rsa* /root/.ssh"
    centy.vm.provision :shell, inline: "kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile"
    centy.vm.provision :shell, inline: <<-SHELL 
      if rpm --quiet -q epel-release; then
        echo 'EPEL repo present'
      else
        echo 'Adding EPEL repo'
        rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
      fi
    SHELL
  end


  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end

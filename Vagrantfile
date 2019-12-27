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

  shared_folders_all = [
    { :host_dir => 'srv', :guest_dir => '/src', :create => 'false', :owner => 'vagrant', },
  ]

  ##########  Zero  ##########   

  config.vm.define 'zero' do |node|

    node.vm.box = "bento/centos-8.0"
    node.vm.hostname = 'zero'
    #node.vm.network "private_network", auto_network: true
    node.vm.network "public_network", ip: '192.168.1.50', :bridge => 'en0: Ethernet 1'
    node.vm.provider :virtualbox do |vb|
      vb.gui = true
      vb.customize ['modifyvm', :id, '--memory', 2048]
      vb.customize ['modifyvm', :id, '--cpus', 2]
      vb.customize ['modifyvm', :id, '--vram', 128]
    end

    #node.vm.provision :shell, inline: <<-SETUP
    #  if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi
    #  cp /vagrant/config/id_rsa* /root/.ssh
    #  if [[ -f /root/.ssh/id_rsa ]]; then chmod 0600 /root/.ssh/id_rsa; fi
    #  kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile
    #SETUP

    #node.vm.provision :shell, path:   "config/hostwithmost.pl"
    node.vm.provision :shell, inline: <<-SHELL 
      if [[ `dnf --quiet repolist epel | egrep "^*?epel" | echo $?` != 0 ]]; then
        echo 'EPEL repo present'
      else
        echo 'Adding EPEL repo'
        dnf config-manager --set-enabled PowerTools
        dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
		dnf install epel-release -y
      fi
      dnf -y update
      if [[ `dnf --quiet repolist docker-ce | egrep "^*?docker-ce" | echo $?` != 0 ]]; then
        echo 'Docker-CE repo present'
      else
        echo 'Adding Docker-CE repo'
        dnf -y config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
      fi
    SHELL

    node.vm.provision :shell, inline: 'perl -i -pe\'s/^SELINUX=enforcing\s+$/SELINUX=disabled\n/\' /etc/selinux/config'
    node.vm.provision :shell, inline: "dnf -y install git bash-completion tree bind-utils"
    node.vm.provision :shell, path:   "config/bashrc_mod.pl"

  end


  ##########  Ubuntu 18.04 Bionic  ##########   

  k8s_ubu_vms = [
    # 1024 2048 3072 4096
    # Ubuntu 18.04 Bionic
    { :hostname => 'lucky-1',   :ip => '192.168.1.81', :box => 'ubuntu/bionic64', :cpu => 2, :ram => 4096, :vram => 64, },
    { :hostname => 'lucky-2',   :ip => '192.168.1.82', :box => 'ubuntu/bionic64', :cpu => 2, :ram => 4096, :vram => 64, },
    { :hostname => 'lucky-3',   :ip => '192.168.1.83', :box => 'ubuntu/bionic64', :cpu => 2, :ram => 4096, :vram => 64, },
    { :hostname => 'yolo-1',   :ip => '192.168.1.84', :box => 'ubuntu/bionic64', :cpu => 2, :ram => 4096, :vram => 64, },
    { :hostname => 'yolo-2',   :ip => '192.168.1.85', :box => 'ubuntu/bionic64', :cpu => 2, :ram => 4096, :vram => 64, },
    { :hostname => 'yolo-3',   :ip => '192.168.1.86', :box => 'ubuntu/bionic64', :cpu => 2, :ram => 4096, :vram => 64, },
  ]
  default_ubuntu_user = 'solidfire'

  k8s_ubu_vms.each do |machine|
    config.vm.define machine[:hostname] do |node|

      ip_addr = machine[:ip]
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      #node.vm.network "private_network", auto_network: true
      node.vm.network "public_network", ip: machine[:ip], :bridge => 'en0: Ethernet 1', :netmask => "255.255.255.0"
      node.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--memory', machine[:ram]]
        vb.customize ['modifyvm', :id, '--cpus', machine[:cpu]]
        vb.customize ['modifyvm', :id, '--vram', machine[:vram]]
        vb.name = machine[:hostname]
      end
      node.vm.provider 'virtualbox' do |vb|
        disk_container  = "../vbox/#{node.vm.hostname}/containers.vdi"
        disk_persistent = "../vbox/#{node.vm.hostname}/persistent.vdi"
        unless File.exist?( disk_container )
          vb.customize ['createhd', '--filename', disk_container, '--variant', 'Fixed', '--size', 12 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', disk_container]
        unless File.exist?(disk_persistent)
          vb.customize ['createhd', '--filename', disk_persistent, '--variant', 'Fixed', '--size', 24 * 1024]
        end
        vb.customize ['storageattach', :id,  '--storagectl', 'SCSI', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', disk_persistent]
    end

    node.vm.provision :shell, inline: <<-SETUP
      if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi
      useradd -m -Gsudo -p $(openssl passwd -1 #{default_ubuntu_user}) -s/bin/bash #{default_ubuntu_user}
      perl -pi -e's/^PasswordAuthentication\s+no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl reload sshd
    SETUP

    shared_folders_all.each do |shared|
      hostdir  = shared[:host_dir]
      guestdir = shared[:guest_dir]
      create   = shared[:create]
      owner    = shared[:owner]
      node.vm.synced_folder "../#{hostdir}", "/#{guestdir}", create: "#{create}, owner: "#{owner}"
    end

    end
  end

  ##########  CentOS 8  ##########   

  k8s_centos_vms = [
    # Ice
    { :hostname => 'ice-1', :ip => '192.168.1.71', :box => 'bento/centos-8', :cpu => 2, :ram => 4096, :vram => 64, },
    { :hostname => 'ice-2', :ip => '192.168.1.72', :box => 'bento/centos-8', :cpu => 2, :ram => 4096, :vram => 64, },
    { :hostname => 'ice-3', :ip => '192.168.1.73', :box => 'bento/centos-8', :cpu => 2, :ram => 4096, :vram => 64, },
  ]
  default_centos_user = 'solidfire'

  def sata_controller_exists?(controller_name="SATAController", node_name)
    `vboxmanage showvminfo #{node_name} | grep " #{controller_name}" | wc -l`.to_i == 1
  end

  k8s_centos_vms.each do |machine|
    config.vm.define machine[:hostname] do |node|

      ip_addr = machine[:ip]
      node.vm.box = machine[:box]
      node.vm.hostname = machine[:hostname]
      #node.vm.network "private_network", auto_network: true
      node.vm.network "public_network", ip: machine[:ip], :bridge => 'en0: Ethernet 1', :netmask => "255.255.255.0"
      node.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--memory', machine[:ram]]
        vb.customize ['modifyvm', :id, '--cpus', machine[:cpu]]
        vb.customize ['modifyvm', :id, '--vram', machine[:vram]]
        vb.name = machine[:hostname]

        disk_container  = "../vbox/#{node.vm.hostname}/containers.vdi"
        disk_persistent = "../vbox/#{node.vm.hostname}/persistent.vdi"
        #if ARGV[0] == "up" || ARGV[0] == "reload"; then;
        #if ARGV[0] == "up"; then

        #if ARGV[0] == "up"
        if ARGV[0] == "up" || ARGV[0] == "reload"
          if File.exist?( ".vagrant/machines/#{node.vm.hostname}/virtualbox/id" )
            unless sata_controller_exists?(controller_name="SATAController", node_name="#{node.vm.hostname}")
              vb.customize ["storagectl", :id, "--name", "SATAController", "--add", "sata"]
            end
            unless File.exist?( disk_container )
              vb.customize ['createhd', '--filename', disk_container, '--variant', 'Fixed', '--size', 12 * 1024]
            end
            vb.customize ['storageattach', :id,  '--storagectl', 'SATAController', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', disk_container]
            unless File.exist?( disk_persistent )
              vb.customize ['createhd', '--filename', disk_persistent, '--variant', 'Fixed', '--size', 24 * 1024]
            end
            vb.customize ['storageattach', :id,  '--storagectl', 'SATAController', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', disk_persistent]
          end
        end
      end

      node.vm.provision :shell, inline: <<-SETUP
        if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi
        useradd -m -Gwheel -p $(openssl passwd -1 #{default_centos_user}) -s/bin/bash #{default_centos_user}
        perl -pi -e's/^PasswordAuthentication\s+no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        systemctl reload sshd
        #grep "^#{default_centos_user} " /etc/sudoers || echo "#{default_centos_user}  ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
        #grep "^#{ip_addr} " /etc/hosts &&  perl -pi -e's/^#{ip_addr} /#{ip_addr}  #{node.vm.hostname}/' /etc/hosts || echo "#{ip_addr}  #{node.vm.hostname}" >> /etc/hosts
      SETUP
  
      shared_folders_all.each do |shared|
        hostdir  = shared[:host_dir]
        guestdir = shared[:guest_dir]
        create   = shared[:create]
        owner    = shared[:owner]
        node.vm.synced_folder "../#{hostdir}", "/#{guestdir}", create: "#{create}, owner: "#{owner}"
      end

    end
  end 

  ##########  End VMs  ##########   

end 

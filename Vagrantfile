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

  shared_folders = [
    { :host_dir => 'src', :guest_dir => 'src', :create => 'false', :owner => 'vagrant', },
    #{ :host_dir => 'charter', :guest_dir => 'charter', :create => 'false', :owner => 'vagrant', },
  ]

  ##########  Ansible Tower  ##########   

  config.vm.define 'tower' do |node|

    node.vm.box = "ansible/tower"
    node.vm.hostname = 'tower'
    #node.vm.network :private_network, :auto_network => true
    node.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', 2048]
      vb.customize ['modifyvm', :id, '--cpus', 2]
    end

    node.vm.provision :shell, inline: <<-SETUP
      if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi
      cp /vagrant/config/id_rsa* /root/.ssh
      if [[ -f /root/.ssh/id_rsa ]]; then chmod 0600 /root/.ssh/id_rsa; fi
      kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile
      cp /vagrant/config/license /etc/tower/license
    SETUP

    node.vm.provision :shell, path:   "config/hostwithmost.pl"
    node.vm.provision :shell, inline: <<-SHELL 
      if rpm --quiet -q epel-release; then
        echo 'EPEL repo present'
      else
        echo 'Adding EPEL repo'
        /bin/rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      fi
      /bin/yum -y update
    SHELL

    ##if Vagrant.has_plugin? 'vagrant-hostmanager' ##  system "vagrant hostmanager" ##end
    node.vm.provision :shell, inline: "[[ ! -f /etc/yum.repos.d/epel-7.repo ]] || /bin/mv /etc/yum.repos.d/epel-7.repo /etc/yum.repos.d/epel-7.repo.disabled"
    node.vm.provision :shell, inline: "/bin/yum -y install bash-completion tree bind-utils elinks lynx fortune-mod cowsay python2-pip wget"
    node.vm.provision :shell, inline: "/bin/pip install --disable-pip-version-check -q cryptography"
    node.vm.provision :shell, inline: "[[ -f /root/.gitconfig ]] || touch /root/.gitconfig"
    node.vm.provision :shell, path:   "config/gitconfiger.pl"
    node.vm.provision :shell, inline: "[[ -f /root/.bashrc ]] || touch /root/.bashrc"
    node.vm.provision :shell, path:   "config/bashrc_mod.pl"
    node.vm.provision :shell, path:   "config/fortune_cowsy.sh"

    #node.vm.synced_folder "../src", "/src", create: true, owner: 'vagrant'
    shared_folders.each do |shared|
      hostdir  = shared[:host_dir]
      guestdir = shared[:guest_dir]
      create   = shared[:create]
      owner    = shared[:owner]
      node.vm.synced_folder "../#{hostdir}", "/#{guestdir}", create: "#{create}, owner: "#{owner}"
    end

    node.vm.provision :shell, inline: "/bin/ansible-tower-service stop"

  end

  ##########  Jenkins  ##########   

  config.vm.define 'jenkins0' do |jenk|

    jenk.vm.box = "centos/7"
    jenk.vm.hostname = 'jenkins0'
    jenk.vm.network :private_network, :auto_network => true
    #jenk.vm.network 'forwarded_port', guest: 8080, host: 8880, :auto_correct => true
    jenk.vm.network 'forwarded_port', guest: 8080, host: 18080
    jenk.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', 2048]
      vb.customize ['modifyvm', :id, '--cpus', 2]
    end

    jenk.vm.provision :shell, inline: <<-SETUP
      if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi
      cp /vagrant/config/id_rsa* /root/.ssh
      if [[ -f /root/.ssh/id_rsa ]]; then chmod 0600 /root/.ssh/id_rsa; fi
      kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile
    SETUP

    jenk.vm.provision :shell, inline: <<-SHELL 
      if rpm --quiet -q epel-release; then
        echo 'EPEL repo present'
      else
        echo 'Adding EPEL repo'
        /bin/rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      fi
      /bin/yum -y update
    SHELL

    jenk.vm.provision :shell, inline: "[[ ! -f /etc/yum.repos.d/epel-7.repo ]] || /bin/mv /etc/yum.repos.d/epel-7.repo /etc/yum.repos.d/epel-7.repo.disabled"
    jenk.vm.provision :shell, inline: "/bin/yum -y install fortune-mod cowsay tree"
    jenk.vm.provision :shell, path:   "config/fortune_cowsy.sh"
    jenk.vm.provision :shell, inline: "systemctl enable firewalld && systemctl start firewalld"

    shared_folders.each do |shared|
      hostdir  = shared[:host_dir]
      guestdir = shared[:guest_dir]
      create   = shared[:create]
      owner    = shared[:owner]
      jenk.vm.synced_folder "../#{hostdir}", "/#{guestdir}", create: "#{create}, owner: "#{owner}"
    end

  end
  
  ##########  CentOS 7 VM's  ##########   

  centos7vms = [
    {
      :hostname => 'cent7s0',
      :box      => 'centos/7',
      :cpu      => 1,
      :ram      => 1024,
    },
    {
      :hostname => 'cent7s1',
      :box      => 'centos/7',
      :cpu      => 1,
      :ram      => 1024,
    },
    #{
    #  :hostname => 'db0',
    #  :box      => 'centos/7',
    #  :cpu      => 1,
    #  :ram      => 1024,
    #},
    #{
    #  :hostname => 'web0',
    #  :box      => 'centos/7',
    #  :cpu      => 1,
    #  :ram      => 1024,
    #},
    #{
    #  :hostname => 'tomcat0',
    #  :box      => 'centos/7',
    #  :cpu      => 1,
    #  :ram      => 1024,
    #},
    #{
    #  :hostname => 'wordpress0',
    #  :box      => 'centos/7',
    #  :cpu      => 1,
    #  :ram      => 1024,
    #},
    {
      :hostname => 'gitlab0',
      :box      => 'centos/7',
      :cpu      => 1,
      :ram      => 1024,
    },
  ]

  centos7vms.each do |machine|
    config.vm.define machine[:hostname] do |cent7|

      cent7.vm.box = machine[:box]
      cent7.vm.hostname = machine[:hostname]
      #cent7.vm.autostart = false
      #cent7.vm.network :'private_network', ip: '192.168.33.10'
      cent7.vm.network 'forwarded_port', guest: 80, host: 8880, :auto_correct => true
      cent7.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--memory', machine[:ram]]
        vb.customize ['modifyvm', :id, '--cpus', machine[:cpu]]
      end
      cent7.vm.network :private_network, :auto_network => true
 
      cent7.vm.provision :shell, inline: <<-SETUP
        if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi
        cp /vagrant/config/id_rsa* /root/.ssh
        if [[ -f /root/.ssh/id_rsa ]]; then chmod 0600 /root/.ssh/id_rsa; fi
        kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile
      SETUP

      cent7.vm.provision :shell, inline: <<-SHELL 
        if rpm --quiet -q epel-release; then
          echo 'EPEL repo present'
        else
          echo 'Adding EPEL repo'
          rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
        fi
        yum -y update
      SHELL

      cent7.vm.provision :shell, inline: "[[ ! -f /etc/yum.repos.d/epel-7.repo ]] || /bin/mv /etc/yum.repos.d/epel-7.repo /etc/yum.repos.d/epel-7.repo.disabled"
      cent7.vm.provision :shell, inline: 'perl -i -pe\'s/^SELINUX=enforcing\s+$/SELINUX=disabled\n/\' /etc/selinux/config'
      cent7.vm.provision :shell, inline: "yum -y install fortune-mod cowsay"
      cent7.vm.provision :shell, path:   "config/fortune_cowsy.sh"
      cent7.vm.provision :shell, inline: "systemctl enable firewalld && systemctl start firewalld"

      shared_folders.each do |shared|
        hostdir  = shared[:host_dir]
        guestdir = shared[:guest_dir]
        create   = shared[:create]
        owner    = shared[:owner]
        cent7.vm.synced_folder "../#{hostdir}", "/#{guestdir}", create: "#{create}, owner: "#{owner}"
      end

    end
  end

  ##########  CentOS 6 VM's  ##########   

  centos6vms = [
    {
      :hostname => 'cent6s0',
      :box      => 'centos/6',
      :cpu      => 1,
      :ram      => 512,
    },
    {
      :hostname => 'cent6s1',
      :box      => 'centos/6',
      :cpu      => 1,
      :ram      => 512,
    },
    #{
    #  :hostname => 'mongo1',
    #  :box      => 'centos/6',
    #  :cpu      => 1,
    #  :ram      => 512,
    #},
    #{
    #  :hostname => 'mongo2',
    #  :box      => 'centos/6',
    #  :cpu      => 1,
    #  :ram      => 512,
    #},
    #{
    #  :hostname => 'mongo3',
    #  :box      => 'centos/6',
    #  :cpu      => 1,
    #  :ram      => 512,
    #},
    #{
    #  :hostname => 'mongo4',
    #  :box      => 'centos/6',
    #  :cpu      => 1,
    #  :ram      => 512,
    #},
  ]

  centos6vms.each do |machine|
    config.vm.define machine[:hostname] do |cent6|

      cent6.vm.box = machine[:box]
      cent6.vm.hostname = machine[:hostname]
      cent6.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--memory', machine[:ram]]
      end
      cent6.vm.network :private_network, :auto_network => true

      cent6.vm.provision :shell, inline: <<-SETUP
        if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi
        cp /vagrant/config/id_rsa* /root/.ssh
        if [[ -f /root/.ssh/id_rsa ]]; then chmod 0600 /root/.ssh/id_rsa; fi
        kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile
        restorecon -Rv ~/.ssh
      SETUP

      cent6.vm.provision :shell, inline: <<-SHELL 
        if rpm --quiet -q epel-release; then
          echo 'EPEL repo present'
        else
          echo 'Adding EPEL repo'
          rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
        fi
        yum -y update
      SHELL

      cent6.vm.provision :shell, inline: 'perl -i -pe\'s/^SELINUX=enforcing\s+$/SELINUX=disabled\n/\' /etc/selinux/config'
      #cent6.vm.provision :shell, inline: "[[ -f /etc/profile.d/motd.sh ]] || echo '/bin/fortune | /bin/cowsay' > /etc/profile.d/motd.sh"
      cent6.vm.provision :shell, inline: "yum -y install fortune-mod cowsay"
      cent6.vm.provision :shell, path:   "config/fortune_cowsy.sh"

      shared_folders.each do |shared|
        hostdir  = shared[:host_dir]
        guestdir = shared[:guest_dir]
        create   = shared[:create]
        owner    = shared[:owner]
        cent6.vm.synced_folder "../#{hostdir}", "/#{guestdir}", create: "#{create}, owner: "#{owner}"
      end

    end
  end

  ##########  Ubuntu 14 VM's  ##########   

  ubuntu14vms = [
    #{
    #  :hostname => 'ubu14s0',
    #  :box      => 'ubuntu/trusty64',
    #  :cpu      => 1,
    #  :ram      => 512,
    #},
  ]

  ubuntu14vms.each do |machine|
    config.vm.define machine[:hostname] do |ubu|
      ubu.vm.box      = machine[:box]
      ubu.vm.hostname = machine[:hostname]
      ubu.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--memory', machine[:ram]]
      end
      ubu.vm.network :private_network, :auto_network => true
      ubu.vm.provision :shell, inline: "if [[ ! -d /root/.ssh ]]; then mkdir -m0700 /root/.ssh; fi"
      ubu.vm.provision :shell, inline: "cp /vagrant/config/id_rsa* /root/.ssh"
      ubu.vm.provision :shell, inline: "kfile='/root/.ssh/authorized_keys'; if [[ ! -z $kfile ]]; then cat /root/.ssh/id_rsa.pub > $kfile; fi && chmod 0600 $kfile"
    end   
  end   

  ##########  Example Settings  ##########   

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

# ansible-tower
_The only good bug is a dead bug._

Development environment for Ansible Tower 3.1.4 (Ansible 2.3.1.0) and CentOS client VM's using Vagrant. 
 _______________
<  Tower 3.1.4  >
 ---------------
        \   ^__^
         \  (oo)\_______
            (__)      A )\/\
                ||----w |
                ||     ||

## Requirements

This development environment requires the following on the host machine (i.e. your MacBook or PC):

  - Vagrant
  - Vagrant Plugins
  - Optional:  Create VM definitions in `Vagrantfile`.

### Install Vagrant

Install Vagrant by downloading from https://www.vagrantup.com/downloads.html

### Install Vagrant Plugins

Install Vagrant plugins using native plugin manager.  `vagrant-hostmanager` manages VM operating system hosts file (/etc/hosts).

  - $ vagrant plugin install vagrant-hostmanager

### Create VM Definitions (optional)

Virtual machine definitions are stored in the file `Vagrantfile`.  Customize as needed.
A large number of VM definitions which adds some notable lag to Vagrant start-up times.
Start-up lag can be remedied by pruning unwanted definitions.

### Start VM's

Get status:
  - $ vagrant status

Start VM's:
  - $ vagrant up ansible230
  - $ vagrant up centos7s0 centos7s1

Update hosts files:
  - $ vagrant hostmanager

Re-run provision scripts to update Ansible hosts:
  - $ vagrant provision ansible230

Bounce servers to disable SELinux (unfortunate for now):
  - $ vagrant reload centos7s0 centos7s1

Login to Ansible Tower server(s) and change to root.  Run ansible to connect to all nodes then type yes then enter three times:
  - $ vagrant ssh ansible230
  - ansible230$ sudo su -
  - ansible230$ ansible all -m ping   # type yes three times
  - ansible230$ exit

Stop VM's:
  - $ vagrant halt centos7s1 centos7s0 ansible230

### Helpful tips

Start all VM's:
  - $ vagrant up

Stop all VM's:
  - $ vagrant halt

Get global status:
  - $ vagrant global-status

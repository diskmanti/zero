# ansible-tower
_The only good bug is a dead bug._

Development environment for Ansible Tower and clients using Vagrant and Virtualbox.

 _______________
<  Ansible Tower  >
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

Install Vagrant plugins using native plugin manager.  
`vagrant-hostmanager` manages VM operating system hosts file (/etc/hosts).
VMware Fusion and Desktop are supported with a paid plugin.

  - $ vagrant plugin install vagrant-hostmanager

### Create VM Definitions (optional)

Virtual machine definitions are stored in the file `Vagrantfile`.  Customize as needed.
A large number of VM definitions which adds some notable lag to Vagrant start-up times.
Start-up lag can be remedied by pruning unwanted definitions.

### Spin up new VM's and configure

Get status:
  - $ vagrant status

Start all defined VM's:
  - $ vagrant up

Update hosts files:
  - $ vagrant hostmanager

Re-run provision scripts to update Ansible hosts:
  - $ vagrant provision tower

Bounce servers to disable SELinux (unfortunate for now):
  - $ vagrant reload centos7s0 centos7s1

Login to Ansible Tower server and change to root.
Run ansible ping module to connect to all nodes.
Type yes and press return three times:
  - $ vagrant ssh tower
  - tower$ sudo su -
  - tower$ ansible all -m ping   #  *type yes three times*
  - tower$ exit

### Develop

Ansible repo available from tower server at `/vagrant/files`.
This is a shared directory to directory where Vagrantfile resides on host.

### Stop VM's

Stop VM:
  - $ vagrant halt centos7s1 centos7s0 tower

### Destroy VM(s) to abandon or rebuild:

  - $ vagrant destroy -f centos7s1
  - $ vagrant destroy -f centos7s1 centos7s0 tower

### Helpful commands

Start all VM's:
  - $ vagrant up

Start single VM:
  - $ vagrant up centos7s0

Start multiple VM's:
  - $ vagrant up centos7s0 centos7s1

Stop all VM's:
  - $ vagrant halt

Get global status:
  - $ vagrant global-status

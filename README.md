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

  - Virtualbox (VMware Fusion or VMware Workstation are supported with plugin)
  - Vagrant
  - Vagrant Plugins
  - Optional:  Create VM definitions in `Vagrantfile`.

### Clone repo
Clone this repository to local host and change to directory.
  - $ git clone https://github.com/rcompos/ansible-tower

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

Change to ansible-tower directory and run the following as your user (root not required).

Get status:
  - $ vagrant status

Start set of VM's:
  - $ vagrant up tower dbserver webserver

Update hosts files:
  - $ vagrant hostmanager

Re-run provision scripts to update Ansible hosts:
*All ip addresses are listed.*
  - $ vagrant provision tower

Bounce servers to disable SELinux (unfortunate for now):
  - $ vagrant reload dbserver webserver

Login to Ansible Tower server and change to root. 
*The login message provides the url, username and password for Ansible Tower web service.*
  - $ vagrant ssh tower

On server `tower` change to root and run ansible ping module to connect to all nodes.
*Execute as root on `tower` server*:
Type yes and press return three times:
  - tower$ sudo su -
  - tower$ ansible all -m ping   #  *type yes three times*

### Develop

Ansible repo available from tower server at `/vagrant/files`.
This is a shared directory to directory where Vagrantfile resides on host.

Example LAMP simple on CentOS 7 `webserver` and `dbserver`.  *Execute as root on* `tower` *server*:
See readme https://github.com/rcompos/ansible-tower/tree/master/files/lamp_simple_rhel7-demo

  - tower$  cd /vagrant/files/lamp_simple_rhel7-demo
  - tower$  ansible-playbook -i hosts site.yml

Example Tomcat CentOS 7 on server `tomcat0`.  *Execute as root on* `tower` *server*:
See readme https://github.com/rcompos/ansible-tower/tree/master/files/tomcat-standalone-demo

  - tower$  cd /vagrant/files/tomcat-standalone-demo
  - tower$  ansible-playbook -i hosts site.yml

Example MongoDB on CentOS 6 cluster on `mongo1`, `mongo2`, `mongo3` and `mongo4`.  *Execute as root on* `tower` *server*:
See readme https://github.com/rcompos/ansible-tower/tree/master/files/mongodb-demo

  - tower$  cd /vagrant/files/mongodb-demo
  - tower$  ansible-playbook -i hosts site.yml

### Stop VM's

Stop VM's:
  - $ vagrant halt

### Destroy VM's to abandon or rebuild:

  - $ vagrant destroy -f tower dbserver webserver

### Helpful commands

Start all VM's:
  - $ vagrant up

Start single VM:
  - $ vagrant up tower

Start multiple VM's:
  - $ vagrant up dbserver webserver

Stop single VM:
  - $ vagrant halt dbserver

Stop multiple VM's:
  - $ vagrant halt dbserver webserver

Get global status:
  - $ vagrant global-status

# ansible-tower
_The only good bug is a dead bug._

Development environment for Ansible Tower and client VM's using Vagrant

## Setup

This development environment requires the following on the host machine (i.e. your MacBook or PC):

  - Vagrant
  - Vagrant Plugins
  - Optional:  Create VM definitions in `Vagrantfile`.

### Install Vagrant

Install Vagrant by downloading from http://www.vagrant.com

### Install Vagrant Plugins

Install Vagrant plugins:

  - hostmanager
    Manages virtual machine operating system hosts file (/etc/hosts)

  - vbguest
    Manages VM guest additions.

### Create VM Definitions

Virtual machine definitions are stored in the file `Vagrantfile`.
A large number of VM definitions which adds some notable lag to Vagrant start-up times.
Start-up lag can be remedied by pruning unwanted definitions.

### 





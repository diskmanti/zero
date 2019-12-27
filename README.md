# zero

Create local virtual machines using Vagrant and Virtualbox, VMware Fusion or Workstation.  
Define sets of VM's in the Vagrantfile and spin them up or wipe them out with a single command.  
You can include configuration to be run (such as shell commands and scripts) after OS-install in the provision section.

VM named 'zero' runs CentOS 8, includes a GUI, bridged adapter, DHCP bridged networking.

VM named 'uno' runs CentOS 8, includes a GUI, bridged adapter, static IP bridged networking.

Other VM's are CentOS 8 or Ubuntu 18.04 (Bionic), no GUI with various network options.

* bionic-N: Ubuntu 18.04, bridged adapter, static IP's
* lucky-N, yolo-N:  Ubuntu 18.04, bridged adapter DHCP, additional virtual disks
* ice-N:  CentOS 8, bridged adapter DHCP, additional virtual disks
    
If the bridge adapter doesn't exist or isn't specified, you'll be prompted to choose a network adapter.

Any of the VM's can use a virtual private network employing NAT by changing the network definition from public_network to private_network.
    node.vm.network "private_network", auto_network: true

```
 ____________________________________
<  The only good bug is a dead bug.  >
 ------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)        )\/\
                ||----w |
                ||     ||
```
## Requirements

Running VM's requires the following on the host machine (i.e. your MacBook or PC):

  - Virtualbox (VMware Fusion or VMware Workstation are supported with plugin)
  - Vagrant
  - Git

#### Clone repo
Clone this repository to working directory on local host and change to directory.

`$ git clone https://github.com/rcompos/zero`

`$ cd zero`

#### Install Vagrant

The Vagrant recommendation is to download installer from https://www.vagrantup.com/downloads.html

*MacOS*: `$ brew cask install vagrant`

#### Install Vagrant Plugin(s)

Install Vagrant plugins using native plugin manager.  
VMware Fusion and Desktop are supported with a paid plugin.

#### Create VM Definitions (optional)

Virtual machine definitions are stored in the file *Vagrantfile*.  Customize as needed.
A large number of VM definitions which adds some notable lag to Vagrant start-up times.
Start-up lag can be remedied by pruning unwanted definitions.

If you want to address the guest VM's by host name, you must create DNS entries or entries
on the host VM.

## Setup
#### Spin up basic Linux VM

Change to *zero* directory and run the following as your user (root not required).  
Note: Sometimes you 

Get status.

`$ vagrant status`

Start set of VM's.

`$ vagrant up zero`

Login to control server and change to root. 

`$ vagrant ssh zero`

On server *zero* change to root and run ansible ping module to connect to all nodes.
*Execute as root on server 'zero'.*  Type yes and press return.

```
zero$ sudo su -
zero$ ansible all -m ping   #  * type yes then enter *
```

#### Spin up sets of VM's

Change to *zero* directory and run the following as your user (root not required).

Get status.

`$ vagrant status`

Start set of virtual machines.

`$ vagrant up zero lucky-1`

Start many virtual machines.  Note, these VM's must all be pre-defined in the Vagrantfile.

`$ for i in {1..3}; do vagrant up lucky-$i; done`

Bounce servers to disable SELinux (unfortunate for now).

`$ vagrant reload zero lucky-1`


#### Hostname resolution

If you have bridged networking VMs (public_network) and want to address the VMs by name you can:
  * Create DNS entries for your domain
  * Add entries to host and guest hosts files
 
If you decided to maintain your own host files, 
you should update host and guest machine hosts file (/etc/hosts) with the IP address and name of all your VM's. 


## Develop

Log on to the zero server.  Update your git identity.

```
root@zero ~ $ git config --global user.name "John Doe"
root@zero ~ $ git config --global user.email johndoe@example.com
```

Change to your desired location and clone some repo for development.
The */src* directory on the control VM is shared from the host's filesystem at *../src* (directory named *src* in parent directory).

```
root@zero ~ $ cd /src
root@zero /src $ git clone https://github.com/<user>/<repo>.git
```

Develop and test using server zero as development box.
All files in *src* are stored outside the zero repo.
The *src* directory will persist on host filesystem even if VM's are destroyed or the zero repo is removed.

```
root@zero /sr $ cd my-repo
root@zero /src/my-repo (mybranch *) $
```

## Destruction

#### Stop VM's

Stop VM's.

`$ vagrant halt`

#### Destroy VM's to abandon or rebuild

`$ vagrant destroy -f zero lucky-1`

## Helpful Commands

Start all VM's.

`$ vagrant up`

Start single VM.

`$ vagrant up zero`

Start multiple VM's.

`$ vagrant up lucky-1 lucky-2 lucky-3`

Stop single VM.

`$ vagrant halt dbserver`

Stop multiple VM's.

`$ vagrant halt lucky-1 lucky-2 lucky-3`

Get global status.

`$ vagrant global-status`

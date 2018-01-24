# Salt Config for Kubernetes Kubeadm

#name: Role Facts
{% set block_device = '/dev/sdb' %}
{% set kubernetes_repo = 'kubernetes.repo' %}

#name: Get SELinux state
#name: SELinux Permissive
#name: Disable Service Firewalld

/sbin/swapoff -a:
  cmd.run

Delete swaps in /etc/fstab:
  file.replace:
    - name: /etc/fstab
    - pattern: '^.*swap.*swap.*$'
    - repl: '# Swap disabled for Kubelet'

EPEL Repo:
  pkg.installed:
    - name: epel-release

Copy Kubernetes Repo File:
  file.managed:
    - name: /etc/yum.repos.d/{{ kubernetes_repo }}
    - source: salt://files/{{ kubernetes_repo }}

Enable Kubernetes Repo:
  cmd.run:
    - name: yum-config-manager --enable kubernetes

Add Docker-CE Repo:
  cmd.run:
    - name: yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#name: Accept RPM GPG Keys
#name: Install RPMs

Install Docker-CE:
  # Install explicitly with yum because of errors using pkg
  cmd.run:
    - name: yum install -y docker-ce-17.06.2.ce-1.el7.centos

Install RPMs:
  pkg.installed:
    - pkgs:
      - device-mapper-persistent-data
      - lvm2
      - bind-utils
      - net-tools
      - fortune-mod
      - cowsay
      - tree
      #- docker-ce-17.06.2.ce-1.el7.centos
      - kubelet
      - kubeadm
      - kubectl
      - container-storage-setup

#name: Check for LVM Physical Volume "{{ block_device }}"

Create config file for LVM Thin Pool:
  cmd.run:
    - name: echo DEVS="{{ block_device }}" > /etc/sysconfig/docker-storage-setup

Create LVM Thin Pool:
  cmd.run:
    - name: container-storage-setup

docker:
  service.running:
    - enable: True

kubelet:
  service.running:
    - enable: True

#name: Configure Login Banner
#name: Copy MOTD
#name: Edit Docker Daemon File
#name: Slurp File /etc/docker/daemon.json
#name: Print File /etc/docker/daemon.json
#name: Add KUBECONFIG to root bashrc

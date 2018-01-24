# Salt Config for Kubernetes Kubeadm

#name: Role Facts
{% set block_device = '/dev/sdb' %}
{% set kubernetes_repo = 'kubernetes.repo' %}
{% set motd_file = 'motd-k8s.txt' %}

#name: Get SELinux state
#name: SELinux Permissive
#name: Disable Service Firewalld

systemctl stop firewalld:
  cmd.run

systemctl disable firewalld:
  cmd.run

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

Configure Login Banner:
  cmd.script:
    - source: salt://files/fortune_cowsy.sh
    - user: root
    - group: root
    - shell: /bin/bash

Copy Motd:
  file.managed:
    - name: /etc/motd
    - source: salt://files/{{ motd_file }}

Add KUBECONFIG to root bashrc:
  cmd.run:
    - name: echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /root/.bashrc

# Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
Change Kubectl config:
  file.replace:
    - name: /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
    - pattern: '^Environment="KUBELET_CGROUP_ARGS=.*$'
    - repl: 'Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"'

# Create a pod network
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml



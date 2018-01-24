# Salt Config for Kubernetes Prereqs

#name: Role Facts
{% set kube_master = 'kube0' %}
{% set block_device = '/dev/sdb' %}
{% set kubernetes_repo = 'kubernetes.repo' %}
{% set docker_repo = 'virt7-docker-common-release.repo' %}
{% set motd_file = 'motd-k8s.txt' %}

#name: Get SELinux state
#name: SELinux Permissive
#name: Disable Service Firewalld

systemctl stop firewalld:
  cmd.run

systemctl disable firewalld:
  cmd.run

#/sbin/swapoff -a:
#  cmd.run
#
#Delete swaps in /etc/fstab:
#  file.replace:
#    - name: /etc/fstab
#    - pattern: '^.*swap.*swap.*$'
#    - repl: '# Swap disabled for Kubelet'

EPEL Repo:
  pkg.installed:
    - name: epel-release

#Copy Kubernetes Repo File:
#  file.managed:
#    - name: /etc/yum.repos.d/{{ kubernetes_repo }}
#    - source: salt://files/{{ kubernetes_repo }}
#
#Enable Kubernetes Repo:
#  cmd.run:
#    - name: yum-config-manager --enable kubernetes

#Add Docker-CE Repo:
#  cmd.run:
#    - name: yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

Copy Docker Repo File:
  file.managed:
    - name: /etc/yum.repos.d/{{ docker_repo }}
    - source: salt://files/{{ docker_repo }}

#name: Accept RPM GPG Keys
#name: Install RPMs

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
      - kubernetes
      - etcd
      - flannel
      - container-storage-setup

#name: Check for LVM Physical Volume "{{ block_device }}"

Create config file for LVM Thin Pool:
  cmd.run:
    - name: echo DEVS="{{ block_device }}" > /etc/sysconfig/docker-storage-setup

Create LVM Thin Pool:
  cmd.run:
    - name: container-storage-setup

#docker:
#  service.running:
#    - enable: True

#kubelet:
#  service.running:
#    - enable: True

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

Edit k8s config:
  file.replace:
    - name: /etc/kubernetes/config
    - pattern: '^KUBE_MASTER='
    - repl: "KUBE_MASTER=\"--master=http://{{ kube_master }}:8080\""


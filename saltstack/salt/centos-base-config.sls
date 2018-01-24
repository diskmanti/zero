# Salt config for CentOS
# Base setup

User account for Ron Compos:
  user.present:
    - name: rcompos
    - shell: /bin/bash
    - home: /home/rcompos
    - groups:
      - wheel

Copy /etc/yum.repos.d/google-chrome.repo:
  file.managed:
    - name: /etc/yum.repos.d/google-chrome.repo
    - source:
      - salt://files/google-chrome.repo
    - mode: '0644'

Install Google Chrome Stable:
  pkg.installed:
    - name: google-chrome-stable

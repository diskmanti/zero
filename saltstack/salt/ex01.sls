install vim:
  #pkg.installed:
  pkg.removed:
    - name: vim

create my_new_directory:
  file.directory:
    - name: /opt/my_new_directory
    - user: root
    - group: root
    - mode: 755

Install mariadb and ensure service is running:
  pkg.installed:
    - name: mariadb-server-10.0
  service.running:
    - name: mysql
    - enable: true

Clone the SaltStack bootstrap script repo:
  pkg.installed: 
    - name: git # make sure git is installed first!
  git.latest:
    - name: https://github.com/rcompos/ansibles
    #- rev: develop
    - target: /tmp/ansibles

user account for pete:
  user.present:
    - name: pete
    - shell: /bin/bash
    - home: /home/pete
    - groups:
      - sudo

{% for usr in ['moe','larry','curly'] %}
{{ usr }}:
  user.present
{% endfor %}

myserver in hosts file:
  host.present:
    - name: myserver
    - ip: 192.168.0.42

restart nfs-config:
  module.run:
    - name: service.restart
    - m_name: nfs-config

editori installed:
  pkg.installed:
    - name: {{ pillar['editor'] }}

{% for DIR in ['/tmp/dir1','/tmp/dir2','/tmp/dir3'] %}
{{ DIR }}:
  file.directory:
    - user: root
    - group: root
    - mode: 774
{% endfor %}

{{ salt.cmd.run('whoami') }}:
  user.present  

deploy the file:
  file.managed:
    - name: /tmp/yolo.txt
    - source: salt://yolo.txt

#update lftp conf:
#  file.append:
#    - name: /etc/lftp.conf
#    - text: set net:limit-rate 100000:500000

copy some files to the web server:
  file.recurse:
    - name: /tmp/wdubw
    - source: salt://wdubw

# Salt Config for Kubernetes Master

#name: Role Facts
{% set kube_master = 'kube0' %}
{% set block_device = '/dev/sdb' %}
{% set kubernetes_repo = 'kubernetes.repo' %}
{% set docker_repo = 'virt7-docker-common-release.repo' %}
{% set motd_file = 'motd-k8s.txt' %}
{% set service_cluster_ip_range = '10.254.0.0/16' %}
{% set flannel_network = '172.30.0.0/16' %}
{% set flannel_etcd_prefix = '/kube-centos/network' %}
{% set script_dir = '/root' %}


Edit /etc/etcd/etcd.conf ETCD_NAME:
  file.replace:
    - name: /etc/etcd/etcd.conf
    - pattern: '^ETCD_NAME=.*$'
    - repl: 'ETCD_NAME=default'

Edit /etc/etcd/etcd.conf ETCD_DATA_DIR:
  file.replace:
    - name: /etc/etcd/etcd.conf
    - pattern: '^ETCD_DATA_DIR=.*$'
    - repl: 'ETCD_DATA_DIR="/var/lib/etcd/default.etcd"'

Edit /etc/etcd/etcd.conf ETCD_LISTEN_CLIENT_URLS:
  file.replace:
    - name: /etc/etcd/etcd.conf
    - pattern: '^ETCD_LISTEN_CLIENT_URLS=.*$'
    - repl: 'ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"'

Edit /etc/etcd/etcd.conf ETCD_ADVERTISE_CLIENT_URLS:
  file.replace:
    - name: /etc/etcd/etcd.conf
    - pattern: '^ETCD_ADVERTISE_CLIENT_URLS=.*$'
    - repl: 'ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"'

# Print /etc/etcd/etcd.conf

Edit /etc/kubernetes/apiserver KUBE_API_ADDRESS:
  file.replace:
    - name: /etc/kubernetes/apiserver
    - pattern: '^KUBE_API_ADDRESS=.*$'
    - repl: 'KUBE_API_ADDRESS="--address=0.0.0.0"'

Edit /etc/kubernetes/apiserver KUBE_API_PORT:
  file.replace:
    - name: /etc/kubernetes/apiserver
    - pattern: '^KUBE_API_PORT=.*$'
    - repl: 'KUBE_API_PORT="--port=8080"'

Edit /etc/kubernetes/apiserver KUBELET_PORT:
  file.replace:
    - name: /etc/kubernetes/apiserver
    - pattern: '^KUBELET_PORT=.*$'
    - repl: 'KUBELET_PORT="--kubelet-port=10250"'

Edit /etc/kubernetes/apiserver KUBE_ETCD_SERVERS:
  file.replace:
    - name: /etc/kubernetes/apiserver
    - pattern: '^KUBE_ETCD_SERVERS=.*$'
    - repl: 'KUBE_ETCD_SERVERS="--etcd-servers=http://{{ kube_master }}:2379"'

Edit /etc/kubernetes/apiserver KUBE_SERVICE_ADDRESSES:
  file.replace:
    - name: /etc/kubernetes/apiserver
    - pattern: '^KUBE_SERVICE_ADDRESSES=.*$'
    - repl: 'KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range={{ service_cluster_ip_range }}"'

Edit /etc/kubernetes/apiserver KUBE_API_ARGS:
  file.replace:
    - name: /etc/kubernetes/apiserver
    - pattern: '^KUBE_API_ARGS=.*$'
    - repl: 'KUBE_API_ARGS=""'

# Print /etc/kubernetes/apiserver

etcd:
  service.running:
    - enable: True

etcdctl mkdir /kube-centos/network:
  cmd.run

# flannel_network = '172.30.0.0/16'
Create network entry in etcd:
  cmd.run:
    #- name: etcdctl mk /kube-centos/network/config "{ \"Network\": \"{{ flannel_network }}\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"
    - name: 'etcdctl mk /kube-centos/network/config "{ \"Network\": \"{{ flannel_network }}\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"'

Edit /etc/sysconfig/flanneld FLANNEL_ETCD_ENDPOINTS:
  file.replace:
    - name: /etc/sysconfig/flanneld
    - pattern: '^FLANNEL_ETCD_ENDPOINTS=.*$'
    - repl: "FLANNEL_ETCD_ENDPOINTS=\"http://{{ kube_master }}:2379\""

Edit /etc/sysconfig/flanneld FLANNEL_ETCD_PREFIX:
  file.replace:
    - name: /etc/sysconfig/flanneld
    - pattern: '^FLANNEL_ETCD_PREFIX=.*$'
    - repl: "FLANNEL_ETCD_PREFIX=\"{{ flannel_etcd_prefix }}\""

Edit /etc/sysconfig/flanneld FLANNEL_OPTIONS:
  file.replace:
    - name: /etc/sysconfig/flanneld
    - pattern: '^FLANNEL_OPTIONS=.*$'
    - repl: "FLANNEL_OPTIONS=\"\""

# Print /etc/sysconfig/flanneld

flanneld:
  service.running:
    - enable: True

Copy k8s-master-start.sh:
  file.managed:
    - source: salt://files/k8s-master-start.sh
    - name: "{{ script_dir }}/k8s-master-start.sh"
    - user: root
    - group: root
    - mode: 0754

Copy k8s-master-stop.sh:
  file.managed:
    - source: salt://files/k8s-master-stop.sh
    - name: "{{ script_dir }}/k8s-master-stop.sh"
    - user: root
    - group: root
    - mode: 0754

kubelet:
  service.running:
    - enable: True

Start K8s service:
  cmd.run:
    - name: "{{ script_dir }}/k8s-master-start.sh"


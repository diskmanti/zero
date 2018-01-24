#!/bin/bash

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler flanneld; do
    systemctl stop $SERVICES
    echo systemctl stop $SERVICES
    #systemctl status $SERVICES
done

for SERVICES in kube-proxy kubelet flanneld docker; do
    systemctl stop $SERVICES
    echo systemctl stop $SERVICES
    #systemctl status $SERVICES
done

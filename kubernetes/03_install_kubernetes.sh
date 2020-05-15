#!/bin/bash

set -e

./use_aliyun_kubernetes_yum_source.sh

echo `setenforce 0`
yum remove -y kubelet kubeadm kubectl --disableexcludes=kubernetes
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes


# Check installed Kubernetes packages
yum list installed | grep kube

systemctl enable kubelet && systemctl start kubelet


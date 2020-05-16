#!/bin/bash

kubeadm config print init-defaults > kubeadm-init.yaml

ip a
read -p '请输入本机IP: ' IP
sed -e 's/1.2.3.4/'$IP'/g' -i kubeadm-init.yaml
sed -e 's/imageRepository: k8s.gcr.io/imageRepository: registry.cn-hangzhou.aliyuncs.com\/google_containers/g' -i kubeadm-init.yaml
kubeadm config images pull --config kubeadm-init.yaml
kubeadm init --config kubeadm-init.yaml
echo -e '\033[5;37;43m[十分重要]\033[0m' '请记录上面的token'
read -p '按回车键继续：'

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 配置网络
wget https://docs.projectcalico.org/v3.8/manifests/calico.yaml
sed -e 's/192.168.0.0\/16/10.96.0.0\/12/g' -i calico.yaml
kubectl apply -f calico.yaml

sleep 10
./k8s_health_check.sh

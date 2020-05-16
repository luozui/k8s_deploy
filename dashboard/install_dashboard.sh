#!/bin/bash

wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml
kubectl apply -f recommended.yaml 

kubectl apply -f dashboard-adminuser.yaml

cd ~/.kube
grep 'client-certificate-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.crt
grep 'client-key-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.key
openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-client"

echo -e '\033[5;37;43m[十分重要]\033[0m' '请自行复制登录证书到本地: .kube/kubecfg.p12'
read -p "按回车键继续: "

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

echo -e '\033[5;37;43m[十分重要]\033[0m' "dashboard 地址："
echo https://{k8s-master-ip}:6443/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login
echo -e '\033[5;37;43m[十分重要]\033[0m' "请用下载的证书和上面的token登录"

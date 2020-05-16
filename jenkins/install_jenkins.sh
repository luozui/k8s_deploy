#!/bin/bash

kubectl $1 -f install.yaml
kubectl $1 -f service-account.yml

echo -e "执行以下命令露出jenkins："
echo -e kubectl --namespace kube-logging port-forward --address 0.0.0.0 svc/jenkins 8080

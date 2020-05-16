#!/bin/bash

kubectl $1 -f install.yaml

echo -e "执行以下命令露出jenkins："
echo -e kubectl --namespace kube-logging port-forward --address 0.0.0.0 svc/jenkins 8080

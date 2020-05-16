#!/bin/bash

kubectl $1 -f install.yaml
kubectl $1 -f service-account.yaml

echo -e "执行以下命令露出jenkins："
echo -e kubectl --namespace devops port-forward --address 0.0.0.0 svc/jenkins 8080

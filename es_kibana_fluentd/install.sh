#!/bin/bash

kubectl create -f kube-logging.yaml

kubectl create -f elasticsearch_svc.yaml

kubectl create -f elasticsearch_statefulset.yaml

kubectl create -f kibana.yaml

kubectl create -f fluentd.yaml

echo -e "执行以下命令露出kibana："
echo -e kubectl port-forward kibana-6c9fb4b5b7-plbg2 5601:5601 --namespace=kube-logging


#!/bin/bash


kubectl $1 -f kube-logging.yaml
kubectl $1 -f pv.yaml
kubectl $1 -f elasticsearch_svc.yaml
kubectl $1 -f elasticsearch_statefulset.yaml
kubectl $1 -f kibana.yaml
kubectl $1 -f fluentd.yaml

echo -e "执行以下命令露出kibana："
echo -e kubectl --namespace kube-logging port-forward --address 0.0.0.0 svc/kibana 5601

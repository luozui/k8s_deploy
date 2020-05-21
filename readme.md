# kubernetes deploy script, k8s 一键部署

env:
- centos7

One-click deployment:
- kubernetes v1.18.0
- docker v18
- Kubernetes Dashboard。
- Jenkins
- Prometheus、Alertmanager、Grafana
- Fluentd、Elasticsearch、Kibana


## Quic start

``` shell
git clone --recurse-submodules https://github.com/luozui/k8s_deploy.git
cd k8s_deploy
sudo ./install.sh
```

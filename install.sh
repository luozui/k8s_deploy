#~/bin/bash

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"
work_path=$(pwd)

judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

is_root() {
    if [ 0 == $UID ]; then
        echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font}"
        sleep 3
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户，请切换到root用户后重新执行脚本 ${Font}"
        exit 1
    fi
}

install_k8s_master() {
    cd $work_path/kubernetes
    is_root
    bash ./01_pre_check_and_configure.sh
    judge "系统检测和配置"
    bash ./02_install_docker.sh
    judge "安装docker"
    bash ./03_install_kubernetes.sh
    judge "安装kubernetes"
    bash ./04_master_init.sh
    judge "配置Master和网络"

    judge "done"
}

install_k8s_worker() {
    cd $work_path/kubernetes
    is_root
    bash ./01_pre_check_and_configure.sh
    judge "系统检测和配置"
    bash ./02_install_docker.sh
    judge "安装docker"
    bash ./03_install_kubernetes.sh
    judge "安装kubernetes"
    
    echo -e "注意安装还未完成，请执行安装Master日志中打印的join口令，like this：\nkubeadm join 192.168.3.252:6443 --token abcdef.0123456789abcdef \\
    --discovery-token-ca-cert-hash sha256:cb4b437892bce4eae48ca4b3adebef1bfd873367587ba11588b12a6be44bf4e4"
}

k8s_prometheus() {
    git submodule update
    cd $work_path/kube-prometheus
    kubectl create -f manifests/setup && \
    until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done && \
    kubectl create -f manifests/
    echo -e '远程访问仪盘表，请执行：'
    echo -e 'kubectl --namespace monitoring port-forward --address 0.0.0.0 svc/prometheus-k8s 9090
kubectl --namespace monitoring port-forward --address 0.0.0.0 svc/grafana 3000
kubectl --namespace monitoring port-forward --address 0.0.0.0 svc/alertmanager-main 9093'
}

menu() {
    clear
    echo -e "\t Kubernetes 一键安装脚本"
    echo -e "\t Authored by luozui"
    echo -e "\t https://github.com/luozui\n"

    echo -e "—————————————————————————————————————— 安装向导 ——————————————————————————————————————"
    echo -e "${Green}1.${Font}  安装 Kubernetes Master 节点环境 (Docker+kubelet+kubeadm+kubectl)"
    echo -e "${Green}2.${Font}  安装 Kubernetes Worker 节点环境"
    echo -e "—————————————————————————————————————— 插件安装 ——————————————————————————————————————"
    echo -e "${Green}3.${Font}  安装 Kubernetes dashboard"
    echo -e "${Green}4.${Font}  安装 kube-prometheus (prometheus+alertmanager+grafana)"
    echo -e "${Green}5.${Font}  安装 Jenkins"
    echo -e "${Green}6.${Font}  安装 Elasticsearch & Kibana & Fluentd"
    echo -e "—————————————————————————————————————— 部署应用 ——————————————————————————————————————"
    echo -e "${Green}7.${Font}  部署 MySQL"
    echo -e "${Green}8.${Font}  部署 Redis"
    echo -e "${Green}9.${Font}  部署 example/app1"
    echo -e "—————————————————————————————————————— 其他选项 ——————————————————————————————————————"
    echo -e "${Green}10.${Font} 检查安装信息"
    echo -e "${Green}11.${Font} 退出 \n"

    read -rp "请输入数字：" menu_num
    case $menu_num in
    1)
        install_k8s_master
        ;;
    2)
        install_k8s_worker
        ;;
    3)
        cd $work_path/dashboard
        bash ./install_dashboard.sh
        judge "安装dashboard"
        ;;
    4)
        k8s_prometheus
        judge "安装dashboard"
        ;;
    5)
        cd $work_path/jenkins
        bash ./install_jenkins.sh apply
        judge "安装jenkins"
        ;;
    6)
        cd $work_path/es_kibana_fluentd
        bash ./install.sh apply
        judge "安装日志系统"
        ;;
    7)
        cd $work_path/example/k8s_practice
        bash ./install_mysql.sh apply
        judge "安装mysql"
        ;;
    8)
        cd $work_path/example/k8s_practice
        bash ./install_redis.sh apply
        judge "安装redis"
        ;;
    9)
        cd $work_path/example/k8s_practice
        bash ./install_app1.sh apply
        judge "安装app1"
        ;;
    10)
        cd $work_path/kubernetes
        sh /k8s_health_check.sh
        ;;
    11)
        exit 0
        ;;
    *)
        echo -e "${RedBG}请输入正确的数字${Font}"
        ;;
    esac
}

menu

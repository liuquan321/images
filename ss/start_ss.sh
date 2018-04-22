#!/bin/bash
# luquan201212@gmail.com
SS_PASS=${1:-"NmIzYjJlODIyNzgxYWRiNWMK"}
SS_PORT=${2:-"23993"}
SS_BASE_CONFIG="-s 0.0.0.0  -p ${SS_PORT} -k \'${SS_PASS}\' -m chacha20-ietf-poly1305 -t 60"
SS_NETWORK_COFNIG="-u --reuse-port --fast-open --no-delay"
SS_OBFS_CONFIG="--plugin obfs-server --plugin-opts obfs=tls "
SS_CONFIG_TOTAL="${SS_BASE_CONFIG} ${SS_NETWORK_COFNIG} -v ${SS_OBFS_CONFIG} "
IMAGE_NAME="luquan/myss"
DOCKER_OPTS="-it -d --restart=always --name ${IMAGE_NAME##*/} --network=host --log-driver json-file --log-opt max-size=100m --log-opt max-file=3 "

if  ! docker info &>/dev/null;then
        yum install docker -y
        systemctl enable docker
        systemctl start docker
        systemctl stop firewalld
        systemctl disable firewalld
        yum install iptables-services -y
        systemctl enable iptables
        systemctl start iptables
        iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${SS_PORT} -j ACCEPT
        setenforce 0;sed -i 's/^SELINUX=.*$/SELINUX=disabled/'  /etc/selinux/config
fi

docker run ${DOCKER_OPTS} ${IMAGE_NAME} -s "${SS_CONFIG_TOTAL}"

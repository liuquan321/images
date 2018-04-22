#!/bin/bash
# luquan201212@gmail.com
SS_PASS=${1:-"NmIzYjJlODIyNzgxYWRiNWMK"}
SS_PORT=${2:-"23993"}
SS_BASE_CONFIG="-s 0.0.0.0  -p ${SS_PORT} -k ${SS_PASS} -m chacha20-ietf-poly1305 -t 60"
SS_NETWORK_COFNIG="-u --reuse-port --fast-open --no-delay"
SS_OBFS_CONFIG="--plugin-opts obfs=tls "
SS_CONFIG_TOTAL="${SS_BASE_CONFIG} ${SS_NETWORK_COFNIG} ${SS_OBFS_CONFIG}"
DOCKER_OPTS="-it -d --restart=always --network=host --log-driver json-file --log-opt max-size=100m --log-opt max-file=3 "
IMAGE_NAME=""

if  ! docker info >/dev/null;then
	yum install docker -y
	systemctl enable docker
	systemctl start docker
fi

docker run ${DOCKER_OPTS} ${IMAGE_NAME} -s "${SS_CONFIG_TOTAL}"

#!/usr/bin/env bash

set -ex

getenv(){
    local _env="$(printenv $1)"
    echo "${_env:-$(cat .env | awk 'BEGIN { FS="="; } /^'$1'/ {sub(/\r/,"",$2); print $2;}')}"
}

REGISTRY_URL="$(getenv REGISTRY_URL)"
LOGSTASH_URL="$(getenv LOGSTASH_URL)"
LOG_PATH="$(getenv LOG_PATH)"
LOG2_PATH="$(getenv LOG2_PATH)"
LOG3_PATH="$(getenv LOG3_PATH)"
LOG4_PATH="$(getenv LOG4_PATH)"
LOG5_PATH="$(getenv LOG5_PATH)"
LOG6_PATH="$(getenv LOG6_PATH)"
LOG7_PATH="$(getenv LOG7_PATH)"
LOG8_PATH="$(getenv LOG8_PATH)"
LOG9_PATH="$(getenv LOG9_PATH)"
LOG10_PATH="$(getenv LOG10_PATH)"
FB_TAGS="$(getenv FB_TAGS)"
FB_DATA_HOME="$(getenv FB_DATA_HOME)"
FB_CONTAINER_ID_FILE=/var/run/fb.did

if [ -f "$FB_CONTAINER_ID_FILE" ]; then
    FB_DID=`cat "$FB_CONTAINER_ID_FILE"`
fi

SCRIPT_BASE_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$SCRIPT_BASE_PATH"

usage() {
echo "Usage:  $(basename "$0") [MODE] [OPTIONS] [COMMAND]"
echo
echo "This script is for docker 1.7 to use with Centos/RedHat 6 only!"
echo "Download and install docker 1.7.1:"
echo "$ sudo -i"
echo "# wget https://s3.ap-northeast-2.amazonaws.com/sangah-b1/docker-engine-1.7.1-1.el6.x86_64.rpm"
echo "# yum localinstall --nogpgcheck docker-engine-1.7.1-1.el6.x86_64.rpm"
echo "# service docker start"
echo "# exit"
echo
echo "Commands:"
echo "  up              Start the services"
echo "  down            Stop the services"
echo "  logs            Follow the logs on console"
echo "  remove-all      Remove all containers"
echo "  stop-all        Stop all containers running"
echo
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    usage
    exit 1
fi

echo "Arguments: $CONF_ARG"
echo "Command: $@"

if [ "$1" == "up" ]; then
    docker pull $REGISTRY_URL/filebeat
    docker run \
    --add-host=logstash:${LOGSTASH_URL} \
    --volume "${FB_DATA_HOME}:/data" \
    --volume "${LOG_PATH}:/usr/local/log/1" \
    --volume "${LOG2_PATH}:/usr/local/log/2" \
    --volume "${LOG3_PATH}:/usr/local/log/3" \
    --volume "${LOG4_PATH}:/usr/local/log/4" \
    --volume "${LOG5_PATH}:/usr/local/log/5" \
    --volume "${LOG6_PATH}:/usr/local/log/6" \
    --volume "${LOG7_PATH}:/usr/local/log/7" \
    --volume "${LOG8_PATH}:/usr/local/log/8" \
    --volume "${LOG9_PATH}:/usr/local/log/9" \
    --volume "${LOG10_PATH}:/usr/local/log/10" \
    --env "FB_TAGS=${FB_TAGS}" \
    --env "FB_LOG_LEVEL=${FB_LOG_LEVEL}" \
    --detach=true \
    --restart=always \
    $REGISTRY_URL/filebeat > $FB_CONTAINER_ID_FILE
    exit 0

elif [ "$1" == "down" ]; then
    shift
    docker stop $FB_DID >/dev/null && docker rm $FB_DID
    exit 0

elif [ "$1" == "stop-all" ]; then
    if [ -n "$(docker ps -q)" ]
    then docker stop $(docker ps -q); fi
    exit 0

elif [ "$1" == "remove-all" ]; then
    if [ -n "$(docker ps -a -q)" ]
    then docker rm $(docker ps -a -q); fi
    exit 0

elif [ "$1" == "logs" ]; then
    shift
    docker logs -f --tail 200 $FB_DID
    exit 0
    
fi

docker "$@" $FB_DID

exit $?
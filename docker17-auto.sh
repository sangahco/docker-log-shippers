#!/usr/bin/env bash

set -e

REGISTRY_URL="${REGISTRY_URL:-$(cat .env | awk 'BEGIN { FS="="; } /^REGISTRY_URL/ {sub(/\r/,"",$2); print $2;}')}"
LOGSTASH_URL="${LOGSTASH_URL:-$(cat .env | awk 'BEGIN { FS="="; } /^LOGSTASH_URL/ {sub(/\r/,"",$2); print $2;}')}"
LOG_PATH="${LOG_PATH:-$(cat .env | awk 'BEGIN { FS="="; } /^LOG_PATH/ {sub(/\r/,"",$2); print $2;}')}"
LOG2_PATH="${LOG2_PATH:-$(cat .env | awk 'BEGIN { FS="="; } /^LOG2_PATH/ {sub(/\r/,"",$2); print $2;}')}"
LOG3_PATH="${LOG3_PATH:-$(cat .env | awk 'BEGIN { FS="="; } /^LOG3_PATH/ {sub(/\r/,"",$2); print $2;}')}"
LOG4_PATH="${LOG4_PATH:-$(cat .env | awk 'BEGIN { FS="="; } /^LOG4_PATH/ {sub(/\r/,"",$2); print $2;}')}"
LOG5_PATH="${LOG5_PATH:-$(cat .env | awk 'BEGIN { FS="="; } /^LOG5_PATH/ {sub(/\r/,"",$2); print $2;}')}"
FB_TAGS="${FB_TAGS:-$(cat .env | awk 'BEGIN { FS="="; } /^FB_TAGS/ {sub(/\r/,"",$2); print $2;}')}"
FB_DATA_HOME="${FB_DATA_HOME:-$(cat .env | awk 'BEGIN { FS="="; } /^FB_DATA_HOME/ {sub(/\r/,"",$2); print $2;}')}"
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
echo "  restart         Restart the services"
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
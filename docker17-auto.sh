#!/usr/bin/env bash

set -e

REGISTRY_URL="${REGISTRY_URL:-$(cat .env | awk 'BEGIN { FS="="; } /^REGISTRY_URL/ {sub(/\r/,"",$2); print $2;}')}"
LOGSTASH_HOST="${LOGSTASH_HOST:-$(cat .env | awk 'BEGIN { FS="="; } /^LOGSTASH_HOST/ {sub(/\r/,"",$2); print $2;}')}"
LOG_PATH="${LOG_PATH:-$(cat .env | awk 'BEGIN { FS="="; } /^LOG_PATH/ {sub(/\r/,"",$2); print $2;}')}"
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
echo "Download docker 1.7.1:"
echo "$ wget https://s3.ap-northeast-2.amazonaws.com/sangah-b1/docker-engine-1.7.1-1.el6.x86_64.rpm"
echo "Install with:"
echo "$ sudo yum localinstall --nogpgcheck docker-engine-1.7.1-1.el6.x86_64.rpm"
echo 
echo "Mode:"
echo "  --log-prod      Log shippers for production"
echo "  --log-dev       Log shippers for development"
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
    docker run \
    --add-host=logstash:${LOGSTASH_HOST} \
    --volume "${FB_DATA_HOME}:/data" \
    --volume "${LOG_PATH}:/usr/local/log" \
    --detach=true \
    --restart=always \
    $REGISTRY_URL/filebeat > $FB_CONTAINER_ID_FILE
    exit 0

elif [ "$1" == "down" ]; then
    shift
    docker stop $FB_DID >/dev/null && docker rm $FB_DID

elif [ "$1" == "stop-all" ]; then
    if [ -n "$(docker ps --format {{.ID}})" ]
    then docker stop $(docker ps --format {{.ID}}); fi

elif [ "$1" == "remove-all" ]; then
    if [ -n "$(docker ps -a --format {{.ID}})" ]
    then docker rm $(docker ps -a --format {{.ID}}); fi

elif [ "$1" == "logs" ]; then
    shift
    docker logs -f --tail 200 $FB_DID
fi

exit $?
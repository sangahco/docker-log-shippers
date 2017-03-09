#!/usr/bin/env sh

REGISTRY_URL="${REGISTRY_URL:-$(cat .env | awk 'BEGIN { FS="="; } /^REGISTRY_URL/ {sub(/\r/,"",$2); print $2;}')}"
LOGSTASH_HOST="${LOGSTASH_HOST:-$(cat .env | awk 'BEGIN { FS="="; } /^LOGSTASH_HOST/ {sub(/\r/,"",$2); print $2;}')}"
LOG_PATH="${LOG_PATH:-$(cat .env | awk 'BEGIN { FS="="; } /^LOG_PATH/ {sub(/\r/,"",$2); print $2;}')}"
FB_DATA_HOME="${FB_DATA_HOME:-$(cat .env | awk 'BEGIN { FS="="; } /^FB_DATA_HOME/ {sub(/\r/,"",$2); print $2;}')}"

usage() {
echo "This script is for docker 1.7 to use with Centos/RedHat 6 only!"
echo "Download docker 1.7.1:"
echo "$ wget https://s3.ap-northeast-2.amazonaws.com/sangah-b1/docker-engine-1.7.1-1.el6.x86_64.rpm"
echo "Install with:"
echo "$ sudo yum localinstall --nogpgcheck docker-engine-1.7.1-1.el6.x86_64.rpm"
}

if ! command -v docker >/dev/null 2>&1; then
    usage
    exit 1
fi

docker run \
--add-host=logstash:${LOGSTASH_HOST} \
--volume "${FB_DATA_HOME}:/data" \
--volume "${LOG_PATH}:/usr/local/log" \
--detach=true \
--restart=always \
$REGISTRY_URL/filebeat
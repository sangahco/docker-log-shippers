FROM debian:jessie
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV FB_VERSION=5.4.0 \
    FB_HOME=/usr/share/filebeat \
    LOGSTASH_SSL_ENABLED=False

RUN set -e && \
    apt-get update && apt-get -y install \
      curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY filebeat.yml /tmp/
RUN set -e && \
    cd /tmp && \
    curl https://s3.ap-northeast-2.amazonaws.com/sangah-b1/filebeat-$FB_VERSION-linux-x86_64.tar.gz -o /tmp/pkg.tar.gz && \
    tar -xf pkg.tar.gz && \
    mkdir -p $FB_HOME && cp -a filebeat-*/. $FB_HOME && \
    cp -a filebeat.yml $FB_HOME && \
    chmod go-w $FB_HOME/filebeat.yml && \
    mkdir /data && \
    rm -rf /tmp/*

ENV PATH $FB_HOME:$PATH
WORKDIR $FB_HOME

ENTRYPOINT ["filebeat"]
CMD ["-e"]
FROM debian:jessie
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

ENV FB_VERSION=5.2.2 \
    FB_HOME=/usr/share/filebeat \
    DEFAULT_FB_USER=filebeat

RUN set -e && \
    apt-get update && apt-get -y install \
      curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN set -ex && \
    useradd -ms /bin/bash $DEFAULT_FB_USER && \
    cd /tmp && \
    curl https://s3.ap-northeast-2.amazonaws.com/sangah-b1/filebeat-$FB_VERSION-linux-x86_64.tar.gz -o /tmp/pkg.tar.gz && \
    tar -xf pkg.tar.gz && \
    mkdir -p $FB_HOME && cp -a filebeat-*/. $FB_HOME && \
    mkdir /data && chown -R $DEFAULT_FB_USER: /data && \
    chown -R $DEFAULT_FB_USER: $FB_HOME && \
    rm -rf /tmp/*

COPY filebeat.yml $FB_HOME/

ENV PATH $FB_HOME:$PATH
USER $DEFAULT_FB_USER
WORKDIR $FB_HOME

ENTRYPOINT ["filebeat"]
CMD ["-e"]
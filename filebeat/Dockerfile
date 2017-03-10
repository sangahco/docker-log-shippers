FROM prima/filebeat:5.2.0

# RUN set -e && \
#   apt-get update && apt-get -y install \
#     gettext-base && \
#   apt-get clean && \
#   rm -rf /var/lib/apt/lists/*

#COPY ./filebeat.template.yml /
COPY ./filebeat.yml /filebeat.yml

#COPY ./docker-entrypoint.sh ./entrypoint.sh
#RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]
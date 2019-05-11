FROM spritsail/mono:4.5

ARG LIDARR_VER=0.6.2.883

ENV SUID=923 SGID=900

LABEL maintainer="Spritsail <lidarr@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Lidarr" \
      org.label-schema.url="https://lidarr.audio/" \
      org.label-schema.description="A Music management and downloader tool" \
      org.label-schema.version=${LIDARR_VER} \
      io.spritsail.version.lidarr=${LIDARR_VER}

WORKDIR /lidarr

COPY *.sh /usr/local/bin/

RUN apk add --no-cache sqlite-libs libmediainfo xmlstarlet \
 && wget -O- "https://github.com/lidarr/Lidarr/releases/download/v${LIDARR_VER}/Lidarr.develop.${LIDARR_VER}.linux.tar.gz" \
        | tar xz --strip-components=1 \
 && find -type f -exec chmod 644 {} + \
 && find -type d -o -name '*.exe' -exec chmod 755 {} + \
 && find -name '*.mdb' -delete \
# Remove unmanted js source-map files
 && find UI -name '*.map' -delete \
# These directories are in the wrong place
 && rm -rf UI/Content/_output \
# Where we're going, we don't need ~roads~ updates!
 && rm -rf Lidarr.Update \
 && chmod +x /usr/local/bin/*.sh

VOLUME /config
ENV XDG_CONFIG_HOME=/config

EXPOSE 8686

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null 'http://localhost:8686/api/v1/system/status' \
            --header "x-api-key: $(xmlstarlet sel -t -v '/Config/ApiKey' /config/config.xml)"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["mono", "/lidarr/Lidarr.exe", "--no-browser", "--data=/config"]

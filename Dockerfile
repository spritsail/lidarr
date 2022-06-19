FROM spritsail/alpine:3.16

ARG LIDARR_VER=1.0.2.2592
ARG LIDARR_BRANCH=master

ENV SUID=923 SGID=900

LABEL maintainer="Spritsail <lidarr@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Lidarr" \
      org.label-schema.url="https://lidarr.audio/" \
      org.label-schema.description="A Music management and downloader tool" \
      org.label-schema.version=${LIDARR_VER} \
      io.spritsail.version.lidarr=${LIDARR_VER}

WORKDIR /lidarr

COPY --chmod=755 *.sh /usr/local/bin/

RUN apk add --no-cache \
        chromaprint \
        icu-libs \
        libintl \
        libmediainfo \
        sqlite-libs \
        xmlstarlet \
 && wget -O- "https://github.com/lidarr/Lidarr/releases/download/v${LIDARR_VER}/Lidarr.${LIDARR_BRANCH}.${LIDARR_VER}.linux-musl-core-x64.tar.gz" \
        | tar xz --strip-components=1 \
# Remove unmanted js source-map files
 && find UI -name '*.map' -print -delete \
# Where we're going, we don't need ~roads~ updates!
 && rm -rfv Lidarr.Update

VOLUME /config
ENV XDG_CONFIG_HOME=/config

EXPOSE 8686

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null 'http://localhost:8686/api/v1/system/status' \
            --header "x-api-key: $(xmlstarlet sel -t -v '/Config/ApiKey' /config/config.xml)"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["/lidarr/Lidarr", "--no-browser", "--data=/config"]

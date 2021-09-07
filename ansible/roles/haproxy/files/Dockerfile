FROM alpine:3.14

# Timezone
ENV TIMEZONE="Asia/Jakarta"
ENV HAPROXY_VER=2.4.3-r1

RUN apk -U --no-cache add \
    tar \
    wget \
    curl \
    haproxy=${HAPROXY_VER}

# Timezone setting for the system
RUN apk -U --no-cache add tzdata && \
    # Specify the timezone in /etc/localtime
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    # Use the specified timezone for current machine
    echo "${TIMEZONE}" > /etc/timezone && \
    # You can delete the other timezone
    apk del tzdata

ADD haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

EXPOSE 80

ENTRYPOINT ["/usr/sbin/haproxy"]

CMD ["-W", "-db", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
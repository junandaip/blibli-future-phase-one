FROM alpine:3.14

# Variables
ENV TIMEZONE="Asia/Jakarta"
ENV NGINX_VER=1.20.1-r3

RUN apk -U --no-cache add nginx=${NGINX_VER} && \
    apk -U --no-cache add tzdata && \ 
    #specify the timezone in /etc/localtime
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    #use the specified timezone for current machine
    echo "${TIMEZONE}" > /etc/timezone && \
    #you can delete the other timezone
    apk del tzdata && \ 
    rm -rf /var/cache/apk/*

# Add www user and setup root folder
# 82 is the standard uid/gid for "www-data" in Alpine
RUN adduser -u 82 -D -S -G www-data www-data && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

EXPOSE 80
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]

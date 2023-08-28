FROM alpine

RUN apk update  \
    && apk add nginx

RUN mkdir -p /var/run/nginx \
    && touch /var/run/nginx.pid \
    && chmod 644 /var/run/nginx.pid \
    && mkdir -p /var/log/nginx \
    && mkdir -p /var/cache/nginx

CMD ["nginx", "-g", "daemon off;"]

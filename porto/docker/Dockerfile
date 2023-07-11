FROM fedora:latest

RUN dnf -y update \
    && dnf -y install nginx \
        -y tzdata \
        -y telnet \
    && cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone \
#    && mkdir /apps \ 

WORKDIR /apps

#RUN adduser adm-app \
#    && chown -R adm-app /apps
#USER adm-app
USER root

COPY ./code /var/www/html
COPY ./config/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# Custom base image java with Fedora OS and has been scanned using snyk
FROM asia-southeast2-docker.pkg.dev/it-infrastructure-service/docker-repository/nginx:latest-minimum as production

# Set variable TZ for timezone at Asia/Jakarta
ENV TZ=Asia/Jakarta

# Install tzdata and set timezone with environtment variable TZ
RUN dnf install -y tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Initialization directory
WORKDIR /apps

# Create user
RUN useradd -s /sbin/nologin adm-app

# Copy file nginx.conf and all file in folder dist (this folder is build result javascript)
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=build-stage /apps/dist /usr/share/nginx/html

# Add permission in folder /apps and folder used for nginx
RUN chown -R adm-app:adm-app /apps && chmod -R 755 /apps \
    && chown -R adm-app:adm-app /var/cache/nginx \
    && chown -R adm-app:adm-app /var/log/nginx \
    && chown -R adm-app:adm-app /etc/nginx \
    && chown -R adm-app:adm-app /var/run/nginx \
    && chown -R adm-app:adm-app /var/lib/nginx

# Switch to nginx user
USER adm-app

# Expose port application
EXPOSE 8123

# Running nginx web server
CMD ["nginx", "-g","daemon off;"]

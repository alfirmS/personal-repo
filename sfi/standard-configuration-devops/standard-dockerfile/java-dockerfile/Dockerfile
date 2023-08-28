# Custom base image java with Fedora OS and has been scanned using snyk
FROM asia-southeast2-docker.pkg.dev/it-infrastructure-service/docker-repository/java11-fedora:slim

# Check versionjava & set timezone
RUN java -version \
    && cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone \
    && mkdir /apps \
    && mkdir /apps/agent

# Initialization directory
WORKDIR /apps

# create user and set ownership and permissions
RUN adduser adm-app \
    && chown -R adm-app /apps
USER adm-app

# Expose Port Application
EXPOSE 8081

# Copy File Jar
COPY ./elastic-apm-agent-1.28.1.jar /apps/agent/elastic-apm-agent-1.28.1.jar
COPY ./target/idm-0.0.1-SNAPSHOT.jar  /apps/idm-0.0.1-SNAPSHOT.jar

# Running Java Application With Kibana
ENTRYPOINT java \ 
           -javaagent:/apps/agent/elastic-apm-agent-1.28.1.jar \ 
           -Delastic.apm.service_name=uat-ad1-sales-idm \ 
           -Delastic.apm.server_urls=http://10.150.16.18:8200 \ 
           -Delastic.apm.application_packages=id.co.adira.sales \
           -Xms512m \ 
           -Xmx1024m \ 
           -jar /apps/idm-0.0.1-SNAPSHOT.jar

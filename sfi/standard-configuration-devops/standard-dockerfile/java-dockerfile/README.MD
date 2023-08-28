# BUILD YOUR APPLICATION JAVA IMAGE
-----------------------------------

## Aplikasi Java
---------------------------
Silahkan gunakan aplikasi java yang ingin dibuild menggunakan Dockerfile. 
Anda harus klon aplikasi yang ingin di build terlebih dahulu ke dalam local Anda.


```
$ cd /path/to/working/directory  
$ git clone git@bitbucket.org:adira-it/your-application.git  
$ cd your-application
```

## Menguji Aplikasi Tanpa Docker (Optional)
-------------------------------------------
Sebelum Anda mengguanakan docker untuk membungkus aplikasi Anda, Anda ada baiknya
mengujinya terlebih dahulu sehingga aplikasi dapat dipastikan sudah berjalan dengan
baik. Untuk memastikan aplikasi telah berjalan dengan baik, silahkan Anda menggunakan
maven untuk proses kompilasi, pengujian, pengemasan, dll.


Buka terminal Anda dan navigasikan ke direktori kerja yang telah kamu buat dan jalankan
perintah berikut:


```
$ mvn clean package
```

perintah diatas adalah untuk kompilasi, pengujian serta pengemasan aplikasi agar dapat membentuk
`*.jar` file.  

## Buat Dockerfile untuk Java
-----------------------------
tahapan selanjutnya adalah membuat file Dockerfile. Anda perlu mendefinisikan base images
yang ingin anda gunakan, disini saya telah menyediakan base image yang telah di scan menggunakan snyk
dan tenable. 


```
# Custom base image java with Fedora OS and has been scanned using snyk
FROM asia-southeast2-docker.pkg.dev/it-infrastructure-service/docker-repository/java11-fedora:latest
```


kemudian silahkan Anda memastikan version javanya terlebih dahulu, mengatur timezone,
dan juga membuat directory sesuai kebutuhan. Setelah directory telah dibuat Anda dapat
masuk kedalam directory tersebut, membuat user di dalam server dan mengatur owner dari directory tersebut.


```
# Initialization directory  
WORKDIR /apps  


# Create user and set ownership and permissions  
RUN adduser adm-app \  
    && chown -R adm-app /apps  
USER adm-app
```

Exposelah port yang ingin anda gunakan.


```
# Expose Port Application  
EXPOSE 8081
```

Copy file `*.jar` yang Anda butuhkan.


```
# Copy File Jar
COPY ./your-monitoring-application.jar /apps/agent/your-monitoring-application.jar
COPY ./target/your-application.jar  /apps/your-application.jar
```


Eksekusi java application Anda menggunakan Entrypoint berikut.


```
# Running Java Application With Kibana
ENTRYPOINT java \ 
           -javaagent:/apps/agent/your-monitoring-application.jar \ 
           -Delastic.apm.service_name=name-your-application-in-apm-server \ 
           -Delastic.apm.server_urls=http://IP-apm-server:port-apm-server \ 
           -Delastic.apm.application_packages=your-package-for-monitoring \
           -Xms512m \ 
           -Xmx1024m \ 
           -jar /apps/your-application.jar
```


## Build an Image
------------------
Buat docker image.


```
$ docker build --tag name-your-application:tag-your-application .
```


## Test Image Anda
--------------------
Test images yang telah kamu buat dengan menggunakan perintah berikut.


```
$ docker run --name=name-your-container --port=port-application:forward-port-application name-your-application:tag-your-application
```

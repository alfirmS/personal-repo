1. Download beberapa tools yang dibutuhkan untuk keperluan deployment microservice:
    - Java Application:
       - Maven -> Untuk proses compile, test, build [`mvn clean package`]
       > Note : jika ingin melewatkan proses test maka menggunakan perintah berikut [`mvn clean package -DskipTests`].
       
       - Java -> Diperlukan untuk proses build dependency 
       - Kubectl -> Untuk akses resource (svc, pods, deployment, etc.) kubernetes
       - gcloud, oc, kubeconfig (Optional) -> Untuk akses cluster
		> Note: Jika menggunakan cloud yang lain, disesuaikan.
		
		- Docker (optional) -> Untuk build image
		> Note: Jika ingin mencoba prosesnya di local terlebih dahulu

		- Helm
	- Javascript Application:
		- npm -> Untuk proses compile, test (linter), build [`npm run build:${env}`]
       - Node.js -> Diperlukan untuk proses build dependency 
       - Kubectl -> untuk akses resource (svc, pods, deployment, etc.) kubernetes
       - gcloud, oc, kubeconfig (Optional)
		> Note: Jika menggunakan cloud yang lain, disesuaikan.
		
		- Docker (optional)
		> Note: Jika ingin mencoba prosesnya di local terlebih dahulu

		- Helm
3. Clone source aplikasi di bitbucket dan source untuk configuration deployment
	> Example : git clone git@bitbucket.org:adira-it/deployment-application.git -b <nama_branch>  
	>> Note : Pastikan telah register ssh pada bitbucket menggunakan user jenkins.dev [https://adira4.sharepoint.com/:w:/r/sites/RekonsiliasiDataServerAcction/Dokumen%20Berbagi/Daily%20DevOps/BPR%20SQUAD/WI/daftarkan%20ssh%20keys%20di%20bitbucket.docx?d=wbe4184f4379648139fbadab266f7c6e5&csf=1&web=1&e=OXsYpZ]

4. Membuat folder project dan masing-masing service pada repository `deployment-application` yang telah di clone.
```bash
   #Linux
   mkdir <path_application_deployment>/<nama_project>
   mkdir <path_application_deployment>/<nama_project>/<nama_service>
```

5. Membuat Dockerfile pada directory service yang telah di clone sebelumnya, `deployment-application/<nama_project>/<nama_service>`.

- Dockerfile untuk Java Application :
```Dockerfile
# Custom base image java with Fedora OS and has been scanned using snyk
FROM asia-southeast2-docker.pkg.dev/it-infrastructure-service/docker-repository/java11-fedora:slim

# Set Environment
ENV APM_AGENT=elastic-apm-agent-1.28.1.jar
ENV JAR_NAME=admengine-0.0.1-SNAPSHOT.jar
ENV APM_NAME=uat-ad1-admin-main
ENV APM_PACKAGE=id.co.adira.adm
ENV APM_URL=https://10.150.168.18:8200

# Check versionjava & set timezone
RUN java -version \
    && cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone \
    && mkdir /apps \
    && mkdir /apps/agent

# Initialization directory
WORKDIR /apps

# Create user and set ownership and permissions
RUN adduser adm-app \
    && chown -R adm-app /apps
USER adm-app

# Expose Port Application
EXPOSE 8081

# Copy File Jar
COPY ./resources/${APM_AGENT} /apps/agent/${APM_AGENT}
COPY ./target/${JAR_NAME}  /apps/${JAR_NAME}

# Running Java Application With Kibana
ENTRYPOINT java \ 
           -javaagent:/apps/agent/${APM_AGENT} \ 
           -Delastic.apm.service_name=${APM_NAME} \ 
           -Delastic.apm.server_urls=${APM_URL} \ 
           -Delastic.apm.application_packages=${APM_PACKAGE} \
           -Xms512m \ 
           -Xmx1024m \ 
           -jar /apps/${JAR_NAME}
``` 

- Dockerfile untuk Javascript Application:
```Dockerfile
# Custom base image java with Fedora OS and has been scanned using snyk
FROM asia-southeast2-docker.pkg.dev/it-infrastructure-service/docker-repository/nginx:latest-minimum

# Set variable TZ for timezone at Asia/Jakarta
ENV TZ=Asia/Jakarta

# Install tzdata and set timezone with environtment variable TZ
RUN dnf install -y tzdata \
    && cp /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Initialization directory
WORKDIR /apps

# Create user
RUN useradd -m -s /sbin/nologin adm-app

# Copy file nginx.conf and all file in folder dist (this folder is build result javascript)
COPY ad1admin/ad1-adm-front-web/nginx.conf /etc/nginx/nginx.conf
COPY ./dist /usr/share/nginx/html

# Create folder
RUN mkdir -p /var/log/nginx \
    && mkdir -p /var/cache/nginx

# Add permission in folder /apps and folder used for nginx
RUN chown -R adm-app:adm-app /apps && chmod -R 755 /apps \
    && chown -R adm-app:adm-app /var/cache/nginx \
    && chown -R adm-app:adm-app /var/log/nginx \
    && chown -R adm-app:adm-app /etc/nginx \
    && chown -R adm-app:adm-app /var/lib/nginx

# Switch to nginx user
USER adm-app

# Expose port application
EXPOSE 8123

# Running nginx web server
CMD ["nginx", "-g", "daemon off;"]
```

>Note perubahan :  
>1. COPY ./elastic-apm-agent-1.28.1.jar /apps/agent/elastic-apm-agent-1.28.1.jar -> Rubah agent sesuai dengan version apm yang digunakan tim SRE  
>2. COPY ./target/idm-0.0.1-SNAPSHOT.jar  /apps/idm-0.0.1-SNAPSHOT.jar -> Rubah nama SNAPSHOT aplikasi sesuai dengan hasil build aplikasi  
>3. ENTRYPOINT java \   
>        -javaagent:/apps/agent/elastic-apm-agent-1.28.1.jar \ -> Rubah agent apm sesuai versi yang digunakan  
 >       -Delastic.apm.service_name=uat-ad1-sales-idm \ -> Rubah nama service apm yang akan ditampilkan di kibana  
 >       -Delastic.apm.server_urls=http://10.150.16.18:8200 \ -> Rubah IP APM sesuai dengan yang diberikan tim SRE  
 >       -Delastic.apm.application_packages=id.co.adira.sales \ -> Rubah sesuai package aplikasi yang ingin di monitoring  
 >       -Xms512m \ -> Rubah sesuai dengan kebutuhan minimal memori aplikasi agar dapat berjalan  
 >       -Xmx1024m \ ->  Rubah sesuai dengan kebutuhan maximal heap memori aplikasi agar dapat berjalan  
 >       -jar /apps/idm-0.0.1-SNAPSHOT.jar -> Rubah sesuai dengan SNAPSHOT yang ingin dijalankan  
>4. COPY ./dist /usr/share/nginx/html -> rubah ./dist sesuai dengan folder hasil build vue application.  


6. Membuat Jenkinsfile directory service yang telah di clone sebelumnya, `deployment-application/<nama_project>/<nama_service>`.
- Jenkinsfile untuk Java Application:
```Jenkinsfile
#!/usr/bin/env groovy

// Set environment used in pipeline
pipeline {
  environment {
    int VERSION_MAJOR = 1
    int VERSION_MINOR = 0
    int VERSION_PATCH = 0

    String APP = "ad1admin"
    String SERVICE = "ad1-adm-main"
    String ENVIRONMENT = "uat"
    String NAMESPACE = "administrasi"

    String BRANCH = "new-uat"
    String CRED_BITBUCKET = "jenkins-dev"

    String KUBERNETES_URL = "https://34.101.110.89"
    String CRED_KUBERNETES = "jenkins-deployer"
    String CLUSTER_NAME = "bpr-uat"
    //String CLOUD_CONFIG = "config-cloud-administrasi"

    String IMAGE_NAME = "adira-ent-registry-registry-vpc.ap-southeast-5.cr.aliyuncs.com/administrasi/${ENVIRONMENT}-${SERVICE}"
    String IMAGE_TAG = "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}-${BUILD_TIMESTAMP}-${BUILD_NUMBER}"
    String DOCKERFILE = "${APP}/${SERVICE}/Dockerfile"
    String HELM_RELEASE = "${SERVICE}"
    String HELM_CHART = "${APP}/${SERVICE}/helm"
    String HELM_VALUES = "${HELM_CHART}/values-uat-gcp.yaml"
    String SPRING_ACTIVE_PROFILE = "${ENVIRONMENT}"

    String SOURCE_DIR = "${WORKSPACE}/source"

    String SEND_EMAIL = "sholeh.firmasyah@adira.co.id,v.adrianus.habirowo@adira.co.id"
  }
  
  // Set agent used for the pipeline (kubernetes, docker, or any)
  agent {
    kubernetes {
      // Set jobs running in spesific cloud pods
      //cloud '${CLOUD_CONFIG}'
      defaultContainer 'jnlp'
      yaml """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            component: ci
        spec:
          containers:
            - name: maven
              image: maven:3.6.3-openjdk-11
              imagePullPolicy: IfNotPresent
              tty: true
              command:
                - cat
            - name: kaniko
              image: gcr.io/kaniko-project/executor:v1.9.1-debug
              imagePullPolicy: IfNotPresent
              tty: true
              command:
                - /busybox/cat
              volumeMounts:
                - name: docker-config
                  mountPath: /kaniko/.docker
            - name: helm
              image: alpine/helm:3.12.1
              imagePullPolicy: IfNotPresent
              tty: true
              command:
                - cat
          volumes:
            - name: docker-config
              projected:
                sources:
                  - secret:
                      name: regcred
                      items:
                        - key: .dockerconfigjson
                          path: config.json
      """
    }
  }

  // Wrap all stages pipeline
  stages {
    // Checkout source code service
    stage('Checkout Source Code') {
      steps {
        dir("${SOURCE_DIR}"){
          git branch: "${BRANCH}",
            credentialsId: "${CRED_BITBUCKET}",
            url: "https://JenkinsDevelop@bitbucket.org/adira-it/${SERVICE}.git"
        }
      }
    }
 
    // Set process name for parallel stage
    stage('Unit Test and Build') {
      parallel {
        // Set process name for running step
        stage('Unit Test') {
          steps {
            dir("${SOURCE_DIR}"){
              // Set used container for build java application
              container('maven') {
                sh 'mvn clean test'
              }
            }
          }
        }

        stage('Build') {
          steps {
            dir("${SOURCE_DIR}"){
              container('maven') {
                sh 'mvn clean package --quiet -DskipTests'
              }
            }
          }
        }
      }
    }

    stage('sonarqube') {
      steps {
        dir("${SOURCE_DIR}"){
          // Set environtment name for sonarqube, check in console jenkins -> manage jenkins -> configuration system -> sonarqube server -> name
          withSonarQubeEnv('sonarqube-uat') {
            container('maven') {
              sh '''
                echo "******** currently executing sonarqube stage ********"
                # Get command below in sonarqube server when creating a project
                mvn clean sonar:sonar \
                  -Dsonar.projectKey=ad1-adm-main \
                  -Dsonar.host.url=http://10.50.7.220:9000 \
                  -Dsonar.login=sqp_ba12a87f531a7576afcdf830ea6aa2b7081ba5a1
              '''
            }
          }
        }
      }
    }

    // Set quality gate, if want sonarqube result according to policy sonarqube (change value abort pipeline to true)
    stage("Quality gate") {
      steps {
        echo "******** currently executing Quality gate stage ********"
        waitForQualityGate abortPipeline: false
      }
    }

    // Set kaniko for build image process
    stage('Build & Push Image') {
      steps {
        dir("${SOURCE_DIR}"){
          container('kaniko') {
            sh """
              cp -r -f ${WORKSPACE}/${APP} ${SOURCE_DIR}
              cp -r -f ${WORKSPACE}/resources ${SOURCE_DIR}
              executor \
                --destination="${IMAGE_NAME}:${IMAGE_TAG}" \
                --dockerfile=`pwd`/"${DOCKERFILE}" \
                --log-format=text \
                --context=`pwd`
            """
          }
        }
      }
    }

    // Set helm for deploy to kubernetes process
    stage('Deploy'){
      steps {
        dir("${SOURCE_DIR}"){
          container('helm') {
            // Set url, credentialsId, and clusterName 
            withKubeCredentials(kubectlCredentials: [[
              serverUrl: "${KUBERNETES_URL}",
              credentialsId: "${CRED_KUBERNETES}",
              clusterName: "${CLUSTER_NAME}"
            ]]) {
              sh """
                helm upgrade --install \
                  "${HELM_RELEASE}" "${HELM_CHART}" \
                  --values="${HELM_VALUES}" \
                  --set=image.tag="${IMAGE_TAG}" \
                  --namespace="${NAMESPACE}" \
                  --timeout=5m0s --debug
              """
            }
          }
        }
      }
      
      // Send email with 3 condition build : failure, success, aborted
      post {
        failure {
          mail  to: "$SEND_EMAIL",
                subject: "FAILED: Build ${env.JOB_NAME} in UAT Branch",
                body: "Build failed ${env.JOB_NAME} build no: ${env.BUILD_NUMBER}.\n\nView the log at:\n ${env.BUILD_URL}"
        }

        success {
          mail  to: "$SEND_EMAIL",
                subject: "SUCCESSFUL: Build ${env.JOB_NAME} in UAT Branch",
                body: "Build Successful ${env.JOB_NAME} build no: ${env.BUILD_NUMBER}\n\nView the log at:\n ${env.BUILD_URL}"
        }

        aborted {
          mail  to: "$SEND_EMAIL",
                subject: "ABORTED: Build ${env.JOB_NAME} in UAT Branch",
                body: "Build was aborted ${env.JOB_NAME} build no: ${env.BUILD_NUMBER}\n\nView the log at:\n ${env.BUILD_URL}"
        }
      }
    }
  }
}
```
- Jenkinsfile untuk Javascript Application:
```Jenkinsfile
#!/usr/bin/env groovy

pipeline {
  environment {
    int VERSION_MAJOR = 1
    int VERSION_MINOR = 0
    int VERSION_PATCH = 0

    String APP = "ad1admin"
    String SERVICE = "ad1-adm-front-web"
    String ENVIRONMENT = "uat"
    String NAMESPACE = "administrasi"

    String BRANCH = "uat"
    String CRED_BITBUCKET = "jenkins-dev"

    String KUBERNETES_URL = "https://34.101.110.89"
    String CRED_KUBERNETES = "jenkins-deployer"
    String CLUSTER_NAME = "bpr-uat"
    //String CLOUD_CONFIG = "config-cloud-administrasi"

    String IMAGE_NAME = "adira-ent-registry-registry-vpc.ap-southeast-5.cr.aliyuncs.com/administrasi/${ENVIRONMENT}-${SERVICE}"
    String IMAGE_TAG = "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}-${BUILD_TIMESTAMP}-${BUILD_NUMBER}"
    String DOCKERFILE = "${APP}/${SERVICE}/Dockerfile"
    String HELM_RELEASE = "${SERVICE}"
    String HELM_CHART = "${APP}/${SERVICE}/helm"
    String HELM_VALUES = "${HELM_CHART}/values-uat-gcp.yaml"
    String SOURCE_DIR = "${WORKSPACE}/source"

    String SEND_EMAIL = "sholeh.firmansyah@adira.co.id,v.adrianus.habirowo@adira.co.id"
  }
    
  agent {
    kubernetes {
      //cloud 'config-cloud-administrasi'
      defaultContainer 'jnlp'
      yaml """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            component: ci
        spec:
          containers:
            - name: node
              image: node:16.0.0
              imagePullPolicy: IfNotPresent
              tty: true
              command:
              - cat
            - name: kaniko
              image: gcr.io/kaniko-project/executor:v1.9.1-debug
              imagePullPolicy: IfNotPresent
              tty: true
              command:
                - /busybox/cat
              volumeMounts:
                - name: docker-config
                  mountPath: /kaniko/.docker
            - name: helm
              image: alpine/helm:3.12.1
              imagePullPolicy: IfNotPresent
              tty: true
              command:
                - cat
          volumes:
            - name: docker-config
              projected:
                sources:
                  - secret:
                      name: regcred
                      items:
                        - key: .dockerconfigjson
                          path: config.json
      """
    }
  }

  // Wrap all stages pipeline
  stages {
    // Checkout source code service
    stage('Checkout Source Code') {
      steps {
        dir("${SOURCE_DIR}"){
          git branch: "${BRANCH}",
            credentialsId: "${CRED_BITBUCKET}",
            url: "https://JenkinsDevelop@bitbucket.org/adira-it/${SERVICE}.git"
            sh """
              cp -r -f ${WORKSPACE}/${APP}/${SERVICE} ${SOURCE_DIR}
              cp -r -f ${WORKSPACE}/${APP} ${SOURCE_DIR}
              cp -r -f ${WORKSPACE}/resources ${SOURCE_DIR}
            """
        }
      }
    }

    stage('Build') {
      steps {
        dir("${SOURCE_DIR}"){
          container('node') {
            sh """
              npm cache clean --force
              npm install --force
              npm run build:${ENVIRONMENT}
            """
          }
        }
      }
    }
  
    // stage('sonarqube') {
    //   steps {
    //     // Set environtment name for sonarqube, check in console jenkins -> manage jenkins -> configuration system -> sonarqube server -> name
    //     withSonarQubeEnv('sonarqube-uat') {
    //       container('maven') {
    //         sh '''
    //           echo "******** currently executing sonarqube stage ********"
    //           # Get command below in sonarqube server when creating a project
    //           mvn clean sonar:sonar \
    //             -Dsonar.projectKey=ad1-adm-main \
    //             -Dsonar.host.url=http://10.50.7.220:9000 \
    //             -Dsonar.login=sqp_ba12a87f531a7576afcdf830ea6aa2b7081ba5a1
    //         '''
    //       }
    //     }
    //   }
    // }
    //
    // // Set quality gate, if want sonarqube result according to policy sonarqube (change value abort pipeline to true)
    // stage("Quality gate") {
    //   steps {
    //     echo "******** currently executing Quality gate stage ********"
    //     waitForQualityGate abortPipeline: false
    //   }
    // }

    // Set kaniko for build image process
    stage('Build & Push Image') {
      steps {
        dir("${SOURCE_DIR}"){
          container('kaniko') {
            sh """
              executor \
                --destination="${IMAGE_NAME}:${IMAGE_TAG}" \
                --dockerfile=`pwd`/"${DOCKERFILE}" \
                --log-format=text \
                --cache=false \
                --cache-run-layers=false \
                --cache-copy-layers=false \
                --context=`pwd`
            """
          }
        }
      }
    }

    // Set helm for deploy to kubernetes process
    stage('Deploy'){
      steps {
        dir("${SOURCE_DIR}"){
          container('helm') {
            // Set url, credentialsId, and clusterName 
            withKubeCredentials(kubectlCredentials: [[
              serverUrl: "${KUBERNETES_URL}",
              credentialsId: "${CRED_KUBERNETES}",
              clusterName: "${CLUSTER_NAME}"
            ]]) {
              sh """
                helm upgrade --install \
                  "${HELM_RELEASE}" "${HELM_CHART}" \
                  --values="${HELM_VALUES}" \
                  --set=image.tag="${IMAGE_TAG}" \
                  --namespace="${NAMESPACE}" \
                  --timeout=5m0s --debug
              """
            }
          }
        }
      }

      post {
        failure {
          mail  to: "${SEND_EMAIL}",
                subject: "FAILED: Build ${env.JOB_NAME} in UAT Branch",
                body: "Build failed ${env.JOB_NAME} build no: ${env.BUILD_NUMBER}.\n\nView the log at:\n ${env.BUILD_URL}"
        }

        success {
          mail  to: "${SEND_EMAIL}",
                subject: "SUCCESSFUL: Build ${env.JOB_NAME} in UAT Branch",
                body: "Build Successful ${env.JOB_NAME} build no: ${env.BUILD_NUMBER}\n\nView the log at:\n ${env.BUILD_URL}"
        }

        aborted {
          mail  to: "${SEND_EMAIL}",
                subject: "ABORTED: Build ${env.JOB_NAME} in UAT Branch",
                body: "Build was aborted ${env.JOB_NAME} build no: ${env.BUILD_NUMBER}\n\nView the log at:\n ${env.BUILD_URL}"
        }
      }
    }
  }
}
```

> Note :
> 1. Sesuaikan value pada variable yang digunakan di script environtment{...}, variablenya adalah sebagai berikut  
> - APP -> sesuaikan dengan nama folder project yang telah dibuat di repo deployment-application  
> - SERVICE -> sesuaikan dengan nama service yang telah dibuat di repo deployment-application  
> - ENVIRONMENT -> sesuaikan dengan environment yang akan di deploy  
> - NAMESPACE -> sesuaikan dengan namespace yang telah di buatkan oleh infra pada cluster aplikasi yang ingin di deploy  
> - BRANCH -> sesuaikan dengan branch aplikasi yang akan digunakan  
> - CRED_BITBUCKET -> sesuaikan dengan credentialId yang ada di console jenkins pada bagian manage credentials  
> - KUBERNETES_URL-> sesuaikan dengan url kubernetes yang diberikan oleh infra atau ketikan `kubectl cluster-info` setelah berada di current cluster yang ingin di deploy untuk melihat url kubernetesnya  
> - CRED_KUBERNETES -> sesuaikan dengan credentialId yang ada di console jenkins pada bagian manage credentials  
> - CLUSTER_NAME -> sesuaikan dengan nama cluster yang ingin di deploy  
> - IMAGE_NAME -> sesuaikan dengan registry yang dipakai (aliyun, GCR, Colla) dengan format <url_registry>/<folder_registry>/default  
> - HELM_VALUES -> sesuaikan dengan nama file values yang digunakan  

7. Buat file helm menggunakan command `helm create <nama_service>`.  
- Copy example values dari monorepo (git clone git@bitbucket.org:adira-it/devops.git) di dalam folder `/home/noname/devops-repo/devops/users/sfi/standard-configuration-devops/standard-helm-template/helm-java`  
-  Sesuaikan beberapa template berikut :  
---
#### deployment.yaml
```yaml
## Change calling value in image
## BEFORE
...
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
...
## AFTER
image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"

## Add env
env:
             - name: SPRING_ACTIVE_PROFILE
               valueFrom:
                   configMapKeyRef:
                       key: SPRING_ACTIVE_PROFILE
                       name: {{ .Release.Name }}

## Change calling value in containerPort
## BEFORE
containerPort: {{ .Values.service.port }}
#AFTER
containerPort: {{ .Values.service.targetport }}

## Comment/remark readiness and liveness, if don't used
          # livenessProbe:
          #   httpGet:
          #     path: /
          #     port: http
          # readinessProbe:
          #   httpGet:
          #     path: /
          #     port: http
```
---

#### service.yaml
```yaml
## Add Annotation for subnet network
  annotations:
	## Aliyun <tanya-infra-ais>
	service.beta.kubernetes.io/alibaba-cloud-loadbalancer-address-type: "intranet"
    service.beta.kubernetes.io/alibaba-cloud-loadbalancer-protocol-port: "https:443"
    service.beta.kubernetes.io/alibaba-cloud-loadbalancer-cert-id: "5660042342906061_17d032d7041_-1742845701_-1028522903"
    service.beta.kubernetes.io/alibaba-cloud-loadbalancer-vswitch-id: "vsw-k1ajdhoii6qauydjn44qv"
	## GCP <tanya-infra-ais>
    networking.gke.io/load-balancer-type: "Internal"
    networking.gke.io/internal-load-balancer-subnet: "<tanya-infra-ais>"
## Add variable
...
{{- if eq .Values.service.type "LoadBalancer" }}
   loadBalancerIP: {{ .Values.service.IPLoadBalancer }}
{{- end}}
  ports:
...

## Change calling value in targetPort
## BEFORE
targetPort: http
## AFTER
targetPort: {{ .Values.service.targetport }}
```
---

#### hpa.yaml  
pastikan telah menggunakan manifest terbaru apiVersion: autoscaling/v2.   

---
#### configmap.yaml  
tambahkan di dalam folder template.
```yaml
## Ubah nama service sesuai dengan apa yang ingin di deploy
apiVersion: v1
kind: ConfigMap
metadata:
  annotations:
  name: {{ include "ad1-adm-main.fullname" . }}
  labels:
	{{- include "ad1-adm-main.labels" . | nindent 4 }}
data:
  SPRING_ACTIVE_PROFILE: "{{ .Values.config.spring_active_profile}}"
```
---

- Sesuaikan values.yaml yang digunakan:  
```yaml
## Image
image:
  repository: <url_registry>/<folder_registry>/<environment>-<nama_service>
  pullPolicy: Always
  # Overrides the image tag whose default is the chart appVersion.
  tag: "1.0.0-<tahun-bulan-tgl>-1"

## Config
config:
  spring_active_profile: 'uat-gcp'

...
## Imagepullsecret
imagePullSecrets: 
  - name: regcred # Sesuaikan dengan yang diberikan infra
...
## Service
service:
  type: LoadBalancer # Jika FE buat menjadi ClusterIP
  port: 8081 # sesuaikan port yang digunakan
  targetport: 8081 # sesuaikan dengan port yang digunakan
  IPLoadBalancer: 10.150.10.37 # Untuk static IP Load Balancer
...
## Resources
resources:
  limits:
    cpu: 2500m # Sesuaikan dengan limit CPU yang dipakai
    memory: 2048Mi # Sesuaikan dengan limit Memoru yang dipakai
  requests:
    cpu: 250m # Sesuaikan dengan initiate awal CPU yang dipakai
    memory: 256Mi # Sesuaikan dengan initiate awal Memory yang dipakai

## Autoscaling
autoscaling:
  enabled: true # Set menjadi true/false
  minReplicas: 1 # Set minimum replica pod yang digunakan
  maxReplicas: 2 # Set maximal replica pod yang digunakan
  #targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80 # Set treshold memory untuk melakukan replica
```

8. Buat file config sesuai dengan framwork yang digunakan
> example :  
> - Java -> application.properties dan bootstrap.properties  
> - Vue.js -> .env, package.json, nginx.conf  
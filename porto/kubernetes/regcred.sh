#!/usr/bin/zsh

kubectl create secret docker-registry regcred \
--docker-server=https://index.docker.io/v1/ \
--docker-username=sfirman87 \
--docker-password=SFirman889 \
--docker-email=sholehfirmansyah7@gmail.com

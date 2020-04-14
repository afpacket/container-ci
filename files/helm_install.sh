#!/usr/bin/env bash

VERSION="$1"

mkdir /usr/local/src/helm
curl -L https://get.helm.sh/helm-v"$VERSION"-linux-amd64.tar.gz  -o /usr/local/src/helm/helm-v"$VERSION"-linux-amd64.tar.gz
curl -L https://get.helm.sh/helm-v"$VERSION"-linux-amd64.tar.gz.sha256sum -o /usr/local/src/helm/helm-v"$VERSION"-linux-amd64.tar.gz.sha256sum

cd /usr/local/src/helm && sha256sum -c helm-v"$VERSION"-linux-amd64.tar.gz.sha256sum  --ignore-missing --quiet

if [ $? -eq 0 ]; then
   tar -C /usr/local/src/helm -zxvf /usr/local/src/helm/helm-v"$VERSION"-linux-amd64.tar.gz
   mv /usr/local/src/helm/linux-amd64/helm /usr/local/bin/helm
   chmod 755 /usr/local/bin/helm && \
   chown root:root /usr/local/bin/helm && \
   rm -r /usr/local/src/helm
else
   exit 1
fi

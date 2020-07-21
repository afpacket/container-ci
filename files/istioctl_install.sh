#!/usr/bin/env bash

VERSION="$1"

mkdir /usr/local/src/istioctl
curl -L https://github.com/istio/istio/releases/download/"$VERSION"/istioctl-"$VERSION"-linux.tar.gz -o /usr/local/src/istioctl/istioctl-"$VERSION"-linux.tar.gz
curl -L https://github.com/istio/istio/releases/download/"$VERSION"/istioctl-"$VERSION"-linux.tar.gz.sha256 -o /usr/local/src/istioctl/istioctl-"$VERSION"-linux.tar.gz.sha256

cd /usr/local/src/istioctl && sha256sum -c istioctl-"$VERSION"-linux.tar.gz.sha256 --ignore-missing --quiet

if [ $? -eq 0 ]; then
   tar -C /usr/local/src/istioctl -zxvf /usr/local/src/istioctl/istioctl-"$VERSION"-linux.tar.gz 
   mv /usr/local/src/istioctl/istioctl /usr/local/bin/istioctl
   chmod 755 /usr/local/bin/istioctl && \
   chown root:root /usr/local/bin/istioctl && \
   rm -r /usr/local/src/istioctl
else
   exit 1
fi

#!/usr/bin/env bash

COMPONENT="$1"
VERSION="$2"

mkdir /usr/local/src/"$COMPONENT"
wget -q https://releases.hashicorp.com/"$COMPONENT"/"$VERSION"/"$COMPONENT"_"$VERSION"_linux_amd64.zip -P /usr/local/src/"$COMPONENT"
wget -q https://releases.hashicorp.com/"$COMPONENT"/"$VERSION"/"$COMPONENT"_"$VERSION"_SHA256SUMS -P /usr/local/src/"$COMPONENT"

cd /usr/local/src/"$COMPONENT" && sha256sum -c "$COMPONENT"_"$VERSION"_SHA256SUMS --ignore-missing --quiet

if [ $? -eq 0 ]; then
   unzip /usr/local/src/"$COMPONENT"/"$COMPONENT"_"$VERSION"_linux_amd64.zip -d /usr/local/bin/ && \
   chmod 755 /usr/local/bin/"$COMPONENT" && \
   rm -r /usr/local/src/"$COMPONENT"
else
   exit 1
fi

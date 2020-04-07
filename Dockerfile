FROM fedora:31
#FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

ARG GOSS_VERSION="0.3.7"
ARG HADOLINT_VERSION="1.17.1"
ARG PACKER_VERSION="1.5.5"
ARG TF_VERSION="0.12.24"
ARG VAULT_VERSION="1.3.4"

COPY files/hashicorp_software_install.sh /usr/local/bin/hashicorp_software_install.sh
COPY files/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
COPY files/RPM-GPG-KEY-Google-Cloud /etc/pki/rpm-gpg/RPM-GPG-KEY-Google-Cloud
COPY files/RPM-GPG-KEY-Google-Cloud-Repo /etc/pki/rpm-gpg/RPM-GPG-KEY-Google-Cloud-Repo

# create non-root user for container to run as
RUN groupadd -r -g 987 ci \
 && useradd -r -u 987 -m -s /bin/bash -g ci ci

# set up non-root user
COPY files/ansible.cfg /home/ci/.ansible.cfg
COPY files/terraformrc /home/ci/.terraformrc
RUN mkdir -m 755 -p /home/ci/.ansible \
 && mkdir -m 755 -p /home/ci/.packer.d \
 && mkdir -m 700 -p /home/ci/.ssh \
 && mkdir -m 755 -p /home/ci/.terraform.d \
 && chown -R ci:ci /home/ci

RUN dnf --setopt=install_weak_deps=false install -y \
    ansible \
    buildah \
    fuse-overlayfs \
    git \
    kubectl \
    podman \
    podman-docker \
    python3 \
    python3-dateutil \
    python3-docutils \
    python3-pip \
    python3-poetry \
    python3-pyasn1 \
    python3-pytest \
    python3-rsa \
    python3-testinfra \
    python3-virtualenv \
    ShellCheck \
    skopeo \
    unzip \
    zip \
 && dnf clean all

# awscli
RUN pip3 install awscli --upgrade \
 && rm -rf /usr/local/bin/__pycache__/*.pyc \
 && rm -rf /usr/local/bin/__pycache__/*.pyo

# hadolint
RUN curl -L https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 -o /usr/local/bin/hadolint \
 && chmod 755 /usr/local/bin/hadolint

# Packer, Terraform, Vault install
RUN /usr/local/bin/hashicorp_software_install.sh packer ${PACKER_VERSION} \
 && /usr/local/bin/hashicorp_software_install.sh terraform ${TF_VERSION} \
 && /usr/local/bin/hashicorp_software_install.sh vault ${VAULT_VERSION}

# Goss - copy gossfiles
COPY files/goss.yml /usr/local/etc/goss.yml
COPY files/goss-vars.yml /usr/local/etc/goss-vars.yml

# Goss - install
RUN curl -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64 -o /usr/local/bin/goss \
 && chmod 755 /usr/local/bin/goss \
 && curl -L https://raw.githubusercontent.com/aelsabbahy/goss/v${GOSS_VERSION}/extras/dgoss/dgoss -o /usr/local/bin/dgoss \
 && chmod 755 /usr/local/bin/dgoss

# Goss - run tests
RUN goss --gossfile /usr/local/etc/goss.yml --vars /usr/local/etc/goss-vars.yml validate

USER ci

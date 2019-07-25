FROM registry.fedoraproject.org/fedora-minimal:30
#FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

ARG PACKER_VERSION="1.4.2"
ARG TF_VERSION="0.11.14"
ARG VAULT_VERSION="1.1.3"

RUN microdnf install -y \
    awscli \
    unzip \
    wget \ 
    && microdnf clean all

COPY files/hashicorp_software_install.sh /usr/local/bin/hashicorp_software_install.sh

# Packer install
RUN /usr/local/bin/hashicorp_software_install.sh packer ${PACKER_VERSION}

# Terraform install
RUN /usr/local/bin/hashicorp_software_install.sh terraform ${TF_VERSION}

# Vault install
RUN /usr/local/bin/hashicorp_software_install.sh vault ${VAULT_VERSION}

# Packer install
#RUN mkdir /usr/local/src/packer && \
#    wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -P /usr/local/src/packer && \
#    wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS -P /usr/local/src/packer
#RUN cd /usr/local/src/packer && sha256sum -c packer_${PACKER_VERSION}_SHA256SUMS --ignore-missing --quiet && \
#    if [ $? -eq 0 ]; then unzip /usr/local/src/packer/packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin/ && chmod 755 /usr/local/bin/packer && rm -r /usr/local/src/packer ; else exit 1 ; fi
#
## Terraform install
#RUN mkdir /usr/local/src/terraform && \
#    wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -P /usr/local/src/terraform && \
#    wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_SHA256SUMS -P /usr/local/src/terraform 
#RUN cd /usr/local/src/terraform && sha256sum -c terraform_${TF_VERSION}_SHA256SUMS --ignore-missing --quiet && \
#    if [ $? -eq 0 ]; then unzip /usr/local/src/terraform/terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin/ && chmod 755 /usr/local/bin/terraform && rm -r /usr/local/src/terraform ; else exit 1 ; fi
#
## Vault install
#RUN mkdir /usr/local/src/vault && \
#    wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -P /usr/local/src/vault && \
#    wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS -P /usr/local/src/vault
#RUN cd /usr/local/src/vault && sha256sum -c vault_${VAULT_VERSION}_SHA256SUMS --ignore-missing --quiet && \
#    if [ $? -eq 0 ]; then unzip /usr/local/src/vault/vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/local/bin/ && chmod 755 /usr/local/bin/vault && rm -r /usr/local/src/vault ; else exit 1 ; fi

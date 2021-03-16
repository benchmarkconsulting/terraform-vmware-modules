FROM jenkins/jnlp-slave

ARG terraform_version=0.14.8


ENV TERRAFORM_VER=${terraform_version}

USER root

# Enable sudo
RUN apt-get update && apt-get -y install sudo
RUN adduser jenkins sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Packer
RUN wget https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip -O terraform.zip &&\
    unzip terraform.zip &&\
    mv terraform /usr/bin/terraform &&\
    chmod 755 /usr/bin/terraform

ENV USER jenkins

USER jenkins

ENTRYPOINT ["jenkins-slave"]
FROM amazonlinux:2 AS build
ARG PACKER_VERSION=1.4.1
ARG ANSIBLE_VERSION=2.8.0
ARG ANSIBLE_LINT_VERSION=4.1.0
ARG AWSCLI_VERSION=1.16.162
ARG JSON2YAML_VERSION=1.1.1
RUN yum update -y && yum install -y git jq unzip python-pip
RUN curl -SsL -O https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip
RUN pip install --user ansible==${ANSIBLE_VERSION}
RUN pip install --user ansible-lint==${ANSIBLE_LINT_VERSION}
RUN pip install --user awscli==${AWSCLI_VERSION}
RUN pip install --user json2yaml==${JSON2YAML_VERSION}


FROM amazonlinux:2
ENV PATH $PATH:/root/.local/bin
COPY --from=build /packer /usr/local/bin/packer
COPY --from=build /root/.local /root/.local
#RUN amazon-linux-extras install epel
RUN yum update -y && \
    yum install -y jq git python-pip && \
    yum clean all  

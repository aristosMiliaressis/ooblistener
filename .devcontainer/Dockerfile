FROM ubuntu

RUN apt-get update \
    && apt-get install -y curl \
        git \
        jq \
        libssl-dev \
        nano \
        pipx \
        python3-pip \
        sudo \
        unzip

RUN pipx install --include-deps ansible

RUN curl -OJ https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_amd64.zip
RUN unzip terraform_1.6.5_linux_amd64.zip \
    && rm terraform_1.6.5_linux_amd64.zip \
    && mv terraform /usr/local/bin/

RUN curl -OJ https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip awscli-exe-linux-x86_64.zip \
    && rm awscli-exe-linux-x86_64.zip \
    && ./aws/install --update \
    && rm -rf ./aws

RUN curl -OJ https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_darwin_amd64.zip \
    && unzip -d /usr/local/bin packer_1.11.2_darwin_amd64.zip \
    && rm packer_1.11.2_darwin_amd64.zip

RUN pip install pre-commit molecule[docker] molecule-plugins[docker] docker yamllint ansible-lint

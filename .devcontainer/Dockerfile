FROM ubuntu

RUN apt-get update \
    && apt-get install -y curl \
        git \
        jq \
        libssl-dev \
        nano \
        pipx \
        python3-docker \
        python3-pip \
        sudo \
        unzip

RUN pipx install --include-deps pre-commit ansible \
    && pipx ensurepath \
    && python3 -m venv .venv \
    && .venv/bin/pip install molecule[docker] molecule-plugins[docker] ansible-lint

RUN curl -OJ https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_amd64.zip \
    && unzip -d /usr/local/bin terraform_1.6.5_linux_amd64.zip \
    && rm terraform_1.6.5_linux_amd64.zip

RUN curl -OJ https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip awscli-exe-linux-x86_64.zip \
    && rm awscli-exe-linux-x86_64.zip \
    && ./aws/install --update \
    && rm -rf ./aws

RUN curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt update \
    && apt install packer

RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

RUN curl -o /tmp/trivy_0.55.2_Linux-64bit.dep -L https://github.com/aquasecurity/trivy/releases/download/v0.55.2/trivy_0.55.2_Linux-64bit.deb \
   && sudo dpkg -i /tmp/trivy_0.55.2_Linux-64bit.dep \
   && rm /tmp/trivy_0.55.2_Linux-64bit.dep

RUN curl -o /usr/local/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.9.0/shfmt_v3.9.0_linux_amd64 \
   && chmod +x /usr/local/bin/shfmt

RUN echo 'export LC_ALL="C.UTF-8"' >> ~/.profile

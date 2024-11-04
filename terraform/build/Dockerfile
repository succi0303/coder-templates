FROM codercom/enterprise-base:ubuntu

USER root

RUN apt-get update \
	&& apt-get install -y \
	curl \
	git \
	golang \
	sudo \
	tzdata \
	unzip \
	vim \
	wget \
	&& rm -rf /var/lib/apt/lists/*

ARG TF_VERSION=1.9.8
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip ./terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm ./terraform_${TF_VERSION}_linux_amd64.zip

ENV TZ Asia/Tokyo
ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
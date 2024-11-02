FROM ubuntu/python:3.12-24.04_stable

RUN apt-get update \
	&& apt-get install -y \
	curl \
	git \
	sudo \
	unzip \
	vim \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# Install AWS and AWS SAM CLI
RUN pip install -U pip setuptools wheel --no-cache-dir && \
    pip install pipx --no-cache-dir && \
	pipx install awscli==2.* && \
	pipx install aws-sam-cli==1.*

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
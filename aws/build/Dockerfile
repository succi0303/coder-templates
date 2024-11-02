FROM ubuntu

RUN apt-get update \
	&& apt-get install -y \
	curl \
	git \
	python3.10 \
	python3-pip \
	sudo \
	unzip \
	vim \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# Install AWS and AWS SAM CLI
RUN pip3 install -U pip setuptools wheel --no-cache-dir && \
    pip3 install pipx --no-cache-dir && \
	pipx install awscli==2.* && \
	pipx install aws-sam-cli==1.*

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
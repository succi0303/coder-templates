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
RUN python3.10 -m pip install --upgrade pip

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
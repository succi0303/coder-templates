FROM codercom/enterprise-base:ubuntu

USER root

RUN apt-get update \
	&& apt-get install -y \
	curl \
	git \
	golang \
    rustup \
	sudo \
	tzdata \
	vim \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# Install rust default toolchain
RUN rustup default stable

ENV TZ Asia/Tokyo
ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
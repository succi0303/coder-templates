FROM codercom/enterprise-base:ubuntu

USER root

# Install Python
RUN apt-get update \
	&& apt-get install -y \
	python3 \
	python3-pip \
	pipx \
	&& rm -rf /var/lib/apt/lists/*
RUN ln -s $(which python3) /usr/bin/python

USER coder
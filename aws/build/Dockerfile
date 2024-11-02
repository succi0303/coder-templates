FROM ubuntu

RUN apt-get update \
	&& apt-get install -y \
	curl \
	git \
	nodejs \
	npm \
	sudo \
	unzip \
	vim \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
	&& ./aws/install -i /usr/local/aws-cli -b /usr/bin

# Install git-secret
RUN git clone https://github.com/awslabs/git-secrets \
    && cd git-secrets && make install \
	&& git secrets --register-aws --global \
	&& git config --global init.templateDir ~/.git-templates/git-secrets

# Install AWS SAM CLI
RUN wget "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" \
    && unzip aws-sam-cli-linux-x86_64.zip -d sam-installation \
	&& ./sam-installation/install

# Install AWS CDK
RUN npm install -g aws-cdk

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}
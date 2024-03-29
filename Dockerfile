# base
FROM ubuntu:20.04

# set the github runner version
ARG RUNNER_VERSION="2.311.0"
#ARG PLATFORM="linux-x64"
ARG PLATFORM="linux-arm64"

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip \
    iputils-ping unzip nodejs sudo

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${PLATFORM}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-${PLATFORM}-${RUNNER_VERSION}.tar.gz

# allow sudo access for the docker user
RUN usermod -aG root docker
RUN echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY install-pwsh-direct.sh install-pwsh.sh

# make the script executable
RUN chmod +x install-pwsh.sh

RUN ./install-pwsh.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
FROM ubuntu:18.04

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        python3.6 \
        python3.6-dev \
        python3-pip \
        python-setuptools \
        cmake \
        wget \
        curl \
        libsm6 \
        libxext6 \ 
        libxrender-dev


RUN python3.6 -m pip install -U pip
RUN python3.6 -m pip install --upgrade setuptools

ENV SINGNET_REPOS=/opt/singnet
ENV ORGANIZATION_ID="odyssey-org"
ENV ORGANIZATION_NAME="odyssey"
ENV SERVICE_ID="uclnlp-service"
ENV SERVICE_NAME="UCLNLP Service"
ENV SERVICE_IP="195.201.197.25"
ENV SERVICE_PORT="3444"
ENV DAEMON_PORT="7000"
ENV DAEMON_HOST="0.0.0.0"
ENV USER_ID="Amante"

ARG nunet_adapter_address
ENV nunet_adapter_address=${nunet_adapter_address}

EXPOSE 3444
EXPOSE 7000

# COPY requirements.txt /tmp

# WORKDIR /tmp

# RUN python3.6 -m pip install -r requirements.txt

COPY . /${SINGNET_REPOS}/STANZA

WORKDIR /STANZA

# SNET Daemon
RUN SNETD_GIT_VERSION=`curl -s https://api.github.com/repos/singnet/snet-daemon/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' || echo "v3.1.6"` && \
    SNETD_VERSION=${snetd_version:-${SNETD_GIT_VERSION}} && \
    cd /tmp && \
    wget https://github.com/singnet/snet-daemon/releases/download/${SNETD_VERSION}/snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    tar -xvf snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    mv snet-daemon-${SNETD_VERSION}-linux-amd64/snetd /usr/bin/snetd && \
    rm -rf snet-daemon-*


RUN python3.6 -m pip install -e .

RUN python3.6 -m pip install -r requirements.txt



RUN cd service && python3.6 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. stanza.proto

WORKDIR /${SINGNET_REPOS}/STANZA/service

CMD ["python3.6", "server.py"]


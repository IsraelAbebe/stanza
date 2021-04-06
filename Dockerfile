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
        libxrender-dev \
        vim \
        lsof


RUN python3.6 -m pip install -U pip
RUN python3.6 -m pip install --upgrade setuptools


ENV SINGNET_REPOS=/opt/singnet
ENV ORGANIZATION_ID="nunet-org"
ENV ORGANIZATION_NAME="nunet"
ENV SERVICE_ID="stanza-service"
ENV SERVICE_NAME="stanza Service"
ENV SERVICE_IP="109.88.2.12"
ENV SERVICE_PORT="2379"
ENV DAEMON_PORT="7010"
ENV DAEMON_HOST="0.0.0.0"
ENV USER_ID="Israel"

ARG nunet_adapter_address
ENV nunet_adapter_address=${nunet_adapter_address}

EXPOSE 2379
EXPOSE 7010

COPY . /${SINGNET_REPOS}/STANZA

WORKDIR /${SINGNET_REPOS}/STANZA

RUN python3.6 -m pip install -e .

RUN python3.6 -m pip install -r requirements.txt

RUN python3.6 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. service/stanza.proto 

CMD ["python3.6", "start_service.py"]


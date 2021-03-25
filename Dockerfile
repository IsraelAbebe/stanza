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
# COPY requirements.txt /tmp

# WORKDIR /tmp

# RUN python3.6 -m pip install -r requirements.txt

COPY . /STANZA

WORKDIR /STANZA

RUN python -m pip install -e .

RUN python -m pip install -r requirements.txt

EXPOSE 50051

RUN cd service

RUN python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. stanza.proto

CMD ["python", "server.py"]


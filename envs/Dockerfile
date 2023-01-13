
ARG CUDA=11.3.1
FROM nvidia/cuda:${CUDA}-cudnn8-runtime-ubuntu18.04
# FROM directive resets ARGS, so we specify again (the value is retained if
# previously set).
ARG CUDA

# Use bash to support string substitution.
SHELL ["/bin/bash", "-c"]

# Fetch the missing keys
RUN APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A4B469963BF863CC

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      cmake \
      git \
      wget \
      slurm-client \
      openmpi-bin openmpi-doc libopenmpi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -P /tmp \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-latest-Linux-x86_64.sh



COPY ./envs/ddmd.yml /ddmd.yml

# Install conda packages.
ENV PATH="/opt/conda/bin:$PATH"
RUN conda update -qy conda \
    && conda env update -n base -f /ddmd.yml
RUN pip install git+https://github.com/hengma1001/ddmd.git


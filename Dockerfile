FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel AS dev
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}

RUN python -m pip install --upgrade pip \
    && pip install packaging cython future
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y git llvm pkg-config wget gfortran
RUN git clone https://github.com/nvidia/apex.git  /root/workspaces/apex \
	&& pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext" /root/workspaces/apex

RUN mkdir -p /root/workspaces/
COPY . /root/workspaces/waveglow
RUN pip install -r /root/workspaces/waveglow/requirements.txt

WORKDIR /root/workspaces/waveglow

FROM dev AS build

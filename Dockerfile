FROM continuumio/anaconda3:2021.11

RUN apt-get -y update && apt-get install -y --no-install-recommends \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=TRUE \
    PYTHONDONTWRITEBYTECODE=TRUE \
    TZ="Asia/Tokyo" \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:en \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=utility,compute,graphics \
    LIBRARY_PATH=/opt/conda/pkgs/cuda-toolkit/lib64/stubs \
    PATH=$PATH:/usr/local/nvidia/bin \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib64:/opt/conda/lib

WORKDIR /tmp
RUN conda update -n base -c defaults conda
COPY base.yml .
RUN conda env update -f base.yml
COPY requirements.txt .
RUN pip install -r requirements.txt && rm -rf ~/.cache/pip
RUN chmod 777 /opt/conda/pkgs/cuda-toolkit
RUN useradd -m signate
USER signate
WORKDIR /opt/ml

FROM continuumio/anaconda3:2020.07

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
    LD_LIBRARY_PATH=/usr/local/nvidia/lib64

COPY base.yml /root
RUN conda env update -f /root/base.yml
COPY requirements.txt /root
RUN pip install -r /root/requirements.txt
RUN rm -rf /root/.cache

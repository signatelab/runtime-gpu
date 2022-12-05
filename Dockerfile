FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

ENV PYTHONUNBUFFERED=TRUE \
    PYTHONDONTWRITEBYTECODE=TRUE \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=utility,compute,graphics \
    PATH=$PATH:/opt/conda/bin \
    DEBIAN_FRONTEND=noninteractive
    
WORKDIR /opt

RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        build-essential \
        libnvinfer8 \
        libnvinfer-plugin8 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge --auto-remove && \
    apt-get clean

RUN cd /usr/lib/x86_64-linux-gnu && \
    ln -s libnvinfer.so.8 libnvinfer.so.7 && \
    ln -s libnvinfer_plugin.so.8 libnvinfer_plugin.so.7

ARG ANACONDA3_VERSION=2022.10
ARG PYTHON_VERSION=3.9

RUN wget -q https://repo.continuum.io/archive/Anaconda3-${ANACONDA3_VERSION}-Linux-x86_64.sh -P ./downloads/ && \
    bash ./downloads/Anaconda3-${ANACONDA3_VERSION}-Linux-x86_64.sh -b -p /opt/conda && \
    rm -rf ./downloads

COPY requirements.txt .
RUN pip install -U pip && \
    pip install -r requirements.txt && \
    rm -rf ~/.cache/pip \
    rm -f requirements.txt

ARG OPENCV_VERSION=4.6.0

RUN apt-get update && apt-get install -y --no-install-recommends \
        cmake \
        unzip \
        yasm \
        pkg-config \
        checkinstall \
        gfortran \
        libatlas-base-dev \
        libavcodec-dev \
        libavformat-dev \
        libavresample-dev \
        libeigen3-dev \
        libexpat1-dev \
        libglew-dev \
        libgtk-3-dev \
        libjpeg-dev \
        libopenexr-dev \
        libpng-dev \
        libpostproc-dev \
        libpq-dev \
        libqt5opengl5-dev \
        libsm6 \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libtiff-dev \
        libtool \
        libv4l-dev \
        libwebp-dev \
        libxext6 \
        libxrender1 \
        libxvidcore-dev \
        protobuf-compiler \
        libgstreamer1.0-0 \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-doc \
        gstreamer1.0-tools \
        gstreamer1.0-x \
        gstreamer1.0-alsa \
        gstreamer1.0-gl \
        gstreamer1.0-gtk3 \
        gstreamer1.0-qt5 \
        gstreamer1.0-pulseaudio \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge --auto-remove && \
    apt-get clean

RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O opencv.zip &&\
    unzip opencv.zip &&\
    rm opencv.zip &&\
    wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib.zip &&\
    unzip opencv_contrib.zip &&\
    rm opencv_contrib.zip &&\
    mkdir -p opencv-${OPENCV_VERSION}/build && cd opencv-${OPENCV_VERSION}/build && \
    cmake \
        -D BUILD_opencv_java=OFF \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_SHARED_LIBS=OFF \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=ON \
        -D CUDA_ARCH_BIN= \
        -D CUDA_ARCH_PTX= \
        -D CUDA_FAST_MATH=ON \
        -D OPENCV_DNN_CUDA=ON \
        -D WITH_CUDA=ON \
        -D WITH_CUDNN=ON \
        -D WITH_CUBLAS=ON \
        -D WITH_NVCUVID=ON \
        -D WITH_CUFFT=ON \
        -D WITH_OPENGL=ON \
        -D WITH_IPP=ON \
        -D WITH_TBB=ON \
        -D WITH_EIGEN=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_LIBV4L=ON \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
        -D PYTHON3_EXECUTABLE=$(which python${PYTHON_VERSION}) \
        -D CMAKE_INSTALL_PREFIX=$(python${PYTHON_VERSION} -c "import sys; print(sys.prefix)") \
        -D PYTHON_INCLUDE_DIR=$(python${PYTHON_VERSION} -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON_PACKAGES_PATH=$(python${PYTHON_VERSION} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
        -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs \
        .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /opt/opencv-${OPENCV_VERSION} && rm -rf /opt/opencv_contrib-${OPENCV_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        locales \
        apt-utils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get purge --auto-remove && \
    apt-get clean

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    locale-gen ja_JP.UTF-8

ENV TZ="Asia/Tokyo" \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:en

RUN useradd -m signate
USER signate
WORKDIR /opt/ml

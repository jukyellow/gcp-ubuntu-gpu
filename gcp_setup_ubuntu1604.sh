#!/bin/bash


# Install NVIDIA drivers
# sudo apt-get update && sudo add-apt-repository ppa:graphics-drivers/ppa -y && \
# sudo apt-get update && sudo apt-get install nvidia

# Check for CUDA and try to install.
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/base/Dockerfile
sudo apt-get update && sudo apt-get install -y --no-install-recommends ca-certificates apt-transport-https gnupg-curl && sudo rm -rf /var/lib/apt/lists/* && \
NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
sudo apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && sudo rm cudasign.pub && \
sudo sh -c 'echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list' && \
sudo sh -c 'echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list'

export CUDA_VERSION=9.0.176
export CUDA_PKG_VERSION=9-0=$CUDA_VERSION-1

sudo apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION

curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_${CUDA_VERSION}-1_amd64.deb
sudo dpkg -i ./cuda-repo-ubuntu1604_${CUDA_VERSION}-1_amd64.deb
sudo apt-get update && sudo apt-get install -y --no-install-recommends cuda=${CUDA_VERSION}-1
sudo rm ./cuda-repo-ubuntu1604_${CUDA_VERSION}-1_amd64.deb

ln -s cuda-9.0 /usr/local/cuda

sudo sh -c 'echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf'
sudo sh -c 'echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf'

export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

# NCCL install
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/runtime/Dockerfile
export NCCL_VERSION=2.2.13

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-cublas-9-0=9.0.176.3-1 \
        libnccl2=$NCCL_VERSION-1+cuda9.0


# CUDNN install
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/runtime/cudnn7/Dockerfile
export CUDNN_VERSION=7.1.4.18

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
        libcudnn7=$CUDNN_VERSION-1+cuda9.0

sudo rm -rf /var/lib/apt/lists/*

# Tensorflow
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/docker/Dockerfile.gpu
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-9-0 \
        cuda-cublas-9-0 \
        cuda-cufft-9-0 \
        cuda-curand-9-0 \
        cuda-cusolver-9-0 \
        cuda-cusparse-9-0 \
        curl \
        cmake \
        libcudnn7=7.1.4.18-1+cuda9.0 \
        libnccl2=2.2.13-1+cuda9.0 \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        python3-dev \
        python-tk3\
        unzip


pip --no-cache-dir install \
        ipykernel

python -m ipykernel.kernelspec

export LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

sudo sh -c 'echo PATH=$PATH > /etc/environment'
sudo sh -c 'echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH >> /etc/environment'

echo PATH=$PATH >> .bashrc
echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH >> .bashrc
source .bashrc
# echo PATH=$PATH >> /root/.bashrc
# echo LD_LIBRARY_PATH=$LD_LIBRARY_PATH >> /root/.bashrc
# source /root/.bashrc


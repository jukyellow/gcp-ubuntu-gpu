# GPU 드라이버와 우분트16.04 설정만 사용(아나콘다와 jupyter는 별도 설치)  

# Quick Set Up NVIDIA GPUs with GCP VM
* OS: `Ubuntu 16.04`
* GPU: `NVIDIA K80, P100, V100`
    * CUDA: `9.0.176`
    * NCCL: `2.2.13`
    * CUDNN: `7.1.4.18`
* Programs:
    * Anaconda: `5.3.1`, Python: `3.7.5` (is not default)

# How to use
* Run `gcp_setup_ubuntu1604.sh`
* Before you run this file, please check your OS __Ubuntu 16.04__.
* You can modify this code if you want to use other OS or CUDA version.
```
wget https://raw.githubusercontent.com/jukyellow/gcp-ubuntu-gpu/master/gcp_setup_ubuntu1604.sh
bash gcp_setup_ubuntu1604.sh
```

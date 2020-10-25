#!/bin/bash -x
# This should work on a minimal 18.04 Ubuntu install with any CUDA core supported by CUDA 10.2
# Installing pytorch requires a lot of RAM

# Get the base system up-to-date
apt-get -y update
apt-get -y upgrade

# Install standard dev tools, llvm10 is needed by numba
apt-get -y install gcc git emacs-nox llvm-10-dev
apt-get -y install curl cmake libboost-all-dev 
ln -s /usr/bin/llvm-config-10 /usr/bin/llvm-config

# Install CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
apt-get update
apt-get -y install --no-install-recommends cuda


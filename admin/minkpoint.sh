#!/bin/sh -x
# This should work on a minimal 18.04 Ubuntu install with any CUDA core supported by CUDA 10.2
# Installing pytorch requires a lot of RAM

# Get the base system up-to-date
apt-get -y update
apt-get -y upgrade

# Install standard dev tools
apt-get -y install gcc git emacs-nox
apt-get -y install python3 python3-pip curl cmake libboost-all-dev

# Install CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
apt-get update
apt-get -y install --no-install-recommends cuda

# Install machine learning stuff
apt-get -y install libopenblas-dev
pip3 install --no-input numpy mkl-include torch torchvision

# Make sure everything is using python 3 before trying to build MinkowskiEngine
ln -sf /usr/bin/python3 /usr/bin/python

pip3 install --no-input nuscenes-devkit

pip3 install --no-input -U MinkowskiEngine --install-option="--blas=openblas" -v

git clone https://github.com/NVIDIA/MinkowskiEngine.git
cd MinkowskiEngine
python3 setup.py install --blas=openblas
cd ..

# Install apex, spconv for CenterPoint
git clone https://github.com/NVIDIA/apex
cd apex
git checkout 5633f6  # recent commit doesn't build in our system 
pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
cd ..

git clone https://github.com/traveller59/spconv.git --recursive
cd spconv && git checkout 7342772
python3 setup.py bdist_wheel
cd ./dist && pip install *
cd ../..

git clone https://github.com/tianweiy/CenterPoint.git
cd CenterPoint
pip3 install -r requirements.txt


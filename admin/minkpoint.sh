#!/bin/sh -x
# This should work on a minimal 18.04 Ubuntu install with any CUDA core supported by CUDA 10.2
# Installing pytorch requires a lot of RAM

# Get the base system up-to-date
apt-get -y update
apt-get -y upgrade

# Install standard dev tools, llvm10 is needed by numba
apt-get -y install gcc git emacs-nox llvm-10-dev
apt-get -y install python3.6 python3-pip curl cmake libboost-all-dev 
ln -s /usr/bin/llvm-config-10 /usr/bin/llvm-config

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

# Install conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

conda create --name minkpoint python=3.6
conda activate minkpoint
conda install pytorch==1.6.0 torchvision==0.7.0 cudatoolkit=10.2 -c pytorch

pip3 install scikit-build
pip3 install numpy

# Install nuScenes developer kit
git clone https://github.com/tianweiy/nuscenes-devkit

# Install apex, spconv for CenterPoint
git clone https://github.com/NVIDIA/apex
cd apex
git checkout 5633f6  # recent commit doesn't build in our system 
pip3 install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
cd ..

# Install spconv
git clone https://github.com/traveller59/spconv.git --recursive
cd spconv && git checkout 7342772
python3 setup.py bdist_wheel
cd ./dist && pip install *
cd ..

# Install CenterPoint
git clone https://github.com/tianweiy/CenterPoint.git
cd CenterPoint
pip3 install -r requirements.txt

# pip3 install --no-input -U MinkowskiEngine --install-option="--blas=openblas" -v
git clone https://github.com/NVIDIA/MinkowskiEngine.git
cd MinkowskiEngine
python3 setup.py install --blas=openblas
cd ..

chown -R charmedliferaft ~

echo "Add CenterPoint and nuscenes/python-sdk to your PYTHONPATH env var."


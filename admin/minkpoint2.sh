#!/bin/bash -x
# Run the first minkpoint script before this and reboot
# Also upload libcudnn for CUDA10.2 to the same directory
# Install machine learning stuff
apt-get -y install libopenblas-dev
apt install ./libcudnn8_8.0.4.30-1+cuda10.2_amd64.deb
apt install ./libcudnn8-dev_8.0.4.30-1+cuda10.2_amd64.deb

# Install conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# To get conda stuff in the environment
source /home/charmedliferaft/miniconda3/etc/profile.d/conda.sh

# Create conda environment
conda create -y --name minkpoint python=3.6
conda activate minkpoint

# Tensorflow like CUDA 10.1, but 10.2 is compatible...
cd /home/charmedliferaft/miniconda3/envs/minkpoint/lib/
sudo ln -s libcudart.so.10.2 libcudart.so.10.1
cd /home/charmedliferaft

# Use conda to install some stuff
conda install -y -c conda-forge scikit-build
conda install -y pytorch==1.6.0 torchvision==0.7.0 cudatoolkit=10.2 -c pytorch
conda install -y tensorflow

export CUDACXX="/usr/local/cuda/bin/nvcc"

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
# This version is recommended, but doesn't build
# cd spconv && git checkout 7342772
cd spconv
python3 setup.py bdist_wheel
cd dist
pipe install *
cd ../..

# Install CenterPoint
git clone https://github.com/tianweiy/CenterPoint.git
cd CenterPoint
pip3 install -r requirements.txt
mkdir work_dirs
tar xvzf ../demo.tgz

# pip3 install --no-input -U MinkowskiEngine --install-option="--blas=openblas" -v
git clone https://github.com/NVIDIA/MinkowskiEngine.git
cd MinkowskiEngine
python3 setup.py install
cd ..

chown -R charmedliferaft ~

# Tidy up
apt-get autoremove

echo "Add /home/charmedliferaft/CenterPoint:/home/charmedliferaft/nuscenes-devkit/python-sdk your PYTHONPATH env var."

export PYTHONPATH="/home/charmedliferaft/CenterPoint:/home/charmedliferaft/nuscenes-devkit/python-sdk"



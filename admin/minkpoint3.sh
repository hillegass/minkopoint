#!/bin/bash -x

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
conda install -y pytorch==1.5.0 torchvision==0.3.0 cudatoolkit=10.2 -c pytorch
conda install -y tensorflow

export CUDACXX="/usr/local/cuda/bin/nvcc"

cd apex
git checkout 5633f6  # recent commit doesn't build in our system 
pip3 install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
cd ~

# This version is recommended, but doesn't build
# cd spconv && git checkout 7342772
cd spconv
python3 setup.py bdist_wheel
cd dist
pipe install *
cd ~

cd CenterPoint
pip3 install -r requirements.txt
mkdir work_dirs
mkdir work_dirs/centerpoint_pillar_512_demo
tar xzf ../demo.tgz
cp ../last.pth work_dirs/centerpoint_pillar_512_demo
cd ~

# pip3 install --no-input -U MinkowskiEngine --install-option="--blas=openblas" -v
cd MinkowskiEngine
python3 setup.py install
cd ..

chown -R charmedliferaft ~

# Tidy up
apt-get autoremove

echo "Add /home/charmedliferaft/CenterPoint:/home/charmedliferaft/nuscenes-devkit/python-sdk your PYTHONPATH env var."

export PYTHONPATH="/home/charmedliferaft/CenterPoint:/home/charmedliferaft/nuscenes-devkit/python-sdk"



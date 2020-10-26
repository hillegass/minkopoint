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

echo "RUN THESE"
echo "conda create -y --name minkpoint python=3.6"
echo "conda activate minkpoint"

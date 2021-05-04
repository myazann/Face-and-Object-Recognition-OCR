FROM nvidia/cuda:11.1-devel-ubuntu20.04

USER root
WORKDIR /app

RUN apt update -y && apt install wget curl libgl1-mesa-glx systemctl apt-utils gcc python3-dev -yq --no-install-recommends \
				  && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && sha256sum Miniconda3-latest-Linux-x86_64.sh \
				  && bash Miniconda3-latest-Linux-x86_64.sh -b


ENV PATH=/root/miniconda3/bin:$PATH

RUN conda init && conda config --set auto_activate_base false && rm Miniconda3-latest-Linux-x86_64.sh \
               && conda create -n examenv -y

RUN conda install --file files/requirements2.txt -y -n examenv -c conda-forge -c menpo -c pytorch cudatoolkit=10.2

ADD files/20180402-114759-vggface2.pt /root/.cache/torch/checkpoints/20180402-114759-vggface2.pt
ADD facenet_pytorch /root/miniconda3/envs/examenv/lib/python3.8/site-packages/facenet_pytorch
ADD facenet_pytorch-2.5.0.dist-info/ /root/miniconda3/envs/examenv/lib/python3.8/site-packages/facenet_pytorch-2.5.0.dist-info/

ENTRYPOINT ["/bin/bash"]

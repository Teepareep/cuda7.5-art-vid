# Start with CUDA Caffe dependencies
FROM kaixhin/cuda-caffe-deps:latest
MAINTAINER Kai Arulkumaran <design@kaixhin.com>

RUN apt-get install -y \
  vim \
  ssh \
  libprotobuf-dev \
  protobuf-compiler \
  libav-tools

# Move into Caffe repo
RUN cd /root/caffe && \
# Make and move into build directory
  mkdir build && cd build && \
# CMake
  cmake .. && \
# Make
  make -j"$(nproc)" all && \
  make install

# Add to Python path
ENV PYTHONPATH=/root/caffe/python:$PYTHONPATH

#install loadcaffe
RUN cd /root/ && \
  luarocks install loadcaffe
  
RUN cd /root/ && \
  git clone https://github.com/manuelruder/artistic-videos.git && \
  git clone https://github.com/Teepareep/cuda-files.git && \
  cp cuda-files/cuda/include/* /usr/local/cuda/include && \
  cp cuda-files/cuda/lib64/*.so* /usr/local/cuda/lib64 && \
  cp cuda-files/deepflow2-static artistic-videos/ && \
  cp cuda-files/deepmatching-static artistic-videos/ && \
  cd artistic-videos && \ 
  # cd models && \
  # sh download_models.sh && \ # this takes too long
  # cd /root/artistic-videos && \
  mkdir vid && \
  mkdir img 

# Set ~/caffe as working directory
WORKDIR /root/artistic-videos

#!/bin/bash -e
#
# Create Dockerfiles from template

# Template file
template="Dockerfile.template"
# List of environment variables which will be substituted into the template
shell_format='$BASE:$ADDITIONAL_STEPS'

# Creates a Dockerfile from the template.
# Arguments:
# 1. Output path to write the resulting Dockerfile to
# 2. The base image, substituted into $BASE in the template
# 3. Additional steps to insert into the Dockerfile,
#    substituted into $ADDITIONAL_STEPS in the template
function make_dockerfile {
  dest=$1
  export BASE=$2
  export ADDITIONAL_STEPS=$3

  # Make path to output file
  mkdir -p "$(dirname "$dest")"
  # Fill in the template and write the result to $dest
  envsubst $shell_format < $template > $dest
  # Copy additional files required by the Docker build
  if [ -d "common" ]; then
    cp -r common/. "$(dirname "$dest")"
  fi
}


### Currently supported images

# CUDA 10.0
make_dockerfile \
  'cuda-10.0/Dockerfile' \
  'nvidia/cuda:10.0-base-ubuntu16.04' \
  '# CUDA 10.0-specific steps
RUN conda install -y -c pytorch \
    cudatoolkit=10.0 \
    "pytorch=1.2.0=py3.6_cuda10.0.130_cudnn7.6.2_0" \
    "torchvision=0.4.0=py36_cu100" \
 && conda clean -ya'

# CUDA 9.2
make_dockerfile \
  'cuda-9.2/Dockerfile' \
  'nvidia/cuda:9.2-base-ubuntu16.04' \
  '# CUDA 9.2-specific steps
RUN conda install -y -c pytorch \
    cudatoolkit=9.2 \
    "pytorch=1.2.0=py3.6_cuda9.2.148_cudnn7.6.2_0" \
    "torchvision=0.4.0=py36_cu92" \
 && conda clean -ya'

# No CUDA
make_dockerfile \
  'no-cuda/Dockerfile' \
  'ubuntu:16.04' \
  '# No CUDA-specific steps
ENV NO_CUDA=1
RUN conda install -y -c pytorch \
    cpuonly \
    "pytorch=1.2.0=py3.6_cpu_0" \
    "torchvision=0.4.0=py36_cpu" \
 && conda clean -ya'


### Deprecated images

# # CUDA 7.5
# make_dockerfile \
#   'cuda-7.5/Dockerfile' \
#   'nvidia/cuda:7.5-runtime-ubuntu14.04' \
#   '# CUDA 7.5-specific steps
# RUN conda install -y -c pytorch \
#     cuda75=1.0 \
#     magma-cuda75=2.2.0 \
#     pytorch=0.3.0 \
#     torchvision=0.2.0 \
#  && conda clean -ya'

# # CUDA 8.0
# make_dockerfile \
#   'cuda-8.0/Dockerfile' \
#   'nvidia/cuda:8.0-runtime-ubuntu16.04' \
#   '# CUDA 8.0-specific steps
# RUN conda install -y -c pytorch \
#     cuda80=1.0 \
#     magma-cuda80=2.3.0 \
#     "pytorch=1.0.0=py3.6_cuda8.0.61_cudnn7.1.2_1" \
#     torchvision=0.2.1 \
#  && conda clean -ya'

# # CUDA 9.0
# make_dockerfile \
#   'cuda-9.0/Dockerfile' \
#   'nvidia/cuda:9.0-base-ubuntu16.04' \
#   '# CUDA 9.0-specific steps
# RUN conda install -y -c pytorch \
#     cuda90=1.0 \
#     magma-cuda90=2.4.0 \
#     "pytorch=1.0.0=py3.6_cuda9.0.176_cudnn7.4.1_1" \
#     torchvision=0.2.1 \
#  && conda clean -ya'

# # CUDA 9.1
# make_dockerfile \
#   'cuda-9.1/Dockerfile' \
#   'nvidia/cuda:9.1-base-ubuntu16.04' \
#   '# CUDA 9.1-specific steps
# RUN conda install -y -c pytorch \
#     cuda91=1.0 \
#     magma-cuda91=2.3.0 \
#     pytorch=0.4.0 \
#     torchvision=0.2.1 \
#  && conda clean -ya'

# Derive image from the official Ubuntu image
FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y git wget python3 python3-venv python3-pip libstdc++-12-dev

# Add user
RUN usermod -a -G render,video $LOGNAME

# Install ROCM
RUN wget https://repo.radeon.com/amdgpu-install/6.1.2/ubuntu/jammy/amdgpu-install_6.1.60102-1_all.deb && \ 
    apt install ./amdgpu-install_6.1.60102-1_all.deb -y && \
    apt update && \
    amdgpu-install --usecase=rocm

# If you build a Image till here and check using shell if rocm can find your gpu, you are good to go!
# RUN rocminfo
# Sometimes, rocm may not be recognized, but dkms status will return your GPU, that is probably a Kernel incompatibility error.
# but I can't say for sure.

# Clone the repository - AUTO1111
RUN git clone --depth 1 https://github.com/AUTOMATIC1111/stable-diffusion-webui
WORKDIR /stable-diffusion-webui

# Set up venv as PEP requires it
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV 
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install all Automatic1111 requirements
RUN apt-get clean -y && \
    pip install --upgrade pip wheel  && \
    pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/rocm6.1.2 && \
    python -m pip install --force-reinstall httpcore==0.15 && \
    echo "Downloading SDv1.4 Model File.." && \
    curl -o models/Stable-diffusion/model.ckpt https://huggingface.co/CompVis/stable-diffusion-v-1-4-original/resolve/main/sd-v1-4.ckpt

# Port used for webui
EXPOSE 7860
ENTRYPOINT ["python3", "launch.py", "--precision full", "--no-half"]
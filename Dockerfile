FROM ubuntu:latest

RUN useradd automatic

RUN apt-get update && \
  apt install -y wget git libgl1 libglib2.0-0 software-properties-common google-perftools bc 

RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN add-apt-repository ppa:deadsnakes/ppa && \
  apt-get update && \
  apt install -y python3.10 python3.10-venv python3-pip python3.10-venv nvidia-container-toolkit

WORKDIR /opt/AUTOMATIC1111

COPY launch.py /tmp/launch.py
COPY webui.sh .
RUN chmod +x webui.sh
RUN chown -R automatic:automatic /opt/AUTOMATIC1111

USER automatic

RUN NO_START=true ./webui.sh --skip-torch-cuda-test --ckpt-dir=/models/

ENTRYPOINT [ "./webui.sh", "--ckpt-dir=/models/", "--server-name=0.0.0.0", "--xformers"]

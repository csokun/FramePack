FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y curl wget libgl1 libglib2.0-0 python3-pip python-is-python3 python3.12-venv git \
    ffmpeg libx264-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install under /root/.local
ENV PIP_USER="true"
ENV PIP_NO_WARN_SCRIPT_LOCATION=0
ENV PIP_ROOT_USER_ACTION="ignore"

WORKDIR /app

COPY requirements.txt .

RUN --mount=type=cache,target=/root/.cache \
    pip install --upgrade pip --break-system-packages

RUN --mount=type=cache,target=/root/.cache \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126 --break-system-packages

RUN --mount=type=cache,target=/root/.cache \
    pip install -r requirements.txt --break-system-packages

COPY . .

EXPOSE 7861

CMD ["python3", "demo_gradio.py", "--port", "7861"]
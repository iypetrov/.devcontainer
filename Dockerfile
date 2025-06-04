FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \

RUN apt update && apt install -y \
    curl \
    wget \
    git \
    vim \
    tmux \
    zsh \
    htop \
    fzf \
    unzip \
    build-essential \
    ripgrep \
    ca-certificates \
    openssh-client \
    sudo \
 && rm -rf /var/lib/apt/lists/*

RUN chsh -s /usr/bin/zsh root

WORKDIR /root

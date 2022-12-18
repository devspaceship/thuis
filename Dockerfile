FROM ubuntu

# Base
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y \
        sudo \
        man-db \
        git \
        vim \
        python3 \
    && rm -rf /var/lib/apt/lists/*

# RUST / NODE / NEOVIM
# dotfiles

# Unminimizing
RUN yes | unminimize


# Non-root user
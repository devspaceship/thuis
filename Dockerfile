FROM ubuntu

# Unminimize
RUN yes | unminimize

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

# RUST / DOTNET / NODE / NEOVIM / ZSH / TMUX
# dotfiles


# Non-root user
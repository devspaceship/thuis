FROM ubuntu
ARG USERNAME=devspaceship
ARG USER_UID=1000
ARG USER_GID=$USER_UID

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
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

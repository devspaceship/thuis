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
        software-properties-common \
        curl \
        git \
        zsh \
        python3

# Neovim
RUN add-apt-repository ppa:neovim-ppa/stable \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y \
        neovim

# Non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust-install.sh \
    && chmod +x rust-install.sh \
    && ./rust-install.sh -y \
    && rm ./rust-install.sh \
    && . $HOME/.cargo/env

# Oh my zsh
RUN yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

CMD zsh

# dotnet / node / tmux / PowerShell
# dotfiles
# non-root user password
# -> disclaimer to not publish built image because secret baked in

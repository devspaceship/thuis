FROM ubuntu
ARG USERNAME=devspaceship
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DOTNET_FILE=dotnet-sdk-7.0.101-linux-arm64.tar.gz

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
        wget \
        git \
        zsh \
        neofetch \
        tmux \
        gcc \
        g++ \
        make \
        python3

# Neovim
RUN add-apt-repository ppa:neovim-ppa/stable \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y \
        neovim

# Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Yarn
RUN corepack enable \
    && corepack prepare yarn@stable --activate

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

# Dotnet
RUN wget https://download.visualstudio.microsoft.com/download/pr/caa0e6fb-770c-4b21-ba55-30154a7a9e11/3231af451861147352aaf43cf23b16ea/$DOTNET_FILE \
    && export DOTNET_ROOT=$HOME/.dotnet \
    && mkdir -p "$DOTNET_ROOT" && tar zxf "$DOTNET_FILE" -C "$DOTNET_ROOT" \
    && rm $DOTNET_FILE

# Chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" \
    && echo 'export PATH=$PATH:$HOME/bin' >> .zshrc

# Starship Prompt
RUN wget https://starship.rs/install.sh \
    && chmod +x install.sh \
    && ./install.sh --yes \
    && rm install.sh

CMD zsh

# non-root user password
# -> disclaimer to not publish built image because secret baked in / also it's a heavy image
# better -> build with --secret

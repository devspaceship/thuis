FROM ubuntu

RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y \
        git \
        vim \
        python3 \
    && rm -rf /var/lib/apt/lists/*

# RUST / NODE / NEOVIM
# NON-ROOT-USER
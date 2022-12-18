export USERNAME=devspaceship
docker build -t devcontainer-image .
docker rm -f devcontainer
docker create -it --name devcontainer devcontainer-image
docker cp ~/.ssh devcontainer:/home/$USERNAME
docker start devcontainer
docker exec -it devcontainer bash -c "sudo rm .ssh/config \
    && sudo chown -R $USERNAME:$USERNAME ./.ssh \
    && ./bin/chezmoi init git@github.com:$USERNAME/dotfiles.git \
    && ./bin/chezmoi apply \
    && echo 'export DOTNET_ROOT=\$HOME/.dotnet' >> .zshrc \
    && echo 'export PATH=\$PATH:\$DOTNET_ROOT:\$DOTNET_ROOT/tools' >> .zshrc"
docker stop devcontainer

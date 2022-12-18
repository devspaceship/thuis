docker build -t devcontainer-image .
docker rm -f devcontainer
docker create -it --name devcontainer devcontainer-image

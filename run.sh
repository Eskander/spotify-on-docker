#!/usr/bin/env bash

DEVICE_NAME=Spotify-on-Docker
CONFIG_DIR=/home/$USER/.config/spotify
PORT=8080

# Check for podman or docker
if [ -f "/usr/bin/podman" ]; then
    container=podman
else
    container=docker
fi

mkdir -p $CONFIG_DIR

sudo $container run -it --rm \
  --publish $PORT:8080 \
  --volume $CONFIG_DIR:/home/user/.config/spotify \
  --volume $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse \
  --hostname $DEVICE_NAME \
  --name $DEVICE_NAME \
  spotify-on-docker:latest

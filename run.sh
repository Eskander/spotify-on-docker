#!/usr/bin/env bash

DEVICE_NAME=Spotify-on-Docker
HOST_CONFIG_DIR=/home/$USER/.config/spotify

mkdir -p $HOST_CONFIG_DIR

docker run -it --rm \
  -p 8080:8080 \
  -v $HOST_CONFIG_DIR:/home/user/.config/spotify \
  -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse \
  -h $DEVICE_NAME \
  spotify-on-docker:latest

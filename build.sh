#!/usr/bin/env bash

# Check for podman or docker
if [ -f "/usr/bin/podman" ]; then
    container=podman
else
    container=docker
fi

sudo $container build -t "spotify-on-docker:latest" .
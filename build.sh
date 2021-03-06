#!/usr/bin/env bash

container=docker

# If podman detected
if [ -f "/usr/bin/podman" ]; then
    echo "Podman detected"
    container=podman
fi

$container build -t "spotify-on-docker:latest" .
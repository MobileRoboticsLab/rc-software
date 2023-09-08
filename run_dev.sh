#!/bin/bash

# Get the absolute path to the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Build the docker image
docker build -t mobiroborc "${SCRIPT_DIR}"

# Start the Docker container
docker run -it \
    --rm \
    --net host \
    --privileged \
    -v /dev:/dev \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e ROS_MASTER_URI=http://localhost:11311 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    mobiroborc \
    bash
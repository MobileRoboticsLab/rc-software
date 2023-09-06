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
    mobiroborc \
    bash
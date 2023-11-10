#!/bin/bash

sudo apt update

# Get the absolute path to the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Build the docker image
docker build -t mobiroborc "${SCRIPT_DIR}"
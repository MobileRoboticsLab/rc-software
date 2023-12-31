#!/bin/bash

# Enable display forwarding
xhost +

# Start the Docker container
docker run -it \
    --rm \
    --net host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -e ROS_MASTER_URI=http://10.42.0.1:11311 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    osrf/ros:noetic-desktop-full \
    rviz
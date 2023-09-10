#!/bin/bash

LOG_FOLDER="/tmp/mobile-robotics-rc.log"

echo "Starting RC Car..."
echo "Logging in ${LOG_FOLDER}"

# Start mobile hotspot
nmcli con up Hostspot

# Start the Docker container
docker run \
    --rm \
    --net host \
    --privileged \
    -v /dev:/dev \
    mobiroborc \
    /bin/bash -c "source /catkin_ws/devel/setup.bash && roslaunch /catkin_ws/src/rc_launch.launch" \
    >> ${LOG_FOLDER}
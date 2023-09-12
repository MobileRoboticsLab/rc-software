#!/bin/bash

LOG_FOLDER="/tmp/mobile-robotics-rc.log"

echo "Starting RC Car..."
echo "Logging in ${LOG_FOLDER}"

# Start the mobile hotspot
nmcli con up Hostspot

# Run the docker container
docker run \
    --rm \
    --name mobile_robotics_rc \
    --net host \
    --privileged \
    -v /dev:/dev \
    -e ROS_IP="10.42.0.1" \
    mobiroborc \
    /bin/bash -c "source /catkin_ws/devel/setup.bash && roslaunch /catkin_ws/src/rc_launch.launch" \
    >> ${LOG_FOLDER}


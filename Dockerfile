# Start from ROS noetic image (robot version)
FROM ros:noetic-robot

# Update apt
RUN apt update

# Install dependencies
RUN apt install -y \
    ros-noetic-tf \
    ros-noetic-ackermann-msgs \
    ros-noetic-serial

# Install Hector SLAM
RUN apt install -y \
    ros-noetic-hector-mapping

# Set work directory
WORKDIR /catkin_ws/

# Install hardware packages
COPY vesc src/vesc
COPY ydlidar src/ydlidar

# Build ROS workspace
RUN . /opt/ros/noetic/setup.sh \
    && catkin_make

# Install project resources
COPY resources/rc_launch.launch src/rc_launch.launch
COPY resources/rc_config.yaml src/rc_config.yaml
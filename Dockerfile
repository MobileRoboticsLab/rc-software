FROM ros:noetic-robot

RUN apt update

RUN apt install -y \
    ros-noetic-tf \
    ros-noetic-ackermann-msgs \
    ros-noetic-serial

RUN apt install -y \
    ros-noetic-hector-mapping

# Set work directory
WORKDIR /catkin_ws/

# Install packages
COPY vesc src/vesc
COPY ydlidar src/ydlidar

# Build ROS workspace
RUN . /opt/ros/noetic/setup.sh \
    && catkin_make

# Install launch file
COPY resources/rc_launch.launch src/rc_launch.launch
COPY resources/rc_config.yaml src/rc_config.yaml
FROM ros:noetic

RUN apt update
RUN apt install net-tools -y

RUN apt install -y \
    ros-noetic-tf \
    ros-noetic-ackermann-msgs \
    ros-noetic-serial

RUN apt install -y \
    ros-noetic-hector-mapping

# Set work directory
WORKDIR /catkin_ws/

# Install packages
COPY ./vesc /catkin_ws/src/vesc
COPY ./ydlidar /catkin_ws/src/ydlidar

# Build ROS workspace
#RUN cd /catkin_ws/ \
#    && . /opt/ros/noetic/setup.sh \
#    && catkin_make
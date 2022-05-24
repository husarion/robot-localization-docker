FROM ros:noetic-ros-core

# Use bash instead of sh
SHELL ["/bin/bash", "-c"]

# Update Ubuntu Software repository
RUN apt update \
    && apt upgrade -y \
    && apt install -y git \
        python3-dev \
        python3-pip \
        ros-noetic-robot-localization

WORKDIR /app

COPY ./localization_bringup ./ros_ws/src/localization_bringup

RUN cd ros_ws \
    && mkdir build \
    && source /opt/ros/$ROS_DISTRO/setup.bash \
    && catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release

# Clear 
RUN apt clean \
    && rm -rf /var/lib/apt/lists/* 

COPY ./ros_entrypoint.sh / 
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
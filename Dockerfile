FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# Source dependencies
RUN git clone https://github.com/strasdat/Sophus.git \
 && cd Sophus && git checkout a621ff \
 && mkdir build && cd build && cmake .. \
 && make install && cd .. && rm -fr Sophus

# Code repository

RUN mkdir -p /catkin_ws/src/

RUN git clone --recurse-submodules \
      https://github.com/RobotResearchRepos/hku-mars_FAST-LIVO \
      /catkin_ws/src/FAST-LIVO

RUN git clone --recurse-submodules \
      https://github.com/uzh-rpg/rpg_vikit \
      /catkin_ws/src/rpg_vikit

RUN git clone --recurse-submodules \
      https://github.com/Livox-SDK/livox_ros_driver \
      /catkin_ws/src/livox_ros_driver

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && cd /catkin_ws \
 && catkin_make
 
 

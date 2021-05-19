FROM debian:buster-slim

# Adapted from https://github.com/tentone/tello-ros2


RUN apt-get update &&\
	apt update

# C++ Build tools
RUN apt install -y build-essential gdb

# Set UTF-8 charset
RUN apt install -y locales &&\
	locale-gen en_US en_US.UTF-8 &&\
	update-locale LANG=en_US.UTF-8 &&\
	update-locale LC_ALL=en_US.UTF-8 &&\
	export LANG=en_US.UTF-8

# Add ROS2 sources
RUN apt update &&\
	apt install -y curl gnupg2 lsb-release &&\
	curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - &&\
	sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# Install ROS 2 (foxy)
RUN apt-get update &&\
	apt update &&\
	apt install -y ros-foxy-desktop

# Step envrioment
RUN source /opt/ros/foxy/setup.bash

# Argcomplete
RUN apt install -y python3-pip &&\
	pip3 install -U argcomplete

# Colcon build tools
RUN apt install -y python3-colcon-common-extensions python3-rosdep2

# Update ROS dep
RUN rosdep update &&\
	rosdep fix-permissions

# Add to bashrc
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc &&\
	echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc &&\
	echo "export _colcon_cd_root=~/ros2_install" >> ~/.bashrc &&\
	source ~/.bashrc

# Install project dependencies
RUN pip3 install catkin_pkg rospkg av image opencv-python djitellopy2 pyyaml &&\
	apt install -y python3-tf* &&\
	apt install -y ros-foxy-ament-cmake* ros-foxy-tf2* ros-foxy-rclcpp* ros-foxy-rosgraph* &&\
	apt install -y ros-foxy-rviz* ros-foxy-rqt*

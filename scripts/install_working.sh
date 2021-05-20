#!/bin/bash

if [ $EUID > 0 ] && ![ -f /.dockerenv ]; then
	echo " - Please run as root"
	exit
fi

#Install ROS 2
echo " - Installing ROS 2 Foxy"

echo " - Install Build Tools"

# C++ Build tools
apt install -y build-essential gdb

# Set UTF-8 charset
apt update
apt install -y locales locales-all # need all, otherwise the container errors `update-locale: Error: invalid locale settings:  LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8`
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo " - ROS 2 sources"

# Add ROS2 sources
apt update
apt install -y curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

echo " - Install ROS 2"

# Install ROS 2 (foxy)
apt update
apt install -y ros-foxy-desktop 

# Step envrioment
source /opt/ros/foxy/setup.bash

echo " - Install Python ROS 2"

# Argcomplete
apt install -y python3-pip
pip3 install -U argcomplete rosdep

# Colcon build tools
apt install -y python3-colcon-common-extensions

# Update ROS dep
rosdep init
rosdep update
rosdep fix-permissions

# Add to bashrc
echo " - Register ROS 2 in .bashrc"
echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc
echo "export _colcon_cd_root=~/ros2_install" >> ~/.bashrc
source ~/.bashrc



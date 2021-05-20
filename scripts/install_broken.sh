#!/bin/bash
# Install project dependencies
echo " - Python dependencies"
pip3 install catkin_pkg rospkg av image opencv-python djitellopy2 pyyaml

apt install python3-tf*

echo " - CPP dependencies"
apt install ros-foxy-ament-cmake* ros-foxy-tf2* ros-foxy-rclcpp* ros-foxy-rosgraph*

echo " - Rviz and RQT Tools"
apt install ros-foxy-rviz* ros-foxy-rqt*

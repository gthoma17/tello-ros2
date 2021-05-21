#!/bin/bash
set -e

permissionsCheck () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	# Ensures user is either root, or we're running inside Docker
	if [ $EUID > 0 ] && ! [ -f /.dockerenv ]; then
		echo " - Please run as root"
		exit
	fi
}

installCppBuildTools () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	apt update
	apt install -y build-essential gdb
}

setLocales () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	apt update
	apt install -y locales locales-all # need all, otherwise the container errors `update-locale: Error: invalid locale settings:  LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8`
	locale-gen en_US en_US.UTF-8
	update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
	export LANG=en_US.UTF-8
}

addROS2SourcesToApt () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	apt update
	apt install -y curl gnupg2 lsb-release
	curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
	sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
}

installROS2Foxy () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	apt update
	apt install -y ros-foxy-desktop
}

setupEnvironment () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	source /opt/ros/foxy/setup.bash
}

installPythonBuildTools () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	apt install -y python3-pip python3-colcon-common-extensions python3-rosdep2
	pip3 install -U argcomplete
}

setupRosdep () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	rosdep init
	rosdep update
	rosdep fix-permissions
}

addToBashrc () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
	echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc
	echo "export _colcon_cd_root=~/ros2_install" >> ~/.bashrc
	source ~/.bashrc
}

installProjectDeps () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	pip3 install catkin_pkg rospkg av image opencv-python djitellopy2 pyyaml
	apt install python3-tf*

	echo " - CPP dependencies"
	apt install ros-foxy-ament-cmake* ros-foxy-tf2* ros-foxy-rclcpp* ros-foxy-rosgraph*

	echo " - Rviz and RQT Tools"
	apt install ros-foxy-rviz* ros-foxy-rqt*
}

main () {
	echo "***************************"
	echo " Entering $FUNCNAME "
	echo "***************************"
	permissionsCheck
	installCppBuildTools
	setLocales
	addROS2SourcesToApt
	installROS2Foxy
	setupEnvironment
	installPythonBuildTools
	setupRosdep
	addToBashrc
	installProjectDeps
}

main

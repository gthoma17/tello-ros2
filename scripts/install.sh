#!/bin/bash
set -xe

permissionsCheck () {
	if (( $EUID > 0 )); then
		echo " - Please run as root"
		exit
	fi
}

installCppBuildTools () {
	apt install build-essential gdb
}

setLocales () {
	apt update
	apt install -y locales
	locale-gen en_US en_US.UTF-8
	update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
	export LANG=en_US.UTF-8
}

addROS2SourcesToApt () {
	apt update
	apt install -y curl gnupg2 lsb-release
	curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
	sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
}

installROS2Foxy () {
	apt update
	apt install -y ros-foxy-desktop
}

setupEnvironment () {
	source /opt/ros/foxy/setup.bash
}

installPythonBuildTools () {
	apt install -y python3-pip python3-colcon-common-extensions python3-rosdep2
	pip3 install -U argcomplete
}

setupRosdep () {
	rosdep init
	rosdep update
	rosdep fix-permissions
}

addToBashrc () {
	echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
	echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc
	echo "export _colcon_cd_root=~/ros2_install" >> ~/.bashrc
	source ~/.bashrc
}

installProjectDeps () {
	pip3 install catkin_pkg rospkg av image opencv-python djitellopy2 pyyaml
	apt install python3-tf*

	echo " - CPP dependencies"
	apt install ros-foxy-ament-cmake* ros-foxy-tf2* ros-foxy-rclcpp* ros-foxy-rosgraph*

	echo " - Rviz and RQT Tools"
	apt install ros-foxy-rviz* ros-foxy-rqt*
}

main () {
	permissionsCheck
	installCppBuildTools
	setLocales
	addROS2Sources
	installROS2Foxy
	setupEnvironment
	installPythonBuildTools
	setupRosdep
	addToBashrc
	installProjectDeps
}

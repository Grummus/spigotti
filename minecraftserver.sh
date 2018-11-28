#!/bin/bash

# server variables
serverdir="/path/to/server" # <------CHANGE THIS
startscript="start.sh"
updatescript="update.sh"

echo "Grummus's Minecraft server launcher v1.0"
echo "	Badly scripted by Graham Klatt 2018"
echo

# Test to see if Screen is installed
echo "Checking dependencies..."
if ! [ -x "$(command -v screen)" ]; then
	echo -e "\e[91mScreen is not installed!\e[0m"
	read -p "Install it? [y/n] " screenyn
	if [ $screenyn == 'y' ]; then
		sudo apt install screen -y
	else
		exit 1
	fi
fi

# check for any active screens
# if none are found, create a new one and run the start script
# otherwise prompt to reattatch to currently open screen
echo "Checking for any running servers..."
if screen -list | grep 'No Sockets found'; then
	cd $serverdir
	echo "You're good to go!"
	# ask to update
	read -p "Update server JAR? [y/n] " updateyn
	if [ $updateyn == "y" ]; then
		./$updatescript
	fi
	screen -L -S "minecraft" ./$startscript
else
	screen -list
	echo
	read -p "Press [Enter] to reattatch or [CTRL+C] to cancel!"
	screen -D -r
fi


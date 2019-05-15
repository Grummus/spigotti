#!/bin/bash

# server variables
serverdir="<serverpath>" # <------CHANGE THIS
updatescript="update.sh"

echo "Grummus's Minecraft server launcher 2.0"
echo "	Cobbled together by Graham Klatt 2019"
echo

if [ ! -d "$serverdir" ]; then
	echo "'$serverdir' does not exist! Did you remember change it in the launch script?"
	read -p "Press [Enter] to close..."
	exit 1
fi

# Test to see if tmux is installed
echo "Checking dependencies..."
if ! [ -x "$(command -v tmux)" ]; then
	echo -e "\e[91mtmux is not installed!\e[0m"
	exit 1
fi

# check for any active sessions 
# if none are found, create a new one and run the start script
# otherwise prompt to reattatch to currently open screen
echo "Checking for any running servers..."
if ! tmux ls | grep 'minecraft'; then
	cd $serverdir
	echo "You're good to go!"
	read -p "Press [Enter] to continue..."
	./launch.sh
else
	echo
	read -p "Press [Enter] to reattatch or [CTRL+C] to cancel!"
	tmux attach -t minecraft
fi


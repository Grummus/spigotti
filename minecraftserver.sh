#!/bin/bash

# server variables
serverdir="<serverpath>" # <------CHANGE THIS
updatescript="update.sh"

# uncomment for borders fix with PuTTY
export NCURSES_NO_UTF8_ACS=1

#if [ ! -d "$serverdir" ]; then
#	echo "'$serverdir' does not exist! Did you remember change it in the launch script?"
#	read -p "Press [Enter] to close..."
#	exit 1
#fi

dialog --backtitle "Graham's Crappy Server Launcher"

# Test to see if tmux is installed
if ! [ -x "$(command -v tmux)" ]; then
	dialog --title "ERROR!" --msgbox "tmux is not installed!" 5 20
	exit 1
fi

dialog --keep-window --title "Update?" \
	--yesno "Update Server Jar?" 7 60

response=$?
case $response in
	0) ./update.sh;;
	1) echo "Skipping Update...";;
	255) echo "wat";;
esac

# check for any active sessions 
# if none are found, create a new one and run the start script
# otherwise prompt to reattatch to currently open screen

if ! tmux ls | grep 'minecraft'; then
	cd $serverdir
	dialog --title "Checking for running servers..." --msgbox "You're good to go!" 5 40
	clear
	./launch.sh
else
	dialog --title "Checking for running servers..." --msgbox "Welcome Back!" 5 40
	clear
	tmux attach -t minecraft
fi


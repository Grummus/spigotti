#!/bin/bash

# server variables
serverdir="<serverpath>" # <------CHANGE THIS
updatescript="update.sh"
backtitle="Graham's Crappy Server Launcher"


# check for any active sessions 
# if none are found, create a new one and run the start script
# otherwise prompt to reattatch to currently open screen
function check() {
if ! tmux ls | grep 'minecraft'; then
	serverstatus="Inactive"
else
	serverstatus="Active"
fi
}

function launch() {
	case $serverstatus in
		Inactive) clear && ./launch.sh;;
		Active) clear && tmux attach -t minecraft;;
	esac
	exit
}

cd $serverdir
check

# uncomment for borders fix with PuTTY
export NCURSES_NO_UTF8_ACS=1

#if [ ! -d "$serverdir" ]; then
#	echo "'$serverdir' does not exist! Did you remember change it in the launch script?"
#	read -p "Press [Enter] to close..."
#	exit 1
#fi

# Test to see if tmux is installed
if ! [ -x "$(command -v tmux)" ]; then
	dialog --title "ERROR!" --msgbox "tmux is not installed!" 5 20
	exit 1
fi

#dialog --keep-window --title "Update?" \
#	--yesno "Update Server Jar?" 7 60
dialog --backtitle "$backtitle" --title "Home" \
--menu "Welcome!\nServer is currently $serverstatus" 15 50 4 \
1 "Start/Reconnect" \
2 "Update Server" \
3 "Exit" 2>option.temp

response="$(cat option.temp)"
case $response in
	1) launch;; 
	2) ./update.sh && check;;
	3) exit;;
	255) exit;;
esac



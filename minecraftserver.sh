#!/bin/bash

# server variables
serverdir="<serverpath>" # <------CHANGE THIS
backtitle="Graham's Crappy Server Launcher"

#here for testing
servertype="spigot"
mcver="1.13.2"
maxram="2G"
minram="1G"


INPUT=/tmp/menu.sh.$$

OUTPUT=/tmp/output.sh.$$

export $serverdir

trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

function update() {
	if ! tmux ls | grep 'minecraft'; then
	dialog --backtitle "$backtitle" --title "$title" \
	--menu "Select A Server Type:" 15 50 4 \
	spigot "(Recommended)" \
	craftbukkit "" \
	vanilla "Plain and Simple" \
	quit "Ack! Get me out of here!" 2>servertype.temp
	if [ "$?" = "0" ]; then
		servertype="$(cat servertype.temp)"
		if [ "$servertype" = "quit" ];then
			clear
			exit 1
		fi
	fi
	dialog --backtitle "$backtitle" --title "$title" \
	--inputbox "Enter Server Version" 8 60 2>mcver.temp
	mcver="$(cat mcver.temp)"

	if [ ! -d "buildtools" ]; then
		echo "Creating 'buildtools' directory..."
		mkdir buildtools
	fi
	read -p "BUILDING $servertype VERSION $mcver"
	cd buildtools
	echo Downloading latest BuildTools...
	wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
	echo Beginning Build Process...
	java -jar BuildTools.jar --rev $mcver
	echo Copying server JAR...
	cp "$servertype-$mcver.jar" "../"
	export servertype=$servertype
	export mcver=$mcver
	cd ..
	echo
	echo "Done!"
	read -p "Press [Enter] to Continue..."
	if [ ! -f "$serverdir/$servertype-$mcver.jar" ]; then
		clear
		exit 255
	else
		exit 0
	fi
else
	dialog --backtitle "$backtitle" --title "WARNING!" --msgbox "Please shut your server off\nbefore updating!" 8 50
	exit 255
fi

}
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
		Inactive) clear && initialize;;
		Active) clear && tmux attach -t minecraft;;
	esac
}

function start() {
	

	# Display Minecraft and Java version then pause
	echo -e "$servertype version $mcver with maximum $maxram and minimum $minram of RAM"
	java -version
	echo
	echo -e "\e[93m[Ctrl+A] \e[96mthen \e[93m[D] \e[96mto detach"
	echo -e "type \e[93m'minecraftserver' \e[96mto reattatch\e[0m"
	echo
	read -p "Press [Enter] to start the server with the current settings..."

	# Start the Server with minram and maxram values
	java -Xmx$maxram -Xms$minram -jar $servertype-$mcver.jar
	echo -e "\e[91mServer stopped!\e[0m"
	read -p "Press [Enter] to close this window..."
	echo "bye bye!"
	sleep 1
	tmux kill-session -t minecraft
}

function initialize() {
	tmux new-session -s minecraft -d 'minecraftserver forcestart'
	tmux split-window -h './term.sh'
	tmux split-window -v './info.sh'
	tmux select-pane -L 
	tmux attach -t minecraft
}

# BEGINNING OF SCRIPT----------------------------------------------------------------------
cd $serverdir
check

# uncomment for borders fix with PuTTY
export NCURSES_NO_UTF8_ACS=1

[ $1 = update ] && update
[ $1 = forcestart ] && start
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
3 "Exit" 2>"${INPUT}"

response=$(<"${INPUT}")
case $response in
	1) launch;; 
	2) update && check;;
esac

[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
clear

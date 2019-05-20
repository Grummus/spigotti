#!/bin/bash

#UNCOMMENT FOR PUTTY FIX
export NCURSES_NO_UTF8_ACS=1

backtitle="Graham's Crappy Server Launcher"
title="Server Updater"
function quit() {
	clear
	exit
}

function update() {
		#read -p "Server version: " mcver
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
}

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

	update
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


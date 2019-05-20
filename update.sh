#!/bin/bash

backtitle="Graham's Crappy Server Launcher"
title="Server Updater"
function quit() {
	clear
	exit
}

function update() {
	#read -p "Server version: " mcver
	#if [ ! -d "buildtools" ]; then
	#	echo "Creating 'buildtools' directory..."
	#	mkdir buildtools
	#fi

	cd buildtools
	echo Downloading latest BuildTools...
	wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
	echo Beginning Build Process...
	java -jar BuildTools.jar --rev $mcver
	echo Copying server JAR...
	cp $servertype-$mcver.jar ../$servertype-$mcver.jar
	export servertype=$servertype
	export mcver=$mcver
	echo
	echo "Done!"
	read -p "Press [Enter] to Continue..."
	exit
}

dialog --backtitle "$backtitle" --title "$title" \
--menu "Select A Server Type:" 15 50 4 \
Spigot "(Recommended)" \
Craftbukkit "" \
Vanilla "Plain and Simple" \
Exit "Ack! Get me out of here!" 2>temp
if [ "$?" = "0" ]; then
	_return=$(cat temp)
	case $_return in
		1) servertype=spigot;;
		2) servertype=craftbukkit;;
		3) servertype=vanilla;;
		4) quit;;
	esac
fi

dialog --backtitle "$backtitle" --title "$title" \
--inputbox "Enter Server Version" 8 60 2>temp
mcver=$(cat temp)

update
quit

#echo
#read -p "Server type (can be 'spigot' or 'craftbukkit'): " servertype


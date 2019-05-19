#!/bin/bash

backtitle = "Graham's Crappy Server Launcher"
title = "Server Updater"

dialog --backtitle $backtitle --title $title \
--menu "Select A Server Type:" 15 50 4 \
Spigot \
Craftbukkit \
Vanilla \
Exit 2>
#echo
#read -p "Server type (can be 'spigot' or 'craftbukkit'): " servertype
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

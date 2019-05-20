#!/bin/bash

export NCURSES_NO_UTF8_ACS=1 

backtitle="Graham's Crappy Server Launcher"
title="Installer"

#read -p "Enter desired install location: (eg. /home/user/server) " serverpath
dialog --backtitle "$backtitle" --title "$title" \
--inputbox "Enter Desired install location" 8 60 2>location.temp

if [ "$?" = "0" ]; then
	serverpath=$(cat location.temp)
else
	exit 1
fi


if [ ! -d "$serverpath" ]; then
  echo "Making serverdir..."
  mkdir $serverpath
fi

#read -p "Enter desired server name: " servername
dialog --backtitle "$backtitle" --title "$title" \
--inputbox "Enter Desired server name:" 8 60 2>servername.temp

if [ "$?" = "0" ]; then
	servername=$(cat servername.temp)
else
	exit 1
fi


#echo "Copying files..."
sudo cp minecraftserver.sh /usr/bin/minecraftserver
sudo sed -i 's@<serverpath>@'"$serverpath"'@' /usr/bin/minecraftserver
sudo chmod +x /usr/bin/minecraftserver
cp update.sh $serverpath/update.sh
cp start.sh $serverpath/start.sh
chmod +x $serverpath/update.sh
chmod +x $serverpath/start.sh

cp launch.sh $serverpath/launch.sh
chmod +x $serverpath/launch.sh
cp term.sh $serverpath/term.sh
chmod +x $serverpath/term.sh
sed -i 's@<servername>@'"$servername"'@' $serverpath/term.sh

cp package.json $serverpath/package.json
cp info.js $serverpath/info.js
cp info.sh $serverpath/info.sh

cd $serverpath
npm install
./update.sh
if [ "$?" = "0" ]; then
	dialog --backtitle "$backtitle" --title "Success!" \
	--msgbox "Everything built successfully!" 8 40
	clear
	exit 0
else
	dialog --backtitle "$backtitle" --title "!!!ERROR!!!" \
	--msgbox "A build error occured!\nInstallation Incomplete" 8 40
	clear
	exit 255
fi

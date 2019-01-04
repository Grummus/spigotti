#!/bin/bash

read -p "Enter desired install location: (eg. /home/user/server) " serverpath
if [ ! -d "$serverpath" ]; then
  echo "Making serverdir..."
  mkdir $serverpath
fi
echo "!!!Change the serverdir variable on the following screen!!!"
read -p "Press [Enter]..."
nano minecraftserver.sh
echo "Copying files..."
sudo cp minecraftserver.sh /usr/bin/minecraftserver
sudo chmod +x /usr/bin/minecraftserver
cp update.sh $serverpath/update.sh
cp start.sh $serverpath/start.sh
chmod +x $serverpath/update.sh
chmod +x $serverpath/start.sh
cp .screenrc $serverpath/.screenrc
cd $serverpath
./update.sh
echo "Install Complete!"

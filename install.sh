#!/bin/bash

read -p "Enter desired install location: (eg. /home/user/server) " serverpath
if [ ! -d "$serverpath" ]; then
  mkdir $serverpath
fi
cp minecraftserver.sh ~/minecraftserver.sh
chmod +x ~/minecraftserver.sh
cp update.sh $serverpath/update.sh
cp start.sh $serverpath/start.sh
chmod +x $serverpath/update.sh
chmod +x $serverpath/start.sh
cd $serverpath
./update.sh
echo "Install Complete!"
echo "!!!Change the serverdir variable on the following screen!!!"
read -p "Press [Enter]..."
nano ~/minecraftserver.sh

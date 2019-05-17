#!/bin/bash

read -p "Enter desired install location: (eg. /home/user/server) " serverpath
if [ ! -d "$serverpath" ]; then
  echo "Making serverdir..."
  mkdir $serverpath
fi

read -p "Enter desired server name" servername

echo "Copying files..."
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
echo "Install Complete!"

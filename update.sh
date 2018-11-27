#!/bin/bash

echo Server Updater
echo
read -p "Server type (can be 'spigot' or 'craftbukkit'): " servertype
read -p "Server version: " mcver
cd buildtools
echo Beginning Build Process...
java -jar BuildTools.jar --rev $mcver
echo Copying server JAR...
cp $servertype-$mcver.jar ../$servertype-$mcver.jar
echo
echo "Done!"
read -p "Press [Enter] to Continue..."
exit

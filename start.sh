#!/bin/bash

# Server Variables
# servertype can be "spigot" "minecraft-server" or "craftbukkit"
servertype="spigot"
mcver="1.13.2"
maxram="2G"
minram="1G"

# Display Minecraft and Java version then pause
echo -e "$servertype version $mcver with maximum $maxram and minimum $minram of RAM"
java -version
echo
echo -e "\e[93m[Ctrl+A] \e[96mthen \e[93m[D] \e[96mto detach"
echo -e "type \e[93m'galacticraft' \e[96mto reattatch\e[0m"
echo
read -p "Press [Enter] to start the server with the current settings..."

# Start the Server with minram and maxram values
java -Xmx$maxram -Xms$minram -jar $servertype-$mcver.jar
echo -e "\e[91mServer stopped!\e[0m"
read -p "Press [Enter] to close this window..."
echo "bye bye!"
sleep 1
tmux kill-session -t minecraft

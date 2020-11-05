#!/bin/bash

# server variables
serverdir="<serverpath>" # <------CHANGE THIS
backtitle="Graham's Crappy Server Launcher"
CONFIG="$serverdir/config"

source "$CONFIG"

#here for testing
#servertype="spigot"
#mcver="1.13.2"
maxram="2G"
minram="1G"


INPUT=/tmp/menu.sh.$$

OUTPUT=/tmp/output.sh.$$

trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

cd $serverdir

# uncomment for borders fix with PuTTY
export NCURSES_NO_UTF8_ACS=1

function whitelist() {
	title="Whitelist"
	CHOICE=$(dialog --backtitle "$backtitle" --title "$title" \
	--menu "What would you like to do?" 15 50 3 \
	1 "View players" \
	2 "Add player" \
	3 "Remove player" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		1) 
			names=$(cat whitelist.json | jq .[].name)
			listlength=$(echo "$names" | wc -l)
			if [ ! $listlength = 0 ]; then
				((listlength+=5))
				dialog --backtitle "$backtitle" --title "$title" \
					--msgbox "$names" $listlength 40
			fi
			whitelist
			;;
		2) 
			dialog --backtitle "$backtitle" --title "$title" \
			--inputbox "Enter player name:" 8 30 2>"${INPUT}"
			clear
			playername=$(<"${INPUT}")
			id=$(GET https://api.mojang.com/users/profiles/minecraft/$playername)
			names=$(cat whitelist.json | jq .[].name)
			listlength=$(echo "$names" | wc -l)
			jq ".[$listlength] |= .+$id" whitelist.json | tee whitelist.json
			sed -i 's/"id"/"uuid"/g' whitelist.json
			read -p "Holding..."
			dialog --backtitle "$backtitle" --title "$title" \
				--msgbox "Added $id to whitelist" 8 40
			exit

			;;
		3) echo whoa there;;
	esac	
}

function update() {
	title="Server Updater"
	if ! tmux ls | grep 'minecraft'; then
		dialog --backtitle "$backtitle" --title "$title" \
		--menu "Select A Server Type:" 15 50 5 \
		paper "(Recommended, fastest install)" \
		spigot "" \
		craftbukkit "" \
		quit "Ack! Get me out of here!" 2>"${INPUT}"
		if [ "$?" = "0" ]; then
			servertype=$(<"${INPUT}")
			if [ "$servertype" = "quit" ];then
				quit
			fi
		else
			exit 1
		fi

		dialog --backtitle "$backtitle" --title "$title" \
		--inputbox "Enter Server Version" 8 30 2>"${INPUT}"
		mcver=$(<"${INPUT}")
		[ ! "$?" = 0 ] && exit 1
		clear

		if [ "$servertype" = "paper" ]; then
			echo "DOWNLOADING $servertype VERSION $mcver"
			wget https://papermc.io/api/v1/paper/1.16.4/latest/download -O "$servertype-$mcver.jar"
			echo "Done!"
		else
			if [ ! -d "buildtools" ]; then
				echo "Creating 'buildtools' directory..."
				mkdir buildtools
			fi
			echo "BUILDING $servertype VERSION $mcver"
			cd buildtools
			echo Downloading latest BuildTools...
			wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
			echo Beginning Build Process...
			java -jar BuildTools.jar --rev $mcver
			echo Copying server JAR...
			cp "$servertype-$mcver.jar" "../"
			cd ..
			echo
			echo "Done!"
		fi

		
		echo "Writing Config File..."
		echo "servertype=$servertype" >> config
		echo "mcver=$mcver" >> config
		read -p "Press [Enter] to Continue..."
		if [ -f "$serverdir/$servertype-$mcver.jar" ]; then
			dialog --backtitle "$backtitle" --title "Success!" \
			--msgbox "Everything built successfully!" 8 40
			quit
		else
			dialog --backtitle "$backtitle" --title "!!!ERROR!!!" \
			--msgbox "A build error occured!\nInstallation Incomplete" 8 40
			exit 1
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

function info() {
	while true
	do node info.js | cowsay | lolcat -F 1
	sleep 10
	clear
	done
	exit 1
}

function start() {
	while true
	do
		# Display Minecraft and Java version then pause
		echo -e "$servertype version $mcver with maximum $maxram and minimum $minram of RAM"
		java -version
		echo
		echo -e "\e[93m[Ctrl+A] \e[96mthen \e[93m[D] \e[96mto detach"
		echo -e "type \e[93m'minecraftserver' \e[96mto reattatch\e[0m"
		echo
	#	read -p "Press [Enter] to start the server with the current settings..."
	
		# Start the Server with minram and maxram values
		java -Xmx$maxram -Xms$minram -jar $servertype-$mcver.jar
		#read -p "server up!" yeetus
		echo -e "\e[91mServer stopped!\e[0m"
		source "$serverdir/restart"
		if [[ $RESTART = "1" ]]; then

			rm $serverdir/restart
			RESTART=0
			echo "Press 'Q' to cancel restart"
			echo "Restarting in..."
			for i in 5 4 3 2 1
			do
				echo "$i..."
				
				read -t 1 -N 1 input
				if [[ $input = "q" ]] || [[ $input = "Q" ]]; then
					# The following line is for the prompt to appear on a new line.
			        	echo
				#	read -p "Press [Enter] to close this window..."
					echo "bye bye!"
					sleep 1
					tmux kill-session -t minecraft
					exit
	
				fi
			done
			echo "Rebooting now!"
		else	
			echo "Bye bye!"
			sleep 1
			tmux kill-session -t minecraft
		fi
	done
	

}

function initialize() {
	tmux new-session -s minecraft -d 'minecraftserver forcestart'
	#tmux split-window -h 'minecraftserver term'
	tmux split-window -h 'gtop'
	tmux split-window -v 'minecraftserver info'
	tmux select-pane -L 
	tmux attach -t minecraft
}

function term() {
	servername="<servername>"

	figlet $servername | lolcat
	bash
}

function quit() {
	[ -f $OUTPUT ] && rm $OUTPUT
	[ -f $INPUT ] && rm $INPUT
	clear
	exit 0
}

# BEGINNING OF SCRIPT----------------------------------------------------------------------
check
# check for command arguments
[ $1 = update ] && update
[ $1 = forcestart ] && start
[ $1 = info ] && info
[ $1 = term ] && term
[ $1 = whitelist ] && whitelist
[ $1 = init ] && initialize

# Test to see if tmux is installed
if ! [ -x "$(command -v tmux)" ]; then
	dialog --title "ERROR!" --msgbox "tmux is not installed!" 5 20
	exit 1
fi

serverinfo="$(node info.js)"
dialog --backtitle "$backtitle" --title "Home" \
--menu "Welcome!\n$serverinfo" 15 50 4 \
1 "Start/Reconnect" \
2 "Update Server" \
3 "Exit" 2>"${INPUT}"

response=$(<"${INPUT}")
case $response in
	1) launch;; 
	2) update && check;;
esac

quit

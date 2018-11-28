# Graham's Crappy Minecraft Server Launcher
Grummus's Crappy Server Launcher

A little something I made so I can SSH into my Minecraft Server  
Uses GNU Screen  

Features:  
-Streamlines the Spigot update process  
-Makes it easy to change allocated memory  
-Allows you to SSH into your server console without stopping it  

To use:  
-Change the 'serverdir' variable in minecraftserver.sh to where you want your minecraft server to be  
-Place update.sh and start.sh in your serverdir. (I might try and automate this who knows ¯\_(ツ)_/¯)  
-Run 'chmod +x (scriptname)' on all the scripts  
-Run ./update.sh  

When you SSH onto your server just run ./minecraftserver.sh and it'll do the rest ;)  

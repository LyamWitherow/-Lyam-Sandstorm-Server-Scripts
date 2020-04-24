#!/bin/bash

VERSION=0.1

echo "	IF THIS SCRIPT DOES NOT EXECUTE OR AUTOTAB-COMPLETE, YOU MUST RUN "chmod 755 UpdateWineInsurgencyServer" BEFORE IT WILL WORK
	
	TO RUN THE SCRIPT JUST TYPE "./UpdateWineInsurgencyServer.sh" INTO A TERMINAL
	
	Report any issues with the script to Lyam#2712 from the Discord Modding Server: https://discord.gg/AyKfUEN"
	
sleep 2
	
echo "
	Running UpdateWineInsurgencyServer Version 0.1
	
	"

sleep 1

#Checks for root. If this fails, count yourself lucky for not being allowed to execute some random script from the internet with root.
if [ "$EUID" -eq 0 ]
  then echo "
	Don't run this script as root!"
  sleep 2
  exit
fi

##	IF YOU WANT A DIFFERENT VERSION OF WINE, CHANGE winename BEFORE RUNNING

#	Sets script variables
winename="wine"
winedir="$HOME/.wine/drive_c"
steamcmddir="$winedir/steamcmd"
steamcmd="$steamcmddir/steamcmd.exe"
sandstormdir="$steamcmddir/steamapps/common/sandstorm_server/Insurgency"
serverconfigdir="$sandstormdir/Saved/Config/WindowsServer"
servercustomconfigdir="$sandstormdir/Config/Server"
serverexe="$sandstormdir/Binaries/Win64/InsurgencyServer-Win64-Shipping.exe"

#	Installs dependencies
read -s aptpass
echo "$aptpass" | sudo apt-get update
sudo apt-get install $winename p7zip curl winetricks --install-recommends -y
echo "
Apt install finished"
echo "
Opening TCP/UDP Ports..."
sudo iptables -A INPUT -p udp --dport 27102 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 27102 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 27103 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 27103 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 27131 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 27131 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 27015 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 27015 -j ACCEPT
echo "Opened ports 27102, 27103, 27131, 27015
"
sleep 1
echo "Autogenerating wine directory
"
winecfg

echo "
Checking for wine directory..."

#	Checks to make sure that the default install was actually drive_c    
if [[ -d "$winedir" ]]
then
    echo "
    $winedir exists on your filesystem, proceeding."
    else
		echo "
		Error: Wine install directory not found, exiting."
		exit 0
fi

echo "Checking for steamcmd directory..."

#	Checks if steamcmd dir has already been made
if [[ -d "$steamcmddir" ]]
then
    echo "
    $steamcmddir exists on your filesystem, proceeding."
    else
		echo "
		Error: Missing $steamcmddir directory, creating folder."
			mkdir $steamcmddir
fi

echo "Checking for steamcmd.exe"

#	Checks if steamcmd.exe exists. If not, it grabs it from the internet.
if [[ -f "$steamcmd" ]]
then
    echo "
    $steamcmd exists on your filesystem."
    else
		echo "
	Error: Missing steamcmd, installing.
"
			
			curl -SL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" --output "$steamcmddir/steamcmd.zip"
			7z x "$steamcmddir/steamcmd.zip" -o"$steamcmddir"
		echo "
	steamcmd.exe (windows version) installed
	"
	sleep 1
fi


#	Runs steamcmd, updates/installs Insurgency Sandstorm Dedicated Server (Windows), checks the install, and then exits.
$winename $steamcmd +login anonymous +app_update 581330 validate +quit

#	Checks if config dir has already been made
if [[ -d "$serverconfigdir" ]]
then
    echo "
    $serverconfigdir exists on your filesystem, proceeding."
    else
		echo "
		Error: Missing $serverconfigdir directory, creating folder."
			mkdir "$sandstormdir/Saved"
			mkdir "$sandstormdir/Saved/Config"
			mkdir "$sandstormdir/Saved/Config/WindowsServer"
curl -SL https://raw.githubusercontent.com/Lyamc/-Lyam-Sandstorm-Server-Scripts/master/Engine.ini --output "$serverconfigdir/Engine.ini"
curl -SL https://raw.githubusercontent.com/Lyamc/-Lyam-Sandstorm-Server-Scripts/master/Game.ini --output "$serverconfigdir/Game.ini"

head -n -4 "$serverconfigdir/Engine.ini"

echo "
To use mods, you must have a mod.io API key. 

Your mod.io can be found by creating an account and logging into mod.io, then navitaging to User Profile [top-right], and API access [left-side].
"

read -p "Enter mod.io API key here: " modioapi
echo "[/Script/ModKit.ModIOClient]
bHasUserAcceptedTerms=True
bCachedUserDetails=True
AccessToken=$modioapi" >> $serverconfigdir/Engine.ini

fi

#	Checks if customconfig dir has already been made
if [[ -d "$servercustomconfigdir" ]]
then
    echo "
    $servercustomconfigdir exists on your filesystem, proceeding."
    else
		echo "
		Error: Missing $servercustomconfigdir directory, creating folder."
			mkdir "$sandstormdir/Config"
			mkdir "$sandstormdir/Config/Server"
			echo "
	In order to have Admin rights on your server, you must have your 64-bit Steam ID
	Your Steam 64-bit ID can be obtained for here: https://steamid.io/ or your user profile address. It should only consist of numbers.
"
read -p "Enter your 64-bit Steam ID here: " steamid
echo "$steamid" >> "$servercustomconfigdir/Admins.txt"
echo "
Creating default MapCycle
"
echo "Farmhouse?Scenario=Scenario_Farmhouse_Checkpoint_Security" >> "$servercustomconfigdir/MapCycle.txt"
echo "
Any mods you want to use will have to be added manually. This script just makes the process easier by creating the file.
Uncomment (delete the ;) in order for the server to use the mod.
The server will check the mod and download the latest version every time you start it.
"
echo ";Example Mod: JumpShoot
;98685" >> "$servercustomconfigdir/Mods.txt"
sleep 2
fi

#	Checks if Admins.ini, Game.ini, Engine.ini, Mods.ini, exists. If not, creates it.
if [[ -f "$HOME/StartWineInsurgencyServer.sh" ]]
then
    echo "
    Startup script exists.
    "
    else
		echo "
	Auto-generating Server Startup Script
"


echo "#!/bin/bash" >> "$HOME/StartWineInsurgencyServer.sh"
echo "randnum=$RANDOM" >> "$HOME/StartWineInsurgencyServer.sh"
#~
#~
#~winename="wine"
#~winedir="$HOME/.wine/drive_c"
#~steamcmddir="$winedir/steamcmd"
#~steamcmd="$steamcmddir/steamcmd.exe"
#~sandstormdir="$steamcmddir/steamapps/common/sandstorm_server/Insurgency"
#~serverconfigdir="$sandstormdir/Saved/Config/WindowsServer"
#~servercustomconfigdir="$sandstormdir/Config/Server"
#~serverexe="$sandstormdir/Binaries/Win64/InsurgencyServer-Win64-Shipping.exe"
#~
#~declare -a maplist 
#~readarray maplist < $servercustomconfigdir/MapCycle.txt 
#~count=0
#~for i in "${maplist[@]}" 
#~do
#~   echo $count: $i
#~   (( ++count ))
#~done
#~
#~read -p "Choose Map: " mapchoice
#~
#~wine \
#~$serverexe \
#~${maplist[0]}  \
#~-mutators=none \
#~-Mods \
#~-Port=27102 \
#~-QueryPort=27131 \
#~-hostname="Linux Wine Server $randnum" \
#~-MapCycle=MapCycle \
#~-NoEAC \
#~-Rcon \
#~-RconPassword=rconpassword \
#~-RconListenPort=27015 \
#~-AdminList=Admins \
#~-EnableCheats \
#~ModDownloadTravelTo=${maplist[$mapchoice]}

cat "$0" | awk '$1 ~ /#~/' | sed 's/#~//g' - >> "$HOME/StartWineInsurgencyServer.sh"
chmod 755 $HOME/StartWineInsurgencyServer.sh
	sleep 1
fi


echo "
Done. Report any issues with the script to Lyam#2712 from the Discord Modding Server: https://discord.gg/AyKfUEN

Run the server by opening a terminal (CTRL + ALT + T) and typing ./StartWineInsurgencyServer.sh (Pressing TAB will autocomplete commands)
"

sleep 2

exit

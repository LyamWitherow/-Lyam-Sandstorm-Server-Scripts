#!/bin/bash

declare -a maplist 
readarray maplist < ~/.steam/SteamApps/common/sandstorm_server/Insurgency/Config/Server/MapCycle.txt 
count=0
for i in "${maplist[@]}"
do
   echo $count: $i
   (( ++count ))
done

sleep 2



~/.steam/SteamApps/common/sandstorm_server/Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping \
Crossing?Scenario=Scenario_Crossing_Checkpoint  \
-mutators=none \
-Mods \
-Port=27102 \
-QueryPort=27131 \
-hostname="LINUX SERVER $RANDOM" \
-MapCycle=MapCycle.txt \
-NoEAC \
-Rcon \
-RconPassword=password \
-RconListenPort=27015 \
-AdminList=Admins \
-EnableCheats \
ModDownloadTravelTo=Crossing?Scenario=Scenario_Crossing_Team_Deathmatch

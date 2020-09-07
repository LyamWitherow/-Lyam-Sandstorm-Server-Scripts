# [Lyam] Sandstorm Server Scripts

Right now, custom maps have issues with the Linux Servers. However, everything works great when using the Windows version in Linux via WINE, so I've created a script that'll get you up and running. (Assuming you're running Ubuntu)

## Step 1: Paste this into the terminal:

`curl https://raw.githubusercontent.com/Lyamc/-Lyam-Sandstorm-Server-Scripts/master/UpdateWineInsurgencyServer.sh --output UpdateWineInsurgencyServer.sh; chmod 755 UpdateWineInsurgencyServer.sh; ./UpdateWineInsurgencyServer.sh`

**What this script does:**

1) Make sure you're not using sudo
2) Install/update wine and other dependencies via apt
3) Download/unzip steamcmd.zip
4) Download/update/install the Windows version of the Sandstorm server via steamcmd
5) Checks for config folders, and if they don't exist, the script creates the folders and auto-generates Game.ini, Engine.ini, Mods.txt, MapCycle.txt, Admins.txt, and a startup script to make launching easier.

## Step 2: Type this into your terminal

`~/StartWineInsurgencyServer.sh`

And you should see a server called "Linux Wine Server" appear in the server browser. To change the name, just edit the StartWineInsurgencyServer.sh

To add more maps, just add the maps to the MapCycle.txt and when you launch the server, it will ask you which map to run.

To add mods, add the mod id to Mods.txt, the Map and Scenario name into MapCycle.txt, and/or the Mutator name into StartWineInsurgencyServer.sh

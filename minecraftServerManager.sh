#!/bin/bash
#Minecraft Server Manager

set -e
#Function to run on script exit.
function cleanup {
    #Clear screen.
    clear
    #Reset permissions.
    chmod 430 $(tty)
    #Remove temp file.
    rm -f $TEMPFILE
    #Display message to user.
    echo "Closing Minecraft Server Manager..."
}
#Set function to run before script exit.
trap cleanup EXIT

MODULESAVAILABLE=0
CONFIGAVAILABLE=0

#Get current working directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Load Config
source "$DIR/mcm.config"

#Check if config was loaded.
if [ $CONFIGAVAILABLE == 0 ]; then
#No config loaded.
    #Set and build error dialog.
    dialog --backtitle "Minecraft Server Console" \
    --colors \
    --title "\Zb\Z1*** ERROR ***" \
    --msgbox "\n\Zb\Z1CONFIG COULD NOT BE LOADED!\n\nMAKE SURE THE CONFIG '$DIR/mcm.config' EXISTS!" 10 40
    exit;
else
    #Loaded, continue.
    echo "Loaded Config"
fi

#Fetch modules
MODULES=($DIR/modules/*)

#Iterate through array of modules
for ((i=0; i<${#MODULES[@]}; i++)); do
#Load module
    source "${MODULES[$i]}"
done

#Check at least one module was loaded.
if [ $MODULESAVAILABLE == 0 ]; then
    #No modules loaded.
    #Set and build error dialog.
    dialog --backtitle "Minecraft Server Console - $NETWORKNAME" \
    --colors \
    --title "\Zb\Z1*** ERROR ***" \
    --msgbox "\n\Zb\Z1NO MODULES HAVE BEEN LOADED!\n\nMAKE SURE THERE ARE MODULES INSIDE THE '$DIR/modules/' FOLDER!" 10 40
    exit;
else
    #Loaded, continue.
    echo "Loaded Modules"
fi
#!/bin/bash
#Console for minecraft
set -e
function cleanup {
        clear
        echo "Closing Console..."
        chmod 430 $(tty)
        rm -f $tempfile
}
trap cleanup EXIT

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$

options=""
COUNTER=1

for path in /opt/minecraft/*; do
        [ -d "${path}" ] || continue
        dirname="$(basename "${path}")"
        options+="$COUNTER $dirname off "
        servers[$COUNTER]="$dirname"
        let COUNTER=$COUNTER+1
done

$DIALOG --backtitle "HeliosGaming" \
        --title "Minecraft Server Console" \
        --radiolist "Select server to connect to:" 10 40 3 $options 2> $tempfile

retval=$?

choice=`cat $tempfile`
case $retval in
        0)
                server=$choice;;
        1)
                exit;;
        255)
                exit;;
esac

dialog --backtitle "Minecraft Server Console - HeliosGaming" --title "${servers[$server]}" --yesno "\nTo exit the console press CTRL A + D\n\nDO NOT PRESS CTRL C!\n\nContinue?" 10 40

if [[ "$?" == 0 ]]
        then
                chmod 666 $(tty)
                su -c "/usr/bin/screen -r mc-${servers[$server]}" minecraft
        else
                exit
fi

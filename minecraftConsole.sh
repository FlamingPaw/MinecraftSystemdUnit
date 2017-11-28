#!/bin/bash
#Console for minecraft
set -e
function cleanup {
        clear
        echo "Closing Minecraft Console..."
        chmod 430 $(tty)
        rm -f $TEMPFILE
}
trap cleanup EXIT

DIALOG=${DIALOG=dialog}
TEMPFILE=`tempfile 2>/dev/null` || TEMPFILE=/tmp/test$$

NETWORKNAME="HeliosGaming"
OPTIONS=""
COUNTER=1

for path in /opt/minecraft/*; do
        [ -d "${path}" ] || continue # if not a directory, skip
        dirname="$(basename "${path}")"
        OPTIONS+="$COUNTER $dirname off "
        SERVERS[$COUNTER]="$dirname"
        let COUNTER=$COUNTER+1
done

$DIALOG --backtitle "Minecraft Server Console - $NETWORKNAME" \
        --title "Server Selector" \
        --radiolist "Select server to connect to:" 10 40 3 $OPTIONS 2> $TEMPFILE

RETVAL=$?

CHOICE=`cat $TEMPFILE`
case $RETVAL in
        0)
                SERVER=$CHOICE;;
        1)
                exit;;
        255)
                exit;;
esac

dialog --backtitle "Minecraft Server Console - $NETWORKNAME" --title "${SERVERS[$SERVER]}" --yesno "\nTo exit the console press CTRL A + D\n\nDO NOT PRESS CTRL C!\n\nContinue?" 10 40

if [[ "$?" == 0 ]]
        then
                chmod 666 $(tty)
                su -c "/usr/bin/screen -r mc-${SERVERS[$SERVER]}" minecraft
        else
                exit
fi

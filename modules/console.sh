#Console for minecraft
MODULESAVAILABLE=1

#Set radio dialog var.
DIALOG=${DIALOG=dialog}

#Set options var.
OPTIONS=""
#Set counter var.
COUNTER=1
#Fetch all directories inside /opt/minecraft/
for path in $MCINSTALL*; do
    #Check if current iteration is a folder.
    [ -d "${path}" ] || continue
    #Fetch the base folder from path.
    dirname="$(basename "${path}")"
    #Build and apprnd to options var.
    OPTIONS+="$COUNTER $dirname off "
    #Build servers array.
    SERVERS[$COUNTER]="$dirname"
    #Increment counter.
    let COUNTER=$COUNTER+1
done

#Set and build radio list dialog. User selection gets put into the tmp file.
$DIALOG --backtitle "Minecraft Server Console - $NETWORKNAME" \
        --title "Server Selector" \
        --radiolist "Select server to connect to:" 10 40 3 $OPTIONS 2> $TEMPFILE

#Fetch status code from radio list dialog.
RETVAL=$?

#Fetch the contents of the tmp file.
CHOICE=`cat $TEMPFILE`
#Check the status code of the radio list dialog.
case $RETVAL in
    #Continue
    0)
        SERVER=$CHOICE;;
    #Exit
    1)
        exit;;
    #Exit
    255)
        exit;;
esac

#Set and build confirmation dialog.
dialog --backtitle "Minecraft Server Console - $NETWORKNAME" \
        --title "${SERVERS[$SERVER]}" \
        --yesno "\nTo exit the console press CTRL A + D\n\nDO NOT PRESS CTRL C!\n\nContinue?" 10 40

#Check answer of yesno dialog.
if [[ "$?" == 0 ]]
    #Yes. Continue
    then
        #Change permissions to allos other user connecting to minecraft screen.
        chmod 666 $(tty)
        #Connect to minecraft screen.
        su -c "/usr/bin/screen -r mc-${SERVERS[$SERVER]}" $MCUSER
    #No. Exit.
    else
        exit
fi
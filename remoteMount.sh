#!/bin/bash
source ./_config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "REMOTE_HOST:" $REMOTE_HOST
echo "REMOTE_USERNAME:" $REMOTE_USERNAME
echo "REMOTE_PASSWORD:" $REMOTE_PASSWORD
echo "REMOTE_FOLDER:" $REMOTE_FOLDER
echo "LOCAL_MOUNT_FOLDER:" $LOCAL_MOUNT_FOLDER
echo "-------------------------------------------------"
echo
#---------------------------------------------------

read -p "Are you sure to mount the remote file system? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    mkdir -p $LOCAL_MOUNT_FOLDER
    
    if [ $REMOTE_FTP_OR_SSH == "SSH" ]; then
        sshfs -o allow_other $REMOTE_USERNAME@$REMOTE_HOST:$REMOTE_FOLDER $LOCAL_MOUNT_FOLDER
    else
        curlftpfs -o user="$REMOTE_USERNAME:$REMOTE_PASSWORD" $REMOTE_HOST $LOCAL_MOUNT_FOLDER
    fi
    
    echo "Done! You should check the mount folder now here: $LOCAL_MOUNT_FOLDER"
    echo "Remeber to unmount after the job."
else
    echo "Nothing has been done, bye bye.";
fi
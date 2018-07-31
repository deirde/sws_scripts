#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "DEPLOY_CONN_TYPE:" $DEPLOY_CONN_TYPE
echo "DEPLOY_RMT_HOST:" $DEPLOY_RMT_HOST
echo "DEPLOY_RMT_UID:" $DEPLOY_RMT_UID
echo "DEPLOY_RMT_PSW:" $DEPLOY_RMT_PSW
echo "DEPLOY_RMT_DIR:" $DEPLOY_RMT_DIR
echo "LC_MOUNT_DIR:" $LC_MOUNT_DIR
echo "------------------------------------------------------------------------"
echo
read -p "Are you sure to mount the remote file system? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    mkdir -p $LC_MOUNT_DIR
    
    if [ $DEPLOY_CONN_TYPE == "SSH" ]; then
        sshfs -o allow_other $DEPLOY_RMT_UID@$DEPLOY_RMT_HOST:$DEPLOY_RMT_DIR $LC_MOUNT_DIR
    else
        curlftpfs -o user="$DEPLOY_RMT_UID:$DEPLOY_RMT_PSW" $DEPLOY_RMT_HOST $LC_MOUNT_DIR
    fi
    echo "Done! You should check the mount folder now here: $LC_MOUNT_DIR"
    echo "Remeber to unmount after the job."
else
    echo "Nothing has been done, bye bye.";
fi
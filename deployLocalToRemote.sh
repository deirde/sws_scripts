#!/bin/bash
source _config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "REMOTE_HOST:" $REMOTE_HOST
echo "REMOTE_USERNAME:" $REMOTE_USERNAME
echo "REMOTE_PASSWORD:" $REMOTE_PASSWORD
echo "DEPLOY_LOCAL_DIR:" $DEPLOY_LOCAL_DIR
echo "DEPLOY_REMOTE_DIR:" $DEPLOY_REMOTE_DIR
echo "-------------------------------------------------"
echo
#---------------------------------------------------

read -p "Direction: LOCAL TO REMOTE. Are you sure to proceed with this deploy? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    
    if [ $REMOTE_FTP_OR_SSH == "SSH" ]; then
        rsync -avzhe ssh --delete --progress $DEPLOY_LOCAL_DIR $REMOTE_USERNAME@$REMOTE_HOST:$DEPLOY_REMOTE_DIR
    else
        lftp -f "
open $REMOTE_HOST
user $REMOTE_USERNAME $REMOTE_PASSWORD
lcd $DEPLOY_LOCAL_DIR
mirror --continue --reverse --delete --verbose $DEPLOY_LOCAL_DIR $DEPLOY_REMOTE_DIR
bye
"
    fi
    
    echo "YAY! Deploy completed."
else
    echo "Nothing has been done, bye bye.";
fi
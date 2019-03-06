#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "DEPLOY_CONN_TYPE:" $DEPLOY_CONN_TYPE
echo "DEPLOY_RMT_DIR:" $DEPLOY_RMT_DIR
echo "DEPLOY_RMT_HOST:" $DEPLOY_RMT_HOST
echo "DEPLOY_RMT_UID:" $DEPLOY_RMT_UID
echo "DEPLOY_RMT_PSW:" $DEPLOY_RMT_PSW
echo "DEPLOY_LC_DIR:" $DEPLOY_LC_DIR
echo "DEPLOY_NO_RECURSION:" $DEPLOY_NO_RECURSION
echo "------------------------------------------------------------------------"
echo
read -p "Direction: LOCAL TO REMOTE. Are you sure to proceed with this deploy? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    if [ $DEPLOY_CONN_TYPE == "SSH" ]; then
        rsync -avzhe ssh --delete --progress $DEPLOY_LC_DIR $DEPLOY_RMT_UID@$DEPLOY_RMT_HOST:$DEPLOY_RMT_DIR
    else
        lftp -f "
open $DEPLOY_RMT_HOST
user $DEPLOY_RMT_UID "$DEPLOY_RMT_PSW"
lcd $DEPLOY_LC_DIR
mirror --continue --reverse --delete --verbose $DEPLOY_NO_RECURSION $DEPLOY_LC_DIR $DEPLOY_RMT_DIR
bye
"
    fi
    echo "YAY! Deploy completed."
else
    echo "Nothing has been done, bye bye.";
fi
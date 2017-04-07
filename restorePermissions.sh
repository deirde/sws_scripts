#!/bin/bash
source _config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "LOCAL_PERMISSIONS_GROUP:" $LOCAL_PERMISSIONS_GROUP
echo "LOCAL_PERMISSIONS_USER:" $LOCAL_PERMISSIONS_USER
echo "LOCAL_ROOT_DIR:" $LOCAL_ROOT_DIR
echo "-------------------------------------------------"
echo
#---------------------------------------------------

read -p "Are you sure to restore the permissions for all the files and folders? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    chown -R $LOCAL_PERMISSIONS_GROUP:$LOCAL_PERMISSIONS_USER $LOCAL_ROOT_DIR
    echo "Done! The permissions has been restored."
else
    echo "Nothing has been done, bye bye.";
fi
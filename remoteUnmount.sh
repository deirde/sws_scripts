#!/bin/bash
source ./_config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "MOUNT_FOLDER:" $LOCAL_MOUNT_FOLDER
echo "-------------------------------------------------"
echo
#---------------------------------------------------

read -p "Are you sure to unmount the remote file system? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    umount -vvv --force $LOCAL_MOUNT_FOLDER
    rmdir $LOCAL_MOUNT_FOLDER
    echo "Done! The remote file system has been unmounted."
else
    echo "Nothing has been done, bye bye.";
fi
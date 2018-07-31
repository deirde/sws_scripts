#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "LC_MOUNT_DIR:" $LC_MOUNT_DIR
echo "------------------------------------------------------------------------"
echo
read -p "Are you sure to unmount the remote file system? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    umount -vvv --force $LC_MOUNT_DIR
    rmdir $LC_MOUNT_DIR
    echo "Done! The remote file system has been unmounted."
else
    echo "Nothing has been done, bye bye.";
fi
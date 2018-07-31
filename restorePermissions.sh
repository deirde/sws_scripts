#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "PERMS_LC_GROUP:" $PERMS_LC_GROUP
echo "PERMS_RMT_GROUP:" $PERMS_RMT_GROUP
echo "LC_PROJECT_DIR:" $LC_PROJECT_DIR
echo "------------------------------------------------------------------------"
echo
read -p "Are you sure to restore the permissions for all the files and folders? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    chown -R $PERMS_LC_GROUP:$PERMS_RMT_GROUP $LC_PROJECT_DIR
    echo "Done! The permissions has been restored."
else
    echo "Nothing has been done, bye bye.";
fi
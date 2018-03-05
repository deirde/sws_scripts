#!/bin/bash
source ./_config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "LOCAL_PUBLIC_DIR:" $LOCAL_PUBLIC_DIR

#---------------------------------------------------

read -p "This script will optimize all the images into the folder <wp-content/themes/> and <wp-content/uploads/. Do you wish to proceed? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    yum install -y jpegoptim
    yum install -y optipng
    cd $LOCAL_PUBLIC_DIR"wp-content/themes/"
    find -type f -name "*.jpg" -exec jpegoptim --strip-all {} \;
    find -type f -name "*.png" -exec optipng {} \;
    cd $LOCAL_PUBLIC_DIR"wp-content/uploads/"
    find -type f -name "*.jpg" -exec jpegoptim --strip-all {} \;
    find -type f -name "*.png" -exec optipng {} \;

    echo "Done!"
else
    echo "Nothing has been done, bye bye.";
fi
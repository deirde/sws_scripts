#!/bin/bash
source _config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "DATABASE_LOCAL_HOST:" $DATABASE_LOCAL_HOST
echo "DATABASE_LOCAL_NAME:" $DATABASE_LOCAL_NAME
echo "DATABASE_LOCAL_USERNAME:" $DATABASE_LOCAL_USERNAME
echo "DATABASE_LOCAL_PASSWORD:" $DATABASE_LOCAL_PASSWORD
echo "-------------------------------------------------"
echo
#---------------------------------------------------

echo "Attention, the database data will be overwritten!"
echo "Before proceed drop your database dump named <import-me.sql> in the same folder of this script."
echo "Note: the file will be deleted after the import."
read -p "Are you sure to do this? [Y/n]"
echo

if [ "$REPLY" == "Y" ]; then
    if [ ! -f import-me.sql ]; then
        echo "The file <import-me.sql> doesn't exist! I can't proceed further."
    else
        mysqldump -u${DATABASE_LOCAL_USERNAME} -p${DATABASE_LOCAL_PASSWORD} -h ${DATABASE_LOCAL_HOST} --add-drop-table --no-data ${DATABASE_LOCAL_NAME} | grep ^DROP | mysql -u${DATABASE_LOCAL_USERNAME} -p${DATABASE_LOCAL_PASSWORD} -h ${DATABASE_LOCAL_HOST} ${DATABASE_LOCAL_NAME}
        mysql -u $DATABASE_LOCAL_USERNAME -p$DATABASE_LOCAL_PASSWORD $DATABASE_LOCAL_NAME < import-me.sql
        rm -f import-me.sql
        echo "It's done. The data has been imported successfully."
    fi
else
    echo "Nothing has been done, bye bye.";
fi

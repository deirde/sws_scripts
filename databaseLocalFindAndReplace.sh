#!/bin/bash
source _config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "DATABASE_LOCAL_HOST:" $DATABASE_LOCAL_HOST
echo "DATABASE_LOCAL_NAME:" $DATABASE_LOCAL_NAME
echo "DATABASE_LOCAL_USERNAME:" $DATABASE_LOCAL_USERNAME
echo "DATABASE_LOCAL_PASSWORD:" $DATABASE_LOCAL_PASSWORD
echo "DATABASE_LOCAL_SEARCH_FOR:" $DATABASE_LOCAL_SEARCH_FOR
echo "DATABASE_LOCAL_REPLACE_WITH:" $DATABASE_LOCAL_REPLACE_WITH
echo "-------------------------------------------------"
echo
#---------------------------------------------------

read -p "Are you sure to find and replace that string in the local database? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    php srdb.cli.php -h $DATABASE_LOCAL_HOST -n $DATABASE_LOCAL_NAME -u $DATABASE_LOCAL_USERNAME -p $DATABASE_LOCAL_PASSWORD -s $DATABASE_LOCAL_SEARCH_FOR -r $DATABASE_LOCAL_REPLACE_WITH
else
    echo "Nothing has been done, bye bye.";
fi
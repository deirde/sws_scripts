#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "DB_LC_HOST:" $DB_LC_HOST
echo "DB_LC_NAME:" $DB_LC_NAME
echo "DB_LC_UID:" $DB_LC_UID
echo "DB_LC_PSW:" $DB_LC_PSW
echo "DB_LC_SEARCH:" $DB_LC_SEARCH
echo "DB_LC_REPLACE:" $DB_LC_REPLACE
echo "------------------------------------------------------------------------"
echo
read -p "Are you sure to find and replace that string in the local database? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    php srdb.cli.php -h $DB_LC_HOST -n $DB_LC_NAME -u $DB_LC_UID -p $DB_LC_PSW -s $DB_LC_SEARCH -r $DB_LC_REPLACE
else
    echo "Nothing has been done, bye bye.";
fi
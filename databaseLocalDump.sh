#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "DB_LC_HOST:" $DB_LC_HOST
echo "DB_LC_NAME:" $DB_LC_NAME
echo "DB_LC_UID:" $DB_LC_UID
echo "DB_LC_PSW:" $DB_LC_PSW
echo "DB_LC_DUMPS_DIR: " $DB_LC_DUMPS_DIR
echo "------------------------------------------------------------------------"
echo
read -p "Are you sure to dump the local database? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    mkdir -p $DB_LC_DUMPS_DIR
    TIMESTAMP=$(date "+%Y%m%d%H%M%S")
    mysqldump -u $DB_LC_UID -p$DB_LC_PSW $DB_LC_NAME > $DB_LC_DUMPS_DIR$DB_LC_NAME"_"$TIMESTAMP.sql
    gzip -v $DB_LC_DUMPS_DIR$DB_LC_NAME"_"$TIMESTAMP.sql
    echo
    echo "It's done here: $DB_LC_DUMPS_DIR$DB_LC_NAME"_"$TIMESTAMP.sql.gz"
else
    echo "Nothing has been done, bye bye.";
fi
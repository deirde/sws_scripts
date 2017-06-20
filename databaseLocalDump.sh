#!/bin/bash
source _config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "DATABASE_LOCAL_HOST:" $DATABASE_LOCAL_HOST
echo "DATABASE_LOCAL_NAME:" $DATABASE_LOCAL_NAME
echo "DATABASE_LOCAL_USERNAME:" $DATABASE_LOCAL_USERNAME
echo "DATABASE_LOCAL_PASSWORD:" $DATABASE_LOCAL_PASSWORD
echo "DATABASE_LOCAL_DUMP_FOLDER: " $DATABASE_LOCAL_DUMP_FOLDER
echo "-------------------------------------------------"
echo
#---------------------------------------------------

read -p "Are you sure to dump the local database? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    mkdir -p $DATABASE_LOCAL_DUMP_FOLDER
    TIMESTAMP=$(date "+%Y%m%d%H%M%S")
    mysqldump -u $DATABASE_LOCAL_USERNAME -p$DATABASE_LOCAL_PASSWORD $DATABASE_LOCAL_NAME > $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_LOCAL_NAME"_"$TIMESTAMP.sql
    gzip -v $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_LOCAL_NAME"_"$TIMESTAMP.sql
    echo
    echo "It's done here: $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_LOCAL_NAME"_"$TIMESTAMP.sql.gz"
else
    echo "Nothing has been done, bye bye.";
fi
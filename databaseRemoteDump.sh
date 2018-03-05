#!/bin/bash
source _config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "DATABASE_REMOTE_HOST:" $DATABASE_REMOTE_HOST
echo "DATABASE_REMOTE_NAME:" $DATABASE_REMOTE_NAME
echo "DATABASE_REMOTE_USERNAME:" $DATABASE_REMOTE_USERNAME
echo "DATABASE_REMOTE_PASSWORD:" $DATABASE_REMOTE_PASSWORD
echo "DATABASE_LOCAL_DUMP_FOLDER: " $DATABASE_LOCAL_DUMP_FOLDER
echo "-------------------------------------------------"
echo "Attention: the remote host must allow the connections from this host."
echo "-------------------------------------------------"
echo
#---------------------------------------------------

read -p "Are you sure to dump the remote database? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    mkdir -p $DATABASE_LOCAL_DUMP_FOLDER
    TIMESTAMP=$(date "+%Y%m%d%H%M%S")
    mysqldump -h $DATABASE_REMOTE_HOST -u $DATABASE_REMOTE_USERNAME -p$DATABASE_REMOTE_PASSWORD --single-transaction $DATABASE_REMOTE_NAME > $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_REMOTE_NAME"_"$TIMESTAMP.sql
    gzip -v $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_REMOTE_NAME"_"$TIMESTAMP.sql
    echo
    echo "It's done here: $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_REMOTE_NAME"_"$TIMESTAMP.sql.gz"
else
    echo "Nothing has been done, bye bye.";
fi
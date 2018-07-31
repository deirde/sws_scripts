#!/bin/bash
source _config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "DB_RMT_HOST:" $DB_RMT_HOST
echo "DB_RMT_NAME:" $DB_RMT_NAME
echo "DB_RMT_UID:" $DB_RMT_UID
echo "DB_RMT_PSW:" $DB_RMT_PSW
echo "DB_LC_DUMPS_DIR: " $DB_LC_DUMPS_DIR
echo "------------------------------------------------------------------------"
echo "Attention: the remote host must allow the connections from this host."
echo "------------------------------------------------------------------------"
echo
read -p "Are you sure to dump the remote database? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    mkdir -p $DB_LC_DUMPS_DIR
    TIMESTAMP=$(date "+%Y%m%d%H%M%S")
    mysqldump -h $DB_RMT_HOST -u $DB_RMT_UID -p$DB_RMT_PSW --single-transaction $DB_RMT_NAME > $DB_LC_DUMPS_DIR$DB_RMT_NAME"_"$TIMESTAMP.sql
    gzip -v $DB_LC_DUMPS_DIR$DB_RMT_NAME"_"$TIMESTAMP.sql
    echo
    echo "It's done here: $DB_LC_DUMPS_DIR$DB_RMT_NAME"_"$TIMESTAMP.sql.gz"
else
    echo "Nothing has been done, bye bye.";
fi
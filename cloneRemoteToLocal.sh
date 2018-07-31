#!/bin/bash
source ./_config.sh

echo "---------- SETUP, CHECK IT BEFORE CONFIRM ----------"
echo "REMOTE_FTP_OR_SSH:" $REMOTE_FTP_OR_SSH
echo "REMOTE_HOST:" $REMOTE_HOST
echo "REMOTE_USERNAME:" $REMOTE_USERNAME
echo "REMOTE_PASSWORD:" $REMOTE_PASSWORD
echo "REMOTE_PUBLIC_DIR:" $REMOTE_PUBLIC_DIR
echo "LOCAL_PUBLIC_DIR:" $LOCAL_PUBLIC_DIR
echo "DATABASE_LOCAL_DUMP_FOLDER": $DATABASE_LOCAL_DUMP_FOLDER
echo "DATABASE_LOCAL_HOST:" $DATABASE_LOCAL_HOST
echo "DATABASE_LOCAL_NAME:" $DATABASE_LOCAL_NAME
echo "DATABASE_LOCAL_USERNAME:" $DATABASE_LOCAL_USERNAME
echo "DATABASE_LOCAL_PASSWORD:" $DATABASE_LOCAL_PASSWORD
echo "DATABASE_LOCAL_SEARCH_FOR:" $DATABASE_LOCAL_SEARCH_FOR
echo "DATABASE_LOCAL_REPLACE_WITH:" $DATABASE_LOCAL_REPLACE_WITH
echo "LOCAL_PERMISSIONS_GROUP:" $LOCAL_PERMISSIONS_GROUP:
echo "LOCAL_PERMISSIONS_USER:" $LOCAL_PERMISSIONS_USER
echo "LOCAL_ROOT_DIR:" $LOCAL_ROOT_DIR
echo "-------------------------------------------------"
echo
#---------------------------------------------------

echo "Direction: REMOTE TO LOCAL."
echo "Before proceed drop your database dump named <import-me.sql> in the same folder of this script."
echo "Note: the file will be deleted after the import."
read -p "Are you sure to do this? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then

    if [ ! -f import-me.sql ]; then
        echo "The file <import-me.sql> doesn't exist! I can't proceed any further."
    else

        #--------------------------------------------------- DOWNLOAD FILES ---------------------------------------------------#
        if [ $REMOTE_FTP_OR_SSH == "SSH" ]; then
            rsync -avzhe ssh --delete --progress $REMOTE_USERNAME@$REMOTE_HOST:$REMOTE_PUBLIC_DIR $LOCAL_PUBLIC_DIR
        else
            lftp -f "
open $REMOTE_HOST
user $REMOTE_USERNAME $REMOTE_PASSWORD
lcd $LOCAL_PUBLIC_DIR
mirror --continue --delete --verbose "" $REMOTE_PUBLIC_DIR $LOCAL_PUBLIC_DIR
bye
"
        fi
        echo "Files have been successfully downloaded."

        #--------------------------------------------------- DUMPING LOCAL DATABASE ---------------------------------------------------#
        mkdir -p $DATABASE_LOCAL_DUMP_FOLDER
        TIMESTAMP=$(date "+%Y%m%d%H%M%S")
        mysqldump -u $DATABASE_LOCAL_USERNAME -p$DATABASE_LOCAL_PASSWORD $DATABASE_LOCAL_NAME > $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_LOCAL_NAME"_"$TIMESTAMP.sql
        gzip -v $DATABASE_LOCAL_DUMP_FOLDER$DATABASE_LOCAL_NAME"_"$TIMESTAMP.sql
        echo "Local database has been successfully dumped."

        #--------------------------------------------------- IMPORT DATABASE ----------------------------------------------------------#
        mysqldump -u${DATABASE_LOCAL_USERNAME} -p${DATABASE_LOCAL_PASSWORD} -h ${DATABASE_LOCAL_HOST} --add-drop-table --no-data ${DATABASE_LOCAL_NAME} | grep ^DROP | mysql -u${DATABASE_LOCAL_USERNAME} -p${DATABASE_LOCAL_PASSWORD} -h ${DATABASE_LOCAL_HOST} ${DATABASE_LOCAL_NAME}
        mysql -u $DATABASE_LOCAL_USERNAME -p$DATABASE_LOCAL_PASSWORD $DATABASE_LOCAL_NAME < import-me.sql
        rm -f import-me.sql
        echo "New database has been successfully imported."

        #--------------------------------------------------- REPLACE DATABASE ENTRIES -------------------------------------------------#
        php srdb.cli.php -h $DATABASE_LOCAL_HOST -n $DATABASE_LOCAL_NAME -u $DATABASE_LOCAL_USERNAME -p $DATABASE_LOCAL_PASSWORD -s $DATABASE_LOCAL_SEARCH_FOR -r $DATABASE_LOCAL_REPLACE_WITH
        echo "Database entries have been successfully replaced."

        #--------------------------------------------------PERMISSIONS -----------------------------------------------------------------#
        chown -R $LOCAL_PERMISSIONS_GROUP:$LOCAL_PERMISSIONS_USER $LOCAL_ROOT_DIR
        echo "Files permssions restored."

        #--------------------------------------------------- WP-CLI -------------------------------------------------------------------#
        cd $LOCAL_PUBLIC_DIR
        wp config set DB_HOST "$DATABASE_LOCAL_HOST" --allow-root
        wp config set DB_NAME "$DATABASE_LOCAL_NAME" --allow-root
        wp config set DB_USER "$DATABASE_LOCAL_USERNAME" --allow-root
        wp config set DB_PASSWORD "$DATABASE_LOCAL_PASSWORD" --allow-root
        wp cache flush --allow-root
        wp user create admin info@localhost --user_pass=admin --role=administrator --skip-plugins --allow-root
        cd -
        echo "WP-CONFIG has been successfully updated."

        echo "ATTENTION! A new admin user has been created, username: admin, password: admin. Remember to update its credentials."
        echo "YAY! Deploy completed."
    fi
else
    echo "Nothing has been done, bye bye.";
fi
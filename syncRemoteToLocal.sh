#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "LC_PUBLIC_DIR:" $LC_PUBLIC_DIR
echo "LC_PROJECT_DIR:" $LC_PROJECT_DIR
echo "DEPLOY_CONN_TYPE:" $DEPLOY_CONN_TYPE
echo "DEPLOY_RMT_HOST:" $DEPLOY_RMT_HOST
echo "DEPLOY_RMT_UID:" $DEPLOY_RMT_UID
echo "DEPLOY_RMT_PSW:" $DEPLOY_RMT_PSW
echo "DEPLOY_RMT_DIR:" $DEPLOY_RMT_DIR
echo "DB_LC_DUMPS_DIR": $DB_LC_DUMPS_DIR
echo "DB_LC_HOST:" $DB_LC_HOST
echo "DB_LC_NAME:" $DB_LC_NAME
echo "DB_LC_UID:" $DB_LC_UID
echo "DB_LC_PSW:" $DB_LC_PSW
echo "DB_LC_SEARCH:" $DB_LC_SEARCH
echo "DB_LC_REPLACE:" $DB_LC_REPLACE
echo "PERMS_LC_GROUP:" $PERMS_LC_GROUP
echo "PERMS_RMT_GROUP:" $PERMS_RMT_GROUP
echo "------------------------------------------------------------------------"
echo
echo "Direction: REMOTE TO LOCAL."
echo "Before proceeding further drop your database dump named <import-me.sql> in the same folder of this script."
echo "Note: the file will be deleted after the import."
read -p "Are you sure to do this? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    if [ ! -f import-me.sql ]; then
        echo "The file <import-me.sql> doesn't exist! I can't proceed any further."
    else
        if [ $DEPLOY_CONN_TYPE == "SSH" ]; then
            rsync -avzhe ssh --delete --progress $DEPLOY_RMT_UID@$DEPLOY_RMT_HOST:$DEPLOY_RMT_DIR $LC_PUBLIC_DIR
        else
            lftp -f "
open $DEPLOY_RMT_HOST
user $DEPLOY_RMT_UID $DEPLOY_RMT_PSW
lcd $LC_PUBLIC_DIR
mirror --continue --delete --verbose "" $DEPLOY_RMT_DIR $LC_PUBLIC_DIR
bye
"
        fi
        mkdir -p $DB_LC_DUMPS_DIR
        TIMESTAMP=$(date "+%Y%m%d%H%M%S")
        mysqldump -u $DB_LC_UID -p$DB_LC_PSW $DB_LC_NAME > $DB_LC_DUMPS_DIR$DB_LC_NAME"_"$TIMESTAMP.sql
        gzip -v $DB_LC_DUMPS_DIR$DB_LC_NAME"_"$TIMESTAMP.sql
        mysqldump -u${DB_LC_UID} -p${DB_LC_PSW} -h ${DB_LC_HOST} --add-drop-table --no-data ${DB_LC_NAME} | grep ^DROP | mysql -u${DB_LC_UID} -p${DB_LC_PSW} -h ${DB_LC_HOST} ${DB_LC_NAME}
        mysql -u $DB_LC_UID -p$DB_LC_PSW $DB_LC_NAME < import-me.sql
        rm -f import-me.sql
        php srdb.cli.php -h $DB_LC_HOST -n $DB_LC_NAME -u $DB_LC_UID -p $DB_LC_PSW -s $DB_LC_SEARCH -r $DB_LC_REPLACE
        chown -R $PERMS_LC_GROUP:$PERMS_RMT_GROUP $LC_PROJECT_DIR
        cd $LC_PUBLIC_DIR
        wp config set DB_HOST "$DB_LC_HOST" --allow-root
        wp config set DB_NAME "$DB_LC_NAME" --allow-root
        wp config set DB_USER "$DB_LC_UID" --allow-root
        wp config set DB_PASSWORD "$DB_LC_PSW" --allow-root
        wp cache flush --allow-root
        wp user create admin info@localhost.me --user_pass=admin --role=administrator --skip-plugins --allow-root
        cd -
        echo "ATTENTION! A new admin user has been created, username: admin, password: admin. Remember to update its credentials."
        echo "YAY! Deploy completed."
    fi
else
    echo "Nothing has been done, bye bye.";
fi
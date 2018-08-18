#!/bin/bash
source ./_config.sh

echo "-------------------- SETUP, CHECK IT BEFORE CONFIRM --------------------"
echo "DB_LC_HOST:" $DB_LC_HOST
echo "DB_LC_NAME:" $DB_LC_NAME
echo "DB_LC_UID:" $DB_LC_UID
echo "DB_LC_PSW:" $DB_LC_PSW
echo "------------------------------------------------------------------------"
echo
echo "Attention, the database data will be overwritten!"
echo "Before proceeding further drop your database dump named <import-me.sql> in the same folder of this script."
echo "Note: the file will be deleted after the import."
read -p "Are you sure to do this? [Y/n]"
echo
if [ "$REPLY" == "Y" ]; then
    if [ ! -f import-me.sql ]; then
        echo "The file <import-me.sql> doesn't exist! I can't proceed further."
    else
        sed -i 's/utf8mb4_unicode_520_ci/utf8_general_ci/g' import-me.sql
        sed -i 's/utf8_general_ci_unicode_ci/utf8_general_ci/g' import-me.sql
        sed -i 's/utf8_general_ci/utf8_general_ci/g' import-me.sql
        sed -i 's/utf8mb4/utf8/g' import-me.sql
        mysqldump -u${DB_LC_UID} -p${DB_LC_PSW} -h ${DB_LC_HOST} --add-drop-table --no-data ${DB_LC_NAME} | grep ^DROP | mysql -u${DB_LC_UID} -p${DB_LC_PSW} -h ${DB_LC_HOST} ${DB_LC_NAME}
        mysql -u $DB_LC_UID -p$DB_LC_PSW $DB_LC_NAME < import-me.sql
        rm -f import-me.sql
        echo "It's done. The data has been imported successfully."
    fi
else
    echo "Nothing has been done, bye bye.";
fi

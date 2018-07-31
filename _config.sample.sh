#!/usr/bin/env bash

#-------------------- PERMISSIONS
PERMS_LC_GROUP="root"
PERMS_RMT_GROUP="root"

#-------------------- PROJECT DIRS
LC_PROJECT_DIR="/home/myproject.com"
LC_PUBLIC_DIR="/home/myproject.comg/httpdocs/"

#-------------------- LOCAL DATABASE CONNECTION
DB_LC_HOST="localhost"
DB_LC_NAME="local_database_name"
DB_LC_UID="root"
DB_LC_PSW="qwerty"

#-------------------- LOCAL DATABASE DUM PS DIR
DB_LC_DUMPS_DIR="/home/myproject.com/.rs/data/"

#-------------------- LOCAL DATABASE FIND AND REPLACE
DB_LC_SEARCH="www.myproject.com"
DB_LC_REPLACE="myproject.com.dev"

#-------------------- REMOTE DATABASE CONNECTION
DB_RMT_HOST="1.2.3.4"
DB_RMT_NAME="remote_database_name"
DB_RMT_UID="root"
DB_RMT_PSW="qwerty"

#-------------------- DEPLOY
DEPLOY_CONN_TYPE="FTP" # FTP OR SSH
DEPLOY_RMT_HOST="1.2.3.4"
DEPLOY_RMT_UID="root"
DEPLOY_RMT_PSW="qwerty"
DEPLOY_RMT_DIR="/httpdocs/"
DEPLOY_LC_DIR="/home/myproject.com/public_html/"
DEPLOY_NO_RECURSION="" #Empty or --no-recursion

#-------------------- MOUNT FOLDER
LC_MOUNT_DIR="/home/myproject.com/.rs/mount/"



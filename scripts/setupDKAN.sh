#!/bin/bash -e

init=false;
DOMAIN=false;
DB_HOST=false;
DB_USER=false;
DB_PASS=false;
REDIS_HOST=false;
REDIS_PASS=false;
DKAN_ADMIN_PASS=false;
USER_EMAIL=false;

ARGUMENT_LIST=(
    "init"
    "DB_HOST"
    "DB_USER"
    "DB_PASS"
    "DKAN_ADMIN_PASS"
    "REDIS_HOST"
    "REDIS_PASS"
    "DOMAIN"
    "USER_EMAIL"
)

DKAN_PATH="/var/www/webroot/ROOT"
DKAN_CONFIG="${DKAN_PATH}/sites/default/settings.php"
DB_NAME="dkan"

SED=`which sed`
MYSQL=`which mysql`
WGET=`which wget`
SED=`which sed`
RSYNC=`which rsync`
TAR=`which tar`
COMPOSER=`which composer`


# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)
eval set --$opts

while [[ $# -gt 0 ]]; do
    case "$1" in

        --init)
            init=$2
            shift 2
            ;;

       --DB_HOST)
            DB_HOST=$2
            shift 2
            ;;

        --DB_USER)
            DB_USER=$2
            shift 2
            ;;
            
       --DB_PASS)
            DB_PASS=$2
            shift 2
            ;;

        --DKAN_ADMIN_PASS)
            DKAN_ADMIN_PASS=$2
            shift 2
            ;;
            
        --REDIS_HOST)
            REDIS_HOST=$2
            shift 2
            ;;

        --REDIS_PASS)
            REDIS_PASS=$2
            shift 2
            ;;

        --DOMAIN)
            DOMAIN=$2
            shift 2
            ;;

        --USER_EMAIL)
            USER_EMAIL=$2
            shift 2
            ;;            
            
        *)
            break
            ;;
    esac
done

lOG="/var/log/run.log"

if [ $init == 'true' ] ; then
  rm -rf ${DKAN_PATH}/*
  $TAR -C "${DKAN_PATH}" -xzf "/tmp/dkan.tar.gz";

  $MYSQL -u${DB_USER} -p${DB_PASS} -h ${DB_HOST} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
  $MYSQL -u${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} < ${DKAN_PATH}/dkan.sql

  chmod 777 -R ${DKAN_PATH}/*

  ###Mysql connection
  $SED -i "s/JELASTIC_DB_USER/${DB_USER}/" ${DKAN_CONFIG};
  $SED -i "s/JELASTIC_DB_PASS/${DB_PASS}/" ${DKAN_CONFIG};
  $SED -i "s/JELASTIC_DB_NAME/${DB_NAME}/" ${DKAN_CONFIG};
  
  ###Redis connection
  $SED -i "s/JELASTIC_REDIS_HOST/${REDIS_HOST}/" ${DKAN_CONFIG};
  $SED -i "s/JELASTIC_REDIS_PASS/${REDIS_PASS}/" ${DKAN_CONFIG};
  
  ###Admin password
  cd ${DKAN_PATH};
  ${DKAN_PATH}/vendor/bin/drush upwd --password="${DKAN_ADMIN_PASS}" admin;
  
fi

if [ $DOMAIN != 'false' ] ; then
	sed -i "s/\$base_url =.*//" ${DKAN_CONFIG};
	DOMAIN=$(echo $DOMAIN | sed -e 's#/$##')
	echo "\$base_url = '${DOMAIN}';" >> ${DKAN_CONFIG};
fi

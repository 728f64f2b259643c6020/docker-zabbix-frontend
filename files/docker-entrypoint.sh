#!/bin/bash

set -e

CONF="/var/www/html/conf/zabbix.conf.php"

if [ -z ${DB_HOST+x} ]; then
    echo "No Default DB Host Provided. Assuming 'db'"
    DB_HOST="db"
fi

if [ -z ${DB_TYPE+x} ]; then
    echo "No default DB Type Provided. Assuming PostgreSQL"
    DB_TYPE="POSTGRESQL"
fi

if [ -z ${DB_PORT+x} ]; then
    echo "No Default port for Db Provided. Assuming 5432."
    DB_PORT=5432
fi

if [ -z ${DB_USER+x} ]; then
    echo "No Default User provided for Db. Assuming zabbix"
    DB_USER="zabbix"
fi

if [ -z ${DB_PASS+x} ]; then
    echo "No Default DB Password provided. Assuming zabbix"
    DB_PASS="zabbix"
fi

if [ -z ${DB_NAME+x} ]; then
    echo "No default db name provided. Assuming zabbix"
    DB_NAME="zabbix"
fi

if [ -z ${ZBX_SERVER+x} ]; then
    echo "No default ZBX_SERVER provided. Assuming zabbix"
    ZBX_SERVER="zabbix"
fi

if [ -z ${ZBX_SERVER_PORT+x} ]; then
    echo "No Default ZBX_SERVER_PORT provided. Assuming 10051"
    ZBX_SERVER_PORT=10051
fi

if [ -z ${ZBX_SERVER_NAME+x} ]; then
    echo "No Default ZBX_SERVER_NAME provided. Assuming Zabbix"
    ZBX_SERVER_NAME="zabbix"
fi

if [ ! -d "/tmp/firstrun" ]; then
    echo "<?php" > $CONF
    echo "global \$DB;" >> $CONF
    echo "\$DB['TYPE'] = '${DB_TYPE}';" >> $CONF

    echo "\$DB['SERVER'] = '${DB_HOST}';" >> $CONF
    echo "\$DB['PORT'] = '${DB_PORT}';" >> $CONF
    echo "\$DB['USER'] = '${DB_USER}';" >> $CONF
    echo "\$DB['PASSWORD'] = '${DB_PASS}';" >> $CONF
    echo "\$DB['DATABASE'] = '${DB_NAME}';" >> $CONF
    echo "\$DB['SCHEMA'] = '';" >> $CONF

    echo "\$ZBX_SERVER = '${ZBX_SERVER}';" >> $CONF
    echo "\$ZBX_SERVER_PORT = '${ZBX_SERVER_PORT}';" >> $CONF
    echo "\$ZBX_SERVER_NAME = '${ZBX_SERVER_NAME}';" >> $CONF

    echo "\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;" >> $CONF
    echo "?>" >> $CONF
    touch /tmp/firstrun
fi

apache2-foreground

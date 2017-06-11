#!/bin/bash

# default
echo "Running Dovecot + Postfix"
echo "Host: $APP_HOST (should be set)"
echo "Database: $DB_NAME (should be set)"
echo "Available environment vars:"
echo "APP_HOST *required*, DB_NAME *required*, DB_USER, DB_PASSWORD"

if [ "${DEBUG}" == 'true' ]; then
  export DOVECOT_DEBUG="yes"
else
  export DOVECOT_DEBUG="no"
fi

DYNAMIC_FILES="/etc/postfix/*.cf /etc/dovecot/*.conf etc/dovecot/conf.d/*.conf"

shopt -s nullglob # enable
for dirs in ${DYNAMIC_FILES}; do
  for f in $dirs; do
    envsubst < ${f} > ${f}
  done
done
shopt -u nullglob # disable

echo > /etc/aliases
newaliases

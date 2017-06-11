#!/bin/bash

# default
echo "Running Dovecot + Postfix"
echo "Host: $APP_HOST (should be set)"
echo "Database: $DB_NAME (should be set)"
echo "Available environment vars:"
echo "APP_HOST *required*, DB_NAME *required*, DB_USER, DB_PASSWORD"

# defining mail name
echo "localhost" > /etc/mailname

[[ -z $DEBUG ]] && DEBUG=no

# update config templates
sed -i "s/{{DB_USER}}/$DB_USER/g"         /etc/postfix/mysql-email2email.cf
sed -i "s/{{DB_HOST}}/$DB_HOST/g"         /etc/postfix/mysql-email2email.cf
sed -i "s/{{DB_NAME}}/$DB_NAME/g"         /etc/postfix/mysql-email2email.cf
sed -i "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" /etc/postfix/mysql-email2email.cf

sed -i "s/{{DB_USER}}/$DB_USER/g"         /etc/postfix/mysql-users.cf
sed -i "s/{{DB_HOST}}/$DB_HOST/g"         /etc/postfix/mysql-users.cf
sed -i "s/{{DB_NAME}}/$DB_NAME/g"         /etc/postfix/mysql-users.cf
sed -i "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" /etc/postfix/mysql-users.cf

sed -i "s/{{DB_USER}}/$DB_USER/g"         /etc/postfix/mysql-virtual-alias-maps.cf
sed -i "s/{{DB_HOST}}/$DB_HOST/g"         /etc/postfix/mysql-virtual-alias-maps.cf
sed -i "s/{{DB_NAME}}/$DB_NAME/g"         /etc/postfix/mysql-virtual-alias-maps.cf
sed -i "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" /etc/postfix/mysql-virtual-alias-maps.cf

sed -i "s/{{DB_USER}}/$DB_USER/g"         /etc/postfix/mysql-virtual-mailbox-maps.cf
sed -i "s/{{DB_HOST}}/$DB_HOST/g"         /etc/postfix/mysql-virtual-mailbox-maps.cf
sed -i "s/{{DB_NAME}}/$DB_NAME/g"         /etc/postfix/mysql-virtual-mailbox-maps.cf
sed -i "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" /etc/postfix/mysql-virtual-mailbox-maps.cf

sed -i "s/{{DB_USER}}/$DB_USER/g"         /etc/postfix/mysql-virtual-mailbox-domains.cf
sed -i "s/{{DB_HOST}}/$DB_HOST/g"         /etc/postfix/mysql-virtual-mailbox-domains.cf
sed -i "s/{{DB_NAME}}/$DB_NAME/g"         /etc/postfix/mysql-virtual-mailbox-domains.cf
sed -i "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" /etc/postfix/mysql-virtual-mailbox-domains.cf

sed -i "s/{{DB_USER}}/$DB_USER/g"         /etc/dovecot/dovecot-sql.conf
sed -i "s/{{DB_HOST}}/$DB_HOST/g"         /etc/dovecot/dovecot-sql.conf
sed -i "s/{{DB_NAME}}/$DB_NAME/g"         /etc/dovecot/dovecot-sql.conf
sed -i "s/{{DB_PASSWORD}}/$DB_PASSWORD/g" /etc/dovecot/dovecot-sql.conf

sed -i "s/{{APP_HOST}}/$APP_HOST/g" /etc/dovecot/local.conf
sed -i "s/{{DEBUG}}/$DEBUG/g"       /etc/dovecot/local.conf
sed -i "s,{{SSL_CERT}},$SSL_CERT_FILE,g" /etc/dovecot/conf.d/ssl.conf
sed -i "s,{{SSL_KEY}},$SSL_KEY_FILE,g"   /etc/dovecot/conf.d/ssl.conf

sed -i "s,{{SSL_CERT}},$SSL_CERT_FILE,g" /etc/postfix/main.cf
sed -i "s,{{SSL_KEY}},$SSL_KEY_FILE,g"   /etc/postfix/main.cf

echo > /etc/aliases
newaliases

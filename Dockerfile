FROM jameseckersall/docker-centos-base
RUN \
  yum -y install postfix dovecot openssl dovecot-mysql dovecot-pigeonhole syslog-ng supervisor && \
  sed -i -E 's/^(\s*)system\(\);/\1unix-stream("\/dev\/log");/' /etc/syslog-ng/syslog-ng.conf && \
  rm -rf /etc/dovecot/conf.d/*
COPY files /

RUN \
  groupadd -g 5000 vmail && \
  useradd -g vmail -u 5000 vmail -d /home/vmail -m && \
  chgrp postfix /etc/postfix/mysql-*.cf && \
  chgrp vmail /etc/dovecot/dovecot.conf && \
  chmod g+r /etc/dovecot/dovecot.conf && \
  postconf -e virtual_uid_maps=static:5000 && \
  postconf -e virtual_gid_maps=static:5000 && \
  postconf -e virtual_mailbox_domains=mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf && \
  postconf -e virtual_mailbox_maps=mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf && \
  postconf -e virtual_alias_maps=mysql:/etc/postfix/mysql-virtual-alias-maps.cf,mysql:/etc/postfix/mysql-email2email.cf && \
  postconf -e virtual_transport=lmtp:unix:private/dovecot-lmtp && \
  postconf -e inet_interfaces=all && \
  postconf -e dovecot_destination_recipient_limit=1 && \
  postconf -e recipient_delimiter=+ && \
  postconf -e smtpd_use_tls=yes && \
  postconf -e smtpd_tls_security_level=encrypt && \
  postconf -e smtpd_tls_received_header=yes && \
  postconf -e smtpd_tls_cert_file={{SSL_CERT}} && \
  postconf -e smtpd_tls_key_file={{SSL_KEY}} && \
  postconf -e smtpd_tls_mandatory_protocols='!SSLv2,!SSLv3' && \
  postconf -e smtpd_tls_protocols='!SSLv2,!SSLv3' && \
  postconf -e smtpd_tls_ciphers=high && \
  postconf -e smtpd_sasl_type=dovecot && \
  postconf -e smtpd_sasl_path=private/auth && \
  postconf -e smtpd_sasl_auth_enable=yes && \
  postconf -e smtpd_recipient_restrictions=permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination && \
  postconf -e smtp_use_tls=yes && \
  postconf -e smtp_tls_security_level=may && \
  postconf -e smtp_tls_mandatory_protocols='!SSLv2,!SSLv3' && \
  postconf -e smtp_tls_protocols='!SSLv2,!SSLv3' && \
  postconf -e smtp_tls_ciphers=high

RUN \
  echo $'dovecot   unix  -       n       n       -       -       pipe \n \
  flags=DRhu user=vmail:vmail argv=/usr/libexec/dovecot/deliver -f ${sender} -a ${recipient} -d ${user}@${domain}' >> /etc/postfix/master.cf && \
  echo $'8025     inet  n       -       -       -       -       smtpd' >> /etc/postfix/master.cf && \
  echo $'8587 inet n      -       n       -       -       smtpd -v -v\n \
  -o smtpd_tls_security_level=encrypt\n \
  -o smtpd_sasl_auth_enable=yes\n \
  -o smtpd_client_restrictions=permit_sasl_authenticated,permit_mynetworks,check_relay_domains,reject' >> /etc/postfix/master.cf

ENV \
  DEBUG=no \
  SSL_CERT_FILE="" \
  SSL_KEY_FILE="" \
  DB_HOST="" \
  DB_NAME="" \
  DB_USER="" \
  DB_PASSWORD=""

# SMTP ports
EXPOSE 8025 8587 8993 8995

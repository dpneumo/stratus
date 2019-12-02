#!/usr/bin/env bash

printf "\n== Add google apppassword to sasl_password & restart postfix ==\n\n"
# https://www.linode.com/docs/email/postfix/
#    configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/
PFSASL='/etc/postfix/sasl'

if ! [ -e "$PFSASL/sasl_passwd" ]; then touch $PFSASL/sasl_password; fi

sudo cat <<-EOT >> $PFSASL/sasl_passwd
[smtp.gmail.com]:587 dpneumo@gmail.com:'$gapppass'
EOT

sudo postmap    $PFSASL/sasl_passwd
sudo chmod 0600 $PFSASL/sasl_passwd $PFSASL/sasl_passwd.db
sudo systemctl restart postfix

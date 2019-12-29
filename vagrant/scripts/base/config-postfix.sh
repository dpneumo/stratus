#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run as root
printf "\n========= Setup Postfix ===========================\n"
yum install cyrus-sasl-plain -y
mkdir /etc/postfix/sasl

mv /etc/aliases           /etc/aliases.$(date +%s)
mv /etc/postfix/main.cf   /etc/postfix/main.cf.$(date +%s)
cp $SRC/postfix/aliases   /etc/
cp $SRC/postfix/main.cf   /etc/postfix/
chmod 644 /etc/aliases*   /etc/postfix/main.cf*

sed -i "s|myhost.mydomain.com|$PFixHostName|g" \
        /etc/postfix/main.cf

newaliases

printf "\n== Add google apppassword to sasl_password & restart postfix ==\n\n"
# https://www.linode.com/docs/email/postfix/
#    configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/
PFSASL='/etc/postfix/sasl'

if ! [ -e "$PFSASL/sasl_passwd" ]; then touch $PFSASL/sasl_password; fi

sudo cat <<-EOT >> $PFSASL/sasl_passwd
'$PFixGmail'
EOT
sudo cat $PFSASL/sasl_passwd

sudo postmap    $PFSASL/sasl_passwd
sudo chmod 0600 $PFSASL/sasl_passwd $PFSASL/sasl_passwd.db


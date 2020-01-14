#!/usr/bin/env bash
SRC='/vagrant/client_files'
PFSASL='/etc/postfix/sasl'

# Run as root
printf "\n========= Setup Postfix ===========================\n"
yum install cyrus-sasl-plain -y

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
if [ ! -e $PFSASL ]; then mkdir $PFSASL; fi

if [ ! -e $PFSASL/sasl_passwd ]
then
  touch $PFSASL/sasl_password
else
  sed -i '/dpneumo@gmail.com:/d' $PFSASL/sasl_passwd
fi

sudo cat <<-EOT >> $PFSASL/sasl_passwd
'$PFixGmail'
EOT

sudo postmap    $PFSASL/sasl_passwd
sudo chmod 0600 $PFSASL/sasl_passwd $PFSASL/sasl_passwd.db


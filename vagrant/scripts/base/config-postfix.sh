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
newaliases
# Start postfix in final_steps.sh

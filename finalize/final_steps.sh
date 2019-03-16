#!/usr/bin/env bash

cd /home/vagrant

printf "\n== Add google apppassword to sasl_password & restart postfic ==\n\n"
# https://www.linode.com/docs/email/postfix/
#           configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/
PFSASL='/etc/postfix/sasl'
touch $PFSASL/sasl_password
sudo cat <<-EOT >> $PFSASL/sasl_passwd
  [smtp.gmail.com]:587 dpneumo@gmail.com:'$gapppass
EOT
sudo postmap    $PFSASL/sasl_passwd
sudo chmod 0600 $PFSASL/sasl_passwd $PFSASL/sasl_passwd.db
sudo systemctl restart postfix


printf "\n========= Setup certs for nginx then restart it ========\n\n"
ipaddr=$(ip route get 8.8.8.8 | awk '{print $7}')
SUBJ=$subj SUBJ_IP=$ipaddr ./setup_ca.sh

subjcert=${subj}_cert.pem

mkdir -p cirrus/config/certs
cp CA/cacert.pem  cirrus/config/certs/cacert.pem
cp CA/certs/stratus_cert.pem  cirrus/config/certs/$subjcert

sudo systemctl restart nginx

printf "\n========= Show cirrus/config/certs/cacert.pem ==========\n\n"
cat cirrus/config/certs/cacert.pem
printf "\n========= Show cirrus/config/certs/$subjcert ===========\n\n"
cat cirrus/config/certs/$subjcert

printf "\n========= Start Rails App =========================\n"
cd cirrus
bundle install
bundle exec rails db:migrate
bundle exec rails server

printf "\n========= Done ====================================\n"

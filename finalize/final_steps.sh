#!/usr/bin/env bash

cd /home/vagrant

ipaddr=$(ip route get 8.8.8.8 | awk '{print $7}')
SUBJ=$subj SAN=DNS:$subj,IP:$ipaddr ./setup_ca.sh
subjcert=${subj}_cert.pem
if [[ -e cirrus/config/certs ]]; then
  cp CA/cacert.pem cirrus/config/certs/cacert.pem
  cp CA/certs/stratus_cert.pem cirrus/config/certs/$subjcert
fi
sudo systemctl restart nginx

printf "\n========= cirrus/config/certs/cacert.pem ==========\n\n"
cat cirrus/config/certs/cacert.pem
printf "\n========= cirrus/config/certs/$subjcert ===========\n\n"
cat cirrus/config/certs/$subjcert

printf "\n========= Start Rails App =========================\n"
cd cirrus
bundle install
bundle exec rails db:migrate
bundle exec rails server

printf "\n========= Done ====================================\n"

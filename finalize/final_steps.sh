#!/usr/bin/env bash
# Run:  ./final_steps.sh
# will run in user's home dir

cd /home/$(whoami)

printf "\n========= Place stratus server certs where cirrus can find them ========\n\n"
mkdir -p cirrus/config/certs
cp 'CA/intermediate/certs/blacklakeca-chain.cert.pem'  'cirrus/config/certs/cacert.pem'
cp 'CA/intermediate/certs/stratus.cert.pem'  'cirrus/config/certs/stratus.cert.pem'

printf "\n========= Restart Nginx ===========================\n"
sudo systemctl restart nginx

printf "\n========= Start Rails App =========================\n"
cd cirrus
bundle install
bundle exec rails db:migrate
bundle exec rails server

printf "\n========= Done ====================================\n"

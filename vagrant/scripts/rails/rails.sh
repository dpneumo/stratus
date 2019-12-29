#!/usr/bin/env bash

# Run unprivileged
printf "\n========= Place stratus server certs where cirrus can find them ========\n\n"
cd ~/
mkdir -p cirrus/config/certs
cp 'CA/certs/rootca.cert.pem'  'cirrus/config/certs/rootca.cert.pem'
cp 'CA/intermediate/certs/blacklakeca-chain.cert.pem'  'cirrus/config/certs/blacklakeca-chain.cert.pem'
cp 'CA/intermediate/certs/blacklakeca.cert.pem'  'cirrus/config/certs/blacklakeca.cert.pem'
cp 'CA/intermediate/certs/stratus.cert.pem'  'cirrus/config/certs/stratus.cert.pem'

printf "\n========= Start Rails App =========================\n"
cd cirrus
bundle install
bundle exec rails db:migrate
cd ..

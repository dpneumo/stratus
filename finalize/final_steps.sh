#!/usr/bin/env bash

cd /home/vagrant
./setup_ca.sh

cd cirrus
bundle install

cat ~/CA/cacert.pem
cat ~/CA/certs/stratus_cert.pem
EDITOR=nano bundle exec rails credentials:edit

bundle exec rails db:migrate
bundle exec rails server

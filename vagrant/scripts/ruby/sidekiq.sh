#!/usr/bin/env bash
SRC='/vagrant/client_files'
SIDEKIQ='/home/vagrant/sidekiq'

# Run unprivileged
printf "\n========= Install Sidekiq =========================\n"
gem install sidekiq
sudo cp $SRC/sidekiq/sidekiq.service /usr/lib/systemd/system/
sudo chmod 644 /usr/lib/systemd/system/sidekiq.service

if [ ! -e $SIDEKIQ ]; then mkdir $SIDEKIQ; fi

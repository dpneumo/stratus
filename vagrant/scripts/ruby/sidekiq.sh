#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Install Sidekiq =========================\n"
gem install sidekiq
sudo cp $SRC/sidekiq/sidekiq.service /usr/lib/systemd/system/
sudo chmod 644 /usr/lib/systemd/system/sidekiq.service

#!/usr/bin/env bash
# The vm-env folder holds scripts to set env vars
# to localize/personalize the setup and
# to provide sensitive information to the app.
# It is a synced folder from outside stratus
# It will/must NEVER be committed to GIT

source /vagrant/vagrant/bash_fns.sh

SRC='vm-env'
BKUP='/home/vagrant/bkup'
DATE="$(date +%s)"

# Run unprivileged
cp vm-env/base-env.sh base-env.sh  -fb --suffix=.$DATE
chown vagrant:vagrant base-env.sh
chmod 755             base-env.sh
source ./base-env.sh

# Cleanup home dir
move2bkup -b $BKUP -- base-env.sh.$DATE

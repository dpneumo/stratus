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

# Run privileged
cp vm-env/base-env.sh base-env-priv.sh  -fb --suffix=.$DATE
chown root:root base-env-priv.sh
chmod 755       base-env-priv.sh
source ./base-env-priv.sh

# Cleanup home dir
move2bkup -b $BKUP -- base-env-priv.sh.$DATE

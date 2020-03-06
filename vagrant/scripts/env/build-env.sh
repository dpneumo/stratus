#!/usr/bin/env bash
# vm-env is a synced folder from outside stratus
# It will/must NEVER be committed to GIT

SRC='vm-env'
BKUP='/home/vagrant/bkup'
DATE="$(date +%s)"

# Run unprivileged
cp vm-env/base-env.sh base-env.sh  -fb --suffix=.$DATE
chown vagrant:vagrant base-env.sh
chmod 755             base-env.sh
source ./base-env.sh

# Cleanup home dir
if [[ ! -e $BKUP ]]; then mkdir $BKUP; fi
if [[ -e "base-env.sh.$DATE" ]]; then
  mv base-env.sh.$DATE $BKUP/
fi

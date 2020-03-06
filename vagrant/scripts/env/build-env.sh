#!/usr/bin/env bash
# vm-env is a synced folder from outside stratus
# It will/must NEVER be committed to GIT

SRC='vm-env'
DATE="$(date +%s)"

# Run unprivileged
cp vm-env/base-env.sh base-env.sh  -fb --suffix=.$DATE
chown vagrant:vagrant base-env.sh
chmod 755             base-env.sh
source ./base-env.sh

# Cleanup home dir
if [[ ! -e /home/vagrant/bkup ]]; then
  mkdir /home/vagrant/bkup
fi
if [[ -e "base-env.sh.$DATE" ]]; then
  mv base-env.sh.$DATE /home/vagrant/bkup/
fi

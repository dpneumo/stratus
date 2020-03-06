#!/usr/bin/env bash
# vm-env is a synced folder from outside stratus
# It will/must NEVER be committed to GIT

SRC='vm-env'
DATE="$(date +%s)"

# Run privileged
cp vm-env/base-env.sh base-env-priv.sh  -fb --suffix=.$DATE
chown root:root base-env-priv.sh
chmod 755       base-env-priv.sh
source ./base-env-priv.sh

# Cleanup home dir
if [[ ! -e /home/vagrant/bkup ]]; then
  mkdir /home/vagrant/bkup
fi
if [[ -e "base-env-priv.sh.$DATE" ]]; then
  mv base-env-priv.sh.$DATE /home/vagrant/bkup/
fi


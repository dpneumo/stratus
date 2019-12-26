#!/usr/bin/env bash
SRC='vm-env'

# Run privileged
cp vm-env/base-env.sh base-env-priv.sh  -fb --suffix=.$(date +%s)
chown root:root base-env-priv.sh
chmod 755       base-env-priv.sh
source ./base-env-priv.sh

# Cleanup home dir
if [[ ! -e ~/bkup ]]; then
  mkdir ~/bkup
fi
mv  *.sh.* ~/bkup/

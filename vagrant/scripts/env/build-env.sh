#!/usr/bin/env bash
SRC='vm-env'

# Run unprivileged
cp vm-env/base-env.sh base-env.sh  -fb --suffix=.$(date +%s)
chown vagrant:vagrant base-env.sh
chmod 755             base-env.sh
source ./base-env.sh

mv  *.sh.* bkup/

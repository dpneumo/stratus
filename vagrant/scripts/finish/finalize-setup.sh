#!/usr/bin/env bash
FIN='/vagrant/finalize'

# Run unprivileged
printf "\n========= Setup manual tasks that must be done ====\n"
cp $FIN/start_postfix.sh start_postfix.sh -fb --suffix=.$(date +%s)

printf "\n========= Insure home folder scripts are runable ==\n"
sudo chmod 755 *ca.sh stratus_server_cert.sh

# Cleanup home dir
if [[ ! -e ~/bkup ]]; then
  mkdir ~/bkup
fi
mv  *.sh.* ~/bkup/

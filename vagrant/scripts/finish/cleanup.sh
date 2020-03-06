#!/usr/bin/env bash

printf "\n========= Remove duplicate entries from files =====\n"
for f in ~/.bash_profile ~/.gemrc /etc/postfix/sasl/sasl_passwd; do
  cp $f $f.bkup
  awk '{if (++dup[$0] == 1) print $0;}' $f > ~/tmp
  cat ~/tmp > $f && rm $f.bkup && rm ~/tmp
done

printf "\n========= Cleanup .bashrc for root and vagrant ====\n"
sed -i '/^# Start Setup Vars/,/^# End Setup Vars/d' ~/.bashrc
sudo sed -i '/^# Start Setup Vars/,/^# End Setup Vars/d' ~/.bashrc

printf "\n========= Cleanup home dir ========================\n"
if [[ ! -e /home/vagrant/bkup ]]; then
  mkdir /home/vagrant/bkup
fi
mv  *.sh.* /home/vagrant/bkup/


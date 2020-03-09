#!/usr/bin/env bash
source /vagrant/vagrant/bash_fns.sh

BKUP='/home/vagrant/bkup/'
DATE="$(date +%s)"

# Run privileged.
printf "\n========= Remove duplicate entries from files =====\n"
FILES=( /etc/postfix/sasl/sasl_passwd )

for f in "${FILES[@]}"; do
  cp $f $f.bkup -fb --suffix=.$DATE
  awk '{if (++dup[$0] == 1) print $0;}' $f > ~/tmp
  cat ~/tmp > $f && rm $f.bkup && rm ~/tmp
done

printf "\n========= Cleanup .bashrc for root and vagrant ====\n"
# Should this be deleted??
#sed -i '/^# Start Setup Vars/,/^# End Setup Vars/d' ~/.bashrc

printf "\n========= Cleanup home dir ========================\n"
move2bkup -b $BKUP -- "${FILES[@]/%/.$DATE}"

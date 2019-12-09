#!/usr/bin/env bash

printf "\n========= Remove duplicate entries from files =====\n"
for f in ~/.bash_profile ~/.gemrc; do
  cp $f $f.bkup
  awk '{if (++dup[$0] == 1) print $0;}' $f > ~/tmp
  cat ~/tmp > $f && rm $f.bkup
done

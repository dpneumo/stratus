#!/bin/bash

# Usage: createdir my-dir-name
function createdir() {
  local mydir="$1"
  if [ ! -e "$mydir" ]; then
    mkdir "$mydir"
    if [ $? -gt 0 ]; then
      echo "$mydir does not exist and could not be created."
      return 1
    fi
  fi
}

# Usage: move2bkup -b /backup -- filea fileb
#        move2bkup --bkupdir /backup -- filea fileb
function move2bkup() {
  local opts=`getopt -o b: --longoptions bkupdir: -- "$@"`
  eval set -- "$opts"

  local bkup="$2"
  createdir "$bkup"
  if [ $? -gt 0 ]; then return; fi
  shift; shift; shift

  local file_list="$@"
  mv ${file_list[@]} ${bkup}/
  if (( $? != 0 )); then
    echo "Unable to move ${file_list[*]} to ${bkup}" >&2
    return 1
  fi
}

#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Install Redis ===========================\n"
ver="$(redis-server --version 2>&1)"
if [[ $ver != 'Redis server'* ]] ; then
  echo "Redis not installed"
  wget -c http://download.redis.io/redis-stable.tar.gz
  tar -xvzf redis-stable.tar.gz
  rm redis-stable.tar.gz

  cd redis-stable
  make
  make test
  sudo make install
  cd /home/vagrant
else
  echo "Redis already installed."
fi


#!/usr/bin/env bash
SRC='/vagrant/client_files'

printf "========= Install Git =============================\n"
sudo yum install -y git
git config --global user.name "Mitch Kuppinger"
git config --global user.email dpneumo@gmail.com
git config --global push.default simple

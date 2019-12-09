#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Install OpenSSL =========================\n"
ver="$(openssl version 2>&1)"
if [[ $ver != OpenSSL* ]]; then
  sudo yum install openssl -y
else
  echo "OpenSSL is already installed."
fi

printf "\n========= Set useful openssl aliases ==========\n"
if ! grep -Fxq "# useful openssl aliases" ~/.bash_profile; then
cat <<-TXT >> ~/.bash_profile
# useful openssl aliases
alias cert='openssl x509 -noout -text -in'
alias req='openssl req -noout -text -in'
alias crl='openssl crl -noout -text -in'
TXT
fi
source ~/.bash_profile


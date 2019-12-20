#!/usr/bin/env bash

# Run unprivileged
printf "\n========= Install a ruby 2.6.3==========================\n"
ver="$(rbenv version 2>&1)"
if [[ $ver != 2.6.3* ]]; then
  rbenv install 2.6.3
  rbenv global 2.6.3
  rbenv rehash
else
  echo "Ruby 2.6.3 already installed."
fi

printf "\n=== Don't install documentation with gem install ==\n"
touch .gemrc
if ! grep -Fxq "gem: --no-document" ~/.gemrc; then
cat <<-TXT >> ~/.gemrc
gem: --no-document
TXT
fi

printf "\n========= Install bundler =========================\n"
gem install bundler
